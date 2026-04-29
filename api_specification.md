---
작성일: 2026-03-15T10:00
수정일: 2026-04-28T16:55
---
# 📋 UBIG 핵심 비즈니스 API 명세서 (Core API Specification)

> **보안 아키텍처, 통신 프로토콜, 인터페이스 명세 중심의 시스템 기술서**  
> 이 문서는 유기동물 매칭 플랫폼 UBIG의 핵심 비즈니스 로직을 수행하는 주요 API들을 계층별로 정의하며, 실제 구현된 소스 코드를 통해 설계 의도를 명세합니다.

---

### 🛡️ [인증 및 보안 아키텍처]
1. [🛡️ 입양 신청 프로세스 및 5중 보안 가드 (Security Guard)](#1-입양-신청-프로세스-및-5중-보안-가드-security-guard)

### 📡 [통신 프로토콜 설계]
2. [📋 마이페이지 비동기 데이터 통신 (AJAX JSON Protocol)](#2-마이페이지-비동기-데이터-통신-ajax-json-protocol)
3. [🌱 봉사 후기 실시간 인터랙션 (Async UI Lifecycle)](#3-봉사-후기-실시간-인터랙션-async-ui-lifecycle)

### 🧩 [인터페이스 설계]
4. [🔍 입양 공고 통합 검색 및 복합 필터링 (Dynamic SQL)](#4-입양-공고-통합-검색-및-복합-필터링-dynamic-sql)
5. [💎 입양 최종 확정 및 상태 전이 (Atomic Transaction)](#5-입양-최종-확정-및-상태-전이-atomic-transaction)
6. [📦 동물 정보 연쇄 정제 및 일괄 삭제 (Cleanup Sequence)](#6-동물-정보-연쇄-정제-및-일괄-삭제-cleanup-sequence)

---

## 🛡️ 1. 입양 신청 프로세스 및 5중 보안 가드 (Security Guard)
- **Technical Point**: 입양 신청 시 발생할 수 있는 데이터 위변조 및 중복 신청을 방지하기 위해 세션 검증과 비즈니스 로직 검증을 결합한 **다중 방어 체계**를 구축했습니다.

### 💻 Controller Guard Logic
```java
// AdoptionController.java 中 - 입양 신청 가드 로직
@RequestMapping("/adoption.insertapplication")
public String insertapplication(AdoptionApplicationVO application, HttpSession session) {
    MemberVO user = (MemberVO) session.getAttribute("loginMember");
    
    // [Guard 1] 인증 확인: 로그인 세션 부재 시 접근 차단
    if (user == null) {
        session.setAttribute("alertMsgAd", "로그인이 필요한 서비스입니다.");
        return "common/errorPage";
    }

    // [Guard 2] 중복 신청 확인: 동일 동물의 중복 신청 방지 (DB 기반 검증)
    int check = service.checkApplication(application.getAnimalNo(), user.getUserId());
    if (check > 0) {
        session.setAttribute("alertMsgAd", "이미 입양 신청을 하셨습니다.");
        return "redirect:/adoption.detailpage?anino=" + application.getAnimalNo();
    }

    // [Guard 3] 소유권 확인: 본인이 등록한 동물을 스스로 신청하는 이상 행위 차단
    AnimalDetailVO animal = service.goAdoptionDetail(application.getAnimalNo());
    if (animal != null && animal.getUserId().equals(user.getUserId())) {
        session.setAttribute("alertMsgAd", "본인이 등록한 동물에는 신청할 수 없습니다.");
        return "redirect:/adoption.detailpage";
    }

    int result = service.insertApplication(application);
    return "redirect:/adoption.detailpage?anino=" + application.getAnimalNo();
}
```

---

## 📡 2. 마이페이지 비동기 데이터 통신 (AJAX JSON Protocol)
- **Technical Point**: 페이지 전체 리로드 없이 필요한 데이터만 전송받아 렌더링하는 **비동기 JSON 통신**을 구현했습니다. `@ResponseBody`와 `Gson`을 활용해 하이브리드 앱 환경으로의 확장성을 확보했습니다.

### 💻 AJAX JSON Response
```java
// AdoptionController.java 中 - 비동기 마이페이지 데이터 응답
@ResponseBody
@RequestMapping(value = "/adoption.mypage", produces = "application/json; charset=UTF-8")
public String mypage(HttpSession session, @RequestBody Map<String, String> body) {
    MemberVO user = (MemberVO) session.getAttribute("loginMember");
    
    // 1. 페이징 및 필터 정보 동적 처리 (Body 파싱)
    int page1 = Integer.parseInt(body.getOrDefault("page1", "1"));
    String keyword = body.getOrDefault("keyword", "");
    
    // 2. 서비스 로직 수행 및 페이징 객체 생성
    PageInfo pi1 = Pagination.getPageInfo(service.selectListCount(user.getUserId()), page1, 5, 5);
    List<AdoptionMainListVO> list1 = service.selectAnimalList1(user.getUserId(), pi1, keyword);
    
    // 3. 응답 데이터 맵핑 및 JSON 직렬화
    Map<String, Object> resultAll = new HashMap<>();
    resultAll.put("myAdoptions", list1);
    resultAll.put("pi1", pi1);

    return new Gson().toJson(resultAll); // [핵심] 일관된 JSON 데이터 포맷 제공
}
```

---

## 🌱 3. 봉사 후기 실시간 인터랙션 (Async UI Lifecycle)
- **Technical Point**: 댓글 등록 및 조회를 비동기로 처리하여 사용자 경험(UX)을 극대화했습니다. **JS(요청) - Java(가공) - SQL(영속)**로 이어지는 전체 비동기 라이프사이클을 설계했습니다.

### 💻 Async Interaction Lifecycle
```javascript
/* [Frontend] AJAX를 활용한 동적 DOM 생성 로직 */
function selectReplyList() {
    $.ajax({
        url: "reviewReplyList.vo",
        data: { actId: "${r.actId}", reviewNo: "${r.reviewNo}" },
        success: function (list) {
            let value = "";
            if (list.length == 0) {
                value += "<div class='no-reply'>첫 댓글의 주인공이 되어보세요!</div>";
            } else {
                for (let i in list) {
                    value += `<div class='reply-row'>
                                <strong>${list[i].userId}</strong>
                                <span>${list[i].cmtDate}</span>
                                <p>${list[i].cmtAnswer}</p>
                              </div>`;
                }
            }
            $("#replyArea").html(value); // 특정 구역만 동적으로 교체
        }
    });
}
```

```java
/* [Controller] 데이터를 JSON으로 변환하여 비동기 응답 */
@ResponseBody
@RequestMapping(value = "/reviewReplyList.vo", produces = "application/json; charset=UTF-8")
public String selectReplyList(VolunteerCommentVO reply) {
    List<VolunteerCommentVO> list = service.selectReplyList(reply);
    return new Gson().toJson(list); // JSON 직렬화 응답
}
```

---

## 🧩 4. 입양 공고 통합 검색 및 복합 필터링 (Dynamic SQL)
- **Endpoint**: `GET /adoption.mainpage`
- **Technical Point**: 품종, 성별, 나이 등 10여 개의 복합 필터 조건을 단일 쿼리 내에서 처리하기 위해 **MyBatis 동적 SQL**을 최적화했습니다.

### 💻 MyBatis Dynamic SQL
```xml
<select id="selectAdoptionMainList" resultType="AdoptionMainListVO" parameterType="AdoptionSearchFilterVO">
    SELECT P.POST_NO, P.POST_TITLE, P.VIEWS, A.PHOTO_URL, A.ANIMAL_NAME, A.ADOPTION_STATUS
    FROM ADOPTION_POSTS P
    JOIN ANIMAL_DETAILS A ON P.ANIMAL_NO = A.ANIMAL_NO
    <where>
        <if test="species != null">AND A.SPECIES = #{species}</if>
        <if test="gender != null">AND A.GENDER = #{gender}</if>
        <if test="ageMin != null">AND A.AGE >= #{ageMin}</if>
        <if test="ageMax != null">AND A.AGE <= #{ageMax}</if>
        <if test="breed != null and breed != ''">AND A.BREED LIKE '%' || #{breed} || '%'</if>
        <if test="keyword != null and keyword != ''">AND A.ANIMAL_NAME LIKE '%' || #{keyword} || '%'</if>
    </where>
    ORDER BY 
        CASE WHEN A.ADOPTION_STATUS = '대기중' THEN 1 ELSE 2 END ASC,
        P.POST_REG_DATE DESC
</select>
```

---

## 💎 5. 입양 최종 확정 및 상태 전이 (Atomic Transaction)
- **Technical Point**: 입양 확정 시 **[확정 처리 - 타 신청자 일괄 반려 - 알림 발송]**의 과정을 하나의 원자적 단위로 묶어 데이터의 일관성을 보장합니다.

### 💻 Service Transaction Logic
```java
@Transactional // 전 과정 원자성 보장
public int confirmAdoption(int adoptionAppId, int animalNo) {
    // 1. 해당 신청자 '입양완료' 처리
    int result1 = dao.confirmApplication(sqlSession, adoptionAppId);

    // 2. 나머지 신청자 일괄 '반려' 처리 (Atomic 처리로 정합성 유지)
    Map<String, Object> map = new HashMap<>();
    map.put("animalNo", animalNo);
    map.put("adoptionAppId", adoptionAppId);
    dao.rejectOtherApplications(sqlSession, map);

    // 3. 동물 상태 최종 업데이트
    int result2 = dao.acceptAdoption(sqlSession, animalNo);
    
    // 4. 비즈니스 알림(쪽지) 자동 발송 로직 실행...
    return (result1 > 0 && result2 > 0) ? 1 : 0;
}
```

---

## 📦 6. 동물 정보 연쇄 정제 및 일괄 삭제 (Cleanup Sequence)
- **Technical Point**: DB 참조 무결성(FK)을 고려하여 하위 데이터부터 상위 데이터까지 순차적으로 정제하는 **Cleanup 파이프라인**을 구현했습니다.

### 💻 Cleanup Sequence
```java
@Transactional
public int deleteAnimalFull(int anino) {
    // 1. 참조 데이터(입양 신청서) 선 정제
    dao.deleteApplicationsByAnimalNo(sqlSession, anino);

    // 2. 하위 연관 데이터(홍보 게시글) 삭제
    dao.deletePost(sqlSession, anino);

    // 3. 최상위 마스터 데이터(동물 상세) 최종 삭제
    return dao.deleteAnimal(sqlSession, anino);
}
```

---

### 💡 API 설계 공통 원칙
1. **Consistency**: 모든 API는 일관된 Response 객체 혹은 JSON 구조를 반환하여 클라이언트 측의 예외 처리를 단순화합니다.
2. **Atomic Integrity**: 다중 테이블 업데이트가 수반되는 모든 로직에는 `@Transactional`을 적용하여 데이터 불일치를 원천 차단합니다.
3. **Efficiency**: MyBatis의 동적 쿼리를 통해 불필요한 DB 접근을 최소화하고, 단일 쿼리로 복합 로직을 처리하여 성능을 최적화합니다.
