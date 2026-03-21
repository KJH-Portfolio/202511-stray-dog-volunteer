<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>유봉일공 - 유기견 봉사활동 일등 공신</title>
            <!-- Google Fonts -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Outfit:wght@300;500;700&display=swap"
                rel="stylesheet">
            <!-- Common Style -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
            <!-- Animate.css for scroll animations -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />

            <style>
                /* 기본 초기화와 공통 스타일은 style.css에서 가져옵니다 */

                /* 메인 페이지 전용 스타일 */
                /* --- Hero Section --- */
                .hero {
                    position: relative;
                    height: 80vh;
                    min-height: 600px;
                    background: url('${pageContext.request.contextPath}/resources/images/main/main1.png') no-repeat center center/cover;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    text-align: center;
                    color: white;
                }

                .hero::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: linear-gradient(to bottom, rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.6));
                }

                .hero-content {
                    position: relative;
                    z-index: 1;
                    animation: fadeIn 1.5s ease-out;
                }

                .hero h1 {
                    font-size: 3.5rem;
                    margin-bottom: 20px;
                    font-weight: 800;
                    text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3);
                }

                .hero p {
                    font-size: 1.4rem;
                    margin-bottom: 40px;
                    text-shadow: 1px 1px 5px rgba(0, 0, 0, 0.3);
                }

                /* 메인 버튼 스타일 (오버라이드) */
                .btn-main {
                    display: inline-block;
                    padding: 12px 30px;
                    background-color: var(--primary-color);
                    color: white;
                    font-weight: 700;
                    border-radius: 50px;
                    box-shadow: 0 4px 6px rgba(255, 159, 67, 0.3);
                    transition: all 0.3s ease;
                }

                .btn-main:hover {
                    background-color: var(--primary-hover);
                    transform: translateY(-3px);
                    box-shadow: 0 6px 12px rgba(255, 159, 67, 0.4);
                }

                /* --- Stats Section --- */
                .stats {
                    background-color: white;
                    padding: 60px 0;
                    margin-top: -60px;
                    position: relative;
                    z-index: 2;
                    box-shadow: var(--shadow-lg);
                    border-radius: 20px 20px 0 0;
                }

                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(4, 1fr);
                    gap: 30px;
                    text-align: center;
                }

                .stat-item h3 {
                    font-size: 2.5rem;
                    font-weight: 700;
                    color: var(--primary-color);
                    /* Updated to Primary */
                    margin-bottom: 5px;
                }

                .stat-item p {
                    color: var(--text-muted);
                    font-weight: 500;
                }

                /* --- About Section --- */
                .about {
                    padding: 100px 0;
                    background-color: var(--body-bg);
                }

                .about-content {
                    display: flex;
                    align-items: center;
                    gap: 50px;
                }

                .about-text {
                    flex: 1;
                }

                .about-text h2 {
                    font-size: 2.2rem;
                    margin-bottom: 20px;
                    font-weight: 700;
                    color: var(--secondary-color);
                }

                .about-text p {
                    margin-bottom: 20px;
                    color: #555;
                    font-size: 1.05rem;
                }

                .about-img {
                    flex: 1;
                    position: relative;
                }

                .about-img img {
                    width: 100%;
                    border-radius: 20px;
                    box-shadow: var(--shadow-lg);
                    transition: transform 0.5s;
                }

                .about-img:hover img {
                    transform: scale(1.02);
                }

                /* --- Activity Section --- */
                .activity {
                    padding: 100px 0;
                    background-color: white;
                }

                .section-title {
                    text-align: center;
                    margin-bottom: 50px;
                }

                .section-title h2 {
                    font-size: 2.5rem;
                    font-weight: 700;
                    color: var(--secondary-color);
                    margin-bottom: 10px;
                }

                .section-title p {
                    color: var(--text-muted);
                    font-size: 1.1rem;
                }

                .activity-grid {
                    display: grid;
                    grid-template-columns: repeat(3, 1fr);
                    gap: 30px;
                }

                .activity-card {
                    background: white;
                    border-radius: 15px;
                    overflow: hidden;
                    box-shadow: var(--shadow-md);
                    transition: transform 0.3s, box-shadow 0.3s;
                    cursor: pointer;
                }

                .activity-card:hover {
                    transform: translateY(-10px);
                    box-shadow: var(--shadow-lg);
                }

                .activity-card img {
                    width: 100%;
                    height: 250px;
                    object-fit: cover;
                }

                .card-body {
                    padding: 25px;
                }

                .card-body h3 {
                    font-size: 1.4rem;
                    margin-bottom: 10px;
                    color: var(--secondary-color);
                }

                .card-body p {
                    color: var(--text-muted);
                    font-size: 0.95rem;
                }

                /* --- Call to Action --- */
                .cta {
                    padding: 100px 0;
                    background: linear-gradient(rgba(255, 159, 67, 0.9), rgba(229, 142, 60, 0.9)),
                    url('${pageContext.request.contextPath}/resources/images/main/main3.png') fixed center center/cover;
                    text-align: center;
                    color: white;
                }

                .cta h2 {
                    font-size: 3rem;
                    margin-bottom: 20px;
                    font-weight: 800;
                }

                .cta p {
                    font-size: 1.3rem;
                    margin-bottom: 40px;
                }

                .cta .btn-main {
                    background-color: white;
                    color: var(--primary-color);
                    font-size: 1.2rem;
                }

                .cta .btn-main:hover {
                    background-color: var(--body-bg);
                    color: var(--primary-hover);
                }

                /* Footer - Simple version override if needed, otherwise rely on common */
                .footer-simple {
                    background-color: var(--secondary-color);
                    color: #aaa;
                    padding: 50px 0;
                    text-align: center;
                    font-size: 0.9rem;
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                /* [User Request] 메인 텍스트 애니메이션 제거 및 중앙 고정 */
                .hero-content,
                .hero h1,
                .hero p,
                .hero .btn-main {
                    animation: none !important;
                    opacity: 1 !important;
                    transform: none !important;
                }
            </style>
        </head>

        <body>

            <!-- Menubar include -->
            <jsp:include page="/WEB-INF/views/common/menubar.jsp" />

            <!-- Hero Section -->
            <section class="hero">
                <div class="hero-content">
                    <h1 class="animate__animated animate__fadeInDown">작은 발걸음이 만드는<br>기적 같은 변화</h1>
                    <p class="animate__animated animate__fadeInUp animate__delay-1s">유기견 봉사활동 일등 공신, 유봉일공과 함께하세요.</p>
                    <a href="${pageContext.request.contextPath}/volunteerList.vo"
                        class="btn-main animate__animated animate__zoomIn animate__delay-1s">
                        봉사활동 신청하기
                    </a>
                </div>
            </section>

            <!-- Stats Section -->
            <section class="stats">
                <div class="container">
                    <div class="stats-grid">
                        <div class="stat-item" data-aos="fade-up" data-aos-delay="100">
                            <h3>128</h3>
                            <p>구조된 동물들</p>
                        </div>
                        <div class="stat-item" data-aos="fade-up" data-aos-delay="200">
                            <h3>28</h3>
                            <p>행복한 입양</p>
                        </div>
                        <div class="stat-item" data-aos="fade-up" data-aos-delay="300">
                            <h3>280</h3>
                            <p>함께하는 봉사자</p>
                        </div>
                        <div class="stat-item" data-aos="fade-up" data-aos-delay="400">
                            <h3>18</h3>
                            <p>연계 보호소</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- About Section -->
            <section class="about">
                <div class="container">
                    <div class="about-content">
                        <div class="about-img animate__animated animate__fadeInLeft">
                            <img src="${pageContext.request.contextPath}/resources/images/main/main2.png"
                                alt="Happy Dog">
                        </div>
                        <div class="about-text animate__animated animate__fadeInRight">
                            <h2>우리는 생명을 잇는<br>다리가 됩니다</h2>
                            <p>
                                유봉일공은 단순한 봉사활동 매칭 플랫폼이 아닙니다.
                                사람의 온기가 그리운 아이들과, 사랑을 나누고 싶은 당신을 연결합니다.
                            </p>
                            <p>
                                주말 산책 봉사부터 임시 보호, 이동 봉사까지.
                                여러분의 작은 관심이 아이들에게는 새로운 세상이 됩니다.
                                지금 바로 따뜻한 동행을 시작해보세요.
                            </p>
                            <a href="${pageContext.request.contextPath}/community/list?category=FREE"
                                class="btn-main">우리 이야기 더보기</a>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Activity Section -->
            <section class="activity">
                <div class="container">
                    <div class="section-title">
                        <h2>함께하는 활동</h2>
                        <p>다양한 방법으로 사랑을 실천할 수 있습니다</p>
                    </div>
                    <div class="activity-grid">
                        <div class="activity-card">
                            <img src="${pageContext.request.contextPath}/resources/images/main/main3.png"
                                alt="Walking Volunteer">
                            <div class="card-body">
                                <h3>산책 봉사</h3>
                                <p>답답한 견사를 벗어나 맑은 공기를 마시며 아이들의 스트레스를 해소해줍니다.</p>
                            </div>
                        </div>
                        <div class="activity-card">
                            <img src="${pageContext.request.contextPath}/resources/images/main/main2.png"
                                alt="Shelter Cleaning">
                            <div class="card-body">
                                <h3>견사 청소</h3>
                                <p>아이들이 쾌적하고 위생적인 환경에서 지낼 수 있도록 보금자리를 정비합니다.</p>
                            </div>
                        </div>
                        <div class="activity-card">
                            <img src="${pageContext.request.contextPath}/resources/images/main/main1.png"
                                alt="Fostering">
                            <div class="card-body">
                                <h3>임시 보호</h3>
                                <p>입양 가기 전 가정 환경 적응을 돕고, 아픈 아이들을 가정에서 케어합니다.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Call to Action -->
            <section class="cta">
                <div class="container">
                    <h2>지금 바로 시작하세요</h2>
                    <p>망설이는 순간에도 아이들은 당신을 기다리고 있습니다.</p>
                    <a href="${pageContext.request.contextPath}/user/signup.me" class="btn-main">회원가입 하고 함께하기</a>
                </div>
            </section>

            <!-- Simple Footer -->
            <footer class="footer-simple">
                <div class="container">
                    <p>&copy; 2024 UBIG (유봉일공). All rights reserved.</p>
                    <p>서울특별시 강남구 테헤란로 123 | Tel: 02-1234-5678</p>
                </div>
            </footer>

            <jsp:include page="/WEB-INF/views/common/chat.jsp" />

        </body>

        </html>