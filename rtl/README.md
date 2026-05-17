# GPSR - FPGA Verilog Implementation
本專案實作於 Intel Cyclone V SoC (DE10-Nano) 平台，實現 GPS 接收機架構，包含硬體 (Verilog) 與軟體 (Firmware) 的協作設計。

## 目錄
- [GPSR - FPGA Verilog Implementation](#gpsr---fpga-verilog-implementation)
  - [目錄](#目錄)
  - [1. 開發環境 (Prerequisites)](#1-開發環境-prerequisites)
    - [軟體工具 (Software Tools)](#軟體工具-software-tools)
    - [硬體平台 (Hardware Platform)](#硬體平台-hardware-platform)
  - [2. Quartus 專案配置](#2-quartus-專案配置)
    - [核心檔案說明](#核心檔案說明)
  - [3. 如何執行 (Getting Started)](#3-如何執行-getting-started)
    - [3.1. 環境檢查清單 (Pre-flight Check)](#31-環境檢查清單-pre-flight-check)
    - [3.2. 圖形化介面操作 (GUI Flow)](#32-圖形化介面操作-gui-flow)
    - [3.3. 自動化編譯流程 (CLI / Makefile Flow)](#33-自動化編譯流程-cli--makefile-flow)
  - [4. Avalon Bus 暫存器映射 (Register Map)](#4-avalon-bus-暫存器映射-register-map)
  - [5. 重要提醒 (Important Notices)](#5-重要提醒-important-notices)
  - [資源使用量 (Resource Utilization)](#資源使用量-resource-utilization)
  - [參考資料與文獻 (References)](#參考資料與文獻-references)
    - [核心架構參考 (Core Architecture)](#核心架構參考-core-architecture)
    - [開發資源與技術文獻 (Technical Resources)](#開發資源與技術文獻-technical-resources)


## 1. 開發環境 (Prerequisites)

### 軟體工具 (Software Tools)

* **Quartus Prime**: Version 25.1std.0 (Lite Edition)
* **SoC FPGA Embedded Development Suite**: Version 20.1 (Standard Edition)
* **Platform Designer**: (前身為 Qsys) 用於構建 Avalon Bus 系統

### 硬體平台 (Hardware Platform)

* **Terasic DE10-Nano Development Kit**:
  * **FPGA**: Cyclone V SE 5CSEBA6U23I7
  * **HPS**: Dual-core ARM Cortex-A9

## 2. Quartus 專案配置
### 核心檔案說明
| 檔案名稱                      | 說明                                      |
| ---------------------------- | ----------------------------------------- |
| `rtl/DE10_NANO_SoC_GHRD.qpf` | Quartus 專案主檔案 (Project File)          |
| `rtl/DE10_NANO_SoC_GHRD.qsf` | 專案設置與 Pin Assignment (Setting File)   |
| `rtl/DE10_NANO_SoC_GHRD.sdc` | 時序約束檔案 (Synopsys Design Constraints) |
| `rtl/DE10_NANO_SoC_GHRD.v`   | Top-level 頂層模組                         |
| `rtl/soc_system.qsys`        | Platform Designer (HPS-FPGA Bridge) 配置檔 |

## 3. 如何執行 (Getting Started)
在執行任何編譯指令前，請務必確認開發環境已正確配置。

### 3.1. 環境檢查清單 (Pre-flight Check)
> [!NOTE]
> Quartus路徑及EDS路徑需依實際安裝位置自行替換。

請依序確認以下工具是否已加入 Windows **環境變數 (System PATH)**，否則 `make` 指令將無法呼叫編譯器。

1. Quartus 工具鏈
   * **路徑**：`C:\altera_lite\25.1std\quartus\bin64`
   * **驗證**：在終端機輸入 `quartus_sh -v`。
   * **預期結果**：顯示 Quartus Prime 版本資訊。

2. Platform Designer (Qsys)
   * **路徑**：`C:\altera_lite\25.1std\quartus\sopc_builder\bin`
   * **驗證**：在終端機輸入 `qsys-script --help`。
   * **預期結果**：顯示 qsys-script 的參數說明。

3. SoC Embedded Development Suite (EDS)
   * **路徑**：`C:\intelFPGA\20.1\embedded\ip\altera\hps\altera_hps\hwlib\include`
   * **驗證**：`if exist "C:\intelFPGA\20.1\embedded\ip\altera\hps\altera_hps\hwlib\include\soc_cv_av\socal\hps.h" (echo File Found) else (echo File Missing)`。
   * **預期結果**：顯示 File Found

4. Make 編譯工具 (MinGW)
   * **安裝**：若未安裝，請至 [MinGW SourceForge](https://sourceforge.net/projects/mingw/) 下載。
   * **驗證**：在終端機輸入 `make -v`。
   * **預期結果**：顯示 `GNU Make` 版本資訊。

### 3.2. 圖形化介面操作 (GUI Flow)

若需要手動編譯專案，請參考以下步驟：

1. **開啟專案**：
   * 啟動 Quartus Prime
   * 點選 `File` -> `Open Project`，選擇 `rtl/DE10_NANO_SoC_GHRD.qpf`。

2. **配置 FFT/IFFT IP檔案**：
   * **開啟工具**：點選選單 `Tools` -> `Platform Designer`。
   * **開啟專案**：在彈出視窗中選取並載入 `rtl/ip/FFT_IFFT/FFT_IFFT.qsys`。
   * **關鍵參數檢查**：
     * **Length**: `4096`
     * **Direction**: `Bi-directional`
     * **Data Flow**: `Variable Streaming`
     * **Input Order**: `Natural`
     * **Output Order**: `Digit Reverse`
     * **Representation**: `Single Floating Point`
   * **生成硬體 (Generate HDL)**：
     * 確認參數無誤後，請點選右下角 **[Generate HDL...]**。
     * 在彈出的 `Generation` 視窗中：
     * **取消勾選** `Create block symbol file (.bsf)`（可縮短生成時間）。
     * 點選 **[Generate]** 開始轉換硬體描述語言。
   * **結束配置**：
     * 出現 `Generate: completed with warnings` 是正常現象，請直接點選 `Close`。
     * 點選 `Finish` 關閉 Platform Designer，回到 Quartus 主介面。


3. **配置 頂層 Platform Designer (soc_system)**：
   * **開啟工具**：點選選單 `Tools` -> `Platform Designer`。
   * **開啟專案**：載入檔案 `rtl/soc_system.qsys`。
   * **SPI 關鍵參數檢查**：
     * 在 System Contents 視窗中雙擊 **`spi_0`** (或對應的 SPI IP)。
     * **重要設定**：確保 `Clock polarity` 與 `Clock phase` 皆為 **`0`**，且資料寬度為 **`32`** bits，否則將導致 DE10-Nano 無法正確與 MAX2769 發送參數。
   * **生成硬體 (Generate HDL)**：
     * 若為第一次編譯、或是曾修改過 `rtl/verilog/` 下的檔案，請點選右下角 **[Generate HDL...]**。
     * 在彈出的 `Generation` 視窗中：
     * **取消勾選** `Create block symbol file (.bsf)`（可縮短生成時間）。
     * 點選 **[Generate]** 開始轉換硬體描述語言。
   * **結束配置**：
     * 出現 `Generate: completed with warnings` 是正常現象，請直接點選 `Close`。
     * 點選 `Finish` 關閉 Platform Designer，回到 Quartus 主介面。

4. **開始編譯**：
   * 點選選單 `Processing` -> `Start Compilation` (編譯時間約25~30分鐘)。

   > [!IMPORTANT]
   > 由於專案架構複雜，編譯過程中若發生無預警崩潰（Crash），請參閱  
   > 👉 [重要提醒：Analysis & Synthesis 崩潰修復](#fix-crash)

5. **燒錄至開發板**：
   1. **硬體連接**：
      * 使用一條 **Mini USB 線** 連接 DE10-Nano 上的 **USB-Blaster II 埠** (J13) 與開發電腦。
      * 無需外接額外的偵錯器硬體，該連線同時提供 JTAG 偵錯與 UART 通訊功能。
   
   2. **開啟燒錄工具**：點選選單 **`Tools` -> `Programmer**`。
   
   3. **檢查硬體偵測 (Hardware Setup)**：
      * 若 `Hardware Setup...` 顯示 **`No Hardware`**，請點選該按鈕。
      * 將 `Currently Selected hardware` 由 `No Hardware` 切換為 **`DE-SoC [USB-1]`**，隨後點選 `Close`。
   
   4. **自動偵測裝置**：
      * 點選左側 **[Auto Detect]**，於彈出視窗選擇 **`5CSEBA6`** 裝置並點選 `OK`。
      * 若跳出詢問視窗：
        > `The auto-detected device chain does not match the Programmer's device list. Do you want to update the Programmer's device list, overwriting any existing settings?`
        > 請直接點選 **`Yes`** (或 OK) 以更新裝置鏈結。
    
    5. **載入編譯檔案**：
         * 於 `5CSEBA6` 裝置上點選右鍵，選擇 **`Change File`**。
         * 路徑指向：`rtl/output_files/DE10_NANO_SoC_GHRD_time_limited.sof`。

    6. **執行燒錄**：
         * 勾選 **`Program/Configure`** 核取方塊。
         * 點選左側 **[Start]** 開始執行。

    7. **確認結果**：
         * 當右上角 **Progress** 顯示 `100% (Successful)` 並跳出 `OpenCore Plus Status` 視窗時，即代表燒錄成功並開始運行。

   > [!IMPORTANT]
   > **運行時限提醒**：由於使用 OpenCore Plus IP，燒錄後請參考下方說明。  
   > 👉 [運行階段：OpenCore Plus 時效限制](#opencore-plus)

> [!TIP]
> **同步韌體位址**：若你在 Platform Designer 中修改了模組基底位址，編譯完硬體後，請務必執行 `make -C rtl header` 來同步韌體開發所需的 `hps_0.h` 標頭檔。

### 3.3. 自動化編譯流程 (CLI / Makefile Flow)
確認 [3.1. 環境檢查清單](#31-環境檢查清單-pre-flight-check) 中的工具皆可正常執行後，即可開始執行自動化編譯流程。

``` makefile
# Quartus 編譯流程(Mapping, Fitting, Assembly)
make -C rtl

# 燒錄板子
make -C rtl flash

# 生成韌體所需的標頭檔(Header File)
make -C rtl header
```

## 4. Avalon Bus 暫存器映射 (Register Map)
本專案包含三個核心模組，詳細的暫存器偏移量與位元定義請參考：  
👉 [詳細暫存器定義說明書](../docs/register_map.md)

| 模組名稱                        | 基底位址 (Base Address) | 說明                      |
| ------------------------------ | ---------------------- | ------------------------- |
| **Serial Search**              | `0x000`                | 13 個衛星追蹤通道與系統控制 |
| **Parallel Code Phase Search** | `0x400`                | 平行碼相位搜尋加速模組      |
| **MAX2769**                    | `0x820`                | 射頻前端控制模組            |

## 5. 重要提醒 (Important Notices)
<span id="fix-crash"></span>

1. 編譯階段: Analysis & Synthesis 崩潰修復
   * **現象**：Quartus 在編譯約3~5分鐘時突然無預警崩潰（Crash），通常發生於 `Analysis & Synthesis` 階段。
   * **報錯資訊**：`Internal Error: Sub-system: OPT, File: /quartus/synth/opt/opt_carry_pack.cpp, Line: 1686` (或任何涉及 OPT 子系統的內部錯誤)。
   * **解決對策**：
     1. **關閉軟體**：關閉 Quartus Prime 軟體。
     2. **清理數據庫**：從專案目錄中手動刪除 **`db`** 與 **`incremental_db`** 兩個資料夾。
     3. **重新編譯**：重啟 Quartus 並重新執行完整編譯 (點選選單 `Processing` -> `Start Compilation`)。
   * **重要備註**：
     * 刪除這些資料夾僅會移除編譯快取，不會影響你的 `.v` 源碼或 `.qsf` 設置檔。
     * 由於邏輯優化過程具備隨機性，若重新編譯後仍遇到相同錯誤，請重複上述步驟直至通過。

2. 編譯階段：EDA Netlist Writer 錯誤
   * **現象**：編譯進度達到 80%~100% 時，最後一項 `EDA Netlist Writer` 會顯示紅色 **Failed**。
   * **原因**：由於專案使用了 FFT/IFFT 等具備 IP 授權限制的模組，Quartus Lite 版本不支援為此類 IP 產生第三方模擬用的網表(EDA Netlist)。
   * **影響**：**完全不影響** 實際的 `.sof` 檔案產生與硬體燒錄，只要其餘編譯階段（如 Fitter, Assembler）皆成功，即可進行燒錄。
   * **解決對策**：
     * 對策一：掛載正式授權
       1. 點選選單`Tools` -> `License Setup...`。
       2. 在左側樹狀選單點選 `IP Settings` -> `License Setup`。
       3. 在右側 `License file` 輸入 `port@server_ip` （例如 27000@140.113.xxx.xxx）。
     * 對策二：關閉 EDA 網表產生
       1. 點選選單`Assignments` -> `Settings`。
       2. 在左側樹狀選單點選 `EDA Tool Settings` -> `Simulation`。
       3. 將右側 `Tool name`選項改為 `<none>`。
       4. 點選 OK 並重新編譯，該錯誤將不再出現。
   * **重要備註**：
     * 模擬限制：若將`Tool name`選項改為 `QuestaSim`，Quartus 才會生成整個專案的模擬所需檔案。
     * 範圍說明：此模擬檔案僅包含 FPGA 內部的邏輯電路（RTL），**不包含** Platform Designer (Qsys) 的 Avalon Bus 系統架構及 HPS (ARM) 硬體端內容。

<span id="opencore-plus"></span>

3. 燒錄階段：OpenCore Plus 時效限制
   * **現象**：燒錄至板子後，若連續運行約 **1 小時**，GPS 訊號追蹤可能會突然異常或中斷。
   * **原因**：專案內含的 FFT/IFFT IP 屬於 OpenCore Plus 評估版，在沒有正式授權 (Standard/Pro License) 的情況下有運行時限。
   * **解決對策**：
     1. 必須保持 **USB Blaster 傳輸線** 連接板子與電腦，不可拔除。
     2. 若 IP 失效導致追蹤失敗，請重新執行 `make flash` 重新燒錄即可恢復運作。


## 資源使用量 (Resource Utilization)

| Resource Type                | Usage     | Capacity  | Percentage |
| :--------------------------- | :-------- | :-------- | :--------- |
| **Logic utilization (ALMs)** | 23,879    | 41,910    | 57%        |
| **Total registers**          | 40,703    | -         | -          |
| **Block memory bits**        | 1,676,356 | 5,662,720 | 30%        |
| **Total DSP Blocks**         | 82        | 112       | 73%        |

## 參考資料與文獻 (References)

### 核心架構參考 (Core Architecture)

* **[GitHub - kristianpaul/gnss-sdr-ru](https://github.com/kristianpaul/gnss-sdr-ru/tree/master)**: 本專案 GPS 接收機之數位基頻 (Digital Baseband) 硬體架構主要參考此開源專案。

### 開發資源與技術文獻 (Technical Resources)

<!-- * **DE10-Nano User Manual**: 關於 Cyclone V SoC 硬體配置與 HPS-FPGA Bridge 之技術細節。 -->
* **[DE10-Nano User Manual](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=205&No=1046&PartNo=4)**: 關於 Cyclone V SoC 硬體配置與 HPS-FPGA Bridge 之技術細節 (Terasic 官方資源)。
* **[Cyclone V Hard Processor System Technical Reference Manual](https://www.intel.com/programmable/technical-pdfs/683126.pdf)**: 包含 HPS 暫存器定義與位址映射 (Address Map) 的權威文件。