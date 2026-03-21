<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>봉사 후기 작성</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
                <style>
                    /* 후기 작성 폼 전용 스타일 */
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
                        color: #333;
                    }

                    .form-group {
                        margin-bottom: 20px;
                    }

                    label {
                        display: block;
                        font-weight: bold;
                        margin-bottom: 8px;
                        color: #555;
                    }

                    select,
                    input,
                    textarea {
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
                        font-size: 16px;
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

                    /* 읽기 전용 입력창 스타일 */
                    .readonly-input {
                        background-color: #eee;
                        cursor: not-allowed;
                        color: #666;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="../common/menubar.jsp" />

                <div class="container">
                    <h2>✍️ 봉사활동 후기 작성</h2>

                    <!-- [기능] 사용자가 입력한 후기 정보(제목, 내용, 별점 등)를 서버로 전송하여 DB에 저장 -->
                    <!-- [기술] Form Post Request -->
                    <form action="insertReview.vo" method="post">

                        <%-- 작성자 ID 전송 --%>
                            <input type="hidden" name="rId" value="${loginMember.userId}">

                            <div class="form-group">
                                <label>작성자</label>
                                <%-- 화면 표시용 --%>
                                    <input type="text" value="${loginMember.userId}" class="readonly-input" readonly>
                            </div>

                            <div class="form-group">
                                <label>어떤 봉사활동을 하셨나요?</label>
                                <!-- [기능] 사용자가 참여했던 활동 중 아직 후기를 작성하지 않은 목록을 드롭다운으로 표시 -->
                                <!-- [기술] JSTL forEach -->
                                <select name="actId" required>
                                    <option value="">봉사활동을 선택해주세요</option>

                                    <c:forEach var="a" items="${actList}">
                                        <option value="${a.actId}">
                                            [
                                            <fmt:formatDate value="${a.actDate}" pattern="yyyy-MM-dd" />] ${a.actTitle}
                                        </option>
                                    </c:forEach>

                                </select>
                            </div>

                            <%-- 후기 제목 입력란 --%>
                                <div class="form-group">
                                    <label>후기 제목</label>
                                    <input type="text" name="rTitle" placeholder="제목을 입력해주세요" required>
                                </div>

                                <input type="hidden" name="rRate" value="0">

                                <div class="form-group">
                                    <label>후기 내용</label>
                                    <textarea name="rReview" placeholder="봉사활동을 하며 느낀 점을 자유롭게 적어주세요."
                                        required></textarea>
                                </div>

                                <div class="btn-area">
                                    <button type="submit" class="btn-submit">등록하기</button>
                                    <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                                </div>
                    </form>
                </div>

            </body>

            </html>