# 🐾 UBIG Semi Project

> 🐶 **유기동물 입양, 봉사 및 펀딩을 연결하여 유기동물과 새로운 가족을 이어주는 종합 플랫폼** 🐱

<br>

> [!IMPORTANT]  
> **아래 섹션 중 💎, 🔥, 🌟 이모지가 붙은 지원자의 팀 내 구현 항목 및 담당 업무 상세를 확인해 보세요.**  
> 특히 **[CORE] 💎**와 **[DEEP DIVE] 🔥** 섹션에서 백엔드 개발자로서 담당했던 핵심 로직과 기술적 해결 과정을 자세히 확인하실 수 있습니다.

<details>
<summary>1. 기본 정보 (개발 기간, 기술 스택, 인원 구성)</summary>

- 📅 **개발 기간:** 2025.12 ~ 2026.02 (약 2.5개월)
- 🖥️ **플랫폼:** Web
- 👥 **개발 인원:** 팀 프로젝트 (4명)
- 🛠️ **개발 환경 (Tech Stack):**
  - **Language:** `Java 11`, `JavaScript`, `HTML5`, `CSS3`
  - **Server:** `Apache Tomcat 9`
  - **Framework:** `Spring Legacy (5.3.39)`
  - **Database:** `Oracle Database XE 21c`
  - **IDE:** `Eclipse`, `VS Code`
  - **API/Library:** `MyBatis`, `Spring Security 5`, `JSTL`, `jQuery`, `DBCP2 Connection Pool`
  - **Infra:** `Docker`, `Docker Compose`, `Maven 3`

</details>
<details>
<summary>2. 프로젝트 전체 개요 (전체 구조, ERD, IA 등)</summary>

**🎯 1. 프로젝트 목표**
> 동물 보호와 복지에 관심이 있는 사람들이 모여, 안전하고 체계적인 동물 입양 절차를 밟고 봉사활동 및 후원에 참여할 수 있는 커뮤니티 기능을 제공하는 것을 목표로 합니다.

**🗓️ 2. 프로젝트 진행 순서**
- 기획 ➡️ 설계 ➡️ 개발 ➡️ 테스트 ➡️ 배포

**📊 3. ERD (Entity Relationship Diagram)**
- 회원, 입양, 봉사활동, 펀딩, 커뮤니티, 메시지 등 총 6개의 핵심 도메인으로 구성된 관계형 DB 모델입니다.
- 👉 **[전체 DB 설계도 (erd.md) 보러가기](./erd.md)**

**🎨 4. 기획 방향성 설계**
- **통합 생태계 지원:** 유기동물에 대한 관심(입양) ➡️ 행동(봉사) ➡️ 물질적 지원(펀딩/기부) 이 3가지 축이 하나의 플랫폼 안에서 유기적으로 돌아가는 선순환 생태계를 기획했습니다.
- **권한 모델링 설계:** 비회원(조회), 일반 회원(신청/작성), 관리자(처리/관리)의 역할을 확실히 분리하여 사이트의 관리 편의성과 보안성을 강화했습니다.

**🗺️ 5. IA (정보 구조도)**
- 내비게이션 바(GNB)를 중심으로 입양, 봉사, 펀딩 등 메뉴별 페이지 접근 뎁스(Depth)와 로그인 제약 여부를 설계했습니다.
- 👉 **[전체 사이트 계층 구조 (ia.md) 보러가기](./ia.md)**

**🌊 6. User Flow**
- 각 기능 처리 시 요구되는 접속 동선을 다이어그램화하여, 승인/반려 프로세스 및 결제/참여 프로세스 중 사용자 이탈을 최소화했습니다.
- 👉 **[역할별/기능별 유저 행동 흐름 (userflow.md) 보러가기](./userflow.md)**

**💡 7. 주요 기능 요약**
- 👤 **회원 및 관리자 기능 (`Member` & `Admin`)**
  - 일반 사용자, 관리자 등급에 따른 권한 분리 (Spring Security 적용)
  - 마이페이지를 통한 본인의 입양/봉사/후원 내역 조회
  - 관리자 대시보드를 통한 사이트 전반의 컨텐츠 및 회원 관리
- 🏠 **반려동물 입양 (`Adoption`)**
  - 유기동물 프로필 리스트업 및 상세 정보 확인
  - 입양 신청 및 심사/승인 프로세스
- 🤝 **봉사활동 (`Volunteer`)**
  - 동물 보호소나 기관의 봉사 프로그램 모집 공고 및 스케줄 관리
- 💰 **후원/펀딩 (`Funding`)**
  - 유기동물 치료비나 보호소 운영 등을 위한 크라우드 펀딩 개설 및 참여
- 🗣️ **커뮤니티 (`Community`)**
  - 입양 후기 작성 및 등업 시스템, 자유게시판 운영

</details>
<details>
<summary>3. 프로젝트 개인 구현 - 백엔드 설계 철학 및 로직 구현 [CORE] 💎</summary>

- 🎯 **프로젝트 목표 (Foundation & Integrity):** 
  - **표준 MVC 아키텍처 수립:** 객체 지향 원칙에 따른 Controller-Service-DAO 계층화로 결합도를 낮추고, 데이터 유입 원천지부터 영속성 계층까지의 **데이터 흐름을 100% 통제**하는 것을 목표로 했습니다.
  - **상태 관리 기반 프로세스 설계:** 단순 입출력을 넘어, 시스템의 상태(Status Code)에 따라 비즈니스 로직이 동적으로 분기되는 **견고한 상태 시스템(State System) 구축**능력을 입증하고자 했습니다.

> [!IMPORTANT]
> **Insight: 왜 이 목표를 선정했는가?**  
> 처음으로 진행하는 메인 프로젝트인 만큼, 어떤 환경에서도 흔들리지 않는 **'안정적인 로직의 뼈대'**를 정석대로 구축해보고 싶었습니다. MVC 패턴의 명확한 역할 분담과 철저한 데이터 정합성 통제라는 본질에 집중하여, 백엔드 엔지니어로서 갖춰야 할 가장 기본적인 핵심 역량을 단단하게 증명하고자 이 목표를 설정했습니다.

- 📅 **개인 개발 진행 순서 (Sprint):** 
  - `1. 요구사항 설계 (12월)` : 입양 도메인의 핵심 프로세스 정의 및 기초 IA/User Flow 설계
  - `2. DB 기초 모델링 (12월~1월)` : 데이터 정규화 및 무결성을 고려한 핵심 테이블(회원/동물/신청서) 설계
  - `3. MVC 아키텍처 구축 (1월)` : Controller-Service-DAO의 명확한 역할 분리 및 MyBatis 연동 기반 강화
  - `4. 비즈니스 로직 고도화 (2월)` : 상태 전이(State Machine)를 활용한 조건별 프로세스 제어 기능 완성
  - `5. 안정화 및 예외 처리 (2월)` : 보안 취약점 점검, 서버 사이드 유효성 검사 및 방어 코드 구축
- 📊 **개인 구현 ERD (입양/심사 도메인 코어):**
  > 유저와 동물을 연결하는 **가장 기초적이면서도 핵심적인 관계망**을 설계했습니다.
  > *(※ 포트폴리오 가독성을 위해 외래키 조인과 핵심 심사 로직에 관여하는 주요 컬럼만 축약하여 명시했습니다.)*
  > 👉 **[전체 DB 설계도 (erd.md) 보러가기](./erd.md)**
  ```mermaid
  erDiagram
      MEMBERS {
          varchar USER_ID PK "신청자 / 관리자"
          char    USER_ROLE
      }
      ANIMAL_DETAILS {
          number  ANIMAL_NO PK
          varchar ANIMAL_NAME
          varchar ADOPTION_STATUS "입양대기/도중/완료"
      }
      ADOPTION_APPLICATIONS {
          number  ADOPTION_APP_ID PK
          number  ANIMAL_NO FK "입양 희망 동물"
          varchar USER_ID FK "신청자"
          number  ADOPT_STATUS "심사상태 (대기/승인/반려)"
      }
  
      ANIMAL_DETAILS ||--o{ ADOPTION_APPLICATIONS : "입양신청 접수"
      MEMBERS ||--o{ ADOPTION_APPLICATIONS : "서류 제출(일반)"
  ```
- 💡 **기획 방향성 설계 (Core Strategy):** 
  - **역할 기반 접근 제어(RBAC):** `Spring Security`와 세션 관리를 통해 `MEMBER`와 `ADMIN`의 권한을 물리적으로 격리하고, 인터셉터 또는 비즈니스 로직 단에서 접근 권한을 2중으로 검증하는 보안 체계를 기획했습니다.
  - **무결성 우선의 I/O 설계:** 모든 사용자 입력 단계에서 `@Valid` 어노테이션 기반의 서버 사이드 검증을 필수화하여, 클라이언트 단의 보안 취약점(F12 변조 등)을 서버에서 원천 차단하는 설계를 채택했습니다.
  - **확장성을 고려한 상태 코드 체계:** 입양 프로세스를 5가지(대기/신청중/승인/반려/종료) 고유 상태 코드로 분류하고, 각 상태 전이(Transition)마다 발생할 수 있는 데이터 예외 상황을 미리 정의하여 프로세스 안정성을 높였습니다.
- 🌊 **IA & User Flow (프로세스 통선):**
  > 기초에 충실한 설계란 무엇인지 보여주기 위해, 사용자와 관리자의 각 행위가 DB 상태와 어떻게 연동되는지 **프로세스 통제 흐름**을 도표화했습니다.
  ```mermaid
  flowchart TD
      subgraph USER_FLOW ["👤 일반 사용자 워크플로우"]
          U1(동물 상세 페이지) -->|로그인| U2[입양 신청서 폼 제출]
          U2 --> U3[마이페이지 : 내 신청 내역]
          U3 --> U4{해당 글의\n현재 심사 상태는?}
          U4 -.->|"⏳ 대기중"| U5["조건부 접근:\n신청서 수정 및 취소 가능"]
          U4 -.->|"✅ 승인/반려"| U6["접근 차단: 데이터 열람 및\n최종 결과만 안내"]
      end
      style U2 fill:#4CAF50,color:#fff
      style U3 fill:#2196F3,color:#fff
  ```

  ---

  ```mermaid
  flowchart TD
      subgraph ADMIN_FLOW ["⚙️ 관리자 및 등록자 프로세스"]
          A1(관리자 전용 로그인) --> A2[입양 홍보글 게시\n승인/반려]
          A2 --> A3[일반 사용자의\n신청 리스트 검토]
          A3 --> A4{최종 입양자 확정}
          A4 -- "확정(Confirm)" --> A5["트랜잭션: 동물 상태 완료 +\n타 신청자 자동 반려"]
          A5 --> A6["자동 알림: 확정/반려\n대상자별 맞춤 쪽지 발송"]
      end
      style A1 fill:#F44336,color:#fff
      style A4 fill:#FF9800,color:#fff
  ```

#### 🔧 핵심 구현 소스 코드 (Core Implementation)
> 입양 도메인의 **전체 생명주기(공고 등록 ➡️ 신청 ➡️ 심사 및 매니징 ➡️ 확정)**를 직접 설계하고 구현한 핵심 파일들입니다.

- **Presentation & Control**: [AdoptionController.java](./UBIGSemiProject/src/main/java/com/ubig/app/adoption/controller/AdoptionController.java)
- **Business Logic**: [AdoptionService.java](./UBIGSemiProject/src/main/java/com/ubig/app/adoption/service/AdoptionService.java) / [AdoptionServiceImpl.java](./UBIGSemiProject/src/main/java/com/ubig/app/adoption/service/AdoptionServiceImpl.java)
- **Persistence (DB Access)**: [AdoptionDao.java](./UBIGSemiProject/src/main/java/com/ubig/app/adoption/dao/AdoptionDao.java) / [adoption-mapper.xml](./UBIGSemiProject/src/main/resources/mappers/adoption-mapper.xml)
- **Domain Models (VO)**: [AnimalDetailVO.java](./UBIGSemiProject/src/main/java/com/ubig/app/vo/adoption/AnimalDetailVO.java) / [AdoptionApplicationVO.java](./UBIGSemiProject/src/main/java/com/ubig/app/vo/adoption/AdoptionApplicationVO.java)
- **View (JSP/JSTL)**: 
  - **사용자향**: [메인 목록](./UBIGSemiProject/src/main/webapp/WEB-INF/views/adoption/adoptionmainpage.jsp) / [상세 보기](./UBIGSemiProject/src/main/webapp/WEB-INF/views/adoption/adoptiondetailpage.jsp) / [입양 신청](./UBIGSemiProject/src/main/webapp/WEB-INF/views/adoption/adoptionapplication.jsp)
  - **매니징/관리**: [입양 공고 및 신청자 관리](./UBIGSemiProject/src/main/webapp/WEB-INF/views/adoption/adoptionpostmanage.jsp) / [동물 정보 등록](./UBIGSemiProject/src/main/webapp/WEB-INF/views/adoption/adoptionenrollpageanimal.jsp)

#### ✨ 주요 기능 하이라이트 (Functional Highlights)

**1) 입양 공고 검색 및 상세 조회**
- 사용자는 다양한 필터(종류, 지역, 나이 등)를 통해 유기동물을 검색하고, 상세한 건강 상태 및 입양 조건을 확인할 수 있습니다.
> `![입양 상세 화면](화면_캡처_경로를_여기에_넣어주세요.png)`

**2) 맞춤형 입양 신청 프로세스**
- 직관적인 폼을 통해 입양 신청서를 제출하며, 본인의 신청 내역을 마이페이지에서 실시간으로 추적하고 관리할 수 있습니다.
> `![입양 신청 과정 화면](화면_캡처_경로를_여기에_넣어주세요.png)`

**3) 마이페이지: 입양 관리 대시보드**
- 본인이 등록한 동물의 신청자 목록을 확인하고, 상세 심사 후 수락/반려를 결정하는 통합 관리 인터페이스를 제공합니다.
> `![마이페이지 관리 화면](화면_캡처_경로를_여기에_넣어주세요.png)`


</details>
<details>
<summary>4. 기술적 깊이 - 까다로운 문제 해결 및 성능 최적화 사례 [DEEP DIVE] 🔥</summary>

**🔍 핵심 로직 분석 (Core Logic Analysis)**

**1️⃣ [Logic] 비즈니스 정합성을 고려한 3중 예외 방어 프레임워크**
- **무결성 검증:** 입양 신청 시 `중복 신청`, `본인이 등록한 동물 신청`, `마감 공고 접근`이라는 3가지 핵심 예외 상황을 Controller 레벨에서 선제적으로 필터링하여 데이터 오염을 원천 차단했습니다.
- **실시간 상태 동기화:** 입양 신청 성공 시, 별도의 추가 조작 없이도 해당 동물의 마스터 상태를 '대기중'에서 '신청중'으로 **자동 업데이트하여 데이터 정합성**을 보장했습니다.
- 👉 **[검증 및 동기화 로직 보러가기](./UBIGSemiProject/src/main/java/com/ubig/app/adoption/controller/AdoptionController.java#L212)**
<details>
<summary>🔍 핵심 검증 로직 보기 (클릭)</summary>

```java
// AdoptionController.java 中
// 1. 중복 신청 확인
int check = service.checkApplication(application.getAnimalNo(), application.getUserId());
// 2. 본인이 등록한 동물인지 확인
AnimalDetailVO animal = service.goAdoptionDetail(application.getAnimalNo());
if (animal != null && animal.getUserId().equals(user.getUserId())) {
    return "본인 동물 신청 불가 처리";
}
// 3. 마감/완료된 공고인지 확인
if (animal != null && ("마감".equals(animal.getAdoptionStatus()) || "입양완료".equals(animal.getAdoptionStatus()))) {
    return "마감된 공고 신청 불가 처리";
}
```
</details>

**2️⃣ [Workflow] 사용자 역할별 맞춤형 접근 제어 및 권한 보호**
- **역할 기반 인터페이스:** 로그인 유저의 권한(Role)과 게시글 소유 여부에 따라 수정 버튼 활성화를 제어하고, 승인/반려된 데이터에 대해서는 수정 권한을 즉시 회수하여 프로세스의 신뢰성을 확보했습니다.
- **자동 메시징 시스템:** 입양 프로세스의 상태가 변경될 때마다(`신청`, `승인`, `반려`, `확정`), 시스템이 자동으로 관련 유저에게 안내 쪽지를 발송하는 비즈니스 이벤트를 통합 구현했습니다.
- 👉 **[자동 알림 핸들러 보러가기](./UBIGSemiProject/src/main/java/com/ubig/app/adoption/service/AdoptionServiceImpl.java#L334)**
<details>
<summary>🔍 메시징 핸들러 소스 보기 (클릭)</summary>

```java
// AdoptionServiceImpl.java 中
private void sendMessage(String senderId, String receiverId, String content) {
    // 차단여부 체크 로직 포함
    int isKicked = kickService.isKicked(...);
    String status = (isKicked > 0) ? "K" : "N";
    
    MessageVO message = MessageVO.builder()
            .messageSendUserId(senderId)
            .messageReceiveUserId(receiverId)
            .messageContent(content)
            .messageIsCheck(status)
            .build();
    messageService.insertMessage(message);
}
```
</details>

**3️⃣ [Integrity] @Transactional 기반의 원자적 입양 확정 프로세스**
- **All-or-Nothing 처리:** 최종 입양 확정 시 [입양자 확정], [동물 상태 갱신], [타 신청자 일괄 반려]라는 3가지의 상이한 DB 작업을 하나의 트랜잭션으로 묶어, 데이터 불일치를 원천 방지했습니다.
- **데이터 생명주기 관리:** 마감 시한이 만료된 공고들을 일괄적으로 '마감' 처리하는 로직을 통해, 시스템의 데이터를 능동적으로 정제하고 프로세스의 완결성을 높였습니다.
- 👉 **[입양 확정 코어 로직 보러가기](./UBIGSemiProject/src/main/java/com/ubig/app/adoption/service/AdoptionServiceImpl.java#L286)**
<details>
<summary>🔍 트랜잭션 확정 로직 보기 (클릭)</summary>

```java
// AdoptionServiceImpl.java 中
@Transactional
public int confirmAdoption(int adoptionAppId, int animalNo) {
    // 1. 해당 신청자 '입양완료' 처리
    dao.confirmApplication(sqlSession, adoptionAppId);
    // 2. 나머지 신청자 '반려' 처리 (일괄 업데이트)
    dao.rejectOtherApplications(sqlSession, map);
    // 3. 동물 마스터 상태 '입양완료' 변경
    dao.acceptAdoption(sqlSession, animalNo);
    // 4. 각 대상자별 알림 발송 (확정자: 축하 / 반려자: 안내)
    if (result1 > 0 && result2 > 0) {
        for (AdoptionApplicationVO app : applicants) {
            if (app.getAdoptionAppId() == adoptionAppId) {
                sendMessage("admin", app.getUserId(), "[알림] 입양 신청이 확정되었습니다!");
            } else {
                sendMessage("admin", app.getUserId(), "[알림] 다른 분께 입양이 확정되었습니다.");
            }
        }
    }
    return 1;
}
```
</details>

**4️⃣ [Performance] JOIN을 활용한 데이터 조회 최적화 (N+1 문제 방지)**
- **SQL JOIN 기반 설계:** 리스트 조회 시 게시글 정보와 동물 정보를 각각 따로 조회하는 대신, **JOIN 문을 사용하여 단 1회의 쿼리로 모든 데이터를 통합 조회**하도록 설계했습니다.
- **성능 이점:** 이를 통해 게시글 수만큼 추가 쿼리가 발생하는 **N+1 문제를 사전에 방지**하였으며, 데이터 양이 많아져도 DB I/O 부하가 늘어나지 않는 안정적인 성능을 확보했습니다.
<details>
<summary>🔍 효율적인 JOIN 쿼리 구조 보기 (클릭)</summary>

```xml
<!-- adoption-mapper.xml -->
<!-- 리스트 조회 시 연관된 테이블을 한 번에 JOIN하여 N+1 발생을 원천 차단 -->
<select id="selectAdoptionMainList" resultType="com.ubig.app.vo.adoption.AdoptionMainListVO">
    SELECT P.POST_NO, P.POST_TITLE, P.VIEWS, 
           A.ANIMAL_NAME, A.PHOTO_URL, A.ADOPTION_STATUS
    FROM ADOPTION_POSTS P
    JOIN ANIMAL_DETAILS A ON P.ANIMAL_NO = A.ANIMAL_NO
    ORDER BY P.POST_REG_DATE DESC
</select>
```
</details>

---

**🤔 1. Decision Making (Technical Rationale)**
- **Spring Legacy & MyBatis (Persistence Strategy):** 
  - **불필요한 추상화보다 '백엔드의 본질'에 집중:** 편리한 최신 문법이나 자동화된 프레임워크를 사용하기에 앞서, 설정 하나하나를 직접 제어해야 하는 **레거시 스택(Legacy Stack)**을 통해 서버의 구동 원리를 깊이 있게 이해하고자 했습니다.
  - **SQL 직접 제어를 통한 데이터 핸들링 역량 강화:** 쿼리 자동 생성의 편리함 대신, MyBatis를 통해 **직접 SQL을 작성하고 매핑**하며 데이터의 흐름과 실행 계획을 명시적으로 통제하는 '기초 체력'을 기르는 데 집중했습니다. 이는 어떤 개발 환경에서도 흔들리지 않는 백엔드 엔지니어의 기본기를 증명하기 위한 선택이었습니다.
- **Oracle DB & Docker (Infrastructure):**
  - **엔터프라이즈 환경 경험:** 강력한 트랜잭션 관리와 정합성을 지원하는 Oracle을 선택하여 대규모 서비스 환경의 DB 설계를 경험했습니다.
  - **[Self-Improvement] 프로젝트 영구 보존을 위한 Docker 도입:** 프로젝트 정규 과정이 종료된 후, 완성된 결과물을 어느 환경에서도 즉시 실행하고 **영구적으로 보존하기 위해 개인적으로 Docker 환경을 구축**했습니다.
  - **이식성 및 재현성 확보:** `Dockerfile`과 `docker-compose.yml`을 직접 설계하여 인프라를 코드화(IaC)함으로써, 로컬 설정에 구애받지 않고 포트폴리오를 안정적으로 시연할 수 있도록 최적화했습니다.

**⚡ 2. Summary: Performance & Integrity (핵심 성과 요약)**

- **성능 최적화**: N+1 쿼리 문제를 JOIN으로 해결하여 DB I/O 비용을 획기적으로 줄이고 응답 속도를 개선했습니다.
- **데이터 정합성**: `@Transactional`을 통해 입양 확정 및 연쇄 삭제 프로세스의 전 과정을 원자적으로 처리, 데이터 불일치를 원천 차단했습니다.
- **방어적 설계**: Service 계층의 비즈니스 검증과 자동 상태 동기화를 통해 시스템 안정성과 사용자 편의성을 동시에 확보했습니다.

**🔥 3. Troubleshooting (트러블 슈팅)**
- **대량의 폼 데이터 유효성 검증 및 무결성 확보**
  - **Problem:** 입양 신청 폼의 항목이 너무 많아 비정상적인 데이터가 입력된 채로 전송되거나, 고의로 폼 검증을 우회한 요청이 들어올 때 500 서버 에러 또는 쓰레기 데이터가 삽입되는 문제 발생.
  - **Cause:** 프론트엔드 단(JavaScript)에서만 유효성 검증을 1차적으로 진행했기 때문에 개발자 도구를 통한 API 변조 공격에 무방비함.
  - **Solution:** Spring의 `@Valid`와 서버 사이드 커스텀 검증 로직을 추가 설계하여, 비정상 요청이 들어오면 에러 메시지를 띄우고 이전 입력 데이터가 유지되도록 View를 반환하게 만들어 **비정상 데이터가 DB에 도달하는 것을 원천 차단**함.

- **API 변조(비정상적인 상태 조작) 방어 전략**
  - **Problem:** 브라우저 개발자 도구를 통해 HTTP 요청을 변조하면 이미 '승인'된 게시물마저도 사용자가 임의로 위변조/삭제할 수 있는 심각한 보안 취약점 발견.
  - **Cause:** 단순 UI 컴포넌트(수정/삭제 버튼)만 감췄을 뿐, 백엔드 API에서 데이터 상태 값에 따른 예외 처리가 부족했음.
  - **Solution:** 삭제 및 수정 API가 호출된 즉시 원본 DB의 데이터를 단건 조회하여, 상태(`Status`) 값이 '대기'가 아닐 시 `Exception`을 강제로 발생시켜 **비즈니스 로직의 보안성을 한층 더 견고**하게 리팩토링함.

- **데이터 무결성을 위한 상태 전이(State Transition) 로직 설계**
  - **Problem:** 한 번 관리자의 승인을 받은 게시글이라도 사용자가 내용을 수정할 경우, 승인되지 않은 부적절한 내용이 '승인' 상태로 노출될 위험이 있음.
  - **Solution:** 게시글 수정 로직 실행 시 현재 상태와 관계없이 **상태값을 자동으로 '대기(Waiting)'로 롤백**하도록 설계했습니다. 이를 통해 어떤 수정 사항이 발생하더라도 반드시 관리자의 재검토를 거치게 함으로써, 서비스의 신뢰성과 데이터의 무결성을 동시에 확보했습니다.

</details>
<details>
<summary>5. 회고 - 프로젝트 성찰 및 향후 기술적 지향점 [GROWTH] 🌟</summary>

- **🟢 Keep (Project Standards):** 
  - **코드 컨벤션 및 도메인 상수화(Constants):** 모든 입양 상태 코드와 권한 등급을 상수로 엄격히 관리하여 하드코딩으로 인한 휴먼 에러를 방지하고, 팀 프로젝트에서의 코드 가독성과 데이터 정합성을 유지한 경험을 지속하고 싶습니다.
- **🔴 Problem (Architecture Trade-off):** 
  - **과도한 정규화(3NF)로 인한 조회 성능 이슈:** 초기 설계 시 무결성에 집중한 제3정규형(3NF) 설계가 실제 대량 조회 상황에서 중첩된 JOIN 오버헤드를 발생시키는 것을 확인했습니다. 결과적으로 서비스 로직이 무거워지는 성능 트레이드 오프(Trade-off)를 경험했습니다.
- **🔵 Try (Future Optimization):** 
  - **전략적 역정규화 및 캐싱 도입:** 차기 프로젝트에서는 빈번한 조회가 발생하는 데이터에 대해 읽기 성능 최적화를 위한 **전략적 역정규화(Denormalization)**를 고려하거나, **Redis와 같은 In-memory 캐시 레이어**를 도입하여 DB 부하를 분산시키는 고도화된 아키텍처 설계를 시도할 계획입니다.

</details>
<details>
<summary>부록: 프로젝트 실행 방법 (Docker)</summary>

> 이 프로젝트는 **Docker** 환경이 모두 세팅되어 있어 매우 간편하게 실행할 수 있습니다.

1. **사전 준비**: 로컬 환경에 `Docker Desktop` 설치 및 실행
2. **프로젝트 클론 및 폴더 이동**
   ```bash
   git clone [레포지토리 주소]
   cd 2026-bootcamp_semi_project
   ```
3. **Docker Compose를 통한 컨테이너 빌드 및 백그라운드 실행**
   ```bash
   docker-compose up -d --build
   ```
4. **접속하기**
   - 브라우저에서 `http://localhost:8080` 으로 접속하여 메인 화면 확인.

</details>
