<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>UBIG - 입양 친구들 소개</title>
			<!-- Bootstrap 5 CSS -->
			<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
				<h1 class="adoption-header">입양 친구들을 소개합니다</h1>

				<!-- CSS 스타일 추가 -->
				<style>
					.search-filter-container {
						background-color: #f8f9fa;
						border-radius: 15px;
						box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
						padding: 25px;
						margin-bottom: 30px;
					}

					.filter-label {
						color: #495057;
						font-weight: 700;
						margin-bottom: 10px;
						display: block;
						font-size: 0.95rem;
					}

					.form-check-inline {
						margin-right: 1.5rem;
					}

					.form-check-input:checked {
						background-color: var(--primary-color);
						border-color: var(--primary-color);
					}

					.custom-input-group {
						box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
					}

					.btn-search {
						padding: 6px 20px;
						font-weight: 600;
						border-radius: 6px;
						transition: all 0.2s;
						font-size: 0.9rem;
					}

					.btn-search:hover {
						transform: translateY(-2px);
						box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
					}
				</style>

				<!-- 검색 필터 섹션 -->
				<div class="search-filter-container">
					<form action="adoption.mainpage" method="get">
						<!-- Row 1: 5개 항목 한줄 (축종, 성별, 중성화, 나이, 몸무게) -->
						<div class="row g-2 mb-2">
							<!-- 1. 축종 -->
							<div class="col-auto">
								<label class="filter-label">축종</label>
								<div class="bg-white p-2 rounded border">
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="species" value="1" id="dog"
											${filter.species==1 ? 'checked' : '' }>
										<label class="form-check-label" for="dog">강아지</label>
									</div>
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="species" value="2" id="cat"
											${filter.species==2 ? 'checked' : '' }>
										<label class="form-check-label" for="cat">고양이</label>
									</div>
								</div>
							</div>

							<!-- 2. 성별 -->
							<div class="col-auto">
								<label class="filter-label">성별</label>
								<div class="bg-white p-2 rounded border">
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="gender" value="1" id="male"
											${filter.gender==1 ? 'checked' : '' }>
										<label class="form-check-label" for="male">수컷</label>
									</div>
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="gender" value="2" id="female"
											${filter.gender==2 ? 'checked' : '' }>
										<label class="form-check-label" for="female">암컷</label>
									</div>
								</div>
							</div>

							<!-- 3. 중성화 -->
							<div class="col-auto">
								<label class="filter-label">중성화 여부</label>
								<div class="bg-white p-2 rounded border">
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="neutered" value="1"
											id="neuteredY" ${filter.neutered==1 ? 'checked' : '' }>
										<label class="form-check-label" for="neuteredY">완료</label>
									</div>
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="neutered" value="0"
											id="neuteredN" ${filter.neutered==0 ? 'checked' : '' }>
										<label class="form-check-label" for="neuteredN">미완료</label>
									</div>
								</div>
							</div>

							<!-- 4. 나이 범위 -->
							<div class="col-auto">
								<label class="filter-label">나이 (살)</label>
								<div class="bg-white p-2 rounded border">
									<div class="input-group input-group-sm custom-input-group">
										<input type="number" class="form-control input-short" name="ageMin"
											placeholder="최소" value="${filter.ageMin}" step="0.1" min="0" max="99"
											onchange="if(this.value){ let v=parseFloat(this.value); if(v<0)v=0; if(v>99)v=99; this.value=v.toFixed(1); }">
										<span class="input-group-text bg-light">~</span>
										<input type="number" class="form-control input-short" name="ageMax"
											placeholder="최대" value="${filter.ageMax}" step="0.1" min="0" max="99"
											onchange="if(this.value){ let v=parseFloat(this.value); if(v<0)v=0; if(v>99)v=99; this.value=v.toFixed(1); }">
									</div>
								</div>
							</div>

							<!-- 5. 몸무게 범위 -->
							<div class="col-auto">
								<label class="filter-label">몸무게 (kg)</label>
								<div class="bg-white p-2 rounded border">
									<div class="input-group input-group-sm custom-input-group">
										<input type="number" class="form-control input-short" name="weightMin"
											placeholder="최소" value="${filter.weightMin}" step="0.1" min="0" max="99"
											onchange="if(this.value){ let v=parseFloat(this.value); if(v<0)v=0; if(v>99)v=99; this.value=v.toFixed(1); }">
										<span class="input-group-text bg-light">~</span>
										<input type="number" class="form-control input-short" name="weightMax"
											placeholder="최대" value="${filter.weightMax}" step="0.1" min="0" max="99"
											onchange="if(this.value){ let v=parseFloat(this.value); if(v<0)v=0; if(v>99)v=99; this.value=v.toFixed(1); }">
									</div>
								</div>
							</div>
						</div>

						<!-- Row 2: 2개 항목 한줄 (희망 지역, 이름 검색) -->
						<div class="row g-2 align-items-end">
							<!-- 6. 지역 -->
							<div class="col-md-6">
								<label class="filter-label">희망 지역</label>
								<input type="text" class="form-control form-control-sm" name="hopeRegion"
									placeholder="예: 서울, 경기" value="${filter.hopeRegion}" maxlength="10">
							</div>

							<!-- 7. 검색어 (이름) -->
							<div class="col-md-6">
								<label class="filter-label">이름 검색</label>
								<input type="text" class="form-control form-control-sm" name="keyword"
									placeholder="동물 이름 입력" value="${filter.keyword}" maxlength="10">
							</div>



							<!-- 검색 버튼 -->
							<div class="col-12 text-center mt-4">
								<button type="submit" class="btn btn-primary btn-search mx-2">조건 검색</button>
								<a href="adoption.mainpage" class="btn btn-outline-secondary btn-search mx-2">초기화</a>
							</div>
						</div>
					</form>
				</div>

				<div class="adoption-grid" id="adoptionGrid">
					<c:choose>
						<c:when test="${adoptionList.size() eq 0}">
							<div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
								<p>등록된 게시글이 없습니다.</p>
							</div>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${adoptionList}">
								<div class="adoption-card" data-anino="${item.animalNo}">
									<div class="card-image-wrapper">
										<img src="${pageContext.request.contextPath}/resources/download/adoption/${item.photoUrl}"
											class="card-image" alt="사진">
										<!-- 입양 상태 표시 -->
										<c:if test="${not empty item.adoptionStatus}">
											<span class="status-badge">${item.adoptionStatus}</span>
										</c:if>
									</div>
									<div class="card-content">
										<div class="card-title">${item.animalName}</div>
										<div class="card-details">
											나이: ${item.animalAge}세<br>
											성별:
											<c:choose>
												<c:when test="${item.animalGender eq '1'}">수컷</c:when>
												<c:when test="${item.animalGender eq '2'}">암컷</c:when>
												<c:otherwise>알 수 없음</c:otherwise>
											</c:choose><br>
											몸무게: ${item.animalWeight}kg<br>
											지역: ${item.hopeRegion}
										</div>
									</div>
								</div>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- 페이징 -->
				<div id="paging">
					<c:choose>
						<c:when test="${pi.currentPage eq 1}">
							<button class="pagination-btn" disabled>&lt;</button>
						</c:when>
						<c:otherwise>
							<button class="pagination-btn prev-btn">&lt;</button>
						</c:otherwise>
					</c:choose>

					<c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
						<c:choose>
							<c:when test="${p eq pi.currentPage}">
								<button class="pagination-btn active">${p}</button>
							</c:when>
							<c:otherwise>
								<button class="pagination-btn">${p}</button>
							</c:otherwise>
						</c:choose>
					</c:forEach>

					<c:choose>
						<c:when test="${pi.currentPage >= pi.maxPage}">
							<button class="pagination-btn" disabled>&gt;</button>
						</c:when>
						<c:otherwise>
							<button class="pagination-btn next-btn">&gt;</button>
						</c:otherwise>
					</c:choose>
				</div>

				<div class="btn-group">
					<c:if test="${not empty loginMember}">
						<button id="enroll" class="btn-primary">입양 글 등록하기</button>
					</c:if>
					<c:if test="${not empty loginMember && loginMember.userRole eq 'ADMIN'}">
						<button id="postManage" class="btn-secondary">입양 글 관리하기(관리자 전용)</button>
					</c:if>
				</div>
			</div>

		</body>
		<!-- Bootstrap 5 JS Bundle -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

		<script>
			document.addEventListener("DOMContentLoaded", function () {
				const adInsert = document.querySelector("#enroll");
				const paging = document.querySelector("#paging");
				const postManage = document.querySelector("#postManage"); // Added this line

				// 입양 디테일 페이지 이동 (이벤트 위임)
				const adoptionGrid = document.querySelector("#adoptionGrid");
				if (adoptionGrid) {
					adoptionGrid.addEventListener('click', function (e) {
						const card = e.target.closest('.adoption-card');

						if (card && card.dataset.anino) {
							const aniNo = card.dataset.anino;
							location.href = 'adoption.detailpage?anino=' + aniNo;
						}
					});
				}

				// 입양동물 등록 페이지로 이동
				if (adInsert) {
					adInsert.addEventListener('click', function () {
						location.href = 'adoption.enrollpageanimal';
					});
				}

				//입양 관리 페이지로 이동
				if (postManage) {
					postManage.addEventListener('click', function () {
						location.href = 'adoption.postmanage';
					});
				}


				// 페이징 처리
				if (paging) {
					paging.addEventListener('click', function (e) {
						const btn = e.target;
						if (btn.tagName === "BUTTON" && !btn.disabled) {
							let page = btn.textContent;
							const currentPage = parseInt('${pi.currentPage}');

							// 이전/다음 버튼 처리
							if (btn.classList.contains("prev-btn")) {
								page = currentPage - 1;
							} else if (btn.classList.contains("next-btn")) {
								page = currentPage + 1;
							}

							if (!isNaN(page)) {
								// 기존 URL 파라미터 유지
								const urlParams = new URLSearchParams(window.location.search);
								urlParams.set('page', page);
								location.href = 'adoption.mainpage?' + urlParams.toString();
							}
						}
					});
				}
			});
		</script>

		</html>