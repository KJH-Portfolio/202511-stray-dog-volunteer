# UBIG 세미 프로젝트 User Flow

> 사용자 행동 경로 다이어그램  
> Mermaid `flowchart` 문법 / GitHub 자동 렌더링 지원

---

## 📑 목차

1. [역할별 플로우](#1-역할별-플로우)
   - [비로그인 사용자](#-비로그인-사용자)
   - [일반 사용자 (USER)](#-일반-사용자-user)
   - [관리자 (ADMIN)](#-관리자-admin)
2. [기능별 플로우](#2-기능별-플로우)
   - [입양 플로우](#-입양-플로우)
   - [봉사활동 플로우](#-봉사활동-플로우)
   - [펀딩 플로우](#-펀딩-플로우)
3. [통합 플로우](#3-통합-플로우)

---

## 1. 역할별 플로우

### 👁️ 비로그인 사용자

```mermaid
flowchart TD
    START([사이트 접속]) --> MAIN[메인 페이지]

    MAIN --> M1[입양 목록 조회]
    MAIN --> M2[봉사활동 목록 조회]
    MAIN --> M3[펀딩 목록 조회]
    MAIN --> M4[커뮤니티 게시판 조회]
    MAIN --> M5[로그인 / 회원가입]

    %% 입양
    M1 --> A1[동물 상세 조회]
    A1 --> A2{입양 신청 시도}
    A2 -->|"🔒 로그인 필요"| LOGIN[로그인 페이지]

    %% 봉사
    M2 --> V1[프로그램 상세 조회]
    V1 --> V2[후기 목록 조회]
    V1 --> V3{봉사 신청 시도}
    V3 -->|"🔒 로그인 필요"| LOGIN

    %% 펀딩
    M3 --> F1[펀딩 상세 조회]
    F1 --> F2{후원 시도}
    F2 -->|"🔒 로그인 필요"| LOGIN

    %% 커뮤니티
    M4 --> C1[게시글 상세 조회]
    C1 --> C2{글 작성/댓글 시도}
    C2 -->|"🔒 로그인 필요"| LOGIN

    %% 로그인 이후
    LOGIN --> REG[회원가입] --> LOGIN
    LOGIN -->|성공| LOGGED[로그인 완료 → 원래 페이지로]
    LOGIN -->|실패| FAIL[아이디/비번 확인 및 재시도]
    FAIL --> LOGIN

    style START fill:#4CAF50,color:#fff
    style LOGIN fill:#FF9800,color:#fff
    style LOGGED fill:#2196F3,color:#fff
    style FAIL fill:#F44336,color:#fff
```

---

### 👤 일반 사용자 (USER)

```mermaid
flowchart TD
    START([로그인]) --> MAIN[메인 페이지]

    MAIN --> M1["🐾 입양"]
    MAIN --> M2["🌱 봉사활동"]
    MAIN --> M3["💰 펀딩"]
    MAIN --> M4["📝 커뮤니티"]
    MAIN --> M5["📋 마이페이지"]
    MAIN --> M6["💬 쪽지"]

    %% ── 입양 ──
    M1 --> A1[동물 목록\n검색·필터]
    A1 --> A2[동물 상세]
    A2 --> A3[입양 신청서 작성]
    A3 --> A4{서버 검증}
    A4 -->|중복신청/본인동물| AERR["❌ 신청 불가\n(Alert 메시지)"]
    A4 -->|정상| A5{제출 확인}
    A5 -->|성공| A6["✅ 신청 완료\n(마이페이지 확인)"]
    A5 -->|실패| A3
    AERR --> A2

    %% ── 봉사활동 ──
    M2 --> V1[봉사 목록\n상태별 필터]
    V1 --> V2[프로그램 상세]
    V2 --> V3[봉사 신청]
    V3 --> V4{정원 및 중복 검증}
    V4 -->|이미 신청함| VERR["❌ 이미 참여 중"]
    V4 -->|정상/승인대기| V5["✅ 신청 완료\n(SIGNS_STATUS=0)"]
    V4 -->|정원 초과| V6["대기번호 부여\n(SIGNS_WAIT=1)"]
    V2 --> V7[후기 목록]
    V7 --> V8["후기 작성\n(참여 완료자만 가능)"]
    V8 --> V9[후기 등록 완료]

    %% ── 펀딩 ──
    M3 --> F1[펀딩 목록]
    F1 --> F2[펀딩 상세]
    F2 --> F3[후원 금액 선택]
    F3 --> F4{결제 처리}
    F4 -->|성공| F5[후원 완료\n마이페이지에서 확인]
    F4 -->|실패| F3

    %% ── 커뮤니티 ──
    M4 --> C1[게시판 목록\n카테고리 선택]
    C1 --> C2[게시글 상세]
    C2 --> C3[댓글 작성]
    C2 --> C4[좋아요]
    C2 --> C5[신고]
    C1 --> C6[게시글 작성]
    C6 --> C7[파일 첨부\n선택]
    C7 --> C8[게시 완료]

    %% ── 마이페이지 ──
    M5 --> MY1[내 정보 수정]
    M5 --> MY2[입양 신청 내역 조회]
    M5 --> MY3[봉사 신청 내역 조회]
    M5 --> MY4[후원 내역 조회]
    M5 --> MY5[회원 탈퇴]

    %% ── 쪽지 ──
    M6 --> MSG1[받은 쪽지함]
    M6 --> MSG2[쪽지 보내기]
    MSG1 --> MSG3[쪽지 읽기\n읽음 처리]

    style START fill:#4CAF50,color:#fff
    style MAIN fill:#2196F3,color:#fff
```

---

### ⚙️ 관리자 (ADMIN)

```mermaid
flowchart TD
    START([관리자 로그인]) --> MAIN[메인 페이지]
    MAIN --> AD1["👥 회원 관리"]
    MAIN --> AD2["🐾 동물 관리"]
    MAIN --> AD3["🌱 봉사 프로그램 관리"]
    MAIN --> AD4["💰 펀딩 관리"]
    MAIN --> AD5["📝 커뮤니티 관리"]
    MAIN --> AD6["💬 채팅 상담"]

    %% ── 회원 관리 ──
    AD1 --> W1[회원 목록 조회]
    W1 --> W2[회원 상세]
    W2 --> W3{처리}
    W3 -->|정지| W4[정지 기간 설정]
    W3 -->|탈퇴처리| W5[강제 탈퇴]
    W3 -->|정상화| W6[정지 해제]

    %% ── 동물 관리 ──
    AD2 --> AN1[동물 목록]
    AN1 --> AN2[동물 등록\n사진 업로드 포함]
    AN2 --> AN3[등록 완료\n입양 게시글 자동 생성]
    AN1 --> AN4[동물 상세]
    AN4 --> AN5[정보 수정]
    AN4 --> AN6[삭제]
    AN4 --> AN7[입양 신청자 목록]
    AN7 --> AN8{입양 처리}
    AN8 -->|승인| AN9[입양 완료\nADOPTION_STATUS 변경]
    AN8 -->|거절| AN10[거절 처리]

    %% ── 봉사 프로그램 관리 ──
    AD3 --> VO1[프로그램 목록]
    VO1 --> VO2[프로그램 등록\n날짜·정원·태그 설정]
    VO2 --> VO3[등록 완료]
    VO1 --> VO4[프로그램 상세]
    VO4 --> VO5[신청자 목록]
    VO5 --> VO6{신청자 처리}
    VO6 -->|승인| VO7[승인 완료\nSIGNS_STATUS 변경]
    VO6 -->|거절| VO8[거절]
    VO4 --> VO9[프로그램 수정 / 삭제]

    %% ── 커뮤니티 관리 ──
    AD5 --> CM1[게시글 목록]
    CM1 --> CM2[공지사항 등록\nIS_PINNED=Y]
    CM1 --> CM3[게시글 삭제\nIS_DELETED=Y]
    CM1 --> CM4[신고 목록 처리]

    %% ── 채팅 상담 ──
    AD6 --> CH1[채팅 목록]
    CH1 --> CH2[사용자와 실시간 채팅]
    CH2 --> CH3[채팅 내역 저장\nADMIN_CHAT_HISTORIES]

    style START fill:#F44336,color:#fff
    style MAIN fill:#2196F3,color:#fff
```

---

## 2. 기능별 플로우

### 🐾 입양 플로우

```mermaid
flowchart LR
    S([시작]) --> L[메인 접속]
    L --> AL[동물 목록 조회]
    AL --> AF{검색·필터 적용}
    AF -->|종/크기/지역| AL
    AF -->|선택| AD[동물 상세]
    AD --> DC[동물 정보 확인\n사진·건강상태·조건]
    DC --> LC{로그인 확인}
    LC -->|비로그인| LI[로그인 페이지]
    LI -->|로그인 성공| CK{서버 사이드 검증}
    LC -->|로그인됨| CK
    CK -->|중복/본인/마감| ERR[❌ 신청 불가 알림]
    CK -->|통과| AF2[입양 신청서 작성]
    AF2 --> SB[신청서 제출]
    SB --> STATUS{관리자 심사}
    STATUS -->|승인/확정| DONE["🌍 입양 완료\n(ADOPTION_STATUS = '완료')"]
    STATUS -->|심사 중| WAIT[마이페이지 대기중]
    STATUS -->|반려| REJ[❌ 반려 알림]

    style S fill:#4CAF50,color:#fff
    style DONE fill:#388E3C,color:#fff
    style REJ fill:#F44336,color:#fff
    style ERR fill:#F44336,color:#fff
```

---

### 🌱 봉사활동 플로우

```mermaid
flowchart LR
    S([시작]) --> L[메인 접속]
    L --> VL[봉사 목록 조회]
    VL --> VF{상태 필터}
    VF -->|모집중/완료/예정| VL
    VF -->|선택| VD[프로그램 상세]
    VD --> VI[일정·장소·정원 확인]
    VI --> LC{로그인 확인}
    LC -->|비로그인| LI[로그인 페이지]
    LI -->|성공| VS[봉사 신청]
    LC -->|로그인됨| VS
    VS --> QUOTA{정원 확인}
    QUOTA -->|여유있음| APPLY[신청 완료\nSIGNS_STATUS=신청중]
    QUOTA -->|정원 초과| WAIT[대기번호 부여\nSIGNS_WAIT+1]
    APPLY --> ADMIN{관리자 승인}
    ADMIN -->|승인| CONF["✅ 승인완료\nSIGNS_STATUS=승인"]
    ADMIN -->|거절| REJ[❌ 미승인]
    CONF --> DONE[봉사 참여]
    DONE --> REVIEW[후기 작성\nVOLUNTEER_REVIEWS]
    REVIEW --> RATE[평점 등록 완료]

    style S fill:#4CAF50,color:#fff
    style CONF fill:#388E3C,color:#fff
    style REJ fill:#F44336,color:#fff
```

---

### 💰 펀딩 플로우

```mermaid
flowchart LR
    S([시작]) --> L[메인 접속]
    L --> FL[펀딩 목록 조회]
    FL --> FD[펀딩 상세]
    FD --> FI["목표금액·현재금액 확인\n(F_MAX_MONEY / F_CURRENT_MONEY)"]
    FI --> LC{로그인 확인}
    LC -->|비로그인| LI[로그인 페이지]
    LI -->|성공| FA[후원 금액 입력]
    LC -->|로그인됨| FA
    FA --> SUBMIT[후원 제출]
    SUBMIT --> SAVE["FUNDING_HISTORIES에 기록\nFUNDINGS.F_CURRENT_MONEY 증가"]
    SAVE --> CHECK{목표 달성?}
    CHECK -->|달성| GOAL["🎉 목표 달성!\nF_CURRENT_MONEY >= F_MAX_MONEY"]
    CHECK -->|미달성| CONT[계속 모금 중]
    GOAL --> DONE[✅ 후원 완료]
    CONT --> DONE

    style S fill:#4CAF50,color:#fff
    style GOAL fill:#FF9800,color:#fff
    style DONE fill:#388E3C,color:#fff
```

---

## 3. 통합 플로우

```mermaid
flowchart TD
    S([사이트 접속]) --> MAIN[🏠 메인 페이지]

    MAIN --> AUTH{로그인 상태}

    AUTH -->|"❌ 비로그인"| GUEST["조회만 가능\n(동물·봉사·펀딩·게시글)"]
    AUTH -->|"✅ 일반회원"| USER[전체 기능 이용 가능]
    AUTH -->|"🔑 관리자"| ADMIN[관리 기능 + 전체 기능]

    %% 비로그인 → 로그인 유도
    GUEST -->|기능 사용 시도| LOGIN[로그인 페이지]
    LOGIN --> REG[회원가입]
    REG --> LOGIN
    LOGIN -->|성공| USER

    %% 일반 사용자 기능
    USER --> U1["🐾 입양 신청"]
    USER --> U2["🌱 봉사 신청"]
    USER --> U3["💰 펀딩 후원"]
    USER --> U4["📝 커뮤니티\n글·댓글·좋아요"]
    USER --> U5["📋 마이페이지\n내역 조회"]
    USER --> U6["💬 쪽지 송수신"]

    %% 관리자 기능
    ADMIN --> AD1["👥 회원 관리"]
    ADMIN --> AD2["🐾 동물 등록·입양처리"]
    ADMIN --> AD3["🌱 봉사 등록·신청승인"]
    ADMIN --> AD4["💰 펀딩 관리"]
    ADMIN --> AD5["📝 공지·게시글 관리"]
    ADMIN --> AD6["💬 채팅 상담"]

    %% 공통 흐름
    U1 -->|관리자 승인| RESULT1["✅ 입양 완료"]
    U2 -->|관리자 승인| RESULT2["✅ 봉사 참여→후기"]
    U3 --> RESULT3["✅ 후원 기록"]
    U4 --> RESULT4["✅ 게시 완료"]

    style S fill:#4CAF50,color:#fff
    style MAIN fill:#2196F3,color:#fff
    style AUTH fill:#FF9800,color:#fff
    style GUEST fill:#9E9E9E,color:#fff
    style USER fill:#2196F3,color:#fff
    style ADMIN fill:#F44336,color:#fff
```

---

## 🛠️ 시각화 방법

| 방법 | 주소 | 특징 |
|---|---|---|
| **GitHub** | push 후 `.md` 자동 렌더링 | 별도 설치 불필요 |
| **mermaid.live** | [mermaid.live](https://mermaid.live) | 실시간 편집·공유 링크 |
| **VS Code** | `Markdown Preview Mermaid Support` 확장 | 로컬 미리보기 |
