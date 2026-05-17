# GPSR - ARM HPS Bare-metal Implementation

本專案包含兩套針對不同編譯器與 IDE 環境所開發的 GPS 接收器 SoC 實作版本。兩者皆基於 **Intel Cyclone V SoC (DE10-Nano)** 硬體平台。

## 專案目錄說明

| 目錄名稱 | 建議環境 (IDE / Compiler) | 專案定位 | 取得方式 |
| --- | --- | --- | --- |
| **hps_core/** | **Arm DS / AC6** | **主要開發分支**。<br/>包含最新演算法、雙信號加速研究及完整專案結構。 | 須依據 `apply.md` 提出申請。 |
| **hps_altera/** | **DS-5 / AC5** | **舊版相容分支**。<br/>適用於學術單位舊型電腦環境，具備特定的 Makefile 修正機制。 | 僅限於特定配置之實驗室電腦使用。 |

---

## 核心環境差異與選擇指南

### 1. hps_core (Primary)

* **適用對象**：個人筆電或已安裝最新 **Arm Development Studio (Arm DS)** 的環境。
* **技術特點**：使用 **Arm Compiler 6 (LLVM)**，編譯效率較高且支援最新的 C 語言標準。
* **權限說明**：由於包含核心研究代碼，存取前請參考 **[how_to_apply_ds5.md](../docs/how_to_apply_ds5.md)** 完成申請程序。

### 2. hps_altera (Legacy Support)

* **適用對象**：僅能使用 **DS-5 Altera Edition (v5.29.1)** 或 **Arm Compiler 5 (AC5)** 的開發者。
* **技術特點**：針對 AC5 的語法嚴謹度進行了調校，並手動禁用了自動 Makefile 生成以避開編譯器 Bug。
* **重要備註**：本目錄不含源碼原始檔，匯入後須先執行從 `hps_core` 搬移檔案的手動同步動作。

---

## 快速上手 (Getting Started)

1. **環境確認**：檢查您的開發電腦安裝的是 **Arm DS** 還是 **DS-5 Altera Edition**。
2. **查閱文件**：
* 若進入 `hps_core`，請先閱讀該目錄下的 `README.md` 了解功能架構。
* 若進入 `hps_altera`，請務必詳閱其 `README.md` 中的 **[Step 0] 檔案複製說明**，否則專案將無法編譯。
