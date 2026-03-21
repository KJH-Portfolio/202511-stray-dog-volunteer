<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>유봉일공 - 로그인</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
            <style>
                body {
                    background-color: var(--body-bg);
                    height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .login-card {
                    width: 100%;
                    max-width: 400px;
                    border: none;
                    box-shadow: var(--shadow-md);
                    border-radius: var(--border-radius-lg);
                }

                .login-header {
                    background-color: var(--primary-color);
                    color: var(--white);
                    text-align: center;
                    padding: 20px;
                    border-top-left-radius: var(--border-radius-lg);
                    border-top-right-radius: var(--border-radius-lg);
                    font-weight: 700;
                    font-size: 1.5rem;
                }

                .btn-custom {
                    background-color: var(--primary-color);
                    border-color: var(--primary-color);
                    color: var(--white);
                    font-weight: 700;
                    transition: all 0.3s;
                }

                .btn-custom:hover {
                    background-color: var(--primary-hover);
                    border-color: var(--primary-hover);
                    color: var(--white);
                }

                /* Link color fix */
                a.text-decoration-none {
                    color: var(--primary-color) !important;
                }
            </style>


        </head>

        <body>
            <jsp:include page="/WEB-INF/views/common/menubar.jsp" />
            <div class="card login-card">
                <div class="login-header">
                    유봉일공 LOGIN
                </div>
                <div class="card-body p-4">

                    <c:if test="${not empty msg}">
                        <div class="alert alert-danger text-center" role="alert">
                            ${msg}
                        </div>
                        <c:remove var="msg" />
                    </c:if>

                    <form action="${pageContext.request.contextPath}/user/login.me" method="post">

                        <div class="mb-3">
                            <label for="userId" class="form-label">아이디</label>
                            <input type="text" class="form-control" id="userId" name="userId" placeholder="아이디를 입력하세요"
                                required autofocus>
                        </div>

                        <div class="mb-3">
                            <label for="userPwd" class="form-label">비밀번호</label>
                            <input type="password" class="form-control" id="userPwd" name="userPwd"
                                placeholder="비밀번호를 입력하세요" required>
                        </div>


                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-custom btn-lg">로그인</button>
                        </div>

                        <div class="mt-4 text-center">
                            <span class="text-secondary">아직 회원이 아니신가요?</span>
                            <a href="${pageContext.request.contextPath}/user/signup.me"
                                class="text-decoration-none fw-bold ms-2">회원가입</a>
                        </div>
                        <!--                 <div class="mt-2 text-center"> -->
                        <!--                      <a href="/member/findInfo" class="text-decoration-none text-secondary small">아이디 / 비밀번호 찾기</a> -->
                        <!--                 </div> -->

                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>