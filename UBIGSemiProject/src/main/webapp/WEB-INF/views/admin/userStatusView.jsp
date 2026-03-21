<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원 관리 | 관리자 센터</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
body { background-color: #f8f9fa; }

/* 사이드바 (대시보드 스타일과 동일) */
.sidebar {
    min-height: 100vh;
    background-color: #343a40;
    color: white;
}
.sidebar a {
    color: rgba(255,255,255,.8);
    text-decoration: none;
    padding: 12px 15px;
    display: block;
}
.sidebar a.active,
.sidebar a:hover {
    background-color: #495057;
    color: white;
}

/* 테이블 컨테이너 */
.table-container {
    background: #fff;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

/* 상태 */
.status-active { color: #28a745; font-weight: 600; }
.status-stoped { color: #fd7e14; font-weight: 600; }
.status-banned { color: #dc3545; font-weight: 600; }

/* 검색 */
.top-menu {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
    margin-bottom: 20px;
}
.top-menu select,
.top-menu input {
    padding: 6px 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
}
.search-btn {
    background-color: #0d6efd;
    color: #fff;
    border: none;
    padding: 6px 14px;
    border-radius: 6px;
}

/* 페이징 */
.pagination {
    margin-bottom: 0;
}
.pagination .page-link {
    color: #495057;
    border-radius: 6px;
    margin: 0 2px;
}
.pagination .page-item.active .page-link {
    background-color: #343a40;
    border-color: #343a40;
    color: #fff;
}
.pagination .page-link:hover {
    background-color: #e9ecef;
}
</style>
</head>

<body>
<div class="container-fluid">
<div class="row">

<!-- 사이드바 (대시보드 스타일 동일 적용) -->
<nav class="col-md-2 d-none d-md-block sidebar p-0">
    <div class="p-4 text-center border-bottom border-secondary">
        <h4><i class="fas fa-paw"></i> 관리자 센터</h4>
        <small>Welcome, Admin</small>
    </div>
    <div class="mt-3">
        <a href="${pageContext.request.contextPath}/admin">
            <i class="fas fa-tachometer-alt me-2"></i> 대시보드
        </a>
        <a href="${pageContext.request.contextPath}/admin/userStatus" class="active">
            <i class="fas fa-users me-2"></i> 회원 관리
        </a>
        <a href="${pageContext.request.contextPath}/admin/chatList.ch">
            <i class="fas fa-headset me-2"></i> 1:1 문의
        </a>
    </div>
</nav>

<!-- 메인 -->
<main class="col-md-10 px-md-4 py-4">
    <h3 class="mb-4"><i class="fas fa-users-cog"></i> 회원 관리</h3>

    <!-- 검색 -->
    <div class="top-menu">
        <form action="${pageContext.request.contextPath}/admin/searchKeyword" class="d-flex gap-2">
            <select name="searchType">
                <option value="all">전체</option>
                <option value="user">아이디</option>
                <option value="name">이름</option>
            </select>
            <input type="text" name="searchKeyword" placeholder="검색어 입력">
            <button class="search-btn">검색</button>
        </form>
    </div>

    <!-- 테이블 -->
    <div class="table-container">
        <table class="table table-hover align-middle text-center">
            <thead class="table-dark">
                <tr>
                    <th>아이디</th>
                    <th>이름(닉네임)</th>
                    <th>가입일</th>
                    <th>봉사횟수</th>
                    <th>상태</th>
                    <th>정지해제일</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <jsp:useBean id="now" class="java.util.Date" />
                <c:forEach var="m" items="${list}">
                    <tr>
                        <td><strong>${m.userId}</strong></td>
                        <td>${m.userName} (${m.userNickname})</td>
                        <td><fmt:formatDate value="${m.userEnrollDate}" pattern="yyyy-MM-dd"/></td>
                        <td>${m.userAttendedCount} 회</td>
                        <td>
                            <c:choose>
                                <c:when test="${m.userStatus == 'N'}">
                                    <span class="status-banned">추방</span>
                                </c:when>
                                <c:when test="${m.userStatus eq 'Y' and m.userRestrictEndDate.time gt now.time}">
                                    <span class="status-stoped">정지</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-active">정상</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${not empty m.userRestrictEndDate}">
                                <fmt:formatDate value="${m.userRestrictEndDate}" pattern="yyyy-MM-dd"/>
                            </c:if>
                            <c:if test="${empty m.userRestrictEndDate}">-</c:if>
                        </td>
                        <td>
                            <c:if test="${m.userStatus == 'Y' and (empty m.userRestrictEndDate or m.userRestrictEndDate.time le now.time)}">
                                <button class="btn btn-sm btn-warning stopBtn" data-userid="${m.userId}">정지</button>
                                <button class="btn btn-sm btn-danger kickBtn" data-userid="${m.userId}">추방</button>
                            </c:if>
                            <c:if test="${m.userStatus eq 'Y' and m.userRestrictEndDate.time gt now.time}">
                                <button class="btn btn-sm btn-success openBtn" data-userid="${m.userId}">정지 해제</button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    
    <!-- 정지 기간 선택 모달 -->
	<div class="modal fade" id="restrictModal" tabindex="-1">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title">회원 활동 정지</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	            </div>
	            <div class="modal-body">
	                <input type="hidden" id="modalUserId">
	                <p>대상 아이디: <strong id="displayUserId"></strong></p>
	                <div class="mb-3">
	                    <label class="form-label">정지 기간 선택</label>
	                    <select class="form-select" id="stopDays">
	                        <option value="3">3일</option>
	                        <option value="7">7일</option>
	                        <option value="30">30일</option>
	                        <option value="999">영구</option>
	                    </select>
	                </div>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	                <button type="button" class="btn btn-warning" id="applyStopBtn">정지 적용</button>
	            </div>
	        </div>
	    </div>
	</div>

    <!-- 페이징 -->
    <div class="d-flex justify-content-center mt-4">
        <ul class="pagination pagination-sm shadow-sm">
            <c:if test="${pi.currentPage > 1}">
                <li class="page-item">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/searchKeyword?curPage=${pi.currentPage-1}&searchKeyword=${keyword}">
                        <i class="fas fa-angle-left"></i>
                    </a>
                </li>
            </c:if>

            <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                <c:choose>
                    <c:when test="${p == pi.currentPage}">
                        <li class="page-item active">
                            <span class="page-link">${p}</span>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/admin/searchKeyword?curPage=${p}&searchKeyword=${keyword}">
                                ${p}
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${pi.currentPage < pi.maxPage}">
                <li class="page-item">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/admin/searchKeyword?curPage=${pi.currentPage+1}&searchKeyword=${keyword}">
                        <i class="fas fa-angle-right"></i>
                    </a>
                </li>
            </c:if>
        </ul>
    </div>

</main>
</div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function(){

    // 정지 모달 열기
    $(document).on("click", ".stopBtn", function(){
        let userId = $(this).data("userid");
        $("#modalUserId").val(userId);
        $("#displayUserId").text(userId);
        new bootstrap.Modal(document.getElementById('restrictModal')).show();
    });

    // 정지 적용
    $("#applyStopBtn").click(function(){
        let userId = $("#modalUserId").val();
        let days = $("#stopDays").val();

        $.ajax({
            url: "${pageContext.request.contextPath}/admin/stopUser",
            type: "POST",
            data: { userId: userId, days: days },
            success: function(res){
                alert(userId + " 회원이 정지 처리되었습니다.");
                location.reload();
            },
            error: function(){
                alert("정지 처리 실패");
            }
        });
    });

    // 정지 해제
    $(document).on("click", ".openBtn", function(){
        let userId = $(this).data("userid");
        if(confirm(userId + " 회원의 정지를 해제하시겠습니까?")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/openUser",
                type: "POST",
                data: { userId: userId },
                success: function(){
                    alert(userId + " 회원 정지가 해제되었습니다.");
                    location.reload();
                },
                error: function(){
                    alert("정지 해제 실패");
                }
            });
        }
    });

    // 추방
    $(document).on("click", ".kickBtn", function(){
        let userId = $(this).data("userid");
        if(confirm(userId + " 회원을 정말 추방하시겠습니까?")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/deleteUser",
                type: "POST",
                data: { userId: userId },
                success: function(){
                    alert(userId + " 회원이 추방되었습니다.");
                    location.reload();
                },
                error: function(){
                    alert("추방 실패");
                }
            });
        }
    });

});
</script>
</body>
</html>
