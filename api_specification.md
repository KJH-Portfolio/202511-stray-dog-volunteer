# 📋 UBIG 핵심 비즈니스 API 명세서 (Core API Specification)

> **데이터 정합성 및 성능 최적화 중심의 핵심 인터페이스 명세**  
> 이 문서는 유기동물 매칭 플랫폼 UBIG의 핵심 비즈니스 로직을 수행하는 주요 API들을 정의하며, 실제 구현된 소스 코드를 통해 설계 의도를 명세합니다.

---

## 📑 목차
1. [🔍 입양 공고 통합 검색 (복합 필터링)](#1-입양-공고-통합-검색-복합-필터링)
2. [🛡️ 입양 신청서 제출 (5중 보안 가드)](#2-입양-신청서-제출-5중-보안-가드)
3. [💎 입양 최종 확정 (원자적 트랜잭션)](#3-입양-최종-확정-원자적-트랜잭션)
4. [📋 마이페이지 활동 내역 (비동기 JSON 통신)](#4-마이페이지-활동-내역-비동기-json-통신)
5. [📦 동물 정보 일괄 삭제 (연쇄 정제 프로세스)](#5-동물-정보-일괄-삭제-연쇄-정제-프로세스)
6. [🌱 봉사 후기 댓글 관리 (AJAX 데이터 핸들링)](#6-봉사-후기-댓글-관리-ajax-데이터-핸들링)

---

## 🔍 1. 입양 공고 통합 검색 (복합 필터링)
- **Endpoint**: `GET /adoption.mainpage`
- **Technical Point**: 10여 개의 검색 조건을 MyBatis 동적 SQL을 통해 단일 쿼리로 최적화하여 조회합니다.

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

## 🛡️ 2. 입양 신청서 제출 (5중 보안 가드)
- **Endpoint**: `POST /adoption.insertapplication`
- **Technical Point**: 컨트롤러 레이어에서 데이터 정합성을 위한 다중 검증 로직을 수행합니다.

### 💻 Controller Guard Logic
```java
@RequestMapping("/adoption.insertapplication")
public String insertapplication(AdoptionApplicationVO application, HttpSession session) {
    MemberVO user = (MemberVO) session.getAttribute("loginMember");
    
    // [Guard 1] 중복 신청 확인
    int check = service.checkApplication(application.getAnimalNo(), user.getUserId());
    if (check > 0) {
        session.setAttribute("alertMsgAd", "이미 입양 신청을 하셨습니다.");
        return "redirect:/adoption.detailpage?anino=" + application.getAnimalNo();
    }

    // [Guard 2] 본인 동물 신청 불가
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

## 💎 3. 입양 최종 확정 (원자적 트랜잭션)
- **Endpoint**: `POST /adoption.confirm`
- **Technical Point**: `@Transactional`을 통해 입양 확정과 타 신청자 일괄 반려, 알림 발송을 하나의 단위로 묶었습니다.

### 💻 Service Transaction Logic
```java
@Transactional
public int confirmAdoption(int adoptionAppId, int animalNo) {
    // 1. 해당 신청자 '입양완료' 처리
    int result1 = dao.confirmApplication(sqlSession, adoptionAppId);

    // 2. 나머지 신청자 일괄 '반려' 처리 (Atomic)
    Map<String, Object> map = new HashMap<>();
    map.put("animalNo", animalNo);
    map.put("adoptionAppId", adoptionAppId);
    dao.rejectOtherApplications(sqlSession, map);

    // 3. 동물 상태 '입양완료'로 최종 갱신
    int result2 = dao.acceptAdoption(sqlSession, animalNo);

    // 4. 비즈니스 알림(쪽지) 자동 발송 로직 실행...
    return (result1 > 0 && result2 > 0) ? 1 : 0;
}
```

---

## 📋 4. 마이페이지 활동 내역 (비동기 JSON 통신)
- **Endpoint**: `POST /adoption.mypage` (AJAX)
- **Technical Point**: `@ResponseBody`와 `Gson`을 사용하여 하이브리드 앱 환경을 고려한 JSON 응답을 제공합니다.

### 💻 AJAX JSON Response
```java
@ResponseBody
@RequestMapping(value = "/adoption.mypage", produces = "application/json; charset=UTF-8")
public String mypage(HttpSession session, @RequestBody Map<String, String> body) {
    MemberVO user = (MemberVO) session.getAttribute("loginMember");
    
    // 페이징 및 필터 정보 처리
    int page1 = Integer.parseInt(body.getOrDefault("page1", "1"));
    List<AdoptionMainListVO> list1 = service.selectAnimalList1(user.getUserId(), pi1, keyword);
    
    Map<String, Object> resultAll = new HashMap<>();
    resultAll.put("myAdoptions", list1);
    resultAll.put("pi1", pi1);

    return new Gson().toJson(resultAll); // JSON 직렬화 응답
}
```

---

## 📦 5. 동물 정보 일괄 삭제 (연쇄 정제 프로세스)
- **Endpoint**: `GET /adoption.deleteanimal`
- **Technical Point**: 참조 무결성을 위해 FK 관계에 있는 하위 데이터(신청서, 게시글)를 먼저 정제한 후 마스터 데이터를 삭제합니다.

### 💻 Cleanup Sequence
```java
@Transactional
public int deleteAnimalFull(int anino) {
    // 1. 참조 데이터(입양 신청서) 선 삭제
    dao.deleteApplicationsByAnimalNo(sqlSession, anino);

    // 2. 홍보 게시글 삭제
    dao.deletePost(sqlSession, anino);

    // 3. 마스터 데이터(동물 상세) 최종 삭제
    return dao.deleteAnimal(sqlSession, anino);
}
```

---

## 🌱 6. 봉사 후기 댓글 관리 (AJAX 데이터 핸들링)
- **Endpoint**: `GET /reviewReplyList.vo`
- **Technical Point**: 봉사활동 후기 상세 페이지의 댓글 리스트를 비동기식으로 처리하며, 실시간 등록/삭제 경험을 제공합니다.

### 💻 Complete AJAX Cycle (JS - Java - SQL)

```javascript
/* [Frontend] JSON 데이터를 받아 동적으로 HTML 생성 및 출력 */
function selectReplyList() {
    $.ajax({
        url: "reviewReplyList.vo",
        data: { actId: "${r.actId}", reviewNo: "${r.reviewNo}" },
        success: function (list) {
            var value = "";
            if (list.length == 0) {
                value += "<div class='no-reply'>첫 댓글의 주인공이 되어보세요!</div>";
            } else {
                for (var i in list) { // JSON 리스트를 반복문으로 순회
                    value += "<div class='reply-row'>";
                    value += "   <strong>" + list[i].userId + "</strong>";
                    value += "   <span>" + list[i].cmtDate + "</span>";
                    value += "   <p>" + list[i].cmtAnswer + "</p>";
                    value += "</div>";
                }
            }
            $("#replyArea").html(value); // [핵심] 특정 구역만 동적으로 교체
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

```xml
/* [Mapper] 비동기 UI를 위한 최신순 정렬 조회 */
<select id="selectReplyList" resultType="VolunteerCommentVO">
    SELECT CMT_NO, USER_ID, CMT_ANSWER, CMT_DATE
    FROM VOLUNTEER_BOARD_COMMENTS
    WHERE ACT_ID = #{actId} AND CMT_REMOVE = 0
    ORDER BY CMT_NO DESC
</select>
```

---

### 💡 API 설계 공통 원칙
1.  **Response Handling**: 모든 결과는 `HttpSession`의 `alertMsg` 또는 JSON 상태값을 통해 일관된 피드백을 제공합니다.
2.  **Exception Handling**: `@Transactional`을 적극 활용하여 비즈니스 로직 수행 도중의 런타임 예외 발생 시 전면 Rollback을 보장합니다.
3.  **Security**: 컨트롤러 진입부에서 세션 및 권한 인터셉터를 통해 비인증 사용자의 API 호출을 원천 차단합니다.
