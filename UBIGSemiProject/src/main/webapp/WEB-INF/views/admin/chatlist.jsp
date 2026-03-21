<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>관리자 대시보드 | 유기동물 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background-color: #343a40; color: white; }
        .sidebar a { color: rgba(255,255,255,.8); text-decoration: none; padding: 10px 15px; display: block; }
        .sidebar a:hover { background-color: #495057; color: white; }
        .card-stat { border: none; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.2s; }
        .card-stat:hover { transform: translateY(-5px); }
        .icon-box { font-size: 2.5rem; opacity: 0.8; }
        .table-card { background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); padding: 20px; }
        .status-badge { font-size: 0.8em; padding: 5px 10px; border-radius: 15px; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block sidebar p-0">
            <div class="p-4 text-center border-bottom border-secondary">
                <h4><i class="fas fa-paw"></i> 관리자 센터</h4>
                <small>Welcome, Admin</small>
            </div>
            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/admin" class="active"><i class="fas fa-tachometer-alt me-2"></i> 대시보드</a>
                <a href="${pageContext.request.contextPath}/admin/userStatus"><i class="fas fa-users me-2"></i> 회원 관리</a>
                <a href="${pageContext.request.contextPath}/admin/chatList.ch"><i class="fas fa-headset me-2"></i> 1:1 문의</a>
            </div>
        </nav>

        <main class="col-md-10 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle" id="chatListTable">
                    <thead class="table-light">
                        <tr>
                            <th>회원ID</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty list}">
                                <tr><td colspan="2" class="text-center">회원이 없습니다.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="m" items="${list}">
                                    <tr>
                                        <td>${m.userId}</td>
                                        <td>
                                        	이 항목을 눌러 채팅을 진행하세요.
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
			<div id="pagingArea">
				<ul class="pagination">
					<c:choose>
                		<c:when test="${pi.currentPage eq 1 }"> <!-- 현재페이지 1이면 이전버튼 비활성화 -->
		                    <li class="page-item disabled"><a class="page-link" href="${pageContext.request.contextPath}/admin/chatList.ch?curPage=${pi.currentPage - 1}">Previous</a></li>
                		</c:when>
                		<c:otherwise>
                			<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/chatList.ch?curPage=${pi.currentPage - 1}">Previous</a></li>
                		</c:otherwise>
                	</c:choose>
                    
                    <c:forEach var="i" begin="${pi.startPage }" end="${pi.endPage }">
<!--                     	el표기법으로 3항연산자를 이용하여 조건이 부합할 땐 disabled 속성 넣기 아니면 빈값처리 -->
                    	<li class="page-item ${i eq pi.currentPage ? 'disabled' : '' }"><a class="page-link" href="${pageContext.request.contextPath}/admin/chatList.ch?curPage=${i}">${i }</a></li>
                    </c:forEach>
                    
                    <c:choose>
                    	<c:when test="${pi.currentPage eq pi.maxPage }">
		                    <li class="page-item disabled"><a class="page-link" href="${pageContext.request.contextPath}/admin/chatList.ch?curPage=${pi.currentPage + 1}">Next</a></li>
                    	</c:when>
                    	<c:otherwise>
                    		<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/chatList.ch?curPage=${pi.currentPage + 1}">Next</a></li>
                    	</c:otherwise>
                    </c:choose>
				</ul>
			</div>
        </main>
    </div>
</div>

<script>

	$(function() {
		$("#chatListTable").on("click", "tbody tr", function() {
			location.href = "chat.ch?userId=" + $(this).children().first().text();
		});
	});

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>