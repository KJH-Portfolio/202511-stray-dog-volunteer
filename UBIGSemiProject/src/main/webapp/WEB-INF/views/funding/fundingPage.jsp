<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

			<!DOCTYPE html>
			<html lang="ko">

			<head>
				<meta charset="UTF-8">
				<title>펀딩 목록</title>
				<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">

				<style>
					body {
						font-family: 'Noto Sans KR', sans-serif;
						background-color: #f8f9fa;
						margin: 0;
					}

					/* [User Request] Refactored Header to match Community */
					.funding-actions {
						display: flex;
						gap: 10px;
						justify-content: flex-end;
						/* Right align actions */
						margin-bottom: 20px;
					}

					/* Card Container adjustment for community-container */
					.funding-grid {
						display: flex;
						flex-wrap: wrap;
						gap: 20px;
						justify-content: center;
						/* Align left */
					}

					/* ... existing styles ... */


					.search-form {
						display: flex;
						gap: 10px;
					}

					.search-form input {
						padding: 10px 15px;
						border-radius: 30px;
						border: 1px solid #ccc;
						width: 250px;
						transition: border 0.2s;
					}

					.search-form input:focus {
						border-color: var(--primary-color);
						outline: none;
					}

					.search-form button,
					.add-btn {
						padding: 10px 20px;
						border-radius: 30px;
						border: none;
						background: var(--primary-color);
						color: var(--white);
						font-weight: 700;
						cursor: pointer;
						transition: background 0.2s;
					}

					.search-form button:hover,
					.add-btn:hover {
						background: var(--primary-hover);
					}

					/* 카드 컨테이너 */
					.container {
						display: flex;
						flex-wrap: wrap;
						gap: 20px;
						justify-content: center;
					}

					/* 카드 스타일 */
					.card {
						background: var(--white);
						border-radius: 15px;
						box-shadow: var(--shadow-md);
						width: 300px;
						padding: 20px;
						display: flex;
						flex-direction: column;
						justify-content: space-between;
						transition: transform 0.2s;
					}

					.card:hover {
						transform: translateY(-5px);
					}

					.card h3 {
						margin: 0 0 10px 0;
						font-size: 1.5rem;
						color: var(--text-color);
					}

					.card p {
						margin: 5px 0;
						color: #555;
						font-size: 0.95rem;
					}

					.card .amount {
						margin-top: 10px;
						font-weight: 700;
					}

					/* 진행률 */
					.progress-bar {
						width: 100%;
						height: 20px;
						background: #eee;
						border-radius: 20px;
						overflow: hidden;
						margin: 15px 0;
					}

					.progress {
						height: 100%;
						background: var(--primary-color);
					}

					/* 카드 버튼 */
					.card button {
						margin-top: 15px;
						padding: 12px;
						border: none;
						border-radius: 30px;
						background: var(--primary-color);
						color: var(--white);
						font-weight: 700;
						cursor: pointer;
						transition: background 0.2s;
					}

					.card button:hover {
						background: var(--primary-hover);
					}

					/* 반응형 */
					@media (max-width: 1024px) {
						.card {
							width: 45%;
						}
					}

					@media (max-width: 768px) {
						.card {
							width: 100%;
						}

						.funding-header {
							flex-direction: column;
							align-items: flex-start;
							gap: 10px;
						}

						.search-form input {
							width: 100%;
						}
					}
				</style>
			</head>

			<body>

				<jsp:include page="/WEB-INF/views/common/menubar.jsp"></jsp:include>

				<main class="community-container">
					<!-- Standard Page Header -->
					<div class="page-header">
						<div class="page-title">펀딩 목록</div>
						<p class="page-desc">따뜻한 마음을 모아 기적을 만듭니다.</p>
					</div>

					<div class="funding-actions">
						<!-- Search Form -->
						<form action="${pageContext.request.contextPath}/funding/searchKeyword" method="get"
							class="search-form">
							<input type="text" name="searchKeyword" value="${param.keyword}" placeholder="작성자 또는 제목 검색">
							<button type="submit">검색</button>
						</form>

						<!-- Add Funding Button (Admin) -->
						<c:if test="${loginMember.userRole == 'ADMIN'}">
							<form action="${pageContext.request.contextPath}/funding/insertPage" method="get">
								<button type="submit" class="add-btn">펀딩 추가</button>
							</form>
						</c:if>
					</div>

					<!-- Funding Grid -->
					<div class="funding-grid">
						<c:forEach var="funding" items="${list}">
							<div class="card">
								<h3>${funding.fundingTitle}</h3>
								<p><strong>작성자:</strong> ${funding.userId}</p>
								<p>${funding.fundingContent}</p>
								<p class="amount"><strong>목표금액:</strong> ${funding.fundingMaxMoney}원</p>
								<p class="amount"><strong>현재금액:</strong> ${funding.fundingCurrentMoney}원</p>

								<!-- 달성률 계산 -->
								<c:choose>
									<c:when test="${funding.fundingMaxMoney > 0}">
										<c:set var="fundingRate"
											value="${funding.fundingCurrentMoney * 100.0 / funding.fundingMaxMoney}" />
									</c:when>
									<c:otherwise>
										<c:set var="fundingRate" value="0" />
									</c:otherwise>
								</c:choose>

								<!-- 달성률 표시 -->
								<p><strong>달성률:</strong>
									<fmt:formatNumber value="${fundingRate}" type="number" maxFractionDigits="2" />%
								</p>

								<div class="progress-bar">
									<div class="progress"
										style="width: <c:out value='${fundingRate}'/>%; min-width:1%;">
									</div>
								</div>

								<form action="${pageContext.request.contextPath}/funding/fundingDetailView"
									method="get">
									<input type="hidden" name="fundingNo" value="${funding.fundingNo}">
									<button type="submit">펀딩 참여하기</button>
								</form>
							</div>
						</c:forEach>
					</div>

					<div id="pagingArea">
						<ul class="pagination">

							<!-- 이전 -->
							<c:if test="${pi.currentPage > 1}">
								<li class="page-item">
									<a class="page-link"
										href="${pageContext.request.contextPath}/funding/searchKeyword?curPage=${pi.currentPage - 1}&searchKeyword=${keyword}">Prev</a>
								</li>
							</c:if>

							<!-- 페이지 번호 -->
							<c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
								<c:choose>
									<c:when test="${p == pi.currentPage}">
										<li class="page-item active"><a class="page-link" href="#">${p}</a></li>
									</c:when>
									<c:otherwise>
										<li class="page-item">
											<a class="page-link"
												href="${pageContext.request.contextPath}/funding/searchKeyword?curPage=${p}&searchKeyword=${keyword}">${p}</a>
										</li>
									</c:otherwise>
								</c:choose>
							</c:forEach>

							<!-- 다음 -->
							<c:if test="${pi.currentPage < pi.maxPage}">
								<li class="page-item">
									<a class="page-link"
										href="${pageContext.request.contextPath}/funding/searchKeyword?curPage=${pi.currentPage + 1}&searchKeyword=${keyword}">Next</a>
								</li>
							</c:if>

						</ul>
					</div>

				</main>
			</body>

			</html>