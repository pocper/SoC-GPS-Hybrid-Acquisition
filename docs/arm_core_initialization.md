# Cyclone V HPS 底層暫存器與時脈校正指南

本文件紀錄了本專案在 ARM DS 或 DS-5 環境下，為了正確驅動 CMSIS RTOS v2 (Keil RTX5) 與 HPS 底層周邊，針對 ARMCA9 核心配置進行關鍵的底層修正。

> [!NOTE]
> 本專案已將所有修正完畢的標頭檔與設定直接納入版本控制。當您匯入專案時，正確的硬體參數與暫存器位址會自動覆蓋 (Override) 系統預設值，一般情況下您無需手動修改任何程式碼。本文件僅供環境核對與底層時脈/硬體原理解析使用。

## 目錄
- [Cyclone V HPS 底層暫存器與時脈校正指南](#cyclone-v-hps-底層暫存器與時脈校正指南)
  - [目錄](#目錄)
  - [核心修正與架構核對清單](#核心修正與架構核對清單)
    - [1. GIC 與 Private Timer 實體硬體位址修正](#1-gic-與-private-timer-實體硬體位址修正)
    - [2. 主頻時脈校正與 Private Timer 分頻計算](#2-主頻時脈校正與-private-timer-分頻計算)
    - [3. 關閉虛擬記憶體管理單元 (Disable MMU)](#3-關閉虛擬記憶體管理單元-disable-mmu)
    - [4. 記憶體基底重映射 (Memory Base Remapping)](#4-記憶體基底重映射-memory-base-remapping)
    - [5. 編譯優化等級配置說明 (Optimization Level)](#5-編譯優化等級配置說明-optimization-level)
    - [6. 記憶體佈局與核心區段配置 (Scatter File Configuration)](#6-記憶體佈局與核心區段配置-scatter-file-configuration)
    - [7. RTOS 核心內核配置與執行緒上限核對 (RTX Kernel Configuration)](#7-rtos-核心內核配置與執行緒上限核對-rtx-kernel-configuration)
  - [專案參考 (Reference)](#專案參考-reference)

## 核心修正與架構核對清單

### 1. GIC 與 Private Timer 實體硬體位址修正

  * **檢視檔案**：專案目錄下的 `INC/ARMCA9.h`
  * **修正原理**：標準 Cortex-A9 的 GIC 分配器與 Private Timer 預設位址（`0x2C00_XXXX`）與 Cyclone V HPS 的實體暫存器映射地圖不符。本專案已在本地標頭檔中將其強制重對映至 Intel 官方規範之 `0xFFFE_XXXX` 位址，確保 FPGA 中斷訊號與系統計時器能被正確捕捉。

  * **正確配置核對 (After)**：

      ```c
      #define GIC_DISTRIBUTOR_BASE (0xFFFED000UL)
      #define GIC_INTERFACE_BASE   (0xFFFEC100UL)
      #define GLOBAL_TIMER_BASE    (0xFFFEC200UL)
      #define TIMER_BASE           (0xFFFEC600UL)
      ```

### 2. 主頻時脈校正與 Private Timer 分頻計算

  * **檢視檔案**：專案目錄下的 `RTE/Device/ARMCA9/system_ARMCA9.c`
  * **修正原理**：
    1. **MPU 實際主頻**：雖然 Intel Quartus Platform Designer (Qsys) 中 MPU 時脈預設標註為 800 MHz，但當 DE10-Nano 開機並執行 Preloader 時，硬體會將 MPU 主頻（`mpu_base_clk`）重新配置為 **925 MHz**，系統時脈計算須以 Preloader 實際運行之數值為主。
    2. **OS Tick 來源分頻**：CMSIS RTOS v2 的系統時鐘（OS Tick）完全依賴 Cortex-A9 內部的 Private Timer。根據 Intel 官方發佈之 *Cyclone V Hard Processor System Technical Reference Manual* 規範，Private Timer 的時鐘來源為 `mpu_periph_clk`，其頻率為 MPU 主頻固定 **4 分頻**（925 MHz / 4 = 231.25 MHz）。因此，必須將 `SYSTEM_CLOCK` 常數精確修正為 `231250000U`，否則系統任務排程與 `osDelay` 時間將嚴重失準。

  * **正確配置核對 (After)**：
     ```c
     #define  SYSTEM_CLOCK  231250000U
     ```

### 3. 關閉虛擬記憶體管理單元 (Disable MMU)

  * **檢視檔案**：專案目錄下的 `RTE/Device/ARMCA9/system_ARMCA9.c` (內部的 `SystemInit` 函數)
  * **修正原理**：在即時作業系統（RTOS）與 HPS 硬體混合架構下，為了讓 CPU 核心直接透過實體位址存取 FPGA 側的記憶體對映 (Memory-mapped) 暫存器（`0xFF200000`）與核心周邊，專案中已將預設開啟的 MMU 轉譯功能改為停用。

  * **正確配置核對 (After)**：
      ```c
      // Create Translation Table
      // MMU_CreateTranslationTable();

      // Enable MMU
      // MMU_Enable();
      ```

### 4. 記憶體基底重映射 (Memory Base Remapping)

  * **檢視檔案**：專案目錄下的 `RTE/Device/ARMCA9/mem_ARMCA9.h`
  * **修正原理**：預設位址 `0x80000000` 位於外部 SDRAM。但在除錯引導階段，為了確保 RTOS 核心能直接在 HPS 內部的 On-Chip RAM 穩定執行，本專案已將暫存空間修正至 `0x00000000` 實體起始位址，避免在未初始化外部 SDRAM 前發生存取錯誤。

  * **正確配置核對 (After)**：
      ```c
      #define __ROM_BASE       0x00000000
      #define __RAM_BASE       0x00200000
      #define __TTB_BASE       0x10000000

      #define __RW_DATA_SIZE   0x00100000
      ```

### 5. 編譯優化等級配置說明 (Optimization Level)
  
  * **專案預設配置**：本專案的編譯優化等級**已預先在專案設定檔中鎖定為 `-O0`**。當您匯入專案至 ARM DS 或 DS-5 後，系統會自動套用此配置，一般情況下無需手動修改。
  * **設定核對路徑**：若需確認配置，可於專案點選右鍵 -> `Properties` -> `C/C++ Build` -> `Settings` -> `Tool Settings` -> `ARM C/C++ Compiler` -> `Optimization`，確認等級為 **`-O0` (Minimum optimization / Do not optimize)**。
  * **修正原理**：鎖定 **`-O0`** 可防止編譯器因高階優化進行指令重排、將核心狀態鎖死於 CPU 暫存器、省略硬體指標讀寫，或破壞 Cortex-A9 的 8-Byte 堆疊對齊，從而確保 RTOS 任務切換與底層暫存器控制的時序完全精準。

### 6. 記憶體佈局與核心區段配置 (Scatter File Configuration)

  * **檢視檔案**：專案目錄下的 `RTE/Device/ARMCA9/ARMCA9_ac6.sct`
  * **修正原理**：
    1. **SDRAM 範圍修正**：本專案已將預設的分散載入空間調整為 `0x00000000 0x40000000`（實體 1 GB 空間），以完全符合 Cyclone V HPS 實體記憶體地圖的定址規範。
    2. **自定義專屬硬體快取區段**：為了優化衛星訊號處理之並行運算效率，並確保跨時鐘域（CDC）數據流傳輸的穩定性，本專案在 Scatter file 中顯式定義了兩個獨立的核心數據區段。編編譯器會自動將其配置於高速實體記憶體特定位址中，避免與系統常規變數或執行緒堆疊（Stack）產生資源衝突。
  * **正確配置核對 (After)**：

      ```c
      /* 衛星訊號運算專屬儲存區域 */
      CORRELATION_REGION 0x00600000 CORRELATION_SIZE
      { *(correlation_section) }                                 
      
      /* 跨時鐘域處理數據流專屬儲存區域 */
      DATA_CDC_REGION 0x02000000 DATA_CDC_SIZE
      { *(data_CDC_section) }
      ```

  * **相關連結器警告說明 (Linker Warning L6329W)**：

    * **警告訊息**:當編譯專案時，`主控台 (Console)` 可能會輸出以下警告訊息：
        ```text
        "ARMCA9_ac6.sct", line 86: Warning: L6329W: Pattern *(correlation_section) only matches removed unused sections.
        "ARMCA9_ac6.sct", line 89: Warning: L6329W: Pattern *(data_CDC_section) only matches removed unused sections.
        ```

    * **原因解析**：此警告代表 ARM Linker 在連結階段時，發現 C 原始碼中**目前尚未有變數或函式實際使用 `__attribute__((section("correlation_section")))` 進行宣告**，或是該宣告的變數因未被程式碼呼叫而被優化器判定為無效區段。
    * **處理對策**：此為正常現象，並不影響系統編譯與其餘功能的運行。當後續演算法開發完成並正確指定對應區段後，此警告將自動消失；或可視需求在代碼中使用 `__attribute__((used))` 強制保留該區段。

### 7. RTOS 核心內核配置與執行緒上限核對 (RTX Kernel Configuration)

* **檢視檔案**：專案目錄下的 `RTE/CMSIS/RTX_Config.h`
* **修正原理**：在 CMSIS RTOS v2 (Keil RTX5) 內核中，系統心跳（OS Tick）預設已配置為 **1000 Hz**（即每 1 ms 觸發一次系統排程），核心時脈則會自動咬合並同步繼承自 `system_ARMCA9.c` 中修正完畢的 `SYSTEM_CLOCK` 常數。然而，為了配合本專案包含衛星訊號並行搜尋、追蹤、PVT 運算以及顯示等多任務並行的複雜架構，必須手動放寬內核允許的最大執行緒數量上限，避免 RTOS 核心在初始化階段因資源超限而拒絕建立新執行緒。

* **關鍵配置核對 (After)：**

    ```c
    // 限制系統同時執行的最大執行緒數量 (包含使用者執行緒與內核常駐執行緒)
    #define OS_THREAD_NUM             8
    ```

## 專案參考 (Reference)

* **[Intel Cyclone V HPS Address Map](https://www.intel.com/content/www/us/en/programmable/hps/cyclone-v/hps.html)**: 詳列 HPS 暫存器定義、中斷 ID 以及 Lightweight HPS-to-FPGA Bridge 的物理位址映射。
* **[Cyclone® V Hard Processor System Technical Reference Manual](https://www.intel.com/programmable/technical-pdfs/683126.pdf)**: 官方技術手冊，主要參考第 2 章的 Clock Manager 與 Private Timer 時脈分頻架構。
* **[CSDN 參考文獻：Cortex-A9 RTOS 移植異常分析與解決對策](https://blog.csdn.net/qq_28576837/article/details/124969857)**: 關於通用 CMSIS 軟體包在 Cortex-A9 實體硬體上重對映的底層邏輯參考。