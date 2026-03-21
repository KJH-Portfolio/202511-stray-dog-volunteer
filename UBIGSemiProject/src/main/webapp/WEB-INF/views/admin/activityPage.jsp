<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>봉사활동 관리 | 관리자 센터</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .activity-container { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .progress { height: 8px; margin-top: 5px; }
        .addr-text { font-size: 0.85em; color: #666; display: block; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    </style>
</head>
<body class="bg-light">

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-hand-holding-heart text-danger"></i> 봉사활동 프로그램 관리</h2>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#activityModal">
            <i class="fas fa-plus"></i> 새 프로그램 등록
        </button>
    </div>

    <div class="activity-container">
        <table class="table table-hover align-middle">
            <thead class="table-dark">
                <tr class="text-center">
                    <th>ID</th>
                    <th>프로그램 제목</th>
                    <th>활동 기간</th>
                    <th>장소(주소)</th>
                    <th>참여 현황</th>
                    <th>참가비</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="a" items="${list}">
                    <tr>
                        <td class="text-center">${a.actId}</td>
                        <td>
                            <strong>${act.actTitle}</strong>
                            <small class="d-block text-muted">등록일: <fmt:formatDate value="${a.actLoad}" pattern="yyyy-MM-dd"/></small>
                        </td>
                        <td class="text-center">
                            <span class="small">
                                <fmt:formatDate value="${a.actDate}" pattern="yy-MM-dd HH:mm"/> ~<br>
                                <fmt:formatDate value="${a.actEnd}" pattern="yy-MM-dd HH:mm"/>
                            </span>
                        </td>
                        <td>
                            <span class="addr-text" title="${a.actAddress}">${a.actAddress}</span>
                            <small class="text-primary" style="cursor:pointer" onclick="viewMap('${a.actLat}', '${a.actLon}')">
                                <i class="fas fa-map-marker-alt"></i> 위치보기
                            </small>
                        </td>
                        <td>
                            <div class="d-flex justify-content-between mb-1 small">
                                <span>${a.actCur} / ${a.actMax} 명</span>
                                <span><fmt:formatNumber value="${(a.actCur / a.actMax) * 100}" pattern="0"/>%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar ${a.actCur >= a.actMax ? 'bg-danger' : 'bg-success'}" 
                                     role="progressbar" style="width: ${(a.actCur / a.actMax) * 100}%"></div>
                            </div>
                        </td>
                        <td class="text-center text-primary fw-bold">
                            <fmt:formatNumber value="${a.actMoney}" type="currency" currencySymbol="₩"/>
                        </td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-outline-secondary">수정</button>
                            <button class="btn btn-sm btn-outline-danger">마감</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="activityModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">봉사활동 프로그램 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/insertActivity" method="post">
                <div class="modal-body">
                    <input type="hidden" name="adminId" value="${loginMember.userId}">
                    
                    <div class="mb-3">
                        <label class="form-label">프로그램 명 (ACT_TITLE)</label>
                        <input type="text" class="form-control" name="actTitle" required placeholder="예: [정기] 주말 유기견 산책 봉사">
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">시작 일정 (ACT_DATE)</label>
                            <input type="datetime-local" class="form-control" name="actDate" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">종료 일정 (ACT_END)</label>
                            <input type="datetime-local" class="form-control" name="actEnd" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">활동 주소 (ACT_ADDRESS)</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="address" name="actAddress" readonly required>
                            <button class="btn btn-outline-secondary" type="button" onclick="searchAddress()">주소 검색</button>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">위도 (ACT_LAT)</label>
                            <input type="number" step="0.0000001" class="form-control" id="lat" name="actLat" readonly>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">경도 (ACT_LON)</label>
                            <input type="number" step="0.0000001" class="form-control" id="lon" name="actLon" readonly>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">최대 인원 (ACT_MAX)</label>
                            <input type="number" class="form-control" name="actMax" min="1" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">참가비/후원금액 (ACT_MONEY)</label>
                        <input type="number" class="form-control" name="actMoney" placeholder="0" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-primary">프로그램 게시</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 주소 검색 (카카오 주소 API 등을 연동하면 위도/경도를 쉽게 얻을 수 있습니다)
    function searchAddress() {
        alert("카카오 주소 API 또는 Google Maps API 연동이 필요한 부분입니다.\n현재는 위도/경도 자동 입력을 위한 예시로만 표시됩니다.");
        // 예시 데이터 입력
        document.getElementById('address').value = "서울특별시 강남구 테헤란로 123";
        document.getElementById('lat').value = 37.5012345;
        document.getElementById('lon').value = 127.0396123;
    }

    function viewMap(lat, lon) {
        window.open('https://www.google.com/maps/search/?api=1&query=' + lat + ',' + lon, '_blank');
    }
</script>
</body>
</html>