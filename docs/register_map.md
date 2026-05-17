# Avalon Bus 暫存器映射 (Register Map)
> [!IMPORTANT]
> **自動化同步**：本文件定義與硬體 RTL 同步。  
> 若修改 Qsys 配置，請在資料夾 `rtl` 中執行 `make header` 以更新 `hps_0.h`，並將檔案複製並蓋寫至`firmware/hps_core/DE10_serial_parallel/INC/hps_0.h`。

## 目錄
- [Avalon Bus 暫存器映射 (Register Map)](#avalon-bus-暫存器映射-register-map)
  - [目錄](#目錄)
  - [1. 系統模組分配 (System Module Map)](#1-系統模組分配-system-module-map)
      - [模組位址映射表](#模組位址映射表)
  - [2. Serial Search 模組 (gps\_baseband\_0)](#2-serial-search-模組-gps_baseband_0)
    - [2.1 Serial Search 通道偏移量 (Channel Offset)](#21-serial-search-通道偏移量-channel-offset)
    - [2.2 Serial Search 系統狀態與控制 (Status \& Control)](#22-serial-search-系統狀態與控制-status--control)
      - [2.2.1 Serial Search Code\_Delay Group (Base: 0x0D0)](#221-serial-search-code_delay-group-base-0x0d0)
      - [2.2.2 Serial Search Status Group (Base: 0x0E0)](#222-serial-search-status-group-base-0x0e0)
      - [2.2.3 Serial Search Control Group (Base: 0x0F0)](#223-serial-search-control-group-base-0x0f0)
  - [3 Parallel Search 模組 (parallel\_search\_0)](#3-parallel-search-模組-parallel_search_0)
    - [3.1 模式定義 (Operation Modes)](#31-模式定義-operation-modes)
    - [3.2 Parallel Search暫存器 (Base: 0x400)](#32-parallel-search暫存器-base-0x400)
    - [3.3 相關值記錄 - Mode 0 (Base: 0x400)](#33-相關值記錄---mode-0-base-0x400)
    - [3.4 相關值記錄 - Mode 1 (Base: 0x400)](#34-相關值記錄---mode-1-base-0x400)
    - [3.5 相關值記錄 - Mode 2 (Base: 0x400)](#35-相關值記錄---mode-2-base-0x400)
    - [3.6 除錯資訊 (Base: 0x400)](#36-除錯資訊-base-0x400)
  - [4. MAX2769 模組 (max2769)](#4-max2769-模組-max2769)
  - [4.1 MAX2769 暫存器 (Base: 0x820)](#41-max2769-暫存器-base-0x820)
  - [5. 韌體開發範例 (C Language)](#5-韌體開發範例-c-language)

---

## 1. 系統模組分配 (System Module Map)
本專案透過 **h2f_lw_axi_master** (Lightweight HPS-to-FPGA Bridge) 進行硬體存取。在 HWLib 的 `socal/hps.h` 中定義了橋接器的物理基底位址：

```c
// 物理基底位址定義
#define ALT_LWFPGASLVS_OFST    0xff200000 
```

#### 模組位址映射表
> [!TIP]
> **位址對齊提醒**：由於是透過 Lightweight Bridge 存取，所有的位址均為 32-bit 對齊。在 C 語言中指標轉型時，請確保使用 `uint32_t *` 以符合 Avalon-MM 的存取規範。

各模組於 Avalon Bus 上的相對位址（Offset）如下。

在韌體開發時，實際存取位址為：`ALT_LWFPGASLVS_OFST + Module_Base`。


| 模組名稱             | 類別 (Class)        | 基底位址 (Base) | 說明                            |
| ------------------- | ------------------- | -------------- | ------------------------------- |
| **Serial Search**   | `gps_baseband`      | `0x000`        | 包含 13 個追蹤通道與系統控制暫存器 |
| **Parallel Search** | `parallel_search`   | `0x400`        | 平行碼相位搜尋模組                |
| **SPI Controller**  | `altera_avalon_spi` | `0x800`        | 用於配置射頻端參數                |
| **MAX2769**         | `max2769`           | `0x820`        | 射頻前端 (RF Front-end) 控制模組  |

## 2. Serial Search 模組 (gps_baseband_0)

通道區採用重複的結構。

**第 $N$ 個通道** (N=0~12)的位址計算方式為：`Target_Addr = Base (0x000) + (Channel * 0x10) + Offset`

| 區塊名稱         | 位址範圍 (Address) | 說明                                                          |
| --------------- | ------------------ | ------------------------------------------------------------ |
| **chan_0 ~ 12** | `0x00` - `0xCF`    | 13 個獨立相關器/通道(Correlator/Channel)(每個通道佔用 16 bytes) |
| **Code Delay**  | `0xD0` - `0xDF`    | Parallel Code Phase Search 相關參數                           |
| **status**      | `0xE0` - `0xEF`    | 系統狀態暫存器                                                 |
| **control**     | `0xF0` - `0xFF`    | 系統控制暫存器                                                 |

### 2.1 Serial Search 通道偏移量 (Channel Offset)
> [!NOTE]
> 這些暫存器位於通道區（Offset <= 0xCF），為13個相關器(通道)。

| 偏移量 (Offset) | 名稱 (Name)    | 權限    | 說明                                 |
| --------------- | ------------- | ------- | ----------------------------------- |
| `0x0`           | `prn_key`     | **R/W** | 設定衛星 PRN 編碼                    |
| `0x1`           | `carrier_nco` | **R/W** | 載波 NCO 控制參數                    |
| `0x2`           | `code_nco`    | **R/W** | 測距碼 NCO 控制參數                  |
| `0x3`           | `code_slew`   | **R/W** | 測距碼相位調整 (Slew Control)        |
| `0x4`           | `I_early`     | **R**   | 同相分量 - 早 (In-phase Early)       |
| `0x5`           | `Q_early`     | **R**   | 正交分量 - 早 (Quadrature Early)     |
| `0x6`           | `I_prompt`    | **R**   | 同相分量 - 即時 (In-phase Prompt)    |
| `0x7`           | `Q_prompt`    | **R**   | 正交分量 - 即時 (Quadrature Prompt)  |
| `0x8`           | `I_late`      | **R**   | 同相分量 - 晚 (In-phase Late)        |
| `0x9`           | `Q_late`      | **R**   | 正交分量 - 晚 (Quadrature Late)      |
| `0xA`           | `carrier_val` | **R**   | 目前載波數值讀取                     |
| `0xB`           | `code_val`    | **R**   | 目前碼 NCO 數值讀取                  |
| `0xC`           | `epoch`       | **R**   | Epoch 計數值 (1ms 週期)              |
| `0xD`           | `epoch_check` | **R**   | -                                   |
| `0xE`           | `epoch_load`  | **R/W** | 載入 Epoch 狀態                      |
| `0xF`           | `chip_select` | **R/W** | early/prompt/late之間相差多少個chip  |

### 2.2 Serial Search 系統狀態與控制 (Status & Control)
> [!NOTE]
> 這些暫存器位於通道區之後（Offset >= 0xD0），為全域控制與狀態監控使用。

#### 2.2.1 Serial Search Code_Delay Group (Base: 0x0D0)
用於對齊Parallel Code Phase結果與Serial Search 碼相位差異。

| 偏移量 (Offset)  | 名稱 (Name)            | 權限    | 說明                                                  |
| --------------- | ---------------------- | ------- | ---------------------------------------------------- |
|  `0x0`          | `set_serial_ch[0]`     | **R/W** | Parallel Search占用的Serial Search通道之一            |
|  `0x1`          | `set_serial_ch[1]`     | **R/W** | Parallel Search占用的Serial Search通道之二            |
|  `0x2`          | `ch0_hc_count2_start`  | **R**   | Parallel Search開始時，Serial Search 通道0的hc_count2 |
|  `0x3`          | `ch0_hc_count3_start`  | **R**   | Parallel Search開始時，Serial Search 通道0的hc_count3 |
|  `0x4`          | `ch0_hc_count2_end`    | **R**   | Parallel Search結束時，Serial Search 通道0的hc_count2 |
|  `0x5`          | `ch0_hc_count3_end`    | **R**   | Parallel Search結束時，Serial Search 通道0的hc_count3 |
|  `0x6`          | `ch0_hc_count2_q`      | **R**   | 每0.1 [ms]中斷栓鎖通道0的hc_count2                    |
|  `0x7`          | `ch0_hc_count3_q`      | **R**   | 每0.1 [ms]中斷栓鎖通道0的hc_count3                    |
|  `0x8`          | `ch1_hc_count3_start`  | **R**   | Parallel Search開始時，Serial Search 通道1的hc_count3 |
|  `0x9`          | `ch1_hc_count3_end`    | **R**   | Parallel Search結束時，Serial Search 通道1的hc_count3 |
|  `0xA`          | `ch1_hc_count3_q`      | **R**   | 每0.1 [ms]中斷栓鎖通道1的hc_count3                    |
|  `0xB`          | `ch2_hc_count3_start`  | **R**   | Parallel Search開始時，Serial Search 通道2的hc_count3 |
|  `0xC`          | `ch2_hc_count3_end`    | **R**   | Parallel Search結束時，Serial Search 通道2的hc_count3 |
|  `0xD`          | `ch2_hc_count3_q`      | **R**   | 每0.1 [ms]中斷栓鎖通道2的hc_count3                    |

#### 2.2.2 Serial Search Status Group (Base: 0x0E0)

| 偏移量 (Offset) | 名稱 (Name)   | 權限  | 說明                             |
| -------------- | ------------- | ----- | ------------------------------- |
| `0x0`          | `status`      | **R** | 系統整體運作狀態                  |
| `0x1`          | `new_data`    | **R** | 新數據產生標記 (Interrupt status) |
| `0x2`          | `tic_count`   | **R** | 系統 Tic 計時器數值               |
| `0x3`          | `accum_count` | **R** | 累加器計數值                      |

#### 2.2.3 Serial Search Control Group (Base: 0x0F0)

| 偏移量 (Offset) | 名稱 (Name)      | 權限  | 說明           |
| -------------- | ---------------- | ----- | -------------- |
| `0x0`          | `reset`          | **W** | 系統軟體復位    |
| `0x1`          | `prog_tic`       | **W** | 設定 Tic 週期   |
| `0x2`          | `prog_accum_int` | **W** | 設定累加中斷區間 |

## 3 Parallel Search 模組 (parallel_search_0)

本模組基底位址為 **`0x400`**，專用於衛星訊號的快速擷取 (Acquisition)。

搜尋行為由 `set_mode` (Offset `0x03`) 決定，並在 `ctrl_start` (Offset `0x00`) 偵測到上升緣脈衝時鎖定參數並啟動運算。

### 3.1 模式定義 (Operation Modes)

| 模式 (Mode) | 名稱             | 搜尋範圍                       | 應用場景 |
| ----------- | --------------- | ------------------------------ | ---------------------------------------------- |
| **Mode 0**  | **全域搜尋模式** | 32 PRN × 41 Shifts             | 遍歷所有衛星進行訊號擷取。      |
| **Mode 1**  | **局部搜尋模式** | 特定 PRN × 指定範圍             | 針對特定 PRN 進行精細搜尋。 |
| **Mode 2**  | **除錯解析模式** | 32 PRN × 41 Shifts × 4096 Data | 讀取每一筆相關性結果，每次計算後需發送 `table_data_read_ack` 才能繼續。 |

### 3.2 Parallel Search暫存器 (Base: 0x400)

| 偏移量 (Offset) | 名稱 (Name)                    | 權限    | 說明                                 |
| --------------- | ----------------------------- | ------- | ----------------------------------- |
| `0x00`          | `ctrl_start` (W) / `ctrl` (R) | **R/W** | 寫入以啟動計算 / 讀取目前控制狀態      |
| `0x01`          | `state`                       | **R**   | 顯示目前系統主狀態機狀態               |
| `0x02`          | `irq_ack`                     | **W**   | 中斷確認 (Clear Interrupt)            |
| `0x03`          | `set_mode`                    | **R/W** | 設定運行模式 (Mode 0, 1, 2)           |
| `0x04`          | `set_condition`               | **R/W** | 設定計算邊界條件                      |
| `0x10`          | `table_CDC_in_address`        | **R/W** | CDC (Clock Domain Crossing) 輸入位址 |
| `0x11`          | `table_CDC_out_data`          | **R**   | CDC 輸出數據讀取                      |

### 3.3 相關值記錄 - Mode 0 (Base: 0x400)

| 偏移量 (Offset) | 名稱 (Name)                  | 權限    | 說明                 |
| --------------- | --------------------------- | ------- | ------------------- |
| `0x20`          | `table_in_CACode`           | **R/W** | 輸入 CA Code 索引    |
| `0x21`          | `table_in_shift`            | **R/W** | 輸入位移量 (Shift)   |
| `0x22`          | `table_out_correlation_avg` | **R**   | 輸出平均相關值       |
| `0x23`          | `table_out_correlation`     | **R**   | 輸出原始相關值       |
| `0x24`          | `table_out_chip_offset`     | **R**   | 輸出 Chip 偏移量     |
| `0x25`          | `table_max_valid`           | **R**   | 最大值有效標記       |
| `0x26`          | `table_max_in_CACode`       | **R/W** | 最大值對應的 CA Code |
| `0x27`          | `table_max_out_shift`       | **R/W** | 最大值對應的位移量    |

### 3.4 相關值記錄 - Mode 1 (Base: 0x400)

| 偏移量 (Offset) | 名稱 (Name)        | 權限    | 說明                        |
| -------------- | ------------------ | ------- | -------------------------- |
| `0x30`         | `set_CACode_id`    | **R/W** | 指定要搜尋的衛星 CA Code ID |
| `0x31`         | `set_shift_center` | **R/W** | 指定搜尋中心位移            |
| `0x32`         | `set_shift_width`  | **R/W** | 指定搜尋寬度範圍            |

### 3.5 相關值記錄 - Mode 2 (Base: 0x400)

| 偏移量 (Offset) | 名稱 (Name)                  | 權限    | 說明                                |
| -------------- | ---------------------------- | ------- | ---------------------------------- |
| `0x40`         | `table_data_in_index`        | **R/W** | 除錯數據索引輸入                     |
| `0x41`         | `table_data_out_CACode`      | **R**   | 輸出當前除錯的 CA Code               |
| `0x42`         | `table_data_out_shift`       | **R**   | 輸出當前除錯的位移量                  |
| `0x43`         | `table_data_out_correlation` | **R**   | 輸出當前除錯的相關值                  |
| `0x44`         | `table_data_read_ack`        | **W**   | 除錯數據讀取確認 (用於進入下一個數據點) |

### 3.6 除錯資訊 (Base: 0x400)
| 偏移量 (Offset) | 所屬模組                 | 名稱 (Name)           | 權限  | 說明 |
| -------------- | ------------------------ | -------------------- | ----- | ---- |
| `0x50`         | `correlation_processing` | `CACode`             | **R** |      |
| `0x51`         | `correlation_processing` | `shift_unsigned`     | **R** |      |
| `0x52`         | `correlation_processing` | `shift_end_unsigned` | **R** |      |
| `0x53`         | `correlation_processing` | `cnt_data`           | **R** |      |
| `0x54`         | `controller_ft_input`    | `state`              | **R** |      |
| `0x55`         | `controller_ft_input`    | `cnt_FTIn`           | **R** |      |
| `0x56`         | `convolution`            | `state`              | **R** |      |
| `0x57`         | `CACode_generator`       | `state`              | **R** |      |
| `0x58`         | `CACode_generator`       | `cnt_data`           | **R** |      |

## 4. MAX2769 模組 (max2769) 
本模組基底位址為 **`0x820`**，主要負責管理 MAX2769 晶片的電源狀態與監測硬體連接狀態。透過此模組，韌體端可以確保 RF 前端模組已正確啟動且時脈穩定，這是衛星訊號擷取的前提條件。

## 4.1 MAX2769 暫存器 (Base: 0x820)
| 偏移量 (Offset) |  名稱 (Name)            | 權限     | 說明                                                                                            |
| -------------- | ----------------------- | -------- | ----------------------------------------------------------------------------------------------- |
|  **0x0**       | `IDLE_B`                | **R/W**  | **空閒模式控制**：設定為 `1` 進入正常工作模式，`0` 進入待機模式。                                    |
|  **0x0**       | `IDLE_B`                | **R/W**  | **硬體關斷控制**：設定為 `1` 開啟晶片，`0` 關閉晶片電源 (Shutdown)。                                |
|  **0x0**       | `is_frontend_connected` | **R**    | **物理連接偵測**：`1` 代表 Front-end 模組已正確插入 GPIO，`0` 為未連接。                            |
|  **0x0**       | `clk_frontend_locked`   | **R**    | **時脈鎖定監測**：讀取 MAX2769 內部 PLL 狀態。`1`: 時脈鎖定且穩定 (Locked)，`0`: 未鎖定 (Unlocked)。 |

> [!CAUTION]
> **啟動順序建議**：在進行任何搜尋 (Acquisition) 動作前，請務必先確認 `is_frontend_connected` 與 `clk_frontend_locked` 皆為 `1`，以確保採樣到的訊號為有效衛星數據。

## 5. 韌體開發範例 (C Language)
檔案位置`firmware/hps_core/DE10_serial_parallel/INC/namuru.h`，存取範例如下：
```c
ch_block->channels[0].chip_select = 1; // 設定通道 0的early/prompt/late之間相差0.25 [chip]
```