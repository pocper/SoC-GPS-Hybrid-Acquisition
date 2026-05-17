# 如何申請 DS-5 / Arm DS 開發環境 (TSRI 資源)

本文件說明如何透過 **TSRI (台灣半導體研究中心)** 申請本專案所需的開發工具授權。

> [!IMPORTANT]
> **申請前提**：您必須具備 **TSRI 有效會員資格**。若非會員，將無法存取受保護的軟體授權。

## 注意事項 (Notice)
1. **並行處理**：主要流程（TSRI 申請與 DNS 申請）可同時進行，兩者皆完成後方可連線授權。
2. **網路驗證**：TSRI 的 License Server 需驗證申請設備之 IP 是否具備「正反查 (Forward/Reverse DNS Lookup)」能力。

## 主要流程
1. **TSRI 申請 EDA Tools 授權**
2. **校園/單位 DNS 申請正反查登錄**

## 詳細申請步驟

### 1. TSRI 申請 EDA Tools
- **註冊帳號**：請至 [TSRI 會員服務平台](https://www.tsri.org.tw/) 註冊或確認您的會員身分。
- **軟體申請**：依照 [TSRI EDA tools 申請流程](https://www.tsri.org.tw/main.jsp) 辦理。
- **IP 登錄**：完成申請後，需於 TSRI 平台登錄您的設備公網 IP。
- **軟體取得**：
  - 登入後至：軟體資訊 > Embedded Software > DS。
  - 下載對應版本並依照 `Installation_Guide` 進行安裝。

### 2. 校園 DNS 正反查申請 (以 NYCU 為例)
由於 TSRI 伺服器安全性要求，您的 IP 必須綁定 Domain Name。
- **連線系統**：進入 [NYCU DNS 服務申請系統](https://dns.nycu.edu.tw/)。
- **功能選單**：點選 `網域名稱登錄` 並接受管理規範。
- **填寫基本資料**：
  - **主管資訊**：請填寫您的指導教授 姓名、工號與電郵。
- **申請細節**：
  - **託管期限**：建議選擇 3 年（視研究需求而定）。
  - **單位**：選擇您的所屬實驗室。
