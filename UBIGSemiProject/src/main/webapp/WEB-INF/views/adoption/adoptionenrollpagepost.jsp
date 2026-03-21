<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>UBIG - 게시글 등록</title>
			<!-- Global Style -->
			<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
			<!-- Adoption Specific Style -->
			<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adoption-style.css">
		</head>

		<body>
			<jsp:include page="/WEB-INF/views/common/menubar.jsp" />
			<c:if test="${not empty alertMsgAd}">
				<script>
					alert(`${alertMsgAd}`);
				</script>
				<c:remove var="alertMsgAd" scope="session" />
			</c:if>

			<div class="adoption-container">
				<h1 class="adoption-header">입양 등록(관리자) 페이지</h1>

				<form action="adoption.insert.board" method="POST" class="adoption-form">
					<h3>[게시글 등록]</h3>

					<label>게시물 제목 (자동 입력)</label>
					<input type="hidden" name="postTitle" value="더미">
					<input type="text" value="더미" disabled>

					<label>작성자 아이디 (동물 원래 주인)</label>
					<input type="text" name="userId" value="${ownerId}" readonly>

					<label>동물 고유 번호</label>
					<input type="number" name="animalNo" placeholder="숫자만 입력" value="${anino}" min="1" ${not empty anino
						? 'readonly' : '' }>

					<div class="text-center mt-20">
						<input type="submit" value="게시글 등록하기" class="btn-primary">
					</div>
				</form>
			</div>

		</body>

		</html>