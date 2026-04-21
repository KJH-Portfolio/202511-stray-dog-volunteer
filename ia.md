# UBIG 세미 프로젝트 IA (Information Architecture)

> 사이트 전체 페이지 계층 구조 및 기능 정의  
> Mermaid `graph TD` 문법 / GitHub 자동 렌더링 지원

---

## 📑 목차
1. [전체 사이트 구조 (Overview)](#1-전체-사이트-구조-overview)
2. [도메인별 상세 구조](#2-도메인별-상세-구조)
   - [🐾 입양](#-입양)
   - [🌱 봉사활동](#-봉사활동)
   - [💰 펀딩 / 기부](#-펀딩--기부)
   - [📝 커뮤니티](#-커뮤니티)
   - [⚙️ 관리자 및 마이페이지](#-관리자-및-마이페이지)

---

## 1. 전체 사이트 구조 (Overview)

상단 내비게이션 바(GNB)를 중심으로 한 메인 계층 구조입니다.

```mermaid
graph TD
    ROOT["🏠 UBIG 메인"]

    ROOT --> NAV_ADOPT["🐾 입양"]
    ROOT --> NAV_VOL["🌱 봉사활동"]
    ROOT --> NAV_FUND["💰 펀딩"]
    ROOT --> NAV_COMM["📝 커뮤니티"]
    ROOT --> NAV_MY["📋 마이페이지 / 로그인"]
    ROOT --> NAV_ADMIN["⚙️ 관리자 (ADMIN 전용)"]

    style ROOT fill:#4CAF50,color:#fff,stroke:#388E3C
    style NAV_ADOPT fill:#FF9800,color:#fff
    style NAV_VOL fill:#8BC34A,color:#fff
    style NAV_FUND fill:#2196F3,color:#fff
    style NAV_COMM fill:#9C27B0,color:#fff
    style NAV_MY fill:#00BCD4,color:#fff
    style NAV_ADMIN fill:#F44336,color:#fff
```

---

## 2. 도메인별 상세 구조

### 🐾 입양
유기동물 보호 및 입양 신청을 담당하는 도메인입니다.

```mermaid
graph LR
    SUB_A["🐾 입양 메인"] --> A1["동물 목록\n(검색·필터)"]
    A1 --> A2["동물 상세 보기"]
    A2 --> A3{입양 신청}
    A3 -->|"🔒 로그인 필요"| A4["입양 신청서 작성"]
    A4 --> A5["신청 완료"]
    
    style SUB_A fill:#FF9800,color:#fff
```

### 🌱 봉사활동
봉사 프로그램 참여 및 후기 작성을 담당합니다.

```mermaid
graph LR
    SUB_V["🌱 봉사 메인"] --> V1["프로그램 목록\n(상태 필터)"]
    V1 --> V2["프로그램 상세"]
    V2 --> V3{참여 신청}
    V3 -->|"🔒 로그인"| V4["신청 완료"]
    
    V2 --> V5["참여 후기 목록"]
    V5 --> V6{후기 작성}
    V6 -->|"🔒 로그인"| V7["후기 등록"]
    V5 --> V8["후기 상세 보기"]

    style SUB_V fill:#8BC34A,color:#fff
```

### 💰 펀딩 / 기부
프로젝트 후원 및 물품 기부 신청을 담당합니다.

```mermaid
graph LR
    SUB_F["💰 펀딩 메인"] --> F1["펀딩 목록"]
    F1 --> F2["펀딩 상세"]
    F2 --> F3{후원하기}
    F3 -->|"🔒 로그인"| F4["후원 진행 / 결제"]
    F4 --> F5["후원 완료"]
    
    SUB_F --> F6["물품 기부 신청"]
    F6 -->|"🔒 로그인"| F7["기부 내용 작성"]

    style SUB_F fill:#2196F3,color:#fff
```

### 📝 커뮤니티
사용자 간 소통 및 문의 게시판을 담당합니다.

```mermaid
graph LR
    SUB_C["📝 커뮤니티 메인"] --> C1["게시판 목록\n(전체/공지/자유/문의/후기)"]
    C1 --> C2["게시글 상세"]
    C2 --> C3["댓글 / 좋아요 / 신고"]
    C1 --> C4{글쓰기}
    C4 -->|"🔒 로그인"| C5["게시글 작성"]
    
    style SUB_C fill:#9C27B0,color:#fff
```

### ⚙️ 관리자 및 마이페이지
회원 관리 및 개인 신청 내역을 확인할 수 있는 영역입니다.

```mermaid
graph TD
    subgraph MyPage ["📋 마이페이지 (로그인 필요)"]
        MY1["내 정보 수정"]
        MY2["신청 내역\n(입양/봉사/펀딩)"]
        MY3["쪽지함\n(받은/보낸)"]
        MY4["회원 탈퇴"]
    end

    subgraph Admin ["⚙️ 관리자 권한 (ADMIN)"]
        AD1["회원 관리\n(정지·탈퇴)"]
        AD2["동물/봉사/펀딩 관리\n(등록·삭제·승인)"]
        AD3["커뮤니티 관리\n(공지등록·신고처리)"]
        AD4["1:1 채팅 상담"]
    end

    style MyPage fill:#E0F7FA,stroke:#00BCD4
    style Admin fill:#FFEBEE,stroke:#F44336
```

---

## 📋 페이지 목록 요약

| 영역 | 페이지 | 로그인 필요 | 접근 권한 |
|---|---|---|---|
| **입양** | 목록, 상세 | ❌ | 공통 |
| **입양** | 신청서 작성 | ✅ | 일반회원 |
| **봉사** | 목록, 상세, 후기 | ❌ | 공통 |
| **봉사** | 참여 신청, 후기 작성 | ✅ | 일반회원 |
| **기타** | 로그인, 회원가입 | ❌ | 비로그인 |
| **마이페이지** | 정보수정, 신청내역, 쪽지 | ✅ | 일반회원 |
| **관리자** | 회원/콘텐츠/신고 관리, 상담 | ✅ | 관리자 |
