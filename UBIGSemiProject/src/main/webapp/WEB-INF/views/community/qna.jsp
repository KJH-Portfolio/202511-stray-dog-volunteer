<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>유봉일공 - 봉사활동 Q&A</title>
            <!-- Google Fonts & Icons -->
            <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
            <style>
                body {
                    font-family: 'Noto Sans KR', sans-serif;
                    background-color: #f8f9fa;
                }

                .community-container {
                    padding: 100px 0;
                    width: 100%;
                    max-width: 1000px;
                    margin: 0 auto;
                }

                .page-header {
                    text-align: center;
                    margin-bottom: 60px;
                }

                .page-title {
                    font-size: 2.5em;
                    font-weight: 700;
                    color: #2c3e50;
                    margin-bottom: 15px;
                }

                .page-desc {
                    color: #6c757d;
                    font-size: 1.1em;
                }

                /* 탭 스타일 (list.jsp와 통일) */
                .tab-menu {
                    display: flex;
                    justify-content: center;
                    margin-bottom: 50px;
                    gap: 10px;
                }

                .tab-item {
                    padding: 12px 30px;
                    cursor: pointer;
                    color: #495057;
                    font-weight: 500;
                    text-decoration: none;
                    border-radius: 50px;
                    background-color: white;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                    transition: all 0.3s ease;
                }

                .tab-item:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
                    color: #ff9f43;
                }

                .tab-item.active {
                    background-color: #ff9f43;
                    color: white;
                    font-weight: 700;
                    box-shadow: 0 4px 10px rgba(255, 159, 67, 0.4);
                }

                /* 아코디언 스타일 */
                .faq-section {
                    display: flex;
                    flex-direction: column;
                    gap: 20px;
                }

                .accordion-item {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    overflow: hidden;
                    transition: all 0.3s ease;
                }

                .accordion-item:hover {
                    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
                    transform: translateY(-2px);
                }

                .accordion-header {
                    padding: 25px 30px;
                    cursor: pointer;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    font-weight: 500;
                    font-size: 1.1em;
                    color: #2c3e50;
                    transition: background-color 0.3s, color 0.3s;
                }

                .accordion-header:hover {
                    background-color: #fff9f0;
                }

                .accordion-header.active {
                    color: #ff9f43;
                    background-color: #fff9f0;
                    border-bottom: 1px solid #ff9f4320;
                }

                .question-text {
                    display: flex;
                    align-items: center;
                    gap: 15px;
                }

                .q-mark {
                    color: #ff9f43;
                    font-weight: 700;
                    font-size: 1.2em;
                }

                .toggle-icon {
                    color: #ccc;
                    transition: transform 0.3s;
                }

                .accordion-header.active .toggle-icon {
                    transform: rotate(180deg);
                    color: #ff9f43;
                }

                .accordion-content {
                    max-height: 0;
                    overflow: hidden;
                    background-color: #ffffff;
                    transition: max-height 0.3s ease-out;
                    color: #555;
                    line-height: 1.7;
                }

                .accordion-content-inner {
                    padding: 30px;
                    border-top: 1px solid #f1f2f6;
                }

                .accordion-content p {
                    margin-bottom: 10px;
                }

                .accordion-content p:last-child {
                    margin-bottom: 0;
                }
            </style>
        </head>

        <body>

            <jsp:include page="/WEB-INF/views/common/menubar.jsp" />

            <main class="community-container">

                <div class="page-header">
                    <div class="page-title">봉사활동 Q&A</div>
                    <p class="page-desc">자주 묻는 질문들을 모아보았습니다.</p>
                </div>

                <div class="tab-menu">
                    <a href="list?category=NOTICE" class="tab-item">공지사항</a>
                    <a href="list?category=FREE" class="tab-item">자유게시판</a>
                    <a href="list?category=REQUEST" class="tab-item">건의사항</a>
                    <a href="list?category=REVIEW" class="tab-item">봉사후기</a>
                    <a href="qna" class="tab-item active">봉사활동 Q&A</a>
                </div>

                <div class="faq-section">
                    <div class="accordion-item">
                        <div class="accordion-header">
                            <span class="question-text">
                                <span class="q-mark">Q1.</span>
                                봉사활동은 어떻게 참여하나요?
                            </span>
                            <i class="fas fa-chevron-down toggle-icon"></i>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-content-inner">
                                <p>봉사활동 일정 공지를 참고하여 신청 절차에 따라 신청해주세요. 신청 후 확정 안내 문자를 받으시면 참여가 가능합니다.</p>
                                <p>처음 참여하시는 분들도 현장에서 오리엔테이션을 통해 자세히 안내해 드리니 걱정하지 않으셔도 됩니다.</p>
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <div class="accordion-header">
                            <span class="question-text">
                                <span class="q-mark">Q2.</span>
                                봉사활동 장소는 보통 어디에 있나요?
                            </span>
                            <i class="fas fa-chevron-down toggle-icon"></i>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-content-inner">
                                <p>임대료 및 소음/냄새 민원 등의 문제로 인해 서울 시내에서는 보호소 운영이 어렵습니다.</p>
                                <p>주로 <strong>파주, 일산, 시흥, 남양주, 평택, 김포</strong> 등 경기도권 외곽 지역의 보호소로 이동하여 활동합니다.</p>
                                <p>도움이 절실한 곳이라면 제보를 받아 새로운 지역으로도 봉사를 떠납니다.</p>
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <div class="accordion-header">
                            <span class="question-text">
                                <span class="q-mark">Q3.</span>
                                봉사참여금(10,000원)은 어디에 사용되나요?
                            </span>
                            <i class="fas fa-chevron-down toggle-icon"></i>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-content-inner">
                                <p><strong>1. 점심 식사 제공:</strong> 약 5,000원 상당의 식사(김밥, 도시락 등)를 제공합니다.</p>
                                <p><strong>2. 물품 후원:</strong> 보호소 아이들을 위한 사료, 간식, 이불 등 필요 물품을 구매하여 전달합니다.</p>
                                <p><strong>3. 운영비:</strong> 이동 차량 유류비 등 단체 운영에 필요한 최소한의 경비로 사용됩니다.</p>
                                <p>모든 사용 내역은 투명하게 공개됩니다.</p>
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <div class="accordion-header">
                            <span class="question-text">
                                <span class="q-mark">Q4.</span>
                                미성년자도 봉사 참여가 가능한가요?
                            </span>
                            <i class="fas fa-chevron-down toggle-icon"></i>
                        </div>
                        <div class="accordion-content">
                            <div class="accordion-content-inner">
                                <p>안전상의 이유로 중학생 이상부터 참여 가능하며, 미성년자의 경우 <strong>반드시 보호자(부모님 등) 동반</strong> 시에만 참여 가능합니다.
                                </p>
                                <p>더 궁금한 사항은 1:1 문의를 남겨주세요.</p>
                            </div>
                        </div>
                    </div>

                </div>

            </main>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const headers = document.querySelectorAll('.accordion-header');

                    headers.forEach(header => {
                        header.addEventListener('click', function () {
                            const content = this.nextElementSibling;
                            const isActive = this.classList.contains('active');

                            // 모든 아이템 닫기 (하나만 열리게 하려면 유지, 다중 선택 허용하려면 주석 처리)
                            // 여기서는 깔끔하게 하나만 열리는 방식 유지
                            document.querySelectorAll('.accordion-header').forEach(h => {
                                if (h !== this) {
                                    h.classList.remove('active');
                                    h.nextElementSibling.style.maxHeight = null;
                                }
                            });

                            // 토글
                            if (!isActive) {
                                this.classList.add('active');
                                content.style.maxHeight = content.scrollHeight + "px";
                            } else {
                                this.classList.remove('active');
                                content.style.maxHeight = null;
                            }
                        });
                    });
                });
            </script>

        </body>

        </html>