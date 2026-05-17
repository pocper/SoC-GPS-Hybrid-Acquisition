# GPSR - Altera Edition (Legacy Support)

> [!IMPORTANT]
> **核心開發與導讀建議**
> 1. **專案定位**：本專案僅提供針對 **DS-5 Altera Edition** 環境的編譯配置與差異說明。
> 2. **程式碼來源**：本目錄不包含實體原始碼，所有核心代碼均需從 `hps_core` 手動同步，**請務必參考主開發版本**：
> 👉 **[前往主要開發版本 (hps_core)](../hps_core/README.md)**

## 目錄
- [GPSR - Altera Edition (Legacy Support)](#gpsr---altera-edition-legacy-support)
  - [目錄](#目錄)
  - [1. 開發環境 (Prerequisites)](#1-開發環境-prerequisites)
    - [1.1 DS-5 環境插件必要配置 (CMSIS-Pack Plug-in)](#11-ds-5-環境插件必要配置-cmsis-pack-plug-in)
    - [1.2 CMSIS 軟體包版本限制 (CMSIS 5.9.0)](#12-cmsis-軟體包版本限制-cmsis-590)
  - [2. 專案架構與配置 (Project Structure)](#2-專案架構與配置-project-structure)
  - [4. 如何執行 (Getting Started)](#4-如何執行-getting-started)
    - [Step 0: 複製檔案](#step-0-複製檔案)
    - [Step 1: 匯入專案 (Import Project)](#step-1-匯入專案-import-project)
    - [Step 2: 編譯專案 (Build Project)](#step-2-編譯專案-build-project)
    - [Step 3: 硬體連線與除錯配置 (Debug Configuration)](#step-3-硬體連線與除錯配置-debug-configuration)
    - [Step 4: 顯示輸出資訊 (Monitoring)](#step-4-顯示輸出資訊-monitoring)
  - [檔案差異](#檔案差異)
  - [已知限制與開發建議](#已知限制與開發建議)
  - [已知問題：Assembler 預定義格式錯誤 (A1020E)](#已知問題assembler-預定義格式錯誤-a1020e)
    - [問題描述](#問題描述)
    - [解決辦法 (手動修正 Makefile)](#解決辦法-手動修正-makefile)


## 1. 開發環境 (Prerequisites)
* **硬體平台**: Terasic DE10-Nano (Cyclone V 5CSEBA6U23I7)。
* **開發環境**: ARM DS-5 Intel SoC FPGA Edition (Version 5.29.1)。
* **開發套件**: SoC FPGA Embedded Development Suite Standard Edition (Version 20.1)。
* **作業系統**: CMSIS RTOS v2。
* **編譯器**: ARM Compiler 5 (AC5)。
* **終端機軟體**: PuTTY (用於透過 UART 觀察系統輸出與 HPS 狀態)。
* **硬體需求**: 需先透過 Quartus 編譯並產生 `.rbf` 檔案載入 FPGA，確保 HPS 可透過 Lightweight HPS-to-FPGA Bridge 存取暫存器。

### 1.1 DS-5 環境插件必要配置 (CMSIS-Pack Plug-in)

若使用 DS-5 進行開發，必須安裝插件以支援 **CMSIS-RTOS2 (Keil RTX5)** 與軟體組件管理。系統預設並不支援 CMSIS-Pack 管理器。為了能正確載入專案中的相關軟體組件，必須手動安裝 Eclipse 插件。

1. **下載**：前往 [GitHub](https://github.com/arm-software/cmsis-pack-eclipse/releases) 下載 `CmsisPackPlugIn-2.4.2.zip` 這是 DS-5 5.29.1 所能支援的最高版本）。
2. **安裝**：
   * 開啟 DS-5，透過 `Help` -> `Install New Software...`。
   * 點擊 **`Add...`**，接著點選 **`Archive...`** 並選取剛下載的 `.zip` 檔案。
   * 勾選所有出現的 **CMSIS Pack** 相關組件，並依提示完成安裝（期間可能需要重啟 IDE）。
3. **驗證**：
* 重啟後，對著專案點擊右鍵應可看到 **`Manage Run-Time Environment`** 選項，且能正常開啟 `.rteconfig` 檔案。

### 1.2 CMSIS 軟體包版本限制 (CMSIS 5.9.0)

在安裝完插件後，由於 **ARM Compiler 5 (AC5)** 的語法限制，本專案必須搭配特定版本的 CMSIS 核心庫方能正確編譯。

* **安裝方式**：
  * 從 [Keil 官網](https://www.keil.arm.com/packs/cmsis-arm/versions/) 下載 `ARM.CMSIS.5.9.0.pack`。
  * 開啟 DS-5 中的 **CMSIS Pack Manager** 視窗（若未看到，請點選 `Window` -> `Show View` -> `CMSIS Pack Manager`）。
  * 點選視窗工具列中的 **`Import...`** 按鈕。
  * 選取下載的 `.pack` 檔案完成安裝。


## 2. 專案架構與配置 (Project Structure)

匯入專案後，請確保 `.rteconfig` 中的組件版本如下：

| 類別 (Category)     | 組件名稱 (Component)               | 變體 (Variant) | 實測版本 (Version) |
| ------------------ | ---------------------------------- | -------------- | ----------------- | 
| **CMSIS**          | **CORE**                           | -              | **1.2.1**         | 
| **CMSIS**          | **OS Tick (API) -> Private Timer** | -              | **1.0.2**         |
| **CMSIS**          | **RTOS2 (API) -> Keil RTX5**       | **Source**     | **5.5.4**         | 
| **CMSIS-Compiler** | **STDIN/STDOUT (API) -> Custom**   | -              | **1.1.0**         | 
| **Device**         | **IRQ Controller (API) -> GIC**    | -              | **1.0.1**         | 
| **Device**         | **Startup**                        | -              | **1.0.2**         | 


## 4. 如何執行 (Getting Started)

本節說明如何將專案匯入 **DS-5 Altera Edition**、編譯並透過 **USB-Blaster II** 進行硬體偵錯。

### Step 0: 複製檔案
由於本目錄僅含設定檔，開始前須手動執行以下複製動作：

1. 複製 `firmware/hps_core/bootloader/*` 到 `firmware/hps_altera/bootloader`。
2. 複製 `firmware/hps_core/DE10_serial_parallel/SRC/*` 到 `firmware/hps_altera/DE10_serial_parallel/SRC`。
3. 複製 `firmware/hps_core/DE10_serial_parallel/INC/*` 到 `firmware/hps_altera/DE10_serial_parallel/INC`。
4. 複製 `firmware/hps_core/DE10_serial_parallel/main.c` 到 `firmware/hps_altera/DE10_serial_parallel/main.c`。



### Step 1: 匯入專案 (Import Project)

1. 啟動 **Eclipse for DS-5 v5.29.1**。
2. 點選選單 `File` -> `Switch Workspace` -> `firmware/hps_altera`。
3. 點選選單 `File` -> `Import...`。
4. 選擇 `General` -> `Existing Projects into Workspace`，並點選 `Next`。
5. 在 `Select root directory` 中點選 `Browse..`，路徑切換至 `firmware/hps_altera/DE10_serial_parallel` 目錄後點選 `選擇資料夾`。
6. 在 `Projects` 清單中勾選 `DE10_serial_parallel`，最後點選 `Finish`。

### Step 2: 編譯專案 (Build Project)

1. 點選選單 `Project` -> `Build All`。
2. **編譯檢查**：
   * 出現 **Warnings** 通常為編譯器優化建議，尚可接受。
   * 若出現 **Errors** 則代表 `.axf` 執行檔未成功生成，請檢查 Include 路徑或 CMSIS 庫配置。

### Step 3: 硬體連線與除錯配置 (Debug Configuration)

1. **硬體連結**：
   * 使用一條 **Mini USB 線** 連接 DE10-Nano 上的 **USB-Blaster II 埠** (J13) 與開發電腦。
   * 無需外接額外的偵錯器硬體，該連線同時提供 JTAG 偵錯與 UART 通訊功能。

2. **硬體檢查**：
   * **指撥開關 (MSEL)**：請確保DE10-Nano 上的 **MSEL[4:0]** 開關設定為 `01010` (FPP 模式)以允許 HPS 透過 FPGA Manager 配置硬體。
   * **FPGA 載入狀態**：在啟動 DS 偵錯前，請務必透過 Quartus Programmer 載入對應的 `.rbf` 檔案。
    > [!IMPORTANT]
    > * **重要安全機制**：若 FPGA 未載入或 Bridge 未開啟，HPS 存取 `0xFF200000` 位址空間時會導致 **Data Abort (資料終止異常)**，造成系統當機。

3. **偵錯配置**：
   * 在 `Debug Control` 視窗右鍵點選 `Debug Configurations...`。
   * 在左側樹狀選單連點兩次 `DS-5 Debugger`。
     * **Connection 標籤頁**: 選擇 `Altera` -> `Cyclone V SoC (Dual Core)` -> `Bare Metal Debug` -> `Debug Cortex-A9_0`。
     * **Connection 標籤頁**: Target Connection 選擇 `USB Blaster`。
     * **Connection 標籤頁**: Bare Metal Debug 點擊 `Connection` 旁的 `Browse...`，選擇 `DE-SoC on localhost [USB-1]`。
     * **Files 標籤頁**: 檢查 `Application on host to download` 是否指向 `${workspace_loc:/DE10_serial_parallel/Debug/DE10_serial_parallel.axf}` 並勾選 `Load symbols`。
     * **Debugger 標籤頁**: 在 `Run control` 選擇 `Debug from symbol` 並填入 `main`；同時確保 `Run target initialization debugger script` 已載入 `${workspace_loc:/DE10_serial_parallel/bootloader/preloader.ds}` 以完成 HPS 初始化。
     * **OS Awareness 標籤頁**: 在 `Select OS awareness` 選擇 `Keil CMSIS-RTOS RTX`，以利在偵錯時觀察 **RTOS v2** 任務狀態。

4. **開始偵錯與執行**：
   * 確認上述設定無誤後，點選視窗右下角的 **`Debug`** 按鈕。
   * **下載與掛載**：IDE 將會開始燒錄 `.axf` 執行檔至 HPS 記憶體，並根據設定自動停在 `main` 函式的起始點。

5. **啟動運行**：在 `Debug Control` 視窗點選 `Continue (F8)`，系統才會正式進入 main 並啟動核心調度。

### Step 4: 顯示輸出資訊 (Monitoring)

1. **確認 COM Port 編號**：
   * 在 Windows 任務欄的「開始」圖示點選右鍵，選擇 **「裝置管理員 (Device Manager)」**。
   * 展開 **「連接埠 (COM 和 LPT)」** 項目。
   * 尋找名稱含有 **`Altera USB-Blaster II`** 或 **`USB Serial Port`** 的項目，並記下其後方的編號（例如：`COM3`）。

2. **開啟並配置 PuTTY**：
   * 啟動 **PuTTY** 程式。
   * 在 `Connection type` 選擇 **`Serial`**。
   * 在 `Serial line` 欄位輸入剛才確認的編號（如 `COM3`）。
   * 在 `Speed` 欄位輸入 **`115200`** 。
   * 點選 **`Open`** 開啟終端機視窗。

3. **開始執行與觀測**：
   * 回到 ARM DS 偵錯界面，點選 `Debug Control` 中的 **`Continue (F8)`**。
   * 此時系統正式啟動，你可以在 PuTTY 視窗中即時觀測到 GPS 接收器的初始化資訊、衛星追蹤狀態以及經緯度等運算數據。

## 檔案差異
| 功能項目     | 主要版本 (hps_core)    | Altera 版本 (hps_altera)        |
| ----------- | ---------------------- | ------------------------------ |
| **開發工具** | Arm Development Studio | **DS-5 Altera Edition**     |
| **編譯器**   | ARM Compiler 6 (LLVM)  | **ARM Compiler 5 (armcc)**     |
| **RTOS**    | CMSIS RTOS2 (Modern)   | CMSIS RTOS2 (Keil RTX5 v5.5.4) |

## 已知限制與開發建議
* **檔案結構說明**：本目錄僅保留 `.project`、`.cproject` 等 IDE 必要設定檔。若未執行 **Step 0**，專案將無法編譯。
* **手動程式碼更新**：本專案**不支援**與 `firmware/hps_core/` 的自動同步。若主專案演算法有更新，須手動將程式碼複製至 `firmware/hps_altera/` 對應目錄。
* **Makefile 狀態控制**：DS-5 預設會自動生成 Makefile，但為了修正 A1020E 錯誤，**本專案要求手動禁用自動構建**。請完全依賴 DS-5 IDE 的編譯管理系統進行手動觸發。
* **編譯優化限制**：**Optimization 等級必須設定為 `-O0`**。
  * 若選擇 `-O1` 以上的優化等級，將導致 **CMSIS-RTOS v2 (RTX5)** 無法正常運作。
  * 點選選單 `Project` -> `Properties`。
  * 在左側樹狀選單點選 `C/C++ Build` -> `Settings`。
  * 在 `Tool Settings` 標籤頁 -> `Arm C Compiler 5` -> `Optimization` -> `Optimization level` : `Minimum (-O0)`。

> [!IMPORTANT]
> **重要：編譯清單重整機制**
> 當專案的**檔案結構有任何增減**時，必須重新啟動自動生成機制，否則新檔案不會被編譯：
> 1. **觸發情境**：
>     * 在 `.rteconfig` 中新增或刪除組件。
>     * 手動在專案中**新增或移除任何 `.c`、`.s` 原始碼檔案**。
> 
> 2. **操作流程**：
>     * 重新勾選 `Generate Makefiles automatically`。
>     * 執行 `Build Project` 讓 IDE 更新編譯清單（此時會再次出現 `A1020E` 錯誤）。
>     * **再次取消勾選**並手動修正 `subdir.mk` 中的參數。

---

## 已知問題：Assembler 預定義格式錯誤 (A1020E)

### 問題描述

在編譯過程中，若組譯器（armasm）處理 `irq_armv7a.S` CMSIS 核心檔案時報錯：

```text
A1020E: Bad predefine: _RTE_
A1020E: Bad predefine: ARMCA9
make: [RTE/CMSIS/subdir.mk:76: RTE/CMSIS/irq_armv7a.o] Error 1
```

這是因為 **CMSIS-Pack Plug-in** 在舊版 **DS-5 (AC5)** 環境中生成的預處理參數格式 `--pd "_RTE_"` 無法被組譯器識別。

### 解決辦法 (手動修正 Makefile)

由於 DS-5 在 AC5 環境下生成的組譯參數格式錯誤，請依以下步驟手動「禁用」並「修正」：

1. **初步編譯**：先執行 `Build Project` 讓 IDE 生成編譯目錄。
2. **禁用自動構建 (關鍵步驟)**：
* 在專案上點擊右鍵 -> `Properties`。
* 導航至 `C/C++ Build` -> 標籤頁 `Builder Settings`。
* **取消勾選** `Generate Makefiles automatically`（防止 IDE 覆蓋您的手動修改）。


3. **修正參數**：
* 開啟檔案：`Debug/RTE/CMSIS/subdir.mk`。
* 將 L76 附近的 `armasm --pd "_RTE_" --pd "ARMCA9"` 指令中，刪除 `--pd "_RTE_" --pd "ARMCA9"`。

4. **重新編譯**：儲存後再次點擊 `Build Project`。


