<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <% pageContext.setAttribute("newLine", "\n" ); %>


                    <!DOCTYPE html>
                    <html lang="ko">

                    <head>
                        <meta charset="UTF-8">
                        <title>유봉일공 - 게시글 상세</title>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
                        <!-- Google Fonts & Icons -->
                        <link
                            href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

                        <style>
                            body {
                                font-family: 'Noto Sans KR', sans-serif;
                                background-color: #f8f9fa;
                            }

                            .community-container {
                                padding: 100px 0;
                                width: 100%;
                                max-width: 900px;
                                /* 상세페이지는 가독성을 위해 너비를 약간 줄임 */
                                margin: 0 auto;
                            }

                            /* 게시글 카드 스타일 */
                            .board-card {
                                background: white;
                                border-radius: 15px;
                                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
                                padding: 40px;
                                margin-bottom: 30px;
                            }

                            .detail-header {
                                border-bottom: 1px solid #eee;
                                padding-bottom: 20px;
                                margin-bottom: 30px;
                            }

                            .detail-title {
                                font-size: 2em;
                                font-weight: 700;
                                color: #2c3e50;
                                margin-bottom: 15px;
                                line-height: 1.3;
                            }

                            .detail-meta {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                color: #7f8c8d;
                                font-size: 0.95em;
                            }

                            .meta-left {
                                display: flex;
                                gap: 15px;
                                align-items: center;
                            }

                            .meta-item i {
                                margin-right: 5px;
                                color: #bdc3c7;
                            }

                            .detail-content {
                                min-height: 300px;
                                line-height: 1.8;
                                color: #34495e;
                                font-size: 1.05em;
                                margin-bottom: 40px;
                            }

                            .detail-content img {
                                max-width: 100%;
                                height: auto;
                                border-radius: 10px;
                                margin: 10px 0;
                            }

                            /* 첨부파일 영역 */
                            .attachment-area {
                                background-color: #f1f2f6;
                                padding: 15px 20px;
                                border-radius: 10px;
                                margin-bottom: 30px;
                                font-size: 0.9em;
                                display: flex;
                                align-items: center;
                                gap: 10px;
                            }

                            .attachment-area a {
                                color: #333;
                                text-decoration: none;
                                font-weight: 500;
                            }

                            .attachment-area a:hover {
                                text-decoration: underline;
                            }

                            /* 좋아요 & 버튼 그룹 */
                            .action-area {
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                margin-top: 50px;
                                padding-top: 30px;
                                border-top: 1px solid #eee;
                            }

                            .btn-like {
                                background-color: white;
                                border: 2px solid #ff5e57;
                                color: #ff5e57;
                                padding: 8px 15px;
                                border-radius: 30px;
                                cursor: pointer;
                                font-weight: 600;
                                transition: all 0.2s;
                                display: flex;
                                align-items: center;
                                gap: 5px;
                                font-size: 1rem;
                            }

                            .btn-like:hover,
                            .btn-like.active {
                                background-color: #ff5e57;
                                color: white;
                                box-shadow: 0 4px 10px rgba(255, 94, 87, 0.3);
                            }

                            .btn-group {
                                display: flex;
                                gap: 10px;
                            }

                            .btn-action {
                                padding: 10px 20px;
                                border-radius: 8px;
                                font-weight: 500;
                                text-decoration: none;
                                font-size: 0.9em;
                                transition: all 0.2s;
                            }

                            .btn-list {
                                background-color: #34495e;
                                color: white;
                            }

                            .btn-list:hover {
                                background-color: #2c3e50;
                            }

                            .btn-edit {
                                background-color: #f1f2f6;
                                color: #333;
                            }

                            .btn-edit:hover {
                                background-color: #e2e6ea;
                            }

                            .btn-delete {
                                background-color: #fff0f0;
                                color: #e74c3c;
                            }

                            .btn-delete:hover {
                                background-color: #ffe6e6;
                            }


                            /* 댓글 스타일 */
                            .comment-section {
                                background: white;
                                border-radius: 15px;
                                padding: 20px;
                                /* 30px -> 20px */
                                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
                            }

                            .comment-header {
                                font-size: 1.2em;
                                font-weight: 700;
                                color: #2c3e50;
                                margin-bottom: 15px;
                                /* 20px -> 15px */
                                padding-bottom: 10px;
                                border-bottom: 1px solid #f1f2f6;
                                /* 2px -> 1px */
                            }

                            .comment-list {
                                list-style: none;
                                padding: 0;
                                margin: 0;
                            }

                            .comment-item {
                                padding: 12px 0;
                                /* 20px -> 12px */
                                border-bottom: 1px solid #f8f9fa;
                            }

                            .comment-item:last-child {
                                border-bottom: none;
                            }

                            .comment-meta {
                                display: flex;
                                justify-content: space-between;
                                margin-bottom: 0px;
                                /* Reduced to 0 for tight spacing */
                                font-size: 0.9em;
                            }

                            .comment-writer {
                                font-weight: 600;
                                color: #333;
                            }

                            .comment-date {
                                color: #999;
                                font-size: 0.9em;
                            }

                            .comment-content {
                                color: #555;
                                line-height: 1.5;
                                /* white-space: pre-line; removed to fix indentation issue */
                            }

                            .comment-actions {
                                margin-top: 6px;
                                /* 10px -> 6px */
                                font-size: 0.85em;
                                display: flex;
                                gap: 10px;
                                color: #888;
                            }

                            .comment-actions span,
                            .comment-actions a {
                                cursor: pointer;
                                transition: color 0.2s;
                                text-decoration: none;
                                color: inherit;
                            }

                            .comment-actions span:hover,
                            .comment-actions a:hover {
                                color: #333;
                            }

                            .comment-like-btn i {
                                color: #ff5e57;
                            }

                            /* 대댓글 들여쓰기 시각적 효과 */
                            .reply-item {
                                background-color: #fafbfc;
                                padding: 12px 15px 12px 25px;
                                /* Reduced vertical padding */
                                /* 왼쪽 여백 추가 */
                                margin-top: 5px;
                                border-radius: 8px;
                            }

                            /* 댓글 입력 폼 */
                            .comment-form-container {
                                margin-top: 30px;
                                background-color: #f8f9fa;
                                padding: 20px;
                                border-radius: 10px;
                            }

                            .comment-textarea {
                                width: 100%;
                                height: 80px;
                                padding: 15px;
                                border: 1px solid #ddd;
                                border-radius: 8px;
                                resize: none;
                                margin-bottom: 10px;
                                font-family: inherit;
                            }

                            .comment-textarea:focus {
                                outline: none;
                                border-color: #ff9f43;
                            }

                            .btn-submit {
                                background-color: #333;
                                color: white;
                                border: none;
                                padding: 8px 20px;
                                border-radius: 5px;
                                cursor: pointer;
                                font-weight: 500;
                            }

                            .login-plz {
                                text-align: center;
                                padding: 30px;
                                color: #7f8c8d;
                            }

                            .login-link {
                                color: #ff9f43;
                                font-weight: bold;
                                text-decoration: none;
                            }
                        </style>
                    </head>

                    <body>

                        <jsp:include page="/WEB-INF/views/common/menubar.jsp" />

                        <main class="community-container">

                            <!-- 게시글 상세 카드 -->
                            <article class="board-card">
                                <!-- 헤더 -->
                                <div class="detail-header">
                                    <div class="detail-title">${board.title}</div>
                                    <div class="detail-meta">
                                        <div class="meta-left">
                                            <span class="meta-item"><i class="fas fa-user"></i> ${board.userId}</span>
                                            <span class="meta-item"><i class="far fa-clock"></i>
                                                <fmt:formatDate value="${board.createDate}"
                                                    pattern="yyyy.MM.dd HH:mm" />
                                            </span>
                                        </div>
                                        <span class="meta-item"><i class="far fa-eye"></i> ${board.viewCount}</span>
                                    </div>
                                </div>

                                <!-- 첨부파일 -->
                                <c:if test="${not empty attachment}">
                                    <div class="attachment-area">
                                        <i class="fas fa-paperclip" style="color: #666;"></i>
                                        <a
                                            href="${pageContext.request.contextPath}/community/fileDownload?originalName=${attachment.originalName}&savedName=${attachment.savedName}&path=${attachment.filePath}">
                                            ${attachment.originalName}
                                        </a>
                                    </div>
                                </c:if>

                                <!-- 본문 -->
                                <div class="detail-content">
                                    ${board.content} <!-- Summernote 등 에디터 내용이 그대로 출력됨 -->
                                </div>

                                <!-- 하단 액션 (좋아요 / 삭제 / 목록 등) -->
                                <div class="action-area">
                                    <!-- 좋아요 버튼 -->
                                    <button id="like-btn" class="btn-like">
                                        <i id="heart-icon" class="far fa-heart"></i>
                                        <span id="like-count">0</span>
                                    </button>

                                    <!-- 버튼 그룹 -->
                                    <div class="btn-group">
                                        <a href="list?category=${board.category}" class="btn-action btn-list">
                                            <i class="fas fa-list"></i> 목록
                                        </a>

                                        <c:if
                                            test="${loginMember.userId == board.userId || loginMember.userRole == 'ADMIN'}">
                                            <a href="update?boardId=${board.boardId}" class="btn-action btn-edit">수정</a>
                                            <a href="delete?boardId=${board.boardId}" class="btn-action btn-delete"
                                                onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                                        </c:if>
                                    </div>
                                </div>
                            </article>

                            <!-- 댓글 섹션 -->
                            <section class="comment-section">
                                <div class="comment-header">댓글 <span
                                        style="font-weight: 400; font-size: 0.9em; color:#777;">(소통해요)</span></div>

                                <ul id="comment-list" class="comment-list">
                                    <c:choose>
                                        <c:when test="${empty commentList}">
                                            <li style="padding: 30px 0; text-align: center; color: #999;">첫 번째 댓글을
                                                남겨보세요! ✨
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="c" items="${commentList}">
                                                <!-- level에 따른 클래스 부여 (대댓글 구분) -->
                                                <li class="comment-item ${c.level > 1 ? 'reply-item' : ''}"
                                                    style="${c.level > 1 ? 'margin-left:' += (c.level-1)*20 += 'px;' : ''}">
                                                    <!-- 단순 인라인 스타일로 깊이 표현 보조 -->

                                                    <c:if test="${c.isDeleted == 'Y'}">
                                                        <div style="color: #bbb; font-style: italic;">
                                                            <i class="fas fa-exclamation-circle"></i> 삭제된 댓글입니다.
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${c.isDeleted == 'N'}">
                                                        <div class="comment-meta">
                                                            <span class="comment-writer">
                                                                <c:if test="${c.level > 1}"><i
                                                                        class="fas fa-reply fa-rotate-180"
                                                                        style="color:#bdc3c7; margin-right:5px;"></i>
                                                                </c:if>
                                                                ${c.userId}
                                                            </span>
                                                            <span class="comment-date">
                                                                <fmt:formatDate value="${c.createDate}"
                                                                    pattern="yyyy.MM.dd HH:mm" />
                                                            </span>
                                                        </div>

                                                        <div id="comment-content-${c.commentId}"
                                                            class="comment-content">
                                                            ${fn:replace(fn:escapeXml(c.content), newLine, '<br>')}<c:if
                                                                test="${not empty c.attachment}">
                                                                <div style="margin-top: 5px; font-size: 0.85em;"><i
                                                                        class="fas fa-paperclip"></i> <a
                                                                        href="${pageContext.request.contextPath}/community/fileDownload?originalName=${c.attachment.originalName}&savedName=${c.attachment.savedName}&path=${c.attachment.filePath}"
                                                                        style="color: #666;">${c.attachment.originalName}</a>
                                                                </div>
                                                            </c:if>
                                                        </div>

                                                        <!-- 댓글 액션 (좋아요/답글/수정/삭제) -->
                                                        <div class="comment-actions">
                                                            <span class="comment-like-btn"
                                                                data-comment-id="${c.commentId}">
                                                                <i class="${c.liked ? 'fas' : 'far'} fa-heart"></i>
                                                                <span class="like-count">${c.likeCount}</span>
                                                            </span>

                                                            <c:if test="${not empty loginMember}">
                                                                | <span
                                                                    onclick="toggleReplyForm('${c.commentId}')">답글</span>
                                                            </c:if>

                                                            <c:if
                                                                test="${loginMember.userId == c.userId || loginMember.userRole == 'ADMIN'}">
                                                                | <span
                                                                    onclick="toggleEditForm('${c.commentId}')">수정</span>
                                                                | <a href="deleteComment?commentId=${c.commentId}&boardId=${board.boardId}"
                                                                    onclick="return confirm('댓글을 삭제하시겠습니까?')"
                                                                    style="color:#e74c3c;">삭제</a>
                                                            </c:if>
                                                        </div>

                                                        <!-- 수정 폼 (Hidden) -->
                                                        <div id="comment-edit-${c.commentId}"
                                                            style="display: none; margin-top: 15px;">
                                                            <form action="updateComment" method="post">
                                                                <input type="hidden" name="boardId"
                                                                    value="${board.boardId}">
                                                                <input type="hidden" name="commentId"
                                                                    value="${c.commentId}">
                                                                <textarea name="content" class="comment-textarea"
                                                                    required>${c.content}</textarea>
                                                                <div style="text-align: right;">
                                                                    <button type="button" class="btn-submit"
                                                                        style="background: #fff; border: 1px solid #ddd; color: #333;"
                                                                        onclick="toggleEditForm('${c.commentId}')">취소</button>
                                                                    <button type="submit" class="btn-submit">수정
                                                                        완료</button>
                                                                </div>
                                                            </form>
                                                        </div>

                                                        <!-- 대댓글 작성 폼 (Hidden) -->
                                                        <div id="comment-reply-${c.commentId}"
                                                            style="display: none; margin-top: 15px; background: #fafbfc; padding: 15px; border-radius: 8px;">
                                                            <form action="insertComment" method="post">
                                                                <input type="hidden" name="boardId"
                                                                    value="${board.boardId}">
                                                                <input type="hidden" name="parentId"
                                                                    value="${c.commentId}">
                                                                <div
                                                                    style="font-size: 0.9em; margin-bottom: 5px; color:#555;">
                                                                    To: ${c.userId}</div>
                                                                <textarea name="content" class="comment-textarea"
                                                                    style="height: 60px;" required></textarea>
                                                                <div style="text-align: right;">
                                                                    <button type="button" class="btn-submit"
                                                                        style="background: #fff; border: 1px solid #ddd; color: #333;"
                                                                        onclick="toggleReplyForm('${c.commentId}')">취소</button>
                                                                    <button type="submit" class="btn-submit">답글
                                                                        등록</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </c:if> <!-- Deleted Check End -->
                                                </li>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>

                                <!-- 최하단 댓글 작성 폼 -->
                                <div class="comment-form-container">
                                    <c:choose>
                                        <c:when test="${not empty loginMember}">
                                            <form action="insertComment" method="post" enctype="multipart/form-data">
                                                <input type="hidden" name="boardId" value="${board.boardId}">
                                                <div style="font-weight: 600; margin-bottom: 10px; color: #333;">
                                                    ${loginMember.userId}님</div>
                                                <textarea name="content" class="comment-textarea"
                                                    placeholder="따뜻한 댓글을 남겨주세요." required></textarea>
                                                <div
                                                    style="display: flex; justify-content: space-between; align-items: center;">
                                                    <input type="file" name="upfile" style="font-size: 0.85em;">
                                                    <button type="submit" class="btn-submit">댓글 등록</button>
                                                </div>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="login-plz">
                                                <a href="${pageContext.request.contextPath}/user/login.me"
                                                    class="login-link">로그인</a>을 하시면 댓글을 작성할 수 있습니다.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </section>

                        </main>

                        <!-- Script는 그대로 유지하되, UI 로직과 연동 확인 -->
                        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
                        <script>
                            function toggleEditForm(commentId) {
                                var contentDiv = document.getElementById('comment-content-' + commentId);
                                var editDiv = document.getElementById('comment-edit-' + commentId);

                                if (editDiv.style.display === 'none') {
                                    editDiv.style.display = 'block';
                                    contentDiv.style.display = 'none';
                                } else {
                                    editDiv.style.display = 'none';
                                    contentDiv.style.display = 'block';
                                }
                            }
                            function toggleReplyForm(commentId) {
                                var replyDiv = document.getElementById('comment-reply-' + commentId);
                                if (replyDiv.style.display === 'none') {
                                    replyDiv.style.display = 'block';
                                } else {
                                    replyDiv.style.display = 'none';
                                }
                            }

                            $(document).ready(function () {
                                // 좋아요 기능 (기존 로직 유지, UI 클래스 매핑만 주의)
                                $(document).on("click", "#like-btn", function () {
                                    var boardId = "${board.boardId}";
                                    $.ajax({
                                        url: "${pageContext.request.contextPath}/community/heart",
                                        type: "GET",
                                        data: { boardId: boardId },
                                        dataType: "json",
                                        cache: false,
                                        success: function (data) {
                                            if (data.result === "login_required") {
                                                alert("로그인이 필요합니다.");
                                                location.href = "${pageContext.request.contextPath}/user/login.me";
                                                return;
                                            }

                                            if (data.isLiked) {
                                                $("#heart-icon").removeClass("far").addClass("fas");
                                                $("#like-btn").addClass("active"); // 스타일 효과
                                            } else {
                                                $("#heart-icon").removeClass("fas").addClass("far");
                                                $("#like-btn").removeClass("active");
                                            }
                                            $("#like-count").text(data.count);
                                        },
                                        error: function (xhr, status, error) { console.log("Error", error); }
                                    });
                                });

                                // 댓글 좋아요
                                $(document).on("click", ".comment-like-btn", function () {
                                    var btn = $(this);
                                    var commentId = btn.data("comment-id");
                                    $.ajax({
                                        url: "${pageContext.request.contextPath}/community/comment/heart",
                                        type: "GET",
                                        data: { commentId: commentId },
                                        dataType: "json",
                                        cache: false,
                                        success: function (data) {
                                            if (data.result === "login_required") {
                                                alert("로그인이 필요합니다.");
                                                location.href = "${pageContext.request.contextPath}/user/login.me";
                                                return;
                                            }
                                            var icon = btn.find("i");
                                            var countSpan = btn.find(".like-count");

                                            if (data.isLiked) {
                                                icon.removeClass("far").addClass("fas");
                                            } else {
                                                icon.removeClass("fas").addClass("far");
                                            }
                                            countSpan.text(data.count);
                                        },
                                        error: function (xhr, status, error) { console.log("Error", error); }
                                    });
                                });

                                // 초기 좋아요 상태
                                var isLiked = "${isLiked}";
                                var likeCount = "${likeCount}";

                                if (isLiked === "true") {
                                    $("#heart-icon").removeClass("far").addClass("fas");
                                    $("#like-btn").addClass("active");
                                } else {
                                    $("#heart-icon").removeClass("fas").addClass("far");
                                }

                                if (!likeCount) likeCount = 0;
                                $("#like-count").text(likeCount);
                            });
                        </script>
                    </body>

                    </html>