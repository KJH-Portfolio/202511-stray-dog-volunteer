# UBIG 세미 프로젝트 DB 구조 분석

> **Technical Note: 데이터 타입 및 제약 조건 설계 원칙**
> - **한글 바이트 산정**: Oracle `AL32UTF8` 기준, 한글 1자당 **3바이트**를 할당하여 설계했습니다. (예: VARCHAR2(30) = 한글 10자 제한)
> - **CHAR vs VARCHAR2**: 상태 코드(`Y/N`) 등 길이가 고정된 플래그는 `CHAR(1)`을, 제목이나 내용 등 가변 데이터는 `VARCHAR2`를 사용해 공간 효율성을 높였습니다.
> - **Soft Delete**: 데이터 무결성 보존 및 이력 관리를 위해 `IS_DELETED` 컬럼을 활용한 논리 삭제 방식을 채택했습니다.


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
| `ANIMAL_DETAILS` | `ADOPTION_STATUS` | **VARCHAR2(10)** | `대기중`(9B), `완료`(6B) — 데이터 정합성 유지 |
| `FUNDINGS` | `F_TITLE` | **VARCHAR2(30)** | 비즈니스 제약: 한글 최대 **10자** 이내로 제한 |
| `ACTIVITIES` | `ACT_TITLE` | **VARCHAR2(50)** | 비즈니스 제약: 한글 최대 **16자** 이내로 제한 |
| `BOARDS` | `IS_DELETED` | CHAR(1) | `Y`(삭제됨), `N`(정상) — 논리 삭제 지표 |
| `BOARDS` | `IS_PINNED` | VARCHAR2(1) | 상단 고정 여부 (관리자 전용 기능) |
| `SIGNS` | `SIGNS_STATUS` | NUMBER | `0`=신청, `1`=승인, `2`=거절 (상태 기반 관리) |
| `ADMIN_CHAT_HISTORIES` | `CHAT_IS_CHECK` | VARCHAR2(1) | `Y`(수신확인), `N`(미확인) |



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

