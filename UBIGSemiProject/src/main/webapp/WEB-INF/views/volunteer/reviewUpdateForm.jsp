<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>후기 수정</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
            <style>
                body {
                    font-family: 'Pretendard', sans-serif;
                    background-color: #f8f9fa;
                    padding: 20px;
                }

                .container {
                    width: 800px;
                    margin: 50px auto;
                    background: white;
                    padding: 40px;
                    border-radius: 15px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                }

                h2 {
                    text-align: center;
                    margin-bottom: 30px;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                label {
                    display: block;
                    font-weight: bold;
                    margin-bottom: 8px;
                }

                select,
                textarea,
                input {
                    width: 100%;
                    padding: 12px;
                    border: 1px solid #ddd;
                    border-radius: 5px;
                    box-sizing: border-box;
                }

                textarea {
                    height: 200px;
                    resize: vertical;
                }

                .btn-area {
                    text-align: center;
                    margin-top: 30px;
                }

                button {
                    padding: 12px 30px;
                    border: none;
                    border-radius: 5px;
                    font-weight: bold;
                    cursor: pointer;
                }

                .btn-submit {
                    background-color: #ffc107;
                    color: white;
                }

                .btn-cancel {
                    background-color: #6c757d;
                    color: white;
                    margin-left: 10px;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../common/menubar.jsp" />
            <div class="container">
                <h2>✏️ 후기 수정하기</h2>
                <form action="updateReview.vo" method="post">
                    <input type="hidden" name="reviewNo" value="${r.reviewNo}">

                    <div class="form-group">
                        <label>활동명 (수정불가)</label>
                        <input type="text" value="${r.actTitle}" readonly style="background-color: #eee;">
                    </div>

                    <!-- [추가] 후기 제목 수정란 -->
                    <%-- [추가] 후기 제목 수정 입력란 --%>
						<div class="form-group">
						    <label>후기 제목</label>
						    <input type="text" name="rTitle" value="${r.rTitle}" placeholder="제목을 입력해주세요" required>
						</div>
					<!-- 평점 삭제 12월 26일 -->
                    <input type="hidden" name="rRate" value="${r.rRate}">

                    <div class="form-group">
                        <label>후기 내용</label>
                        <textarea name="rReview" required>${r.rReview}</textarea>
                    </div>

                    <div class="btn-area">
                        <button type="submit" class="btn-submit">수정 완료</button>
                        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                    </div>
                </form>
            </div>
        </body>

        </html>