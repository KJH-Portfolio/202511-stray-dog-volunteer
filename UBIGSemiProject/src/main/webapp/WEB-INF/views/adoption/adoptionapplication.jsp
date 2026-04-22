<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>UBIG - 입양 신청</title>
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
                    <div class="page-title">입양 신청서 작성</div>
                    <p class="page-desc">평생을 함께할 가족을 맞이하는 소중한 약속입니다.</p>
                </div>

                <div class="form-wrapper"
                    style="max-width: 900px; margin: 0 auto; background: #fff; padding: 50px; border-radius: 30px; box-shadow: 0 10px 40px rgba(0,0,0,0.08); border: 1px solid #f1f1f1;">
                    <form action="adoption.insertapplication" method="post" class="adoption-form">

                        <div class="row g-4 mb-5">
                            <div class="col-md-6">
                                <label class="form-label fw-bold" style="color:#555;">동물 고유 번호</label>
                                <input type="number" name="animalNo" value="${param.anino}" class="form-control"
                                    readonly style="background-color: #f8f9fa; border-radius: 12px; height: 50px;">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold" style="color:#555;">신청자 ID</label>
                                <input type="text" name="userId" value="${loginMember.userId}" class="form-control"
                                    readonly
                                    style="background-color: #f8f9fa; border-radius: 12px; height: 50px; color: #333; font-weight: bold;">
                                <input type="hidden" name="adoptStatus" value="1" />
                            </div>
                        </div>

                        <!-- Terms Section -->
                        <div class="terms-container p-4 rounded-4"
                            style="background-color: #fffcf5; border: 1px solid #fae1c3;">
                            <h4 class="fw-bold mb-4" style="color: #d17d36;">📋 입양 필수 약관 동의</h4>

                            <!-- Term 1 -->
                            <div class="term-box mb-4 bg-white p-3 rounded-3 border"
                                style="border-color: #eee !important;">
                                <label class="fw-bold mb-2 text-dark">제1조 (동물 보호 및 관리 의무)</label>
                                <textarea class="form-control rounded-3 border-0 bg-light mb-2" readonly
                                    style="height: 100px; resize: none; color: #666; font-size: 0.9rem;">입양자는 동물을 생명의 존엄성을 가진 생명체로 존중하며, 학대하거나 방치하지 않고 기본적인 의식주와 필요한 의료 서비스를 제공할 책임이 있습니다. 특히 예방접종 및 정기적인 검진을 통해 동물의 건강 상태를 최상으로 유지해야 합니다.</textarea>
                                <div class="form-check d-flex justify-content-end align-items-center">
                                    <input class="form-check-input me-2" type="checkbox" name="agree1" id="agree1"
                                        required>
                                    <label class="form-check-label" for="agree1">동의합니다</label>
                                </div>
                            </div>

                            <!-- Term 2 -->
                            <div class="term-box mb-4 bg-white p-3 rounded-3 border"
                                style="border-color: #eee !important;">
                                <label class="fw-bold mb-2 text-dark">제2조 (유기 및 무단 양도 금지)</label>
                                <textarea class="form-control rounded-3 border-0 bg-light mb-2" readonly
                                    style="height: 100px; resize: none; color: #666; font-size: 0.9rem;">입양자는 어떠한 사유로도 입양한 동물을 유기하거나, 보호소와의 사전 협의 없이 제3자에게 무단으로 양도 또는 판매해서는 안 됩니다. 만약 부득이한 사정으로 더 이상 보호가 불가능할 경우, 반드시 본 보호소로 연락하여 사후 대책을 논의해야 합니다.</textarea>
                                <div class="form-check d-flex justify-content-end align-items-center">
                                    <input class="form-check-input me-2" type="checkbox" name="agree2" id="agree2"
                                        required>
                                    <label class="form-check-label" for="agree2">동의합니다</label>
                                </div>
                            </div>

                            <!-- Term 3 -->
                            <div class="term-box mb-4 bg-white p-3 rounded-3 border"
                                style="border-color: #eee !important;">
                                <label class="fw-bold mb-2 text-dark">제3조 (사후 모니터링 협조)</label>
                                <textarea class="form-control rounded-3 border-0 bg-light mb-2" readonly
                                    style="height: 100px; resize: none; color: #666; font-size: 0.9rem;">입양자는 입양 후 일정 기간 동안 동물의 적응 상태와 관리 현황을 보호소에 정기적으로 보고(사진 전송 또는 유선 상담 등)하는 데 동의합니다. 또한, 보호소의 상담이나 모니터링 요청에 적극적으로 협조하여 동물의 복지를 보장해야 합니다.</textarea>
                                <div class="form-check d-flex justify-content-end align-items-center">
                                    <input class="form-check-input me-2" type="checkbox" name="agree3" id="agree3"
                                        required>
                                    <label class="form-check-label" for="agree3">동의합니다</label>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end align-items-center pt-3 border-top"
                                style="border-color: #fae1c3 !important;">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="allagree" id="allagree"
                                        style="width: 1.2em; height: 1.2em;">
                                    <label class="form-check-label fw-bold text-dark ms-2" for="allagree">
                                        약관 전체 동의
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end w-100 gap-3 mt-5">
                            <button type="submit" class="btn btn-primary btn-lg rounded-pill px-5 fw-bold shadow-sm">입양
                                신청하기</button>
                            <button type="button" class="btn btn-light btn-lg rounded-pill px-5 border"
                                onclick="history.back()">취소</button>
                        </div>

                    </form>
                </div>
            </main>

            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const allagree = document.querySelector("#allagree");
                    // Select all required checkboxes (agree1, agree2, agree3)
                    const checkboxes = document.querySelectorAll("input[name^='agree']");

                    allagree.addEventListener("change", function () {
                        checkboxes.forEach(checkbox => {
                            checkbox.checked = allagree.checked;
                        });
                    });

                    checkboxes.forEach(checkbox => {
                        checkbox.addEventListener("change", function () {
                            // Update allagree based on whether all required checkboxes are checked
                            allagree.checked = Array.from(checkboxes).every(cb => cb.checked);
                        });
                    });
                });
            </script>
        </body>

        </html>