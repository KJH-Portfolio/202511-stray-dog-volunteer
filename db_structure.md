# UBIG 세미 프로젝트 DB 구조 분석

> 분석일: 2026-04-21  
> 프로젝트: UBIG - 유기동물 입양·봉사·펀딩 플랫폼  
> DB 계정: UBIG / UBIG (Oracle 21c, XEPDB1)  
> 구성: Spring Legacy + MyBatis + Oracle 21c (Docker)

---

## 📌 프로젝트 개요

유기동물 입양, 봉사활동, 펀딩, 커뮤니티 기능을 제공하는 통합 플랫폼.

---

## 📊 전체 테이블 목록

| # | 테이블명 | 설명 | 더미 데이터 필요 여부 |
|---|---|---|---|
| 1 | `MEMBERS` | 회원 (아이디, 비밀번호, 닉네임 등) | ✅ 필수 |
| 2 | `ANIMAL_DETAILS` | 동물 상세정보 (품종, 나이, 접종 등) | ✅ 필수 |
| 3 | `ADOPTION_POSTS` | 입양 게시글 | ✅ 필수 |
| 4 | `ADOPTION_APPLICATIONS` | 입양 신청 | ✅ 필요 |
| 5 | `ACTIVITIES` | 봉사활동 프로그램 | ✅ 필수 |
| 6 | `SIGNS` | 봉사활동 신청 내역 | ✅ 필수 |
| 7 | `VOLUNTEER_REVIEWS` | 봉사활동 후기 | ✅ 필수 |
| 8 | `VOLUNTEER_BOARD_COMMENTS` | 봉사활동 게시판 댓글 | ✅ 필요 |
| 9 | `FUNDINGS` | 펀딩 프로젝트 | ✅ 필수 |
| 10 | `FUNDING_HISTORIES` | 펀딩 후원 내역 | ✅ 필요 |
| 11 | `DONATION_FILES` | 펀딩 첨부파일 | 선택 |
| 12 | `DONATIONS` | 후원(단순 기부) 내역 | 선택 |
| 13 | `BOARDS` | 커뮤니티 게시글 | ✅ 필수 |
| 14 | `COMMENTS` | 게시글 댓글 | ✅ 필수 |
| 15 | `BOARD_ATTACHMENTS` | 게시글 첨부파일 | 선택 |
| 16 | `BOARD_LIKES` | 게시글 좋아요 | 선택 |
| 17 | `COMMENT_ATTACHMENTS` | 댓글 첨부파일 | 선택 |
| 18 | `COMMENT_LIKES` | 댓글 좋아요 | 선택 |
| 19 | `MESSAGES` | 회원 간 쪽지 | 선택 |
| 20 | `ADMIN_CHAT_HISTORIES` | 관리자 채팅 기록 | 선택 |
| 21 | `TAGS` | 봉사활동 태그 연결 | 선택 |
| 22 | `TAG_INFOS` | 태그 마스터 | 선택 |
| 23 | `KICKS` | 회원 차단 | 선택 |

---

## ✅ 현재 삽입된 초기 더미 데이터 현황

| 테이블 | 건수 | 내용 |
|---|---|---|
| `MEMBERS` | 7명 | admin + user01~user06 |
| `ANIMAL_DETAILS` | 20마리 | 강아지 10 + 고양이 10 |
| `ADOPTION_POSTS` | 20건 | 동물 1마리당 게시글 1건 |
| `ACTIVITIES` | 10건 | 완료 3 + 모집중 4 + 예정 3 |
| `SIGNS` | 15건 | 봉사 신청 내역 |
| `VOLUNTEER_REVIEWS` | 3건 | 완료된 봉사 후기 |
| `VOLUNTEER_BOARD_COMMENTS` | - | VOLUNTEER_REVIEWS와 연동 |
| `FUNDINGS` | 8건 | 진행 중 + 완료 혼합 |
| `BOARDS` | 20건 | NOTICE/FREE/REQUEST/REVIEW |
| `COMMENTS` | 20건 | 게시글별 댓글 |

---

## 🔑 주요 컬럼 제약사항

| 테이블 | 컬럼 | 타입 | 허용값 / 비고 |
|---|---|---|---|
| `MEMBERS` | `USER_STATUS` | VARCHAR2(1) | `'Y'`=정상, `'N'`=탈퇴 |
| `MEMBERS` | `USER_ROLE` | VARCHAR2(10) | `'ADMIN'` / `'USER'` |
| `MEMBERS` | `USER_GENDER` | VARCHAR2(1) | `'M'` / `'F'` |
| `MEMBERS` | `USER_PWD` | VARCHAR2(100) | BCrypt 암호화 필수 |
| `ANIMAL_DETAILS` | `SPECIES` | NUMBER | `1`=강아지, `2`=고양이 |
| `ANIMAL_DETAILS` | `GENDER` | NUMBER | `1`=수컷, `2`=암컷 |
| `ANIMAL_DETAILS` | `PET_SIZE` | NUMBER | `1`=소형, `2`=중형, `3`=대형 |
| `ANIMAL_DETAILS` | `NEUTERED` | NUMBER | `0`=미완료, `1`=완료 |
| `ANIMAL_DETAILS` | `ADOPTION_STATUS` | **VARCHAR2(10)** | ⚠️ `'대기중'`(9B), `'완료'`(6B) — **`'입양완료'`(12B) 초과!** |
| `FUNDINGS` | `F_TITLE` | **VARCHAR2(30)** | ⚠️ 한글 최대 **10자** 이내 |
| `ACTIVITIES` | `ACT_TITLE` | **VARCHAR2(50)** | ⚠️ 한글 최대 **16자** 이내 |
| `BOARDS` | `CATEGORY` | VARCHAR2(50) | `'NOTICE'` / `'FREE'` / `'REQUEST'` / `'REVIEW'` |
| `BOARDS` | `IS_DELETED` | CHAR(1) | `'Y'` / `'N'` |
| `BOARDS` | `IS_PINNED` | VARCHAR2(1) | `'Y'` / `'N'` (기본값 `'N'`) |
| `COMMENTS` | `IS_DELETED` | CHAR(1) | `'Y'` / `'N'` |
| `SIGNS` | `SIGNS_WAIT` | NUMBER | `0`=대기 없음, `1`=대기 중 |
| `SIGNS` | `SIGNS_STATUS` | NUMBER | `0`=신청 중, `1`=승인 완료 |
| `VOLUNTEER_REVIEWS` | `R_REMOVE` | NUMBER | `0`=정상, `1`=삭제 |
| `VOLUNTEER_BOARD_COMMENTS` | `CMT_REMOVE` | NUMBER | `0`=정상, `1`=삭제 |
| `FUNDING_HISTORIES` | `F_MONEY` | NUMBER | 후원 금액 (양수) |
| `ADMIN_CHAT_HISTORIES` | `CHAT_IS_CHECK` | VARCHAR2(1) | `'Y'` / `'N'` |
| `MESSAGES` | `MESSAGE_IS_CHECK` | VARCHAR2(1) | `'Y'` / `'N'` |

---

## ⚠️ 과거 발생 오류 및 해결 기록

### ORA-12899 (컬럼 길이 초과) — 해결 완료

Oracle AL32UTF8 기준 **한글 1자 = 3바이트** 적용.

| 컬럼 | 제한 | 문제 값 | 해결책 |
|---|---|---|---|
| `FUNDINGS.F_TITLE` | VARCHAR2(30) = 한글 10자 | 제목이 13자 이상 | **10자 이내로 단축** |
| `ACTIVITIES.ACT_TITLE` | VARCHAR2(50) = 한글 16자 | 제목이 20자 이상 | **16자 이내로 단축** |
| `ANIMAL_DETAILS.ADOPTION_STATUS` | VARCHAR2(10) = 한글 3자 | `'입양완료'`(4자=12B) | **`'완료'`(2자=6B)로 변경** |

### ORA-02298 (FK 부모 키 없음) — 연쇄 해결

- `ACTIVITIES` INSERT 실패 → `SIGNS`, `VOLUNTEER_REVIEWS`, `VOLUNTEER_BOARD_COMMENTS` FK 오류 연쇄 발생
- `ACTIVITIES` 오류 해결 시 자동 해소

---

## 🔄 테이블 관계 (ERD 주요 관계)

```
MEMBERS (USER_ID)
  ├── ANIMAL_DETAILS (USER_ID)
  │     └── ADOPTION_POSTS (ANIMAL_NO)
  │           └── ADOPTION_APPLICATIONS (ANIMAL_NO)
  ├── ACTIVITIES (ADMIN_ID)
  │     ├── SIGNS (ACT_ID)
  │     ├── TAGS (ACT_ID) → TAG_INFOS
  │     ├── VOLUNTEER_REVIEWS (ACT_ID)
  │     └── VOLUNTEER_BOARD_COMMENTS (ACT_ID)
  ├── FUNDINGS (USER_ID)
  │     ├── FUNDING_HISTORIES (F_NO)
  │     └── DONATION_FILES (F_NO)
  ├── DONATIONS (USER_ID)
  ├── BOARDS (USER_ID)
  │     ├── COMMENTS (BOARD_ID)
  │     │     ├── COMMENT_ATTACHMENTS (COMMENT_ID)
  │     │     └── COMMENT_LIKES (COMMENT_ID)
  │     ├── BOARD_ATTACHMENTS (BOARD_ID)
  │     └── BOARD_LIKES (BOARD_ID)
  ├── MESSAGES (발신/수신)
  ├── ADMIN_CHAT_HISTORIES (발신/수신)
  └── KICKS (차단자/피차단자)
```

---

## 🏷️ 시퀀스 목록

| 시퀀스명 | 용도 |
|---|---|
| `SEQ_ACTIVITIES` | ACTIVITIES.ACT_ID |
| `SEQ_ADMIN_CHAT` | ADMIN_CHAT_HISTORIES.CHAT_NO |
| `SEQ_ADOPTION_APPS` | ADOPTION_APPLICATIONS.ADOPTION_APP_ID |
| `SEQ_ADOPTION_POSTS` | ADOPTION_POSTS.POST_NO |
| `SEQ_ANIMAL_DETAILS` | ANIMAL_DETAILS.ANIMAL_NO |
| `SEQ_BOARDS` | BOARDS.BOARD_ID |
| `SEQ_BOARD_ATTACH` | BOARD_ATTACHMENTS.FILE_ID |
| `SEQ_BOARD_LIKES` | BOARD_LIKES.LIKE_ID |
| `SEQ_CMT_ATTACH` | COMMENT_ATTACHMENTS.FILE_ID |
| `SEQ_COMMENTS` | COMMENTS.COMMENT_ID |
| `SEQ_COMMENT_LIKES` | COMMENT_LIKES.LIKE_ID |
| `SEQ_DONATIONS` | DONATIONS.DONATION_NO |
| `SEQ_DONATION_FILES` | DONATION_FILES.FILE_ID |
| `SEQ_FUNDINGS` | FUNDINGS.F_NO |
| `SEQ_FUNDING_HIS` | FUNDING_HISTORIES.FH_NO |
| `SEQ_KICKS` | KICKS.KICK_NO |
| `SEQ_MESSAGES` | MESSAGES.MESSAGE_NO |
| `SEQ_SIGNS` | SIGNS.SIGNS_NO |
| `SEQ_TAGS` | TAGS.TAG_NO |
| `SEQ_TAG_INFOS` | TAG_INFOS.TAG_ID |
| `SEQ_VOL_COMMENTS` | VOLUNTEER_BOARD_COMMENTS.CMT_NO |
| `SEQ_VOL_REVIEWS` | VOLUNTEER_REVIEWS.REVIEW_NO |

---

## 🔑 테스트 계정 정보

| USER_ID | 비밀번호(원문) | ROLE | 비고 |
|---|---|---|---|
| `admin` | `admin` | ADMIN | 관리자 |
| `user01` | `pass01` | USER | 테스트유저01 |
| `user02` | `pass01` | USER | 테스트유저02 |
| `user03` | `pass01` | USER | 김민지 |
| `user04` | `pass01` | USER | 박준혁 |
| `user05` | `pass01` | USER | 이수연 |
| `user06` | `pass01` | USER | 최지호 |

> 비밀번호는 BCrypt 10 rounds 암호화되어 저장됨.

---

## 🎯 추가 더미 데이터 필요 항목

현재 비어있거나 보강이 필요한 테이블:

| 테이블 | 현재 | 목표 | 비고 |
|---|---|---|---|
| `FUNDING_HISTORIES` | 0건 | 15건 | 후원자별 내역 |
| `ADOPTION_APPLICATIONS` | 0건 | 10건 | 입양 신청 내역 |
| `VOLUNTEER_REVIEWS` | 3건 | 10건 | 봉사 후기 보강 |
| `VOLUNTEER_BOARD_COMMENTS` | 0건 | 10건 | 봉사 게시판 댓글 |
