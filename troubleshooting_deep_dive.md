---
작성일: 2026-04-25T02:30
수정일: 2026-04-25T02:30
---
# 🔍 UBIG 세미 프로젝트 Troubleshooting & Deep Dive

> **Spring Legacy 환경의 한계 극복 및 아키텍처 최적화 기록**  
> 이 문서는 세미 프로젝트 개발 과정에서 직면한 레거시 환경의 제약 사항들과 복잡한 비즈니스 로직의 정합성 문제를 "비포-애프터" 코드 비교를 통해 기술적으로 어떻게 해결했는지 상세히 기록합니다.

---

## 📑 목차
1. [Case 1: 대규모 유기동물 목록의 동적 필터링 성능 최적화](#case-1-대규모-유기동물-목록의-동적-필터링-성능-최적화)
2. [Case 2: 파일 시스템과 DB 트랜잭션 간의 데이터 무결성 보장](#case-2-파일-시스템과-db-트랜잭션-간의-데이터-무결성-보장)
3. [Case 3: 서버 사이드 다중 검증을 통한 비즈니스 부정 행위 차단](#case-3-서버-사이드-다중-검증을-통한-비즈니스-부정-행위-차단)

---

## 💎 Case 1: 대규모 유기동물 목록의 동적 필터링 성능 최적화

### 🚩 Situation & Cause
지역, 축종, 품종, 성별 등 다중 필터가 적용된 유기동물 목록 조회 시, 동적 조건을 처리하기 위해 자바 단에서 SQL 문자열을 직접 조작하거나 `WHERE 1=1`과 같은 비효율적인 방식을 사용했습니다. 이는 쿼리 가독성을 해칠 뿐만 아니라, 조건이 많아질수록 쿼리 플랜 최적화가 어려워지는 원인이 되었습니다.

### ✅ Solution: MyBatis `<where>` 및 `<if>` 태그 최적화
MyBatis의 동적 SQL 태그를 활용하여 쿼리 빌드 로직을 XML 레이어로 완전히 위임했습니다. 이를 통해 불필요한 `AND` 연산자 자동 제거 및 쿼리 가독성 확보, 데이터 정합성을 동시에 달성했습니다.

#### 🔄 코드 비교 (Before & After)

````carousel
```sql
/* [Before] 하드코딩된 WHERE 1=1 방식 */
SELECT * FROM ADOPTION_POSTS P
JOIN ANIMAL_DETAILS A ON P.ANIMAL_NO = A.ANIMAL_NO
WHERE 1=1
<if test="species != null">
    AND A.SPECIES = #{species}
</if>
/* 조건이 없어도 무조건 1=1 연산을 수행해야 함 */
```
<!-- slide -->
```sql
/* [After] MyBatis <where> 태그 기반 최적화 */
<select id="listCount" resultType="_int">
    SELECT count(*)
    FROM ADOPTION_POSTS P
    JOIN ANIMAL_DETAILS A ON P.ANIMAL_NO = A.ANIMAL_NO
    <where>
        <if test="species != null">
            AND A.SPECIES = #{species}
        </if>
        <if test="gender != null">
            AND A.GENDER = #{gender}
        </if>
        <if test="ageMin != null">AND A.AGE >= #{ageMin}</if>
        <if test="breed != null and breed != ''">
            AND A.BREED LIKE '%' || #{breed} || '%'
        </if>
    </where>
</select>
```
````

---

## 📁 Case 2: 파일 시스템과 DB 트랜잭션 간의 데이터 무결성 보장

### 🚩 Situation & Cause
이미지 업로드 시 파일은 하드디스크에 저장되지만, 이후 진행되는 DB `INSERT` 작업이 실패할 경우 저장된 파일만 서버에 남는 '고립된 파일(Orphan File)' 문제가 발생했습니다. 이는 장기적으로 서버 저장 공간 낭비와 관리 효율 저하를 초래했습니다.

### ✅ Solution: 예외 처리 기반의 파일 롤백(Rollback) 메커니즘
DB 작업의 결과값과 `try-catch` 블록을 활용하여, DB 저장에 실패하거나 예외가 발생할 경우 물리적으로 저장된 파일을 즉시 삭제하는 '방어적 로직'을 구축했습니다.

#### 🔄 코드 비교 (Before & After)

````carousel
```java
/* [Before] 예외 상황을 고려하지 않은 단순 업로드 */
String changeName = uploadFile(session, uploadFile);
animal.setPhotoUrl(changeName);
service.insertAnimal(animal); // 여기서 에러가 나면 파일은 서버에 남음
```
<!-- slide -->
```java
/* [After] DB 실패 시 파일 즉시 삭제 로직 도입 */
try {
    int result = service.insertAnimal(animal);
    if (result > 0) {
        session.setAttribute("alertMsgAd", "등록 성공!");
    } else {
        // [파일 롤백] DB 저장 실패 시 저장된 물리 파일 삭제
        new File(savePath + changeName).delete(); 
        session.setAttribute("alertMsgAd", "등록 실패!");
    }
} catch (Exception e) {
    // [예외 대응] 런타임 에러 발생 시에도 파일 삭제 보장
    new File(savePath + changeName).delete();
    e.printStackTrace();
}
```
````

---

## 🛡️ Case 3: 서버 사이드 다중 검증을 통한 비즈니스 부정 행위 차단

### 🚩 Situation & Cause
입양 신청 시 사용자가 본인이 등록한 동물을 신청하거나, 이미 마감된 게시글에 접근하는 등 정상적인 흐름을 벗어난 요청이 발생할 수 있었습니다. 클라이언트 단의 스크립트 제어만으로는 URL 직접 접근 등을 막을 수 없어 데이터 오염 위험이 있었습니다.

### ✅ Solution: 컨트롤러 레벨의 5중 방어 로직 (Guard Logic)
비즈니스 로직 수행 전 단계에서 세션 및 DB 실시간 조회를 통해 요청의 유효성을 다각도로 검증하는 가드 로직을 구현했습니다.

#### 🛠️ 구현된 5중 검증 가드 (Guard Implementation)
```java
@RequestMapping("/adoption.applicationpage")
public String goAdoptionApplicationPage(int anino, HttpSession session) {
    MemberVO loginUser = (MemberVO) session.getAttribute("loginMember");

    // 1단계: 로그인 세션 체크
    if (loginUser == null) return "redirect:/adoption.mainpage";

    // 2단계: 대상 동물의 실제 존재 여부 검증 (DB 조회)
    AnimalDetailVO animal = service.goAdoptionDetail(anino);
    if (animal == null) return "redirect:/adoption.mainpage";

    // 3단계: 소유권 검증 (자신의 동물을 입양 신청하는 행위 차단)
    if (animal.getUserId().equals(loginUser.getUserId())) return "redirect:/adoption.detailpage";

    // 4단계: 비즈니스 상태 검증 (이미 마감/완료된 입양건 차단)
    if ("마감".equals(animal.getAdoptionStatus())) return "redirect:/adoption.detailpage";

    // 5단계: 중복 신청 방지 (이미 신청한 이력이 있는지 확인)
    int check = service.checkApplication(anino, loginUser.getUserId());
    if (check > 0) return "redirect:/adoption.detailpage";

    return "/adoption/adoptionapplication";
}
```
