# GPS Acquisition - Parallel Code Phase Search Simulation

本專案基於 **MATLAB** 開發，實現了 GPS 訊號擷取階段的 **平行碼相位搜尋演算法 (Parallel Code Phase Search)**。本程式作為演算法的**驗證標準**，目的是確保演算法邏輯正確，以利後續在 SoC 平台上進行軟硬體電路的實作與比對。

## 開發環境與軟體需求

* **開發軟體**：MATLAB R2025b (或相容版本)
* **所需工具箱 (Toolboxes)**：
    * Signal Processing Toolbox
    * Communications Toolbox

## 演算法核心與功能

本模擬腳本（`parallel_code_phase_search_sim.m`）完整涵蓋了從前端基頻訊號模擬到頻域平行搜尋的完整鏈路：

1.  **訊號模擬前端**：生成包含多普勒頻移（Doppler Shift）、C/A 碼相位偏移（Code Phase Offset）以及導航數據（Navigation Data）的 GPS 基頻訊號。
2.  **下採樣與降頻 (Downsampling)**：針對硬體實現進行優化，模擬基頻降頻與移動平均（Moving Sum）處理。
3.  **平行碼相位搜尋演算法**：利用快速傅立葉變換（FFT/IFFT）在頻域對 1 至 32 顆衛星的 C/A 碼進行二維平行搜尋，大幅加速訊號擷取（Acquisition）時間。
4.  **結果驗證與 3D 視覺化**：繪製二維搜尋空間的相關能量圖（Correlation Map），自動追蹤並標記最大峰值（Peak），以驗證演算法在存在導航數據反轉時的擷取可行性。

## 如何執行

1.  將本儲存庫複製（Clone）或下載至本地端。
2.  開啟 **MATLAB** 軟體，並將工作目錄切換至本資料夾。
3.  在 MATLAB 的 Command Window 中輸入並執行以下指令：
    ```matlab
    parallel_code_phase_search_sim
    ```
4.  執行完成後，MATLAB 將自動彈出兩張驗證圖表：
    * **Figure 1**：3D 全衛星平行碼搜尋空間能量分佈圖（自動標記最強 Peak 衛星）。
    * **Figure 2**：模擬的導航數據時域圖，以及最強衛星在最大多普勒頻帶下的相關值切片（Correlation Slice）。