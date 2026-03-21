<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 관리 | 관리자 센터</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .notice-container { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .table thead th { background-color: #f8f9fa; border-bottom: 2px solid #dee2e6; }
        .notice-fixed { background-color: #fff9db; } /* 중요 공지 배경색 */
        .text-ellipsis { max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    </style>
</head>
<body class="bg-light">

<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-bullhorn text-primary"></i> 공지사항 관리</h2>
        <div>
            <button class="btn btn-primary" onclick="location.href='${pageContext.request.contextPath}/admin/insertBoardPage'">
                <i class="fas fa-pen"></i> 신규 공지 작성
            </button>
        </div>
    </div>

    <div class="row mb-3">
        <div class="col-md-6">
            <div class="btn-group" role="group">
                <button type="button" class="btn btn-outline-secondary active">전체</button>
                <button type="button" class="btn btn-outline-secondary">게시중</button>
                <button type="button" class="btn btn-outline-secondary">삭제됨</button>
            </div>
        </div>
        <div class="col-md-6">
            <div class="input-group">
                <input type="text" class="form-control" placeholder="제목 또는 내용 검색">
                <button class="btn btn-outline-primary">검색</button>
            </div>
        </div>
    </div>

    <div class="notice-container">
        <table class="table table-hover align-middle">
            <thead>
                <tr class="text-center">	
                    <th style="width: 80px;">번호</th>
                    <th>제목</th>
                    <th style="width: 120px;">작성자</th>
                    <th style="width: 120px;">조회수</th>
                    <th style="width: 150px;">등록일</th>
                    <th style="width: 100px;">상태</th>
                    <th style="width: 180px;">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="b" items="${list}">
                    <tr class="${b.isDeleted == 'Y' ? 'table-light text-muted' : ''}">
                        <td class="text-center">${b.boardId}</td>
                        <td>
                            <div class="text-ellipsis">
                                <a href="/notice/detail?id=${b.boardId}" class="text-decoration-none fw-bold text-dark">
                                    ${b.title}
                                </a>
                                <%-- <c:if test="${not empty b.attachments}">
                                    <i class="fas fa-paperclip ms-1 text-secondary small"></i>
                                </c:if> --%>
                            </div>
                        </td>
                        <td class="text-center">${b.userId}</td>
                        <td class="text-center">${b.viewCount}</td>
                        <td class="text-center">
                            <fmt:formatDate value="${b.createDate}" pattern="yyyy-MM-dd"/>
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${b.isDeleted == 'N'}">
                                    <span class="badge bg-success">게시중</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">삭제됨</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-outline-dark" onclick="location.href='/admin/notice/edit/${b.boardId}'">
                                <i class="fas fa-edit"></i> 수정
                            </button>
                            <c:if test="${b.isDeleted == 'N'}">
                                <button class="btn btn-sm btn-outline-danger" onclick="deleteNotice('${b.boardId}')">
                                    <i class="fas fa-trash"></i> 삭제
                                </button>
                            </c:if>
                            <c:if test="${b.isDeleted == 'Y'}">
                                <button class="btn btn-sm btn-outline-primary" onclick="restoreNotice('${b.boardId}')">
                                    <i class="fas fa-undo"></i> 복구
                                </button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item disabled"><a class="page-link" href="#">이전</a></li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#">3</a></li>
                <li class="page-item"><a class="page-link" href="#">다음</a></li>
            </ul>
        </nav>
    </div>
</div>

<script>
    function deleteNotice(boardId) {
        if(confirm("해당 공지사항을 삭제 처리하시겠습니까?\n(데이터는 보존되며 사용자에게만 노출되지 않습니다.)")) {
            location.href = "/admin/notice/delete?id=" + boardId;
        }
    }

    function restoreNotice(boardId) {
        if(confirm("삭제된 공지사항을 다시 게시하시겠습니까?")) {
            location.href = "/admin/notice/restore?id=" + boardId;
        }
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>