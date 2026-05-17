# SoC-based GPS Receiver Implementation

本專案實作了一個基於 Intel Cyclone V SoC (DE10-Nano) 平台的 GPS 接收器系統，結合了自製的 MAX2769 RF 前端模組、FPGA 硬體加速器以及 HPS 控制韌體。

## 目錄
- [SoC-based GPS Receiver Implementation](#soc-based-gps-receiver-implementation)
  - [目錄](#目錄)
  - [1. 系統架構 (System Architecture)](#1-系統架構-system-architecture)
  - [2. 目錄導覽 (Repository Structure)](#2-目錄導覽-repository-structure)
  - [3. 開發環境配置 (Development Setup)](#3-開發環境配置-development-setup)
  - [4. 硬體接線與安全須知 (Hardware Connection)](#4-硬體接線與安全須知-hardware-connection)
  - [5. 演算法架構與狀態機 (Alogorithm \& Finite State Machine)](#5-演算法架構與狀態機-alogorithm--finite-state-machine)
  - [6. 程式燒錄與執行順序 (Programming Sequence)](#6-程式燒錄與執行順序-programming-sequence)
  - [7. 運行結果與驗證 (Experimental Results)](#7-運行結果與驗證-experimental-results)
    - [1. 測試設備 (Testing Equipment)](#1-測試設備-testing-equipment)
    - [2. 核心運算耗時對比 (Core Algorithm Performance)](#2-核心運算耗時對比-core-algorithm-performance)
    - [3. 全系統定位效能與 TTFF 綜合對比 (System-Level Performance \& TTFF)](#3-全系統定位效能與-ttff-綜合對比-system-level-performance--ttff)
    - [4. 觀測組 5 次獨立實測原始數據紀錄 (Raw Experimental Data)](#4-觀測組-5-次獨立實測原始數據紀錄-raw-experimental-data)


## 1. 系統架構 (System Architecture)

<div style="text-align: center; margin: 20px 0;">
  <img src="image/system_architecture_block_diagram.png" alt="系統架構" width="600">
  <p style="margin-top: 10px;">
  <i>圖：系統架構圖</i>
  </p>
</div>

本系統主要分為三大模組：
1. **RF Front-End**: 負責GPS L1訊號降採樣(Downsampling)。
2. **FPGA RTL**: 負責 Parallel Code Phase Search (PCPS) 加速。
3. **HPS Firmware**: 負責系統配置、追蹤運算與導航解算。

## 2. 目錄導覽 (Repository Structure)

1. [pcb frontend](pcb_frontend/) (Altium Designer Project)

包含自製 MAX2769 RF 模組的設計檔案。
   - **硬體版本**: 目前推薦使用 **v3**。
   - **內容**: Altium Designer 專案、電路圖 (PDF)、製作與維修紀錄。

2. [rtl](rtl/) (Quartus Project)

包含部署於 FPGA 端的 Verilog 原始碼與 Intel Quartus Prime 專案檔。
   - **核心模組**: 包含 Parallel Code Phase Search 與 Serial Search 之雙重訊號擷取架構。
   - **環境**: Intel Quartus Prime。
   - **重點**: 針對硬體並行化處理進行優化，減少擷取所需時間。

3. [firmware](firmware/) (Arm DS Project)

包含執行於 HPS (ARM Cortex-A9) 的韌體程式碼。
   - **主要功能**: 透過 SoC Bridge 控制硬體暫存器、管理 correlator 數據。
   - **環境**: Intel SoC EDS / VS Code。
   - [**hps_core/**](firmware/hps_core/): **主要開發分支**。使用 Arm DS (AC6) 編譯，需透過校園網路向 TSRI 申請授權，**[詳細編譯與專案設定請見此目錄 README]**。
   - [**hps_altera/**](firmware/hps_altera/): **舊版相容分支**。使用 DS-5 (AC5) 編譯，專為實驗室內建有「買斷版授權」之 DS-5 Altera Edition 筆電設計，**[詳細編譯與專案設定請見此目錄 README]**。

4. [matlab](matlab/) (MATLAB Project)

包含 GPS 衛星訊號擷取演算法的模擬程式碼。
   - **主要功能**: 實現了平行碼相位搜尋演算法(Parallel Code Phase Search)。
   - **環境**: MATLAB。
   - **重點**: 作為演算法的功能模擬與設計標準，用於提前驗證演算法可行性，並作為後續 SoC 硬體開發時比對資料正確性的主要依據。

5. [document](docs/)

存放專案相關的技術文件與操作指南。
   - [**how_to_apply_ds5.md**](docs/how_to_apply_ds5.md): **環境申請指南** (含 TSRI 資源、校園 DNS 正反查申請)。
   - [**emulator.md**](docs/emulator.md): **硬體操作手冊** (Agilent E4438C 與 Spirent GSS7000 操作流程)。
   - [**register_map.md**](docs/register_map.md): **暫存器映射表**。定義 HPS 與 FPGA  之間的通訊位址。
   - [**arm_core_initialization.md**](docs/arm_core_initialization.md): **ARM 核心與 RTOS 配置指南**。記錄 RTOS 環境下 Cortex-A9 時脈校正、GIC 映射與 RTX5 內核放寬執行緒上限之底層修正。

## 3. 開發環境配置 (Development Setup)

1. 硬體需求
   - **FPGA Board**: Terasic DE10-Nano (Cyclone V SoC)。
   - **RF Module**: 自製 MAX2769 模組 (GPSR_frontend_v3)。
   - **Antenna**: 主動式 GPS 天線。

2. 開發環境
   - **FPGA**: Quartus Prime (建議 25.1 或以上版本)。
   - **Hardware-Software Bridge**: Intel SoC EDS Embedded Development Suite (提供硬體與韌體間的運作函式庫)。
   - **Firmware IDE**: Arm Development Studio (TSRI 建議 23.1 或以上版本) 或 DS-5 Altera Edition (實驗室筆電買斷版)。
   - **OS**: CMSIS RTOS (運行於 HPS 端)。
   - **Terminal**: PuTTY (查看 HPS 執行狀態)。

3. 授權取得方式 (TSRI 申請 vs. 實驗室筆電)
  1. **個人電腦開發**：需透過校園網路與 TSRI 驗證，請參閱 **[how_to_apply_ds5.md](docs/how_to_apply_ds5.md)** 完成 IP 正反查申請。
  2. **實驗室筆電開發**：若使用實驗室特定筆電，可直接使用已安裝之 **DS-5 Altera Edition** 進行 `hps_altera` 分支的開發，無需額外申請 TSRI 授權。

## 4. 硬體接線與安全須知 (Hardware Connection)

<img src="image/system_connection_overview.jpg" alt="系統接線總覽" width="600">

1. **JTAG 偵錯**：將 mini-USB 連接至 DE10-Nano 的 **J13** 孔位並連接電腦 (用於 Quartus 燒錄及 DS-5 除錯)。
2. **UART 監控**：將 mini-USB 連接至 DE10-Nano 的 **J4**  孔位並連接電腦 (用於查看 HPS 端 UART Console 輸出結果)。
3. **RF 訊號輸入**：將 SMA Cable 連接至 Front-end 的 **J5** 孔位 (從GPS訊號產生器或天線提供 MAX2769 輸入訊號)。
4. **電源供應**：將 DC Power Cable(5V/2A) 連接至 DE10-Nano 的 **J14** 孔位，另一端連接插座。

> [!CAUTION]
> **重要上電順序提醒 (Critical Safety Warning)**
> 
> 在接通電源前，請務必確認上述 **1~3 項接線已全部連接穩固**。
> 
> **嚴禁在上電狀態下熱插拔 SMA 接頭**。由於上電瞬間可能產生瞬間脈衝 (Pulse) 或靜電，若此時才連接 SMA 接口，極易導致射頻前端 MAX2769 發生短路或因突波而燒毀。請遵循 **「先接線、後上電」** 的原則，拆卸時則反之。

## 5. 演算法架構與狀態機 (Alogorithm & Finite State Machine)

<div style="text-align: center; margin: 20px 0;">
  <img src="image/serial_search_architecture.png" alt="Serial Search 架構" width="600">
  <p style="margin-top: 10px;">
  <i>圖：Serial Search 模組硬體架構圖</i>
  </p>
</div>

<div style="text-align: center; margin: 20px 0;">
  <img src="image/parallel_code_phase_search_architecture.png" alt="Parallel Code Phase Search 架構" width="600">
  <p style="margin-top: 10px;">
  <i>圖：Parallel Code Phase Search 模組硬體架構圖</i>
  </p>
</div>

<div style="max-width: 500px; margin: 0 auto;">

``` mermaid
graph LR
    subgraph ORIG [Original Architecture]
        direction LR
        OFF([OFF]) --> Acquire([Acquire])
        Acquire --> Confirm([Confirm])
        Confirm --> Pull-in([Pull-in])
        Pull-in --> Lock([Lock])
        
        Acquire -- Fail --> OFF
        Confirm -- Fail --> Acquire
        Pull-in -- Fail --> Acquire
        Lock -- Lost --> Pull-in
    end
    
    style ORIG fill:#fff,stroke:#333,stroke-width:2px
```
<p align="center"><i>圖：狀態機 - 原始架構</i></p>
</div>

<div style="max-width: 500px; margin: 0 auto;">

``` mermaid
graph LR
    subgraph HYB [Hybrid Architecture]
        direction LR
        OFF([OFF]) --> Acquire([Acquire])
        Acquire --> Refine([Refine])
        Refine --> Pull-in([Pull-in])
        Pull-in --> Lock([Lock])
        
        Acquire -- Fail --> OFF
        Pull-in -- Fail --> OFF
        Lock -- Lost --> Pull-in
    end
    
    style HYB fill:#fff,stroke:#333,stroke-width:1px
```
<p align="center"><i>圖：狀態機 - 混合架構</i></p>
</div>

## 6. 程式燒錄與執行順序 (Programming Sequence)

> [!IMPORTANT]
> **必須遵循「先燒錄 FPGA，後執行 ARM」的原則**。若 FPGA 尚未配置完成便啟動 ARM 程式，會導致 HPS 因存取非法位址而當機。

1. **載入 FPGA 硬體邏輯 (Quartus)**：
   * 使用 **Quartus Programmer** 透過 JTAG (J13) 燒錄 `.sof` 檔案。
   * 此步驟會建立並啟動 FPGA 端的 Parallel/Serial Search 硬體加速器。
   * 詳細專案說明請參考 **[rtl/README.md](rtl/README.md)**。

2. **執行 HPS 韌體程式 (DS-5 / Arm DS)**
   * 硬體燒錄成功後，即可透過 IDE 啟動 Debug 會話，將韌體載入 ARM Cortex-A9 核心執行。請根據您的開發環境選擇對應專案：
     * **現代化開發 (Arm DS / AC6)**：請使用 **[hps_core](firmware/hps_core/)**。
       * 適用於大多數個人電腦環境，詳細編譯與 Debugger 設定請務必閱讀 [該目錄 README](./firmware/hps_core/README.md)。
     * **實驗室環境 (DS-5 / AC5)**：請使用 **[hps_altera](firmware/hps_altera/)**。
       * 專為實驗室內建買斷版授權之筆電設計。由於編譯器版本與硬體函式庫路徑不同，請務必參閱 [該目錄 README](./firmware/hps_altera/README.md) 進行設定。

3. **觀察輸出**：
   * 確認 **PuTTY** 已開啟，並透過 **mini-USB 線** 連接至 DE10-Nano 的 **J4 (USB-UART)** 埠，即可看到系統初始化與衛星搜尋的 log 資訊。

## 7. 運行結果與驗證 (Experimental Results)

本專案透過硬體模擬器驗證接收器於不同場景下的定位效能。

### 1. 測試設備 (Testing Equipment)
若需重現驗證結果，請參閱 **[emulator.md](docs/emulator.md)** 之操作指引配置硬體環境。

| 實驗環境變數 (Parameter) | 實體軟硬體配置與參數 (Configuration Details)             |
| :---------------------- | :----------------------------------------------------- |
| **射頻訊號模擬器**       | Spirent GSS7000 Multi-GNSS RF Signal Simulator         |
| **測試衛星星座**         | GPS L1 C/A (天空中包含 10 顆動態可見衛星)                |
| **底層計時解析度**       | ARM Cortex-A9 Private Timer (解析度: 1 ms)              |
| **系統排程頻率**         | CMSIS-RTOS v2 / Keil RTX5 (OS Tick Freuqency: 1000 Hz) |
| **統計實驗次數**         | 5 次獨立重複實驗 (5 Trials per Power Level)              |

### 2. 核心運算耗時對比 (Core Algorithm Performance)
下表展示了 SoC 平台在相同搜尋範圍下，執行不同基頻擷取演算法的純硬體運算耗時統計：

| 訊號擷取演算法         | 衛星數量 | 頻率搜索範圍 [kHz] | 總體執行時間 [ms] | 核心運算加速比 |
| :-------------------- | :-----: | :---------------: | :--------------: | :----------: |
| **直接搜尋法** <small>註1, 2</small> | 1 顆    | $0 \pm 10$        | 80,725.64        | 基準 (1.0x)   |
| **碼相位平行搜尋法**   | 1 顆    | $0 \pm 10$        | **4.07**         | **19,834x**   |
| **碼相位平行搜尋法**   | 32 顆   | $0 \pm 10$        | **117.65**       | **686x**      |

<small>**註1**：直接搜尋法之執行時間為完整搜尋所有二維搜尋空間之最大耗時。若於搜尋空間中先行命中載波頻率及碼相位，程式會提早結束。</small>
<small>**註2**：直接搜尋法可透過在 FPGA 上配置多組實體硬體通道平行搜尋不同衛星，以降低總體執行時間。</small>

### 3. 全系統定位效能與 TTFF 綜合對比 (System-Level Performance & TTFF)
本實驗測試共用相同之基頻硬體資源（Parallel Search 模組與 13 組序列硬體相關器通道），純粹透過 **ARM 韌體排程狀態機 (FSM) 的調度策略分流**，對比系統首次定位時間（Time To First Fix, TTFF）的實測結果：

   * **混合架構 (Parallel Code Phase Search + Serial Search)**：完整驅動 FPGA 內之 Parallel Code Phase Search 硬體加速模組進行全星座快速擷取，隨後動態將參數分派予 13 組序列硬體相關器（Serial Correlator）進行精細微調與追蹤。
   * **單一架構 (Serial Search)**：於軟體層面將 Parallel 加速器暫存器關閉，冷啟動後純依賴 13 組通道進行時域與頻域的逐點掃描。為了排除純韌體超時輪詢變因、專注比對硬體搜尋物理速度，此模式下開機**預先指派模擬器中存在的 10 顆存在衛星號碼（指定 PRN）**。

| 模擬器功率 [dBm] | 架構     | 4 顆衛星達成鎖定鎖定耗時 [s] <br>(範圍 / 平均值) | 首次定位時間 (TTFF) [s] <br>(範圍 / 平均值) | **硬體搜尋加速比** |
| :-------------: | :------: | :-------------------------------------------: | :---------------------------------------: | :---------------: |
| **-115**        | 單一      | 19.073 ~ 28.095 (**23.902**)                 | 51.233 ~ 60.218 (**55.570**)              | 基準 (1.0x)       |
|                 | 混合      | 1.122 ~ 3.206 (**2.139**)                    | 26.085 ~ 39.069 (**31.465**)              | **11.17x 加速**   |
| **-120**        | 單一      | 19.143 ~ 25.171 (**21.554**)                 | 46.075 ~ 56.133 (**50.134**)              | 基準 (1.0x)       |
|                 | 混合      | 1.152 ~ 2.253 (**1.943**)                    | 27.234 ~ 38.067 (**33.915**)              | **11.09x 加速**   |
| **-125**        | 單一      | 25.234 ~ 32.026 (**29.351**)                 | 47.057 ~ 74.192 (**61.511**)              | 基準 (1.0x)       |
|                 | 混合      | 28.180 ~ 84.115 (**50.725**)                 | 80.044 ~ 156.029 (**108.885**)            | **註1**           |
| **-130**        | 單一/混合 | —                                            | —                                         | **註2**           |

<small>**註1**：在 `-125 dBm` 下，混合架構因頻率觀測頻寬較寬（500 Hz vs. Serial 125 Hz），致使單一頻率分度（Bin）內累積之總雜訊功率較高。在弱訊號下，真實訊號極易低於硬體偵測門檻而遭誤判，狀態機須反覆驗證，故鎖定耗時拉長。</small>
<small>**註2**：訊號功率降至 `-130 dBm` 時，在當前配置之積分時間（Parallel Code Phase Search: 2 ms / Serial: 1 ms）限制下，相關峰值已無法超越雜訊基底，故不論何種調度模式皆無法達成穩定鎖定。</small>

### 4. 觀測組 5 次獨立實測原始數據紀錄 (Raw Experimental Data)
若需核對或重現統計大表中的範圍區間，可展開下方摺疊面板檢視各組 Run 1 ~ Run 5 的詳細觀測值：

<details>
<summary><b>點擊展開：查看混合架構 5 次獨立實測詳細數據紀錄</b></summary>

| 模擬器輸出功率 [dBm] | 4 顆衛星達成鎖定之耗時 [s] <br> (Run 1 / 2 / 3 / 4 / 5) [平均值] | 首次定位時間 (TTFF) [s] <br> (Run 1 / 2 / 3 / 4 / 5) [平均值] |
| :-----------------: | :------------------------------------------------------------ | :---------------------------------------------------------- |
| **-115**            | 2.134 / 3.206 / 1.122 / 3.084 / 1.151 <br> **[Mean: 2.139]**  | 26.085 / 39.069 / 29.065 / 36.035 / 27.073 <br> **[Mean: 31.465]** |
| **-120**            | 2.019 / 2.062 / 2.253 / 2.229 / 1.152 <br> **[Mean: 1.943]**  | 34.078 / 37.055 / 38.067 / 33.142 / 27.234 <br> **[Mean: 33.915]** |
| **-125**            | 28.180 / 44.113 / 60.064 / 37.154 / 84.115 <br> **[Mean: 50.725]** | 80.044 / 98.198 / 97.006 / 113.242 / 156.029 <br> **[Mean: 108.885]** |
</details>
<br/>
<details>
<summary><b>點擊展開：查看單一架構 5 次獨立實測詳細數據紀錄</b></summary>

| 模擬器輸出功率 [dBm] | 4 顆衛星達成鎖定之耗時 [s] <br> (Run 1 / 2 / 3 / 4 / 5) [平均值] | 首次定位時間 (TTFF) [s] <br> (Run 1 / 2 / 3 / 4 / 5) [平均值] |
| :-----------------: | :--- | :--- |
| **-115**            | 23.033 / 26.176 / 19.073 / 28.095 / 23.131 <br> **[Mean: 23.902]** | 57.134 / 56.106 / 53.161 / 60.218 / 51.233 <br> **[Mean: 55.570]** |
| **-120**            | 23.083 / 25.171 / 20.245 / 19.143 / 20.129 <br> **[Mean: 21.554]** | 56.133 / 46.075 / 53.237 / 48.005 / 47.221 <br> **[Mean: 50.134]** |
| **-125**            | 32.026 / 25.234 / 31.201 / 27.118 / 31.176 <br> **[Mean: 29.351]** | 61.137 / 47.057 / 65.145 / 74.192 / 60.025 <br> **[Mean: 61.511]** |
</details>

> [!NOTE]
> **導航電文傳輸之物理限制 (Technical Constraints)**
> 系統首次定位時間（TTFF）之時間限制，受限於 GPS 導航電文的廣播結構：
> * **50 bps 極低速率**：導航電文之實體層傳輸速率固定為每秒 50 bits。
> * **18 秒解調下限**：定位必備的完整星曆（Ephemeris）散佈於子框架（Subframe）#1、#2 與 #3。每個子框架長度為 300 bits（耗時 6 秒），**物理上光是完整下載這三組數據，就至少需要 18 秒的連續解調時間。**
> * **框架同步等待**：上述 18 秒尚未包含開機後捕捉電文前導字元（Preamble）以達成框架同步的時間差（Preamble 每 6 秒廣播一次）。