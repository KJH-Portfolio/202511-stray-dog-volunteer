# 🗺️ UBIG 세미 프로젝트 IA (Information Architecture)

> **사용자 경험(UX) 중심의 페이지 계층 구조 및 API 명세**  
> 이 문서는 실제 구현된 서버 사이드 매핑(`@RequestMapping`) 정보를 기반으로 사이트의 정보 구조와 데이터 흐름을 정의합니다.

---

## 📑 목차
1. [📊 서비스 레이아웃 (Overview)](#-1-서비스-레이아웃-overview)
2. [🐾 도메인별 상세 아키텍처](#-2-도메인별-상세-아키텍처)
3. [📑 페이지 및 API 상세 명세](#-3-페이지-및-api-상세-명세)

---

## 📊 1. 서비스 레이아웃 (Overview)

사이트의 핵심 메뉴는 GNB(Global Navigation Bar)를 통해 제어되며, 각 도메인은 독립적인 매핑 서픽스(`.mainpage`, `.vo`, `.me` 등)를 가집니다.

```mermaid
graph TD
    ROOT["🏠 UBIG Main"]
    ROOT --> NAV_ADOPT["🐾 입양<br/>(.mainpage)"]
    ROOT --> NAV_VOL["🌱 봉사활동<br/>(.vo)"]
    ROOT --> NAV_FUND["💰 펀딩 / 기부<br/>(/funding)"]
    ROOT --> NAV_COMM["📝 커뮤니티<br/>(/community)"]
    ROOT --> NAV_MY["📋 마이페이지<br/>(.me)"]

    style ROOT fill:#4CAF50,color:#fff,stroke:#388E3C
    style NAV_ADOPT fill:#FF9800,color:#fff
    style NAV_VOL fill:#8BC34A,color:#fff
```

---

## 2. 도메인별 상세 아키텍처

### 🐾 2.1 입양 도메인 (Adoption)
유기동물 매칭과 심사 프로세스를 관리하는 핵심 영역입니다.

```mermaid
graph LR
    A_MAIN["🐾 입양 메인<br/>(adoption.mainpage)"] --> A_DETAIL["상세 보기<br/>(adoption.detailpage)"]
    A_DETAIL --> A_FORM["신청서 작성<br/>(adoption.applicationpage)"]
    A_FORM --> A_SUBMIT["신청 처리<br/>(AJAX / JSON)"]
    
    style A_MAIN fill:#FF9800,color:#fff
```

### 🌱 2.2 봉사활동 도메인 (Volunteer)
봉사 모집 공고 및 활동 후기 시스템을 구축했습니다.

```mermaid
graph LR
    V_LIST["🌱 모집 목록<br/>(volunteerList.vo)"] --> V_DETAIL["공고 상세<br/>(volunteerDetail.vo)"]
    V_DETAIL --> V_APPLY["참여 신청<br/>(volunteerSign.vo)"]
    V_LIST --> V_REV["활동 후기<br/>(reviewList.vo)"]

    style V_LIST fill:#8BC34A,color:#fff
```

### 💰 2.3 펀딩 및 기부 도메인 (Funding & Donation)
투명한 기부 문화 조성을 위한 펀딩 및 후원 프로세스입니다.

```mermaid
graph LR
    F_LIST["💰 펀딩 목록<br/>(/funding/fundingListView)"] --> F_DETAIL["펀딩 상세<br/>(/funding/fundingDetailView)"]
    F_DETAIL --> F_PAY["기부 결제<br/>(/funding/insertFundingHistory)"]
    F_LIST --> D_MAIN["일반 후원<br/>(/donation/donationView)"]

    style F_LIST fill:#2196F3,color:#fff
```

### 📝 2.4 커뮤니티 및 메시징 (Community & Messaging)
사용자 간 정보 공유 및 소통을 위한 소셜 공간입니다.

```mermaid
graph LR
    C_LIST["📝 커뮤니티 메인<br/>(/community/boardList)"] --> C_DETAIL["게시글 상세<br/>(/community/boardDetail)"]
    C_DETAIL --> C_REPLY["댓글/답글<br/>(AJAX / JSON)"]
    C_LIST --> M_INBOX["📬 받은 쪽지함<br/>(/message/inbox.ms)"]
    M_INBOX --> M_SEND["쪽지 발송<br/>(/message/insert.ms)"]

    style C_LIST fill:#9C27B0,color:#fff
```

### 📋 2.5 회원 및 마이페이지 (Member & MyPage)
개인별 활동 이력 및 회원 정보를 통합 관리합니다.

```mermaid
graph LR
    M_LOG["🔐 로그인/가입<br/>(user/login.me)"] --> M_MY["📋 마이페이지<br/>(user/mypage.me)"]
    M_MY --> M_EDIT["정보 수정<br/>(user/update.me)"]
    M_MY --> M_ACT["활동 내역 조회<br/>(AJAX / JSON)"]

    style M_MY fill:#607D8B,color:#fff
```

---

## 📑 3. 페이지 및 API 상세 명세

| 도메인 | 기능(Feature) | Mapping URL (Real) | 데이터 방식 | 권한 |
|---|---|---|---|---|
| **입양** | 공고 리스트 (필터) | `/adoption.mainpage` | SSR (Model) | 공통 |
| **입양** | 입양 신청서 작성 | `/adoption.applicationpage` | SSR (Model) | 일반 |
| **입양** | 내 입양 신청 현황 | `/adoption.mypage` | **AJAX (JSON)** | 일반 |
| **봉사** | 프로젝트 목록 | `/volunteerList.vo` | SSR (Model) | 공통 |
| **봉사** | 후기 댓글 로드 | `/reviewReplyList.vo` | **AJAX (JSON)** | 공통 |
| **봉사** | 내 봉사 신청 관리 | `/mySignList.vo` | **AJAX (JSON)** | 일반 |
| **펀딩** | 펀딩 목록 조회 | `/funding/fundingListView` | SSR (Model) | 공통 |
| **펀딩** | 펀딩 상세 보기 | `/funding/fundingDetailView` | SSR (Model) | 공통 |
| **펀딩** | 기부금 결제 처리 | `/funding/insertFundingHistory` | **AJAX (JSON)** | 일반 |
| **커뮤니티**| 게시글 상세 보기 | `/community/boardDetail` | SSR (Model) | 공통 |
| **커뮤니티**| 댓글 등록/삭제 | `/community/replyInsert` | **AJAX (JSON)** | 일반 |
| **회원** | 마이페이지 메인 | `/user/mypage.me` | SSR (Model) | 일반 |
| **회원** | 회원 정보 수정 | `/user/update.me` | SSR (Model) | 일반 |
| **회원** | 아이디 중복 체크 | `/user/checkId.me` | **AJAX (JSON)** | 공통 |
| **메시지** | 받은 쪽지함 | `/message/inbox.ms` | SSR (Model) | 일반 |
| **메시지** | 쪽지 삭제 처리 | `/message/delete.ms` | **AJAX (JSON)** | 일반 |

---

### 💡 문서 활용 가이드
- **SSR (Server-Side Rendering)**: Controller에서 `Model` 객체에 데이터를 담아 JSP로 직접 전달하는 방식입니다.
- **AJAX (JSON)**: 페이지 새로고침 없이 비동기적으로 데이터를 요청하고 수신하는 방식입니다. (MyPage의 탭 전환 등에서 사용)
- **Mapping URL**: 실제 WAS에서 처리하는 물리적 엔드포인트입니다.
