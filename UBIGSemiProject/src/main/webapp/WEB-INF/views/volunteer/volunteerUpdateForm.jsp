<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>봉사활동 수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <style>
        /* volunteerWriteForm.jsp와 동일한 스타일 적용 */
        body {
            font-family: 'Pretendard', sans-serif;
            background-color: #f8f9fa;
            padding: 20px;
        }

        .container {
            width: 700px;
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
            font-weight: 800;
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

        input[type="text"],
        input[type="number"],
        input[type="date"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        input:focus {
            border-color: #4CAF50;
            outline: none;
        }

        /* 읽기 전용 필드 스타일 */
        .readonly-input {
            background-color: #f0f0f0;
            color: #777;
            cursor: not-allowed;
        }

        /* 주소 검색 행 */
        .address-row {
            display: flex;
            gap: 10px;
        }

        .btn-search {
            background-color: #666;
            color: white;
            border: none;
            padding: 0 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            white-space: nowrap;
        }

        .btn-search:hover {
            background-color: #555;
        }

        /* 버튼 영역 */
        .btn-area {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .btn-submit {
            background-color: #4CAF50; /* 메인 초록색 */
            color: white;
            padding: 15px 40px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-submit:hover {
            background-color: #45a049;
        }

        .btn-cancel {
            background-color: #f1f1f1;
            color: #333;
            padding: 15px 40px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-left: 10px;
        }

        .btn-cancel:hover {
            background-color: #e2e2e2;
        }
    </style>
</head>

<body>

    <jsp:include page="../common/menubar.jsp" />

    <div class="container">
        <h2>✏️ 봉사활동 게시글 수정</h2>
        <p style="text-align: center; color: #888; margin-bottom: 30px; font-size: 14px;">
            등록된 봉사활동 정보를 수정합니다.
        </p>

        <form action="volunteerUpdate.vo" method="post">
            <input type="hidden" name="actId" value="${vo.actId}">

            <div class="form-group">
                <label>작성자 ID</label>
                <input type="text" value="${vo.adminId}" class="readonly-input" readonly>
            </div>

            <div class="form-group">
                <label>봉사 제목</label>
                <input type="text" name="actTitle" value="${vo.actTitle}" required>
            </div>

            <div class="form-group">
                <label>봉사 장소</label>
                <div class="address-row">
                    <input type="text" name="actAddress" id="address" value="${vo.actAddress}" 
                           placeholder="주소를 검색해주세요" required readonly
                           style="background-color: white; cursor: pointer;"
                           onclick="execDaumPostcode()">
                    <button type="button" class="btn-search" onclick="execDaumPostcode()">🔍 재검색</button>
                </div>
            </div>

            <div class="form-group">
                <label>최대 인원 (명)</label>
                <input type="number" name="actMax" min="5" value="${vo.actMax}" required>
                <p style="font-size: 12px; color: #888; margin-top: 5px;">* 현재 신청 인원보다 적게 설정할 수 없습니다.</p>
            </div>

            <div style="display: flex; gap: 20px;">
                <fmt:formatDate value="${vo.actDate}" pattern="yyyy-MM-dd" var="startDate"/>
                <fmt:formatDate value="${vo.actEnd}" pattern="yyyy-MM-dd" var="endDate"/>

                <div class="form-group" style="flex: 1;">
                    <label>시작일</label>
                    <input type="date" name="actDate" value="${startDate}" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>종료일</label>
                    <input type="date" name="actEnd" value="${endDate}" required>
                </div>
            </div>

            <div class="form-group">
                <label>참가비</label>
                <input type="text" value="10,000원 (고정)" class="readonly-input" readonly>
            </div>

            <div class="btn-area">
                <button type="submit" class="btn-submit">수정 완료</button>
                <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
            </div>
        </form>
    </div>

    <script>
        // 우편번호 찾기 기능 (수정 시에도 좌표 갱신을 위해 필요)
        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function (data) {
                    // 주소 선택 시 입력칸에 넣기
                    document.getElementById("address").value = data.address;
                }
            }).open();
        }
    </script>
</body>
</html>