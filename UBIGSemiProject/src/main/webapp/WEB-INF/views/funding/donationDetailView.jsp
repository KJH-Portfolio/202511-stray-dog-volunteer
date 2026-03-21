<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
<title>유기견 후원</title>

<style>
body { font-family:'Noto Sans KR', sans-serif; background:#f5f6f7; margin:0; }
.container { max-width:900px; margin:40px auto; padding:50px; }
h1 { text-align:center; margin-bottom:30px; }
.section { background:#fff; padding:30px; border-radius:15px; }
.tabs { display:flex; margin-bottom:20px; }
.tabs button {
    flex:1; padding:15px; border:none; cursor:pointer;
    background:#ddd; font-weight:600;
}
.tabs button.active { background:#FFC107; color:#fff; }
.donation-content { display:none; }
.donation-content.active { display:block; }
.donation-card {
    display:flex; gap:20px; align-items:center;
    padding:20px; border-radius:15px;
}
.donation-card img {
    width:200px; height:150px; border-radius:10px; object-fit:cover;
}
label { display:block; margin-top:10px; }
input { width:100%; padding:10px; margin-top:5px; }
.submit-btn {
    margin-top:20px; padding:12px;
    background:#FFC107; border:none; color:#fff;
    border-radius:30px; cursor:pointer;
}
.info-box {
    padding:20px;
    background:#fff8e1;
    border:1px solid #ffe082;
    border-radius:15px;
    text-align:center;
    font-weight:600;
    color:#ff9800;
}
</style>

<script>
function showTab(tabId, btn) {
    document.querySelectorAll('.donation-content')
        .forEach(div => div.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');

    document.querySelectorAll('.tabs button')
        .forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
}

window.addEventListener('DOMContentLoaded', () => {
    const firstBtn = document.querySelector('.tabs button');
    if (firstBtn) firstBtn.click();
});
</script>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/menubar.jsp"></jsp:include>

<div class="container">
<h1>🐶 유기견 후원</h1>

<div class="section">

    <!-- 탭 -->
    <div class="tabs">
        <c:if test="${result eq 0}">
            <button onclick="showTab('regular', this)">정기 후원</button>
        </c:if>
        <button onclick="showTab('oneTime', this)">일시 후원</button>
    </div>

    <!-- 정기후원 중 메시지 -->
    <c:if test="${result ne 0}">
        <div class="info-box">
            이미 <strong>정기 후원</strong>을 진행 중입니다 🙏 <br>
            소중한 후원에 진심으로 감사드립니다.
        </div>
    </c:if>

    <!-- 정기 후원 -->	
    <c:if test="${result eq 0}">
        <div id="regular" class="donation-content">
            <div class="donation-card">
                <form action="${pageContext.request.contextPath}/donation/donation" method="post">
                    <input type="hidden" name="donationType" value="1">

                    <label>회원 아이디</label>
                    <input type="text" name="userId"
                           value="${loginMember.userId}" readonly>

                    <label>후원 금액</label>
                    <input type="number" name="donationMoney" min="1" required>

                    <button class="submit-btn">정기 후원 신청</button>
                </form>
            </div>
        </div>
    </c:if>

    <!-- 일시 후원 -->
    <div id="oneTime" class="donation-content">
        <div class="donation-card">
            <form action="${pageContext.request.contextPath}/donation/donation2" method="post">
                <input type="hidden" name="donationType" value="2">

                <label>회원 아이디</label>
                <input type="text" name="userId"
                       value="${loginMember.userId}" readonly>

                <label>후원 금액</label>
                <input type="number" name="donationMoney" min="1" required>

                <button class="submit-btn">일시 후원 신청</button>
            </form>
        </div>
    </div>

</div>
</div>
</body>
</html>
