<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <title>유봉일공 - 커뮤니티</title>
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

                <!-- Custom Style -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=2">

                <style>
                    /* 커뮤니티 페이지 전용 스타일 */
                    body {
                        font-family: 'Noto Sans KR', sans-serif;
                        background-color: #f8f9fa;
                    }

                    .community-container {
                        padding: 100px 0;
                        width: 100%;
                        max-width: 1200px;
                        margin: 0 auto;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/WEB-INF/views/common/menubar.jsp" />

                <main class="community-container">

                    <div class="page-header">
                        <div class="page-title">커뮤니티</div>
                        <p class="page-desc">따뜻한 이야기를 나누고 소통하는 공간입니다.</p>
                    </div>

                    <!-- 탭 메뉴 -->
                    <div class="tab-menu">
                        <a href="?category=NOTICE" class="tab-item ${category == 'NOTICE' ? 'active' : ''}">공지사항</a>
                        <a href="?category=FREE" class="tab-item ${category == 'FREE' ? 'active' : ''}">자유게시판</a>
                        <a href="list?category=REQUEST"
                            class="tab-item ${category == 'REQUEST' ? 'active' : ''}">건의사항</a>
                        <a href="list?category=REVIEW" class="tab-item ${category == 'REVIEW' ? 'active' : ''}">봉사후기</a>
                        <a href="qna" class="tab-item ${category == 'QNA' ? 'active' : ''}">봉사활동 Q&A</a>
                    </div>

                    <!-- 컨트롤 영역 -->
                    <div class="board-controls">
                        <!-- 게시글 수 선택 -->
                        <select id="boardLimit" class="select-box" onchange="changeLimit(this.value)">
                            <option value="10" ${limit==10 ? 'selected' : '' }>10개씩 보기</option>
                            <option value="20" ${limit==20 ? 'selected' : '' }>20개씩 보기</option>
                            <option value="50" ${limit==50 ? 'selected' : '' }>50개씩 보기</option>
                        </select>

                        <!-- 글쓰기 버튼 -->
                        <c:if test="${!empty loginMember && (category != 'NOTICE' || loginMember.userRole == 'ADMIN')}">
                            <a href="write?category=${category}" class="btn-write">
                                <i class="fas fa-pen"></i> 글쓰기
                            </a>
                        </c:if>
                    </div>

                    <!-- [Step 19: 검색 영역 추가] -->
                    <div class="search-area">
                        <form action="list" method="get" class="search-form">
                            <input type="hidden" name="category" value="${category}">
                            <input type="hidden" name="limit" value="${limit}">
                            <select name="condition" class="search-select">
                                <option value="writer" ${condition=='writer' ? 'selected' : '' }>작성자</option>
                                <option value="content" ${condition=='content' ? 'selected' : '' }>내용</option>
                                <option value="titleContent" ${condition=='titleContent' ? 'selected' : '' }>제목+내용
                                </option>
                                <!-- 봉사후기 카테고리일 때만 태그 검색 옵션 노출 -->
                                <c:if test="${category == 'REVIEW'}">
                                    <option value="hashtag" ${condition=='hashtag' ? 'selected' : '' }>태그</option>
                                </c:if>
                            </select>
                            <input type="text" name="keyword" value="${keyword}" class="search-input"
                                placeholder="검색어를 입력하세요">
                            <button type="submit" class="btn-search">검색</button>
                        </form>
                    </div>

                    <!-- 게시판 테이블 -->
                    <div class="board-card">
                        <table class="board-table">
                            <colgroup>
                                <col width="8%">
                                <col width="55%">
                                <col width="12%">
                                <col width="15%">
                                <col width="10%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                    <th>조회수</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty list}">
                                        <tr>
                                            <td colspan="5" class="empty-list">
                                                <i class="far fa-folder-open"
                                                    style="font-size: 3em; margin-bottom: 10px; display: block;"></i>
                                                게시글이 없습니다.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="b" items="${list}">
                                            <!-- [Step 30] 고정 글은 row-pinned 클래스 추가 -->
                                            <tr
                                                class="${b.isPinned == 'Y' ? 'row-pinned' : (b.category == 'NOTICE' ? 'row-notice' : '')}">

                                                <!-- 번호: 고정글은 아이콘, 나머지는 번호 -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.isPinned == 'Y'}">
                                                            <i class="fas fa-bullhorn"
                                                                style="color:#e58e3c; font-size:1.2em;"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${b.boardId}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td class="board-title">
                                                    <a href="detail?boardId=${b.boardId}">
                                                        <!-- 공지 배지: 고정글이거나 공지사항 카테고리일 때 -->
                                                        <c:if test="${b.isPinned == 'Y' || b.category == 'NOTICE'}">
                                                            <span class="badge-notice">공지</span>
                                                        </c:if>
                                                        ${b.title}
                                                        <!-- 댓글 수 표시 (0보다 클 때만) -->
                                                        <c:if test="${b.commentCount > 0}">
                                                            <span
                                                                style="color: #ff9f43; font-weight: bold; margin-left: 5px;">(${b.commentCount})</span>
                                                        </c:if>
                                                    </a>
                                                    <!-- [Step 14: 태그 표시 (봉사후기 전용)] -->
                                                    <c:if test="${b.category == 'REVIEW' && not empty b.hashtags}">
                                                        <div class="board-tags">
                                                            <c:forTokens var="tag" items="${b.hashtags}" delims=",">
                                                                <span class="badge-tag">#${tag}</span>
                                                            </c:forTokens>
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td>${b.userId}</td>
                                                <td>
                                                    <fmt:formatDate value="${b.createDate}" pattern="yyyy.MM.dd" />
                                                </td>
                                                <td style="white-space: nowrap;">
                                                    <i class="fas fa-eye" style="margin-right: 3px; color: #aaa;"></i>
                                                    ${b.viewCount}
                                                    <span style="margin: 0 5px; color: #ddd;">|</span>
                                                    <i class="fas fa-heart"
                                                        style="margin-right: 3px; color: #ff6b6b;"></i> ${b.likeCount}
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- 페이징 바 -->
                    <div class="pagination">
                        <!-- 이전 페이지 -->
                        <c:if test="${pi.currentPage > 1}">
                            <a
                                href="list?category=${category}&cpage=${pi.currentPage - 1}&limit=${limit}&condition=${condition}&keyword=${keyword}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </c:if>

                        <!-- 페이지 번호 -->
                        <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                            <c:choose>
                                <c:when test="${p == pi.currentPage}">
                                    <a href="#" class="active">${p}</a>
                                </c:when>
                                <c:otherwise>
                                    <a
                                        href="list?category=${category}&cpage=${p}&limit=${limit}&condition=${condition}&keyword=${keyword}">${p}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- 다음 페이지 -->
                        <c:if test="${pi.currentPage < pi.maxPage}">
                            <a
                                href="list?category=${category}&cpage=${pi.currentPage + 1}&limit=${limit}&condition=${condition}&keyword=${keyword}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>

                </main>

                <script>
                    function changeLimit(limit) {
                        var url = "list?category=${category}&cpage=1&limit=" + limit;
                        var condition = "${condition}";
                        var keyword = "${keyword}";
                        if (condition && keyword) {
                            url += "&condition=" + condition + "&keyword=" + keyword;
                        }
                        location.href = url;
                    }
                </script>
            </body>

            </html>