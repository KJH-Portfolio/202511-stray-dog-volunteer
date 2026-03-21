<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 작성 | 관리자 모드</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .form-container { 
            max-width: 1000px; 
            margin: 50px auto; 
            background: #ffffff; 
            padding: 40px; 
            border-radius: 12px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.1); 
        }
        .form-label { font-weight: bold; color: #333; margin-top: 10px; }
        .required-star { color: #dc3545; }
        .notice-header { border-bottom: 2px solid #0d6efd; padding-bottom: 15px; margin-bottom: 30px; }
    </style>
</head>
<body class="bg-light">

<div class="container">
    <div class="form-container">
        <div class="notice-header d-flex justify-content-between align-items-center">
            <h2 class="mb-0 text-primary"><i class="fas fa-bullhorn"></i> 공지사항 등록</h2>
            <span class="text-muted small">* 모든 항목은 필수 입력입니다.</span>
        </div>

        <form action="${pageContext.request.contextPath}/admin/insertBoard" method="post" enctype="multipart/form-data">
            
            <input type="hidden" name="userId" value="${loginMember.userId}">
            
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">게시글 유형 <span class="required-star">*</span></label>
                    <select name="category" class="form-select" required>
                        <option value="NOTICE" selected>공지사항 (NOTICE)</option>
                        <option value="FREE">자유게시판 (FREE)</option>
                        <option value="REQUEST">요청 (REQUEST)</option>
                        <option value="REVIEW">후기 (REVIEW)</option>
                    </select>
                </div>

                <div class="col-md-8">
                    <label for="title" class="form-label">제목 <span class="required-star">*</span></label>
                    <input type="text" class="form-control" id="title" name="title" 
                           maxlength="100" placeholder="공지사항 제목을 입력하세요 (최대 100자)" required>
                </div>

                <div class="col-12 mt-4">
                    <label for="content" class="form-label">내용 <span class="required-star">*</span></label>
                    <textarea class="form-control" id="content" name="content" rows="15" 
                              maxlength="4000" placeholder="내용을 입력하세요 (최대 4000자)" required 
                              style="resize: none; background-color: #fafafa;"></textarea>
                    <div class="text-end text-muted mt-1">
                        <span id="charCount">0</span> / 4000자
                    </div>
                </div>

                <div class="col-12 mt-3">
                    <label class="form-label"><i class="fas fa-file-import"></i> 첨부파일</label>
                    <input type="file" class="form-control" name="upfiles" multiple>
                    <small class="text-secondary">여러 파일을 선택할 수 있습니다.</small>
                </div>

                <div class="col-12 mt-4">
                    <div class="alert alert-light border small text-muted">
                        <i class="fas fa-info-circle"></i> 
                        등록 시 <strong>등록일(CREATE_DATE)</strong>은 현재 시간으로, 
                        <strong>조회수(VIEW_COUNT)</strong>는 0으로, 
                        <strong>삭제여부(IS_DELETED)</strong>는 'N'으로 자동 설정됩니다.
                    </div>
                </div>

                <div class="col-12 d-flex justify-content-center gap-2 mt-4">
                    <button type="button" class="btn btn-secondary btn-lg px-5" onclick="history.back();">취소</button>
                    <button type="submit" class="btn btn-primary btn-lg px-5">공지 등록</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    // 글자수 체크 스크립트
    const contentArea = document.getElementById('content');
    const charCount = document.getElementById('charCount');

    contentArea.addEventListener('input', () => {
        const length = contentArea.value.length;
        charCount.innerText = length;
        
        if(length >= 4000) {
            charCount.style.color = 'red';
        } else {
            charCount.style.color = '#666';
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>