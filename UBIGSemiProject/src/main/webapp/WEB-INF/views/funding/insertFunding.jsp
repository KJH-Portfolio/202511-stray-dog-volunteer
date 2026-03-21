<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
<meta charset="UTF-8">
<title>유봉일공 - 펀딩 추가</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">

<style>
body {
    font-family: 'Noto Sans KR', sans-serif;
    background-color: #f8f9fa;
    padding: 100px;
}

h2 {
    text-align: center;
    margin-bottom: 30px;
}

.form-container {
    background: white;
    width: 500px;
    margin: 0 auto;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.1);
}

.form-container label {
    display: block;
    margin: 15px 0 5px;
    font-weight: bold;
}

.form-container input[type="text"],
.form-container textarea,
.form-container input[type="number"] {
    width: 100%;
    padding: 10px;
    border-radius: 5px;
    border: 1px solid #ccc;
}

.form-container textarea {
    resize: vertical;
    height: 100px;
}

.form-container button {
    margin-top: 20px;
    padding: 12px 20px;
    border: none;
    border-radius: 30px;
    background-color: #28a745;
    color: white;
    font-weight: bold;
    cursor: pointer;
    transition: background 0.2s;
}

.form-container button:hover {
    background-color: #218838;
}
</style>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/menubar.jsp"></jsp:include>

<h2>새로운 펀딩 추가</h2>

<div class="form-container">
    <form action="${pageContext.request.contextPath}/funding/insertFunding" method="post">
        
        <label for="userId">작성자</label>
        <input type="text" id="userId" name="userId" value="${loginMember.userId}" readonly="readonly" required>
        
        <label for="fundingTitle">펀딩 제목</label>
        <input type="text" id="fundingTitle" name="fundingTitle" required>

        <label for="fundingContent">펀딩 내용</label>
        <textarea id="fundingContent" name="fundingContent" required></textarea>

        <label for="fundingMaxMoney">목표 금액</label>
        <input type="number" id="fundingMaxMoney" name="fundingMaxMoney" min="100000" max="100000000" required>
        
        <button type="submit">펀딩 등록</button>
    </form>
</div>

</body>
</html>
