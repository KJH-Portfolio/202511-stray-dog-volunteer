<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <header>
            <style>
                /* [Emergency Fix] 드롭다운 정렬 강제 적용 (CSS 캐시 문제 방지용) */
                .dropdown-content {
                    left: 50% !important;
                    transform: translateX(-50%) !important;
                    text-align: center !important;
                    margin-top: 10px !important;
                    margin: 0;
                    padding: 10px 0 !important;
                    overflow: visible !important;
                    /* [Critical Fix] 브릿지가 잘리지 않도록 오버플로우 해제 */
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        margin-top: 20px;
                        transform: translateX(-50%);
                    }

                    to {
                        opacity: 1;
                        margin-top: 10px;
                        transform: translateX(-50%);
                    }
                }

                .dropdown:hover .dropdown-content {
                    animation: fadeIn 0.3s ease-in-out !important;
                }

                /* [Bridge Fix] 드롭다운과 메뉴 사이의 간격을 메워주는 투명한 다리 */
                .dropdown-content::before {
                    content: '';
                    position: absolute;
                    top: -30px;
                    /* 더 넓게 잡음 */
                    left: 0;
                    width: 100%;
                    height: 30px;
                    /* 높이도 키움 */
                    background: transparent;
                }
            </style>
            <c:if test="${not empty alertMsg}">
                <script>
                    alert('${alertMsg}');
                </script>
                <c:remove var="alertMsg" />
            </c:if>
            <!-- adoption 알람 메시지 처리-->
            <c:if test="${not empty sessionScope.alertMsgAd}">
                <script>
                    alert("${sessionScope.alertMsgAd}");
                </script>
                <c:remove var="alertMsgAd" scope="session" />
            </c:if>
            <nav>
                <div class="logo">
                    <a href="${pageContext.request.contextPath}/">유봉일공</a>
                </div>
                <ul class="nav-links">
                    <li class="dropdown">
                        <a href="#">봉사활동</a>
                        <ul class="dropdown-content">
                            <li><a href="${pageContext.request.contextPath}/volunteerList.vo">봉사 프로그램</a></li>
                            <li><a href="${pageContext.request.contextPath}/reviewList.vo">봉사 후기</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a href="${pageContext.request.contextPath}/adoption.mainpage">입양</a>
                    </li>
                    <li class="dropdown">
                        <a href="#">커뮤니티</a>
                        <ul class="dropdown-content">
                            <li><a href="${pageContext.request.contextPath}/community/list?category=NOTICE">공지사항</a>
                            </li>
                            <li><a href="${pageContext.request.contextPath}/community/list?category=FREE">자유게시판</a></li>
                            <li><a href="${pageContext.request.contextPath}/community/list?category=REQUEST">건의사항</a>
                            </li>
                            <li><a href="${pageContext.request.contextPath}/community/list?category=REVIEW">봉사후기</a>
                            </li>
                            <li><a href="${pageContext.request.contextPath}/community/qna">봉사활동 Q&A</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a href="#">후원</a>
                        <ul class="dropdown-content">
                            <li><a href="${pageContext.request.contextPath}/funding">펀딩 목록</a></li>
                            <li><a href="${pageContext.request.contextPath}/donation">후원하기</a></li>
                        </ul>
                    </li>
                    <!-- 유저 관련 메뉴: 로그인 상태에 따라 다르게 보여주면 좋음 -->
                    <li class="dropdown">
                        <a href="#">회원</a>
                        <ul class="dropdown-content">
                            <c:choose>
                                <c:when test="${empty loginMember}">
                                    <li><a href="${pageContext.request.contextPath}/user/login.me">로그인</a></li>
                                    <li><a href="${pageContext.request.contextPath}/user/signup.me">회원가입</a></li>
                                </c:when>
                                <c:otherwise>
                                    <li><a href="#">${loginMember.userNickname}님</a></li>
                                    <li><a href="${pageContext.request.contextPath}/user/mypage.me">마이페이지</a></li>
                                    <li><a href="${pageContext.request.contextPath}/message/inbox.ms">쪽지함</a></li>
                                    <li>
                                        <form id="logoutForm" action="${pageContext.request.contextPath}/user/logout.me"
                                            method="post">
                                            <a href="javascript:void(0);"
                                                onclick="document.getElementById('logoutForm').submit();">로그아웃</a>
                                        </form>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </li>
                </ul>
            </nav>
            <!-- logout이 post 방식이기 때문에 a href로 보내면 로그아웃 처리가 안 된다. 이 부분을 추후에 수정해야 한다. -->
        </header>