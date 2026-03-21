<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>유봉일공 - 글 수정</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
            <!-- jQuery -->
            <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

            <!-- Summernote CSS/JS -->
            <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>

            <style>
                /* 커뮤니티 페이지 전용 스타일 re-use */
                .community-container {
                    padding: 120px 0 50px 0;
                    width: 1000px;
                    margin: 0 auto;
                }

                .page-title {
                    text-align: center;
                    margin-bottom: 40px;
                    font-size: 2em;
                    font-weight: bold;
                }

                .write-form {
                    border-top: 2px solid #333;
                    border-bottom: 1px solid #ddd;
                    padding: 20px;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                .form-label {
                    display: block;
                    margin-bottom: 5px;
                    font-weight: bold;
                }

                .form-input {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 5px;
                    box-sizing: border-box;
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

                .current-file {
                    margin-bottom: 10px;
                    font-size: 0.9em;
                    color: #666;
                }
            </style>
        </head>

        <body>

            <jsp:include page="/WEB-INF/views/common/menubar.jsp" />

            <main class="community-container">
                <div class="page-title">
                    <c:choose>
                        <c:when test="${board.category == 'NOTICE'}">공지사항 수정</c:when>
                        <c:when test="${board.category == 'FREE'}">자유게시판 수정</c:when>
                        <c:when test="${board.category == 'REQUEST'}">건의사항 수정</c:when>
                        <c:when test="${board.category == 'REVIEW'}">봉사후기 수정</c:when>
                        <c:otherwise>글 수정</c:otherwise>
                    </c:choose>
                </div>

                <form action="update" method="post" class="write-form" enctype="multipart/form-data">
                    <input type="hidden" name="boardId" value="${board.boardId}">
                    <input type="hidden" name="category" value="${board.category}">

                    <!-- 관리자 공지글 여부 수정 -->
                    <c:if test="${loginMember.userRole == 'ADMIN' && board.category == 'NOTICE'}">
                        <div class="form-group"
                            style="background:#fff3cd; padding:10px; border-radius:5px; margin-bottom:20px;">
                            <label
                                style="cursor:pointer; display:flex; align-items:center; gap:8px; font-weight:bold; color:#856404;">
                                <input type="checkbox" name="isPinned" value="Y" style="width:18px; height:18px;" <c:if
                                    test="${board.isPinned == 'Y'}">checked
                    </c:if>>
                    📢 공지글로 등록 (목록 최상단 고정)
                    </label>
                    </div>
                    </c:if>

                    <div class="form-group">
                        <label class="form-label">제목</label>
                        <input type="text" name="title" class="form-input" placeholder="제목을 입력하세요 (30자 이내)"
                            value="${board.title}" maxlength="30" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">내용</label>
                        <textarea id="summernote" name="content" required>${board.content}</textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label">첨부파일</label>
                        <c:if test="${not empty attachment}">
                            <div class="current-file">
                                현재 파일: ${attachment.originalName}
                            </div>
                        </c:if>
                        <input type="file" name="upfile" class="form-input">
                        <div style="font-size:0.8em; color:#888; margin-top:5px;">새 파일을 업로드할 경우 기존 첨부파일은 유지됩니다. (단, 로직에
                            따라 다름)</div>
                    </div>

                    <div class="btn-group">
                        <a href="detail?boardId=${board.boardId}" class="btn">취소</a>
                        <button type="submit" class="btn btn-primary">수정 완료</button>
                    </div>
                </form>

            </main>

            <script>
                $(document).ready(function () {
                    $('#summernote').summernote({
                        height: 500,
                        minHeight: null,
                        maxHeight: null,
                        focus: true,
                        lang: "ko-KR",
                        toolbar: [
                            ['style', ['style']],
                            ['font', ['bold', 'underline', 'clear']],
                            ['color', ['color']],
                            ['para', ['ul', 'ol', 'paragraph']],
                            ['table', ['table']],
                            ['insert', ['link', 'picture', 'video']],
                            ['view', ['fullscreen', 'codeview', 'help']]
                        ],
                        callbacks: {
                            onImageUpload: function (files) {
                                uploadImage(files[0], this);
                            }
                        }
                    });
                });

                function uploadImage(file, el) {
                    var formData = new FormData();
                    formData.append('file', file);

                    $.ajax({
                        data: formData,
                        type: "POST",
                        url: 'uploadImage',
                        contentType: false,
                        processData: false,
                        encType: 'multipart/form-data',
                        success: function (data) {
                            $(el).summernote('insertImage', data.url);
                        }
                    });
                }
            </script>
        </body>

        </html>