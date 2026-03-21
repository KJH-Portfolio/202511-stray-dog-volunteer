<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>봉사활동 모집 리스트</title>
                <!-- Google Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Outfit:wght@300;500;700&display=swap"
                    rel="stylesheet">

                <!-- Bootstrap 5 -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
                <style>
                    /* volunteer.jsp specific overrides if needed */
                    /* volunteer.jsp specific overrides if needed */
                    /* [User Request] 글자 잘림 방지 */
                    .page-title {
                        line-height: 1.4 !important;
                        padding-bottom: 10px;
                        overflow: visible;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="../common/menubar.jsp" />

                <main class="community-container">
                    <div class="page-header">
                        <div class="page-title">봉사활동 모집</div>
                        <p class="page-desc">따뜻한 손길이 필요한 곳을 찾아보세요.</p>
                    </div>

                    <div class="board-controls">
                        <!-- Search Area embedded in controls for this layout, or separate -->
                        <div class="search-area" style="margin-left: auto;"> <!-- Align right -->
                            <form action="volunteerList.vo" method="get" class="search-form">
                                <select name="condition" class="search-select">
                                    <option value="title" <c:if test="${condition eq 'title'}">selected</c:if>>제목
                                    </option>
                                    <option value="address" <c:if test="${condition eq 'address'}">selected</c:if>>지역
                                    </option>
                                </select>
                                <input type="text" name="keyword" value="${keyword}" placeholder="검색어를 입력하세요"
                                    class="search-input">
                                <button type="submit" class="btn-search">검색</button>
                            </form>
                        </div>
                    </div>

                    <div class="board-card">
                        <table class="board-table">
                            <thead>
                                <tr>
                                    <th width="10%">번호</th>
                                    <th width="40%">제목</th>
                                    <th width="15%">작성자</th>
                                    <th width="20%">활동 날짜</th>
                                    <th width="15%">지역</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty list}">
                                        <tr>
                                            <td colspan="5" class="empty-list">
                                                🍃 현재 모집 중인 봉사활동이 없습니다.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="vo" items="${list}">
                                            <tr>
                                                <td>${vo.actId}</td>
                                                <td class="board-title">
                                                    <a href="volunteerDetail.vo?actId=${vo.actId}">
                                                        ${vo.actTitle}
                                                    </a>
                                                </td>
                                                <td>${vo.adminId}</td>
                                                <td>
                                                    <fmt:formatDate value="${vo.actDate}" pattern="yyyy-MM-dd" />
                                                </td>
                                                <td>${vo.actAddress}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="pagination">
                        <c:if test="${not empty list}">

                            <c:choose>
                                <c:when test="${pi.currentPage eq 1}">
                                    <!-- Disabled prev -->
                                </c:when>
                                <c:otherwise>
                                    <a
                                        href="volunteerList.vo?cpage=${pi.currentPage - 1}&condition=${condition}&keyword=${keyword}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                                <c:choose>
                                    <c:when test="${p eq pi.currentPage}">
                                        <a href="#" class="active">${p}</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a
                                            href="volunteerList.vo?cpage=${p}&condition=${condition}&keyword=${keyword}">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${pi.currentPage eq pi.maxPage}">
                                    <!-- Disabled next -->
                                </c:when>
                                <c:otherwise>
                                    <a
                                        href="volunteerList.vo?cpage=${pi.currentPage + 1}&condition=${condition}&keyword=${keyword}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>

                    <div class="btn-area" style="text-align: right; margin-top: 20px;">
                        <c:if test="${loginMember.userRole eq 'ADMIN'}">
                            <a href="volunteerWriteForm.vo" class="btn-write">
                                + 새 활동 등록하기
                            </a>
                        </c:if>
                    </div>
                </main>

            </body>

            </html>