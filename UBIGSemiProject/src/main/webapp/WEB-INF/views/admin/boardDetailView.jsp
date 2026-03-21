<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <title>유봉일공 - 게시글 상세</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
                <style>
                    .community-container {
                        padding: 120px 0 50px 0;
                        width: 800px;
                        margin: 0 auto;
                    }

                    .board-detail {
                        border-top: 2px solid #333;
                        border-bottom: 1px solid #ddd;
                    }

                    .detail-header {
                        background-color: #f9f9f9;
                        padding: 20px;
                        border-bottom: 1px solid #eee;
                    }

                    .detail-title {
                        font-size: 1.5em;
                        font-weight: bold;
                        color: #333;
                        margin-bottom: 10px;
                    }

                    .detail-info {
                        color: #666;
                        font-size: 0.9em;
                        display: flex;
                        justify-content: space-between;
                    }

                    .detail-content {
                        padding: 40px 20px;
                        min-height: 300px;
                        line-height: 1.6;
                        color: #333;
                    }

                    /* 이미지 첨부 시 화면 밖으로 나가는 현상 방지 */
                    .detail-content img {
                        max-width: 100%;
                        height: auto;
                    }

                    .btn-group {
                        margin-top: 20px;
                        text-align: center;
                    }

                    .btn {
                        padding: 10px 25px;
                        border: 1px solid #ddd;
                        background: #fff;
                        cursor: pointer;
                        text-decoration: none;
                        color: #333;
                        display: inline-block;
                    }

                    .btn:hover {
                        background: #f1f1f1;
                    }

                    .btn-primary {
                        background: #ff9f43;
                        color: white;
                        border-color: #ff9f43;
                    }

                    .btn-primary:hover {
                        background: #e58e3c;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/WEB-INF/views/common/menubar.jsp" />

                <main class="community-container">

                    <div class="board-detail">
                        <div class="detail-header">
                            <div class="detail-title">${board.title}</div>
                            <div class="detail-info">
                                <span>작성자: ${board.userId}</span>
                                <span>
                                    작성일:
                                    <fmt:formatDate value="${board.createDate}" pattern="yyyy.MM.dd HH:mm" /> |
                                    조회수: ${board.viewCount}

                                    <!-- 게시글 좋아요 (조회수 옆에 배치) -->
                                    <span id="like-btn" style="cursor: pointer; color: #ff5e57; margin-left: 10px;">
                                        <i id="heart-icon" class="far fa-heart"></i>
                                        <span id="like-count">0</span>
                                    </span>
                                </span>
                            </div>
                        </div>

                        <div class="detail-content">
                            <!-- 줄바꿈 처리를 위해 pre 태그나 CSS white-space를 사용할 수도 있지만,
                     여기서는 간단히 내용만 출력합니다. 실제로는 <br> 변환 등이 필요할 수 있습니다. -->
                            ${board.content}
                        </div>
                    </div>

                    <!-- jQuery (Summernote를 위해 필수) -->
                    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

                    <!-- Font Awesome (아이콘) -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

                    <!-- Summernote CSS/JS -->
                    <!-- [Step 21: 댓글 영역] -->
                    <div class="comment-container"
                        style="margin-top: 30px; border-top: 2px solid #ddd; padding-top: 20px;">
                        <h3>댓글</h3>

                        <!-- 댓글 리스트 -->
                        <ul id="comment-list" class="comment-list" style="list-style: none; padding: 0;">
                            <c:choose>
                                <c:when test="${empty commentList}">
                                    <li style="padding: 10px 0; color: #666;">등록된 댓글이 없습니다.</li>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="c" items="${commentList}">
                                        <!-- level-1 만큼 들여쓰기 (대댓글) -->
                                        <li
                                            style="border-bottom: 1px solid #eee; padding: 10px 0; margin-left: ${(c.level - 1) * 40}px;">

                                            <!-- 삭제된 댓글인 경우 -->
                                            <c:if test="${c.isDeleted == 'Y'}">
                                                <div style="color: #999; padding: 10px;">
                                                    [삭제] 삭제된 댓글입니다.
                                                </div>
                                            </c:if>

                                            <!-- 삭제되지 않은 정상 댓글인 경우 -->
                                            <c:if test="${c.isDeleted == 'N'}">
                                                <div
                                                    style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                                                    <div>
                                                        <c:if test="${c.level > 1}">
                                                            <span style="color: #aaa; margin-right: 5px;">↳</span>
                                                        </c:if>
                                                        <strong>${c.userId}</strong>
                                                    </div>
                                                    <span style="font-size: 0.8em; color: #888;">
                                                        <fmt:formatDate value="${c.createDate}"
                                                            pattern="yyyy.MM.dd HH:mm" />

                                                        <!-- 댓글 좋아요 -->
                                                        <span class="comment-like-btn" data-comment-id="${c.commentId}"
                                                            style="cursor: pointer; margin-left: 5px; color: #ff5e57;">
                                                            <i class="${c.liked ? 'fas' : 'far'} fa-heart"></i>
                                                            <span class="like-count">${c.likeCount}</span>
                                                        </span>

                                                        <!-- 답글달기 (로그인한 경우) -->
                                                        <c:if test="${not empty loginUser}">
                                                            | <a href="javascript:void(0)"
                                                                onclick="toggleReplyForm('${c.commentId}')"
                                                                style="cursor: pointer;">답글</a>
                                                        </c:if>

                                                        <!-- 수정/삭제 (본인 또는 관리자) -->
                                                        <c:if
                                                            test="${loginUser.userId == c.userId || loginUser.userRole == 'ADMIN'}">
                                                            | <a href="javascript:void(0)"
                                                                onclick="toggleEditForm('${c.commentId}')"
                                                                style="cursor: pointer;">수정</a>
                                                            | <a href="deleteComment?commentId=${c.commentId}&boardId=${board.boardId}"
                                                                onclick="return confirm('댓글을 삭제하시겠습니까?')"
                                                                style="color: red; cursor: pointer;">삭제</a>
                                                        </c:if>
                                                    </span>
                                                </div>

                                                <!-- 댓글 내용 -->
                                                <div id="comment-content-${c.commentId}">
                                                    ${c.content}
                                                </div>

                                                <!-- 댓글 수정 폼 (숨김) -->
                                                <div id="comment-edit-${c.commentId}"
                                                    style="display: none; margin-top: 10px;">
                                                    <form action="updateComment" method="post">
                                                        <input type="hidden" name="boardId" value="${board.boardId}">
                                                        <input type="hidden" name="commentId" value="${c.commentId}">
                                                        <div style="display: flex;">
                                                            <textarea name="content"
                                                                style="flex: 1; height: 60px; padding: 10px; border: 1px solid #ddd; resize: none; margin-right: 10px;"
                                                                required>${c.content}</textarea>
                                                            <button type="submit" class="btn"
                                                                style="background: #333; color: white; border: none; cursor: pointer;">수정</button>
                                                            <button type="button" class="btn"
                                                                onclick="toggleEditForm('${c.commentId}')"
                                                                style="background: #fff; border: 1px solid #ddd; margin-left: 5px; cursor: pointer;">취소</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </c:if>

                                            <!-- 대댓글 작성 폼 (숨김) -->
                                            <div id="comment-reply-${c.commentId}"
                                                style="display: none; margin-top: 10px; padding: 10px; background: #eee;">
                                                <form action="insertComment" method="post">
                                                    <input type="hidden" name="boardId" value="${board.boardId}">
                                                    <input type="hidden" name="parentId" value="${c.commentId}">
                                                    <div style="font-size: 0.9em; margin-bottom: 5px;">${c.userId}님에게 답글
                                                        작성</div>
                                                    <div style="display: flex;">
                                                        <textarea name="content"
                                                            style="flex: 1; height: 60px; padding: 10px; border: 1px solid #ddd; resize: none; margin-right: 10px;"
                                                            required></textarea>
                                                        <button type="submit" class="btn"
                                                            style="background: #555; color: white; border: none; cursor: pointer;">등록</button>
                                                        <button type="button" class="btn"
                                                            onclick="toggleReplyForm('${c.commentId}')"
                                                            style="background: #fff; border: 1px solid #ddd; margin-left: 5px; cursor: pointer;">취소</button>
                                                    </div>
                                                </form>
                                            </div>

                                        </li>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </ul>

                        <!-- 원글 댓글 작성 폼 (맨 아래) -->
                        <div class="comment-form"
                            style="margin-top: 20px; background: #f9f9f9; padding: 15px; border-radius: 5px;">
                            <c:choose>
                                <c:when test="${not empty loginUser}">
                                    <form action="insertComment" method="post">
                                        <input type="hidden" name="boardId" value="${board.boardId}">
                                        <!-- parentId 없음 (null) -->
                                        <div style="display: flex;">
                                            <textarea name="content" placeholder="댓글을 남겨보세요"
                                                style="flex: 1; height: 60px; padding: 10px; border: 1px solid #ddd; resize: none; margin-right: 10px;"
                                                required></textarea>
                                            <button type="submit" class="btn"
                                                style="background: #333; color: white; border: none; cursor: pointer;">등록</button>
                                        </div>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align: center; color: #666;">
                                        <a href="${pageContext.request.contextPath}/member/login"
                                            style="color: #ff9f43; font-weight: bold;">로그인</a> 후 이용 가능합니다.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="btn-group">
                        <!-- 목록으로 돌아가기: 원래 보던 카테고리로 돌아가면 더 좋겠죠? -->
                        <a href="list?category=${board.category}" class="btn">목록으로</a>

                        <!-- [Step 15: 수정/삭제 버튼] 
                             관리자(ADMIN)만 수정하거나 삭제할 수 있습니다.
                        -->
                        <c:if test="${loginUser.userRole == 'ADMIN'}">
                            <a href="update?boardId=${board.boardId}" class="btn">수정</a>
                            <a href="delete?boardId=${board.boardId}" class="btn"
                                onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                        </c:if>
                    </div>

                </main>

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
                        // 24. 게시글 좋아요 버튼 클릭 (이벤트 위임 사용)
                        $(document).on("click", "#like-btn", function () {
                            console.log("Board Like Button Clicked");
                            var boardId = "${board.boardId}";
                            $.ajax({
                                url: "${pageContext.request.contextPath}/community/heart",
                                type: "GET",
                                data: { boardId: boardId },
                                dataType: "json",
                                cache: false,
                                success: function (data) {
                                    console.log("Board Heart Success", data);
                                    if (data.result === "login_required") {
                                        alert("로그인이 필요합니다.");
                                        location.href = "${pageContext.request.contextPath}/member/login";
                                        return;
                                    }

                                    if (data.isLiked) {
                                        $("#heart-icon").removeClass("far").addClass("fas");
                                    } else {
                                        $("#heart-icon").removeClass("fas").addClass("far");
                                    }
                                    $("#like-count").text(data.count);
                                },
                                error: function (xhr, status, error) {
                                    console.log("통신 실패", status, error);
                                }
                            });
                        });

                        // 25. 댓글 좋아요 버튼 클릭 (이벤트 위임 사용)
                        $(document).on("click", ".comment-like-btn", function () {
                            console.log("Comment Like Button Clicked");
                            var btn = $(this);
                            var commentId = btn.data("comment-id");
                            $.ajax({
                                url: "${pageContext.request.contextPath}/community/comment/heart",
                                type: "GET",
                                data: { commentId: commentId },
                                dataType: "json",
                                cache: false,
                                success: function (data) {
                                    console.log("Comment Heart Success", data);
                                    if (data.result === "login_required") {
                                        alert("로그인이 필요합니다.");
                                        location.href = "${pageContext.request.contextPath}/member/login";
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
                                error: function (xhr, status, error) {
                                    console.log("통신 실패", status, error);
                                }
                            });
                        });

                        // 초기 UI 세팅
                        // 따옴표로 감싸서 속성이 없어도 문법 오류 방지 (var isLiked = "";)
                        var isLiked = "${isLiked}";
                        var likeCount = "${likeCount}";

                        if (isLiked === "true") {
                            $("#heart-icon").removeClass("far").addClass("fas");
                        } else {
                            $("#heart-icon").removeClass("fas").addClass("far");
                        }

                        // likeCount가 비어있으면 0으로 처리
                        if (!likeCount) likeCount = 0;
                        $("#like-count").text(likeCount);

                        console.log("Board Detail Script Loaded. isLiked=" + isLiked);
                    });
                </script>
            </body>

            </html>