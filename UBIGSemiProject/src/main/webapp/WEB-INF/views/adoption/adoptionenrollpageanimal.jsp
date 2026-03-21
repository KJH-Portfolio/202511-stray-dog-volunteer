<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>UBIG - 동물 등록</title>
            <!-- Bootstrap 5 -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Global Style -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
            <!-- Adoption Specific Style -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adoption-style.css">
        </head>

        <body>
            <jsp:include page="/WEB-INF/views/common/menubar.jsp" />

            <c:if test="${not empty alertMsgAd}">
                <script>
                    alert(`${alertMsgAd}`);
                </script>
                <c:remove var="alertMsgAd" scope="session" />
            </c:if>

            <main class="community-container">
                <div class="page-header">
                    <div class="page-title">
                        <c:choose>
                            <c:when test="${not empty animal}">동물 정보 수정</c:when>
                            <c:otherwise>동물 정보 등록</c:otherwise>
                        </c:choose>
                    </div>
                    <p class="page-desc">새로운 가족을 찾을 아이들의 정보를 꼼꼼하게 입력해주세요.</p>
                </div>

                <div class="form-wrapper"
                    style="max-width: 800px; margin: 0 auto; background: #fff; padding: 40px; border-radius: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.05);">
                    <form action="${not empty animal ? 'adoption.update.animal.action' : 'adoption.insert.animal'}"
                        method="POST" enctype="multipart/form-data" class="adoption-form needs-validation" novalidate>

                        <c:if test="${not empty animal}">
                            <input type="hidden" name="animalNo" value="${animal.animalNo}">
                            <input type="hidden" name="originalPhotoUrl" value="${animal.photoUrl}">
                        </c:if>

                        <div class="row g-4">
                            <!-- 1. 축종 -->
                            <div class="col-md-6">
                                <label for="species" class="form-label fw-bold">1. 축종 (Species)</label>
                                <select name="species" id="species" class="form-select" required>
                                    <option value="1" ${animal.species eq 1 ? 'selected' : '' }>강아지</option>
                                    <option value="2" ${animal.species eq 2 ? 'selected' : '' }>고양이</option>
                                </select>
                            </div>

                            <!-- 2. 이름 -->
                            <div class="col-md-6">
                                <label for="animalName" class="form-label fw-bold">2. 이름 (Name)</label>
                                <input type="text" name="animalName" id="animalName" class="form-control"
                                    placeholder="예: 뽀삐" required pattern="^[가-힣a-zA-Z0-9\s]+$" title="특수문자는 사용할 수 없습니다"
                                    maxlength="33" value="<c:out value='${animal.animalName}'/>">
                            </div>

                            <!-- 3. 품종 -->
                            <div class="col-md-6">
                                <label for="breed" class="form-label fw-bold">3. 품종 (Breed)</label>
                                <input type="text" name="breed" id="breed" class="form-control" placeholder="예: 말티즈"
                                    required pattern="^[가-힣a-zA-Z\s]+$" title="특수문자 및 숫자는 사용할 수 없습니다" maxlength="33"
                                    value="<c:out value='${animal.breed}'/>">
                            </div>

                            <!-- 4. 성별 -->
                            <div class="col-md-6">
                                <label class="form-label fw-bold">4. 성별 (Gender)</label>
                                <div class="d-flex gap-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="gender" id="genderM"
                                            value="1" ${empty animal or animal.gender eq 1 ? 'checked' : '' }>
                                        <label class="form-check-label" for="genderM">수컷(M)</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="gender" id="genderF"
                                            value="2" ${animal.gender eq 2 ? 'checked' : '' }>
                                        <label class="form-check-label" for="genderF">암컷(F)</label>
                                    </div>
                                </div>
                            </div>

                            <!-- 5. 나이 -->
                            <div class="col-md-4">
                                <label for="age" class="form-label fw-bold">5. 나이 (Age / 살)</label>
                                <input type="number" name="age" id="age" class="form-control" step="0.1"
                                    placeholder="예: 2.5 (최대 50살)" required min="0" max="50"
                                    oninput="if(this.value<0)this.value=0; if(this.value>50)this.value=50;"
                                    value="${animal.age}">
                            </div>

                            <!-- 6. 체중 -->
                            <div class="col-md-4">
                                <label for="weight" class="form-label fw-bold">6. 체중 (Weight / kg)</label>
                                <input type="number" name="weight" id="weight" class="form-control" step="0.1"
                                    placeholder="예: 5.2 (최대 100kg)" required min="0" max="100"
                                    oninput="if(this.value<0)this.value=0; if(this.value>100)this.value=100;"
                                    value="${animal.weight}">
                            </div>

                            <!-- 7. 크기 -->
                            <div class="col-md-4">
                                <label for="petSize" class="form-label fw-bold">7. 크기 (Size / cm)</label>
                                <input type="number" name="petSize" id="petSize" class="form-control" step="0.1"
                                    placeholder="크기 입력 (최대 300cm)" required min="0" max="300"
                                    oninput="if(this.value<0)this.value=0; if(this.value>300)this.value=300;"
                                    value="${animal.petSize}">
                            </div>

                            <!-- 8. 중성화 여부 -->
                            <div class="col-12">
                                <label class="form-label fw-bold">8. 중성화 여부 (Neutered)</label>
                                <div class="d-flex gap-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="neutered" id="neuteredY"
                                            value="1" ${animal.neutered eq 1 ? 'checked' : '' }>
                                        <label class="form-check-label" for="neuteredY">완료(Yes)</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="neutered" id="neuteredN"
                                            value="0" ${empty animal or animal.neutered eq 0 ? 'checked' : '' }>
                                        <label class="form-check-label" for="neuteredN">미완료(No)</label>
                                    </div>
                                </div>
                            </div>

                            <!-- 9. 접종 상태 -->
                            <div class="col-12">
                                <label for="vaccinationStatus" class="form-label fw-bold">9. 접종 상태 (Vaccination
                                    Status)</label>
                                <input type="text" name="vaccinationStatus" id="vaccinationStatus" class="form-control"
                                    placeholder="예: 3차 완료" maxlength="333" required
                                    value="<c:out value='${animal.vaccinationStatus}'/>">
                            </div>

                            <!-- 10. 특이사항 -->
                            <div class="col-12">
                                <label for="healthNotes" class="form-label fw-bold">10. 특이사항 (Health Notes)</label>
                                <textarea name="healthNotes" id="healthNotes" class="form-control" rows="3"
                                    placeholder="건강 상태 및 특징 작성" maxlength="333"
                                    required><c:out value='${animal.healthNotes}'/></textarea>
                            </div>

                            <!-- 11. 입양 상태 -->
                            <div class="col-md-6">
                                <label for="adoptionStatus" class="form-label fw-bold">11. 입양 상태 (Status)</label>
                                <select name="adoptionStatus" id="adoptionStatus" class="form-select">
                                    <option value="대기중">대기중</option>
                                    <option value="신청중" disabled>신청중</option>
                                    <option value="완료" disabled>완료</option>
                                </select>
                            </div>

                            <!-- 14. 공고 마감일 (순서 조정) -->
                            <div class="col-md-6">
                                <label for="deadlineDate" class="form-label fw-bold">14. 공고 마감일 (Deadline)</label>
                                <input type="date" name="deadlineDate" id="deadlineDate" class="form-control" required
                                    value="${animal.deadlineDate}">
                            </div>

                            <!-- 12. 입양 조건 -->
                            <div class="col-12">
                                <label for="adoptionConditions" class="form-label fw-bold">12. 입양 조건
                                    (Conditions)</label>
                                <textarea name="adoptionConditions" id="adoptionConditions" class="form-control"
                                    rows="3" placeholder="필수 입양 조건 작성" maxlength="333"
                                    required><c:out value='${animal.adoptionConditions}'/></textarea>
                            </div>

                            <!-- 13. 입양 희망 지역 -->
                            <div class="col-12">
                                <label class="form-label fw-bold">13. 입양 희망 지역 (Hope Region)</label>
                                <div class="input-group mb-2" style="max-width: 300px;">
                                    <input type="text" id="postcode" name="postcode" class="form-control"
                                        placeholder="우편번호" readonly>
                                    <button type="button" onclick="execDaumPostcode()"
                                        class="btn btn-outline-secondary">주소 검색</button>
                                </div>
                                <input type="text" id="roadAddress" name="roadAddress" class="form-control"
                                    placeholder="도로명 주소" readonly required
                                    value="<c:out value='${animal.hopeRegion}'/>">
                                <input type="hidden" name="hopeRegion" id="hopeRegion"
                                    value="<c:out value='${animal.hopeRegion}'/>">
                            </div>

                            <!-- 15. 사진 첨부 -->
                            <div class="col-12">
                                <label for="uploadFile" class="form-label fw-bold">15. 사진 첨부 (Photo)</label>
                                <c:if test="${not empty animal.photoUrl}">
                                    <div class="mb-2 text-muted small">현재 파일: ${animal.photoUrl}</div>
                                </c:if>
                                <input type="file" name="uploadFile" id="uploadFile" class="form-control"
                                    accept="image/*" ${empty animal ? 'required' : '' }>
                            </div>

                            <!-- Submit Button -->
                            <div class="col-12 text-center mt-5">
                                <button type="submit" class="btn btn-primary btn-lg rounded-pill px-5">
                                    ${not empty animal ? '동물 정보 수정하기' : '동물 정보 등록하기'}
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </main>

            <!--작성한 주소 api를 가져와서 입력받는 부분입니다.-->
            <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
            <script>
                function execDaumPostcode() {
                    new daum.Postcode({
                        oncomplete: function (data) {
                            var roadAddr = data.roadAddress; // 도로명 주소 변수
                            var extraRoadAddr = ''; // 참고 항목 변수

                            // bname 이 비어있지 않고, '동,로,가'로 끝난다면
                            if (data.bname !== '' && /[동로가]$/g.test(data.bname)) {
                                extraRoadAddr += data.bname;
                            }
                            // buildingName 이 비어있지 않고, 'Y'일 경우 추가한다.
                            if (data.buildingName !== '' && data.apartment === 'Y') {
                                extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                            }
                            // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                            if (extraRoadAddr !== '') {
                                extraRoadAddr = ' (' + extraRoadAddr + ')';
                            }

                            // 우편번호와 주소 정보를 해당 필드에 넣는다.
                            document.getElementById('postcode').value = data.zonecode;
                            document.getElementById("roadAddress").value = roadAddr;

                        }
                    }).open();
                }

                // 폼 제출 시 주소 합치기 (상세 주소 로직 제거)
                document.querySelector('.adoption-form').addEventListener('submit', function (e) {
                    var roadAddr = document.getElementById('roadAddress').value;

                    if (roadAddr) {
                        document.getElementById('hopeRegion').value = roadAddr;
                    }
                });
            </script>
        </body>

        </html>