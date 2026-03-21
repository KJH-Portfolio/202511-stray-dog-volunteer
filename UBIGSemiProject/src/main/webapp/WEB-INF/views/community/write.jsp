<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>유봉일공 - 글쓰기</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
            <!-- jQuery (Summernote를 위해 필수) -->
            <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

            <!-- Summernote CSS/JS -->
            <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>

            <style>
                /* 커뮤니티 페이지 전용 스타일 */
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

                /* [Step 14: 태그 버튼 스타일] */
                .tag-group {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 10px;
                    margin-top: 10px;
                }

                .tag-btn {
                    padding: 8px 15px;
                    border: 1px solid #ddd;
                    border-radius: 20px;
                    background: #f8f9fa;
                    color: #555;
                    cursor: pointer;
                    font-size: 0.9em;
                    transition: all 0.2s;
                }

                .tag-btn:hover {
                    background: #e9ecef;
                }

                .tag-btn.active {
                    background: #ff9f43;
                    color: white;
                    border-color: #ff9f43;
                    font-weight: bold;
                }
            </style>
        </head>

        <body>

            <jsp:include page="/WEB-INF/views/common/menubar.jsp" />

            <main class="community-container">
                <div class="page-title">
                    <c:choose>
                        <c:when test="${category == 'NOTICE'}">공지사항</c:when>
                        <c:when test="${category == 'FREE'}">자유게시판</c:when>
                        <c:when test="${category == 'REQUEST'}">건의사항</c:when>
                        <c:when test="${category == 'REVIEW'}">봉사후기</c:when>
                        <c:otherwise>글 등록</c:otherwise>
                    </c:choose>
                </div>

                <!-- [Step 12: 글쓰기 폼] -->
                <form action="write" method="post" class="write-form" enctype="multipart/form-data">
                    <input type="hidden" name="category" value="${category}">
                    <input type="hidden" name="userId" value="${loginMember.userId}">

                    <!-- [Step 30: 공지글 등록 (관리자 전용)] -->
                    <c:if test="${loginMember.userRole == 'ADMIN'}">
                        <div class="form-group"
                            style="background:#fff3cd; padding:10px; border-radius:5px; margin-bottom:20px;">
                            <label
                                style="cursor:pointer; display:flex; align-items:center; gap:8px; font-weight:bold; color:#856404;">
                                <input type="checkbox" name="isPinned" value="Y" style="width:18px; height:18px;">
                                📢 공지글로 등록 (목록 최상단 고정)
                            </label>
                        </div>
                    </c:if>

                    <label class="form-label">제목</label>
                    <input type="text" name="title" class="form-input" placeholder="제목을 입력하세요 (30자 이내)" maxlength="30"
                        required>
                    </div>

                    <!-- [Step 14: 태그 선택 (봉사후기 전용)] -->
                    <c:if test="${category == 'REVIEW'}">
                        <div class="form-group">
                            <label class="form-label">키워드 선택 (중복 가능)</label>
                            <div class="tag-group">
                                <button type="button" class="tag-btn" data-value="#아이와 봉사활동하기 좋아요">#아이와 봉사활동하기
                                    좋아요</button>
                                <button type="button" class="tag-btn" data-value="#주차가 힘들어요">#주차가 힘들어요</button>
                                <button type="button" class="tag-btn" data-value="#산 높이 있어요. 건강에 좋아요">#산 높이 있어요. 건강에
                                    좋아요</button>
                                <button type="button" class="tag-btn" data-value="#주변에 맛집이 많아요. 봉사활동 후 회식!">#주변에 맛집이
                                    많아요.
                                    봉사활동 후 회식!</button>
                                <button type="button" class="tag-btn" data-value="#분위기 좋은 카페가 근처에 있어요">#분위기 좋은 카페가 근처에
                                    있어요</button>
                            </div>
                            <input type="hidden" name="hashtags" id="hashtagsInput">
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label class="form-label">내용</label>
                        <textarea id="summernote" name="content" required></textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label">첨부파일</label>
                        <input type="file" name="upfile" class="form-input">
                    </div>

                    <div class="btn-group">
                        <a href="list?category=${category}" class="btn">취소</a>
                        <button type="submit" class="btn btn-primary">등록</button>
                    </div>
                </form>

            </main>

            <script>
                $(document).ready(function () {
                    // [Step 14: 태그 버튼 클릭 이벤트]
                    $('.tag-btn').click(function () {
                        $(this).toggleClass('active');
                        updateHashtags();
                    });

                    function updateHashtags() {
                        var tags = [];
                        $('.tag-btn.active').each(function () {
                            tags.push($(this).data('value'));
                        });
                        $('#hashtagsInput').val(tags.join(','));
                    }

                    $('#summernote').summernote({
                        height: 500,                 // 에디터 높이
                        minHeight: null,             // 최소 높이
                        maxHeight: null,             // 최대 높이
                        focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
                        lang: "ko-KR",					// 한글 설정
                        placeholder: '내용을 입력하세요. 이미지를 드래그해서 넣을 수 있습니다.',
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
                                // 이미지 업로드 시 동작
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
                            // 서버에서 JSON으로 { "url": "..." } 형식을 내려주므로 data.url 로 접근
                            $(el).summernote('insertImage', data.url);
                        }
                    });
                }
            </script>
        </body>

        </html>