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
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background-color: #343a40; color: white; }
        .sidebar a { color: rgba(255,255,255,.8); text-decoration: none; padding: 10px 15px; display: block; }
        .sidebar a:hover { background-color: #495057; color: white; }
        .card-stat { border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.2s; }
        .card-stat:hover { transform: translateY(-5px); }
        .icon-box { font-size: 3rem; opacity: 0.8; }
        .table-card { background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); padding: 20px; }
        .badge-status { font-size: 0.85rem; padding: 5px 10px; border-radius: 12px; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- 사이드바 -->
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

        <!-- 메인 -->
        <main class="col-md-10 ms-sm-auto col-lg-10 px-md-4 py-4">
            <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2"><i class="fas fa-chart-line me-2 text-primary"></i>Dashboard</h1>
            </div>

            <!-- 총 회원수 카드 -->
            <div class="row mb-4">
                <div class="col-md-4 mb-4">
                    <a href="${pageContext.request.contextPath}/admin/userStatus" style="text-decoration:none;">
                        <div class="card card-stat bg-primary text-white h-100">
                            <div class="card-body d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-uppercase small fw-bold mb-1">총 회원수</div>
                                    <div class="h3 mb-0 fw-bold">${listCount} 명</div>
                                </div>
                                <div class="icon-box"><i class="fas fa-users"></i></div>
                            </div>
                        </div>
                    </a>
                </div>
            </div>

            <!-- 최근 입양 & 봉사 신청 테이블 -->
            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="table-card">
                        <h5 class="fw-bold text-secondary mb-3"><i class="fas fa-dog me-2 text-warning"></i>최근 입양 신청</h5>
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>신청번호</th>
                                    <th>회원ID</th>
                                    <th>동물번호</th>
                                    <th>신청일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty recentAdoptions}">
                                        <tr><td colspan="4" class="text-center">신규 입양 신청 내역이 없습니다.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="adopt" items="${recentAdoptions}" begin="0" end="2">
                                            <tr>
                                                <td>#${adopt.adoptionAppId}</td>
                                                <td>${adopt.userId}</td>
                                                <td>${adopt.animalNo}</td>
                                                <td><fmt:formatDate value="${adopt.applyDt}" pattern="yyyy-MM-dd"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="col-lg-6 mb-4">
                    <div class="table-card">
                        <h5 class="fw-bold text-secondary mb-3"><i class="fas fa-hands-helping me-2 text-success"></i>최근 봉사 신청</h5>
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>신청번호</th>
                                    <th>활동ID</th>
                                    <th>회원ID</th>
                                    <th>신청일</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty recentVolunteers}">
                                        <tr><td colspan="5" class="text-center">신규 봉사 신청 내역이 없습니다.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="sign" items="${recentVolunteers}" begin="0" end="2">
                                            <tr>
                                                <td>#${sign.signsNo}</td>
                                                <td>${sign.actId}</td>
                                                <td>${sign.signsId}</td>
                                                <td><fmt:formatDate value="${sign.signsDate}" pattern="yyyy-MM-dd"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sign.signsStatus == 0}"><span class="badge bg-secondary badge-status">대기</span></c:when>
                                                        <c:when test="${sign.signsStatus == 1}"><span class="badge bg-success badge-status">승인</span></c:when>
                                                        <c:when test="${sign.signsStatus == 2}"><span class="badge bg-danger badge-status">거절</span></c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
