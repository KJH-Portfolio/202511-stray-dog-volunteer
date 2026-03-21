<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>봉사활동 신청자 목록</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<style>
    body { font-family: 'Malgun Gothic', sans-serif; padding: 20px; }
    h2 { border-bottom: 2px solid #ccc; padding-bottom: 10px; }
    
    /* 상단 버튼 영역 */
    .top-btn-area { text-align: right; margin-bottom: 10px; }

    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
    th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
    th { background-color: #f0f0f0; }
    
    .btn-back { 
        display: inline-block; margin-top: 20px; padding: 10px 20px; 
        background-color: #555; color: white; text-decoration: none; border-radius: 4px;
    }
    .empty-alert { text-align: center; padding: 30px; font-weight: bold; color: #777; }
    
    /* 상태값 색상 */
    .status-wait { color: orange; font-weight: bold; }
    .status-ok { color: green; font-weight: bold; }
    .status-no { color: red; font-weight: bold; }
    .status-done { color: blue; font-weight: bold; }

    /* 버튼 스타일 */
    .btn-action {
        padding: 5px 10px; border: none; border-radius: 4px;
        cursor: pointer; font-size: 12px; margin: 0 2px; color: white;
    }
    .btn-approve { background-color: #28a745; }
    .btn-reject { background-color: #dc3545; }
    .btn-cancel { background-color: #6c757d; }
    .btn-action:hover { opacity: 0.8; }

    /* 일괄 처리 버튼 */
    .btn-batch {
        padding: 10px 20px; background-color: #007bff; color: white; 
        border: none; border-radius: 5px; font-weight: bold; cursor: pointer;
    }
    .btn-batch:hover { background-color: #0056b3; }
    
    .btn-batch:disabled {
        background-color: #ccc; cursor: not-allowed;
    }
    
    /* 체크박스 크기 키우기 */
    input[type=checkbox] { transform: scale(1.2); cursor: pointer; }
</style>
</head>
<body>

    <h2>👥 신청자 현황</h2>

    <jsp:useBean id="now" class="java.util.Date" />
    <fmt:formatDate value="${now}" pattern="yyyyMMdd" var="todayStr" />
    <fmt:formatDate value="${activity.actEnd}" pattern="yyyyMMdd" var="actEndStr" />

    <c:if test="${sessionScope.loginMember.userRole eq 'ADMIN'}">
        <div class="top-btn-area">
            <c:choose>
                <c:when test="${todayStr >= actEndStr}">
                    <button type="button" class="btn-batch" onclick="batchComplete()">
                        ✅ 선택된 회원 활동완료 처리
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="button" class="btn-batch" disabled title="활동 종료일이 지나야 가능합니다">
                        ⏳ 활동 종료 후 처리가능
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty signList}">
            <div class="empty-alert">현재 신청자가 없습니다.</div>
        </c:when>
        
        <c:otherwise>
            <table>
                <thead>
                    <tr>
                        <c:if test="${sessionScope.loginMember.userRole eq 'ADMIN'}">
                            <th width="5%"><input type="checkbox" id="chkAll" onclick="toggleAll(this)"></th>
                        </c:if>
                        
                        <th>신청번호</th>
                        <th>신청자ID</th>
                        <th>신청일</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="sign" items="${signList}">
                        <tr>
                            <c:if test="${sessionScope.loginMember.userRole eq 'ADMIN'}">
                                <td>
                                    <c:if test="${sign.signsStatus == 1}">
                                        <input type="checkbox" name="signsNo" value="${sign.signsNo}" class="chk-row">
                                    </c:if>
                                </td>
                            </c:if>

                            <td>${sign.signsNo}</td>
                            <td>${sign.signsId}</td>
                            <td><fmt:formatDate value="${sign.signsDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                            
                            <td>
                                <c:choose>
                                    <c:when test="${sign.signsStatus == 0}"><span class="status-wait">대기중</span></c:when>
                                    <c:when test="${sign.signsStatus == 1}"><span class="status-ok">승인됨</span></c:when>
                                    <c:when test="${sign.signsStatus == 2}"><span class="status-no">반려됨</span></c:when>
                                    <c:when test="${sign.signsStatus == 3}"><span class="status-no" style="color:gray;">취소됨</span></c:when>
                                    <c:when test="${sign.signsStatus == 4}"><span class="status-done">🏅 활동완료</span></c:when>
                                    <c:otherwise><span>${sign.signsStatus}</span></c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:if test="${sessionScope.loginMember.userRole eq 'ADMIN'}">
                                    <c:if test="${sign.signsStatus == 0}">
                                        <button type="button" class="btn-action btn-approve" onclick="updateAdmin(${sign.signsNo}, 'approve')">승인</button>
                                        <button type="button" class="btn-action btn-reject" onclick="updateAdmin(${sign.signsNo}, 'reject')">반려</button>
                                    </c:if>
                                    </c:if>

                                <c:if test="${sessionScope.loginMember.userId eq sign.signsId}">
                                    <c:if test="${sign.signsStatus == 0 or sign.signsStatus == 1}">
                                        <button type="button" class="btn-action btn-cancel" onclick="updateUser(${sign.signsNo})">신청취소</button>
                                    </c:if>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <a href="volunteerDetail.vo?actId=${param.actId}" class="btn-back">뒤로 가기</a>

    <script>
    // 1. 전체 선택/해제 기능
    function toggleAll(source) {
        const checkboxes = document.querySelectorAll('.chk-row');
        checkboxes.forEach(cb => cb.checked = source.checked);
    }

    // 2. [일괄] 활동 완료 처리
    function batchComplete() {
        // 체크된 박스 찾기
        const checkedList = document.querySelectorAll('.chk-row:checked');
        
        if(checkedList.length === 0) {
            alert("활동 완료 처리할 회원을 선택해주세요.");
            return;
        }

        if(!confirm(checkedList.length + "명의 회원을 '활동완료' 처리 하시겠습니까?\n(처리 후에는 되돌릴 수 없습니다)")) {
            return;
        }

        // 체크된 번호들을 배열에 담기
        let signsNos = [];
        checkedList.forEach(cb => signsNos.push(cb.value));

        // AJAX 전송
        $.ajax({
            url: "updateSignStatusAdminMulti.vo",
            type: "post",
            data: { signsNos: signsNos }, // 배열 전송
            success: function(result) {
                if(result === "success") {
                    alert("✅ 일괄 처리가 완료되었습니다.");
                    location.reload();
                } else if(result === "empty") {
                    alert("선택된 회원이 없습니다.");
                } else {
                    alert("처리 중 오류가 발생했습니다.");
                }
            },
            error: function() {
                alert("서버 통신 오류");
            }
        });
    }

    // 3. [개별] 승인/반려 (기존 로직 유지)
    function updateAdmin(signsNo, statusType) {
        var msg = (statusType === 'approve') ? "승인하시겠습니까?" : "반려하시겠습니까?";
        if(confirm(msg)) {
            $.ajax({
                url: "updateSignStatusAdmin.vo",
                type: "post",
                data: { signsNo: signsNo, status: statusType },
                success: function(result) {
                    if(result === "success") location.reload(); 
                    else if(result === "full") alert("⚠️ 정원 초과!");
                    else alert("처리 실패");
                },
                error: function() { alert("통신 오류"); }
            });
        }
    }

    // 4. [사용자] 취소 (기존 로직 유지)
    function updateUser(signsNo) {
        if(confirm("정말 취소하시겠습니까?")) {
            $.ajax({
                url: "updateSignStatusUser.vo",
                type: "post",
                data: { signsNo: signsNo },
                success: function(result) {
                    if(result === "success") location.reload();
                    else alert("취소 실패");
                },
                error: function() { alert("통신 오류"); }
            });
        }
    }
    </script>
</body>
</html>