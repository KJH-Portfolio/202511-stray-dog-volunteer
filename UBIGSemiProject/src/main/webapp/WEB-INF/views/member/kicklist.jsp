<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>유봉일공 - 쪽지함</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
    <style>
        body { background-color: #f8f9fa; }
        .msg-container { max-width: 1000px; margin: 50px auto; }
        
        /* 탭 스타일 */
        .nav-tabs .nav-link { color: #495057; font-weight: 500; }
        .nav-tabs .nav-link.active { color: #000; font-weight: bold; border-bottom: 3px solid #FFC107; }
        
        /* 테이블 스타일 */
        .table-hover tbody tr { cursor: pointer; transition: 0.2s; }
        .unread-msg { font-weight: bold; background-color: #fffef0; } /* 읽지 않은 쪽지 배경색 */
        .msg-preview {
            display: inline-block;
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            vertical-align: middle;
        }
        
        .btn-write { background-color: #FFC107; border: none; font-weight: bold; color: white; }
        .btn-write:hover { background-color: #e0a800; color: white; }
        
        body {
        	padding-top: 50px;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/menubar.jsp" />

<div class="container msg-container">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">📬 나의 쪽지함</h2>
    </div>

    <ul class="nav nav-tabs mb-3">
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/message/inbox.ms">받은 쪽지함 <span class="badge bg-danger rounded-pill ms-1">${unreadCount}</span></a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/message/sent.ms">보낸 쪽지함</a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/kick/kickList.ki">차단 목록</a>
        </li>
    </ul>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 text-center align-middle" id="kickTable">
                <thead class="table-light">
                    <tr>
                        <th scope="col" style="width: 80%;">차단된 유저 ID</th>
                        <th scope="col" style="width: 20%;">관리</th>
                    </tr>
                </thead>
                <tbody>
                	<!-- 차단한 회원이 없으면 차단한 회원이 없습니다.를 출력하고 그렇지 않다면 차단한 회원 목록 보여주기 -->
                    <c:choose>
                        <c:when test="${empty list}">
                            <tr>
                                <td colspan="5" class="py-5 text-secondary">차단한 회원이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="k" items="${list}">
                                <tr>
                                	<td>${k.kickedUser}</td>
                                	<td>
                                		<form action="${pageContext.request.contextPath}/kick/deleteKick.ki" method="post">
                                			<input type="hidden" name="kickNo" value="${k.kickNo }">
                                			<button class="btn btn-danger" onclick="return checkUnsetKick();">차단 해제</button>
                                		</form>
                                	</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
    
        <div id="pagingArea">
			<ul class="pagination">
				<c:choose>
               		<c:when test="${pi.currentPage le 1 }"> <!-- 현재페이지 1이면 이전버튼 비활성화 -->
	                    <li class="page-item disabled"><a class="page-link" href="${pageContext.request.contextPath}/kick/kickList.ki?curPage=${pi.currentPage - 1}">Prev</a></li>
               		</c:when>
               		<c:otherwise>
               			<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/kick/kickList.ki?curPage=${pi.currentPage - 1}">Prev</a></li>
               		</c:otherwise>
               	</c:choose>
                   
                   <c:forEach var="i" begin="${pi.startPage }" end="${pi.endPage }">
<!--                     	el표기법으로 3항연산자를 이용하여 조건이 부합할 땐 disabled 속성 넣기 아니면 빈값처리 -->
                   	<li class="page-item ${i eq pi.currentPage ? 'disabled' : '' }"><a class="page-link" href="${pageContext.request.contextPath}/kick/kickList.ki?curPage=${i}">${i }</a></li>
                   </c:forEach>
                   
                   <c:choose>
                   	<c:when test="${pi.currentPage ge pi.maxPage }">
	                    <li class="page-item disabled"><a class="page-link" href="${pageContext.request.contextPath}/kick/kickList.ki?curPage=${pi.currentPage + 1}">Next</a></li>
                   	</c:when>
                   	<c:otherwise>
                   		<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/kick/kickList.ki?curPage=${pi.currentPage + 1}">Next</a></li>
                   	</c:otherwise>
                   </c:choose>
			</ul>
		</div>
    
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
	function checkUnsetKick() {
		return confirm("차단을 해제하시겠습니까?");
	}
/* 	$(function() {
		$.each($("#kickTable tbody tr"), function(index, value) {
			let btn = $(this).children().eq(1).children();
			let kickedUser = $(this).children().eq(0).text();
			
			$(this).on("click", "button", function() {
				if (confirm(kickedUser + "님의 차단을 해제하시겠습니까?")) {
					
					let form = document.createElement('form');
					form.method = "post";
					form.action = "${pageContext.request.contextPath}/kick/deleteKick.ki";
					document.body.appendChild(form);
					
					let formField = document.createElement("input");
					formField.type = 'hidden';
					formField.name = "kickNo";
					formField.value = 
					
					location.href = "${pageContext.request.contextPath}/kick/deleteKick.ki";
				}
			});
			
			btn.on("click", function() {
				
			});
			console.log($(this).children().eq(1).children());
		});
	}); */
</script>

</body>
</html>