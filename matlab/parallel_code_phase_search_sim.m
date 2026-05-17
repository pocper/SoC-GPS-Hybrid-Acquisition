clear;clc;close all;

%% 基本參數
fs = 16.368e6;       % [Hz] - frontend sampling rate
ts = 1/fs;           % [s]  - frontend sampling period
f_IF = 4.092e6;      % [Hz] - frontend IF signal
f_nav = 50;          % [Hz] - Navigation Frequency
% t_nav = 1/f_nav;     % [s]  - Navigation period
F_sample  = 16.368e6; % sampling Rate [Hz]
F_chip    = 1.023e6;  % CACode rate [Hz]

w_IF = 2*pi*f_IF*ts; % [Hz] - frontend angular frequency
t  = 2e-3;           % [s]  - frontend save time
ns = fs*t;           % number of sample
N_FFT = 4096;
N_movingSum  = 4;    % number of Moving Sum
N_downsample = 8;    % number of downsample
prn_id_frontend = 13;
F_doppler       = 3e3; % doppler frequency [Hz] (-10kHz ~ +10kHz)
fullchip_offset = 10;

num_top = 1;

%% CACode 生成
CACode_all = gnssCACode(1:32, "GPS")'; % range = [0, 1]
CACode_all_bpsk = (CACode_all * 2) - 1;
CACode_bpsk_frontend = double(CACode_all_bpsk(prn_id_frontend, :));
CACode_bpsk_frontend_shifted = circshift(CACode_bpsk_frontend, fullchip_offset);
samples_per_chip = fs / F_chip; % 16
CACode_bpsk_frontend_1ms = repelem(CACode_bpsk_frontend_shifted, samples_per_chip);
num_code_periods = ceil(ns / length(CACode_bpsk_frontend_1ms));
CACode_stream = repmat(CACode_bpsk_frontend_1ms, 1, num_code_periods);
CACode_stream = CACode_stream(1:ns);

%% Navigation Data 生成
duty_nav = 1;
num_ones = floor(ns*duty_nav);
num_zeros = ns - num_ones;
nav_data = [ones(1, num_ones), -1*ones(1, num_zeros)];

%% 載波 生成
n = (0:ns-1);
carrier = exp(1i*2*pi*(f_IF+F_doppler)*n * ts);

%% 生成訊號
signal = carrier .* CACode_stream .* nav_data;

% =========================================================================
%% 消除載波(4.092 [MHz])
carrier_IF = exp(1i*w_IF*(0:ns-1));
s = signal .* carrier_IF;

s_moving = movsum(s, [0, N_movingSum-1]);
s_downsample = downsample(s_moving, N_downsample);
s_downsample_zp = [s_downsample, zeros(1, N_FFT-length(s_downsample))];

%% Parallel Code Search
X_freq_domain = fft(s_downsample_zp, N_FFT);

correlation2 = zeros(32, 41, N_FFT);
for PRN=1:32
    % Generate CACode for FPGA
    CACode_bpsk_fpga = CACode_all_bpsk(PRN, :);
    CACode_bpsk_duplicate = repelem(CACode_bpsk_fpga, 2);
    CACode2_zp = [CACode_bpsk_duplicate, CACode_bpsk_duplicate, zeros(1, 4)];
    CACode2 = complex(double(CACode2_zp), 0);

    % FFT for CACode
    CACode2_freq_domain = fft(CACode2, N_FFT);

    for doppler_shift=-20:20
        % Frequency domain shift CACode
        CACode2_freq_domain_shift = circshift(CACode2_freq_domain, doppler_shift);

        % Frequency domain Convolution
        X_correlation2 = X_freq_domain .* conj(CACode2_freq_domain_shift);

        % IFFT
        Y2 = ifft(X_correlation2, N_FFT);
        
        % Correlation
        correlation2(PRN, doppler_shift+21, :) = abs(Y2);
    end
end

%% 目前的做法
mag_max2 = max(correlation2, [], 3);
[maxCorr_in_CACode2, idx_max_shift2] = max(mag_max2, [], 2);
[sorted_vals2, sorted_idx2] = sort(maxCorr_in_CACode2, 'descend');
top_idx2   = sorted_idx2(1:num_top); % 前八大CACode的索引
top_shift2 = idx_max_shift2(top_idx2); % 對應shift
top_val2   = maxCorr_in_CACode2(top_idx2); % 最大值


% 畫圖
figure;
sgtitle("correlation");
[X, Y] = meshgrid(1:41, 1:32); % X: shift, Y: CACode

% --------------------------------------------------
hold on;
surf(X, Y, mag_max2);
title('CACode(4092) + zeros(4)');
xlabel('shift');
ylabel('CACode');
zlabel('correlation');
colorbar;
shading interp; % 讓顏色平滑

% 標記前八大點
h = gobjects(1,num_top);
legend_entries = cell(1,num_top);
for k = 1:num_top
    c = top_idx2(k); % CACode
    s = top_shift2(k); % shift
    v = top_val2(k); % 最大值
    h(k) = plot3(s, c, v, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    legend_entries{k} = sprintf('Top %2d: CACode=%02d, Shift=%02d, Value=%7.2f', k, c, s, v);
end
set(gca, 'FontName', 'Consolas');
legend(h, legend_entries, 'Location', 'best');
hold off;
view(3);

% --------------------------------------------------
figure;
CACode_peak = 13;
shift_peak = 27;
sgtitle(sprintf('CACode = %d, f\\_doppler = %d [kHz], fullchip\\_offset = %d, duty\\_nav = %3d %%', CACode_peak, F_doppler/1e3, fullchip_offset, duty_nav*100));
subplot(211);
plot(linspace(0, t*1e3, ns), nav_data);
grid on;
title('Navigation Data');
xticks(0:(t*1e3)/8:t*1e3);
ylim([-1.5, +1.5]);
xlabel('time [ms]');
ylabel('value');

subplot(212);
plot(reshape(correlation2(CACode_peak,shift_peak,:), [1, 4096]));
xticks(0:1024:N_FFT);
xlim([0, N_FFT]);
xlabel('half-chip');
ylabel('correlation');
ylim([0, 10]);
title("CACode(2046) + CACode(2046) + zeros(4)");