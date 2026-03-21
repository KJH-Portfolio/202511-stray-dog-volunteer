<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>UBIG - 입양 동물 관리</title>
            <!-- Global Style -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
            <!-- Adoption Specific Style -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/adoption-style.css">
        </head>

        <body>
            <jsp:include page="/WEB-INF/views/common/menubar.jsp" />
            <div class="adoption-container">
                <h1 class="adoption-header">동물 관리</h1>

                <!-- 검색 필터 영역 -->
                <div class="search-area"
                    style="margin-bottom: 20px; display: flex; justify-content: flex-end; align-items: center; gap: 10px;">
                    <form action="adoption.postmanage" method="get"
                        style="display: flex; align-items: center; gap: 10px;">
                        <input type="number" name="animalNo" placeholder="동물 번호 검색" value="${animalNo}"
                            style="padding: 5px; border: 1px solid #ccc; border-radius: 4px;">
                        <label style="display: flex; align-items: center; gap: 5px; cursor: pointer;">
                            <input type="checkbox" name="onlyPending" value="true" ${onlyPending eq 'true' ? 'checked'
                                : '' } onchange="this.form.submit()">
                            대기 중인 게시글만 보기
                        </label>
                        <button type="submit" class="btn-primary" style="padding: 5px 15px;">검색</button>
                    </form>
                </div>

                <div style="overflow-x: auto;">
                    <table class="adoption-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>이름</th>
                                <th>종류</th>
                                <th>품종</th>
                                <th>성별</th>
                                <th>나이</th>
                                <th>입양상태</th>
                                <th>지역</th>
                                <th>사진</th>
                                <th style="min-width: 150px;">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty list}">
                                    <tr>
                                        <td colspan="10" align="center">등록된 동물이 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="item" items="${list}">
                                        <tr onclick="location.href='adoption.detailpage?anino=${item.animalNo}'">
                                            <td>${item.animalNo}</td>
                                            <td>${item.animalName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.species eq 1}">강아지</c:when>
                                                    <c:when test="${item.species eq 2}">고양이</c:when>
                                                    <c:otherwise>기타</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${item.breed}</td>
                                            <td>${item.gender eq 1 ? '남아' : '여아'}</td>
                                            <td>${item.age}살</td>
                                            <td>${item.adoptionStatus}</td>
                                            <td>${item.hopeRegion}</td>
                                            <td><img src="${pageContext.request.contextPath}/resources/download/adoption/${item.photoUrl}"
                                                    alt="동물 사진" width="50" height="50"></td>
                                            <td>
                                                <div style="display: flex; gap: 5px; flex-direction: column;">
                                                    <button type="button" class="btn-secondary"
                                                        style="padding: 5px 10px; font-size: 0.8rem;"
                                                        onclick="event.stopPropagation(); location.href='adoption.updateanimal?anino=${item.animalNo}'">수정</button>
                                                    <button type="button" class="btn-secondary"
                                                        style="padding: 5px 10px; font-size: 0.8rem;"
                                                        onclick="event.stopPropagation(); if(confirm('정말 삭제하시겠습니까?')) location.href='adoption.deleteanimal?anino=${item.animalNo}'">삭제</button>

                                                    <c:if test="${item.postNo eq 0 && item.adoptionStatus ne '반려'}">
                                                        <button type="button" class="btn-primary"
                                                            style="padding: 5px 10px; font-size: 0.8rem;"
                                                            onclick="event.stopPropagation(); if(confirm('게시글을 등록하시겠습니까?')) location.href='adoption.insert.board.direct?anino=${item.animalNo}'">게시글
                                                            등록</button>
                                                    </c:if>

                                                    <c:if test="${item.adoptionStatus ne '반려'}">
                                                        <button type="button" class="btn-primary"
                                                            style="padding: 5px 10px; font-size: 0.8rem; background-color: #ff4444; border-color: #ff4444;"
                                                            onclick="event.stopPropagation(); if(confirm('게시글을 반려하시겠습니까?')) location.href='adoption.deny.board.direct?anino=${item.animalNo}'">
                                                            ${item.postNo eq 0 ? '등록 반려' : '게시글 반려'}
                                                        </button>
                                                    </c:if>

                                                    <c:if test="${item.postNo ne 0 && item.adoptionStatus ne '반려'}">
                                                        <span
                                                            style="font-size: 0.8rem; color: green; text-align: center;">등록됨</span>
                                                    </c:if>
                                                    <c:if test="${item.adoptionStatus eq '반려'}">
                                                        <span
                                                            style="font-size: 0.8rem; color: red; text-align: center;">등록
                                                            반려</span>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- 페이징 처리 -->
                <div align="center" style="margin-top: 20px;">
                    <c:if test="${pi.currentPage ne 1}">
                        <button class="btn-secondary"
                            onclick="location.href='adoption.postmanage?currentPage=${pi.currentPage-1}&animalNo=${animalNo}&onlyPending=${onlyPending}'">&lt;</button>
                    </c:if>

                    <c:forEach var="p" begin="${pi.startPage}" end="${pi.endPage}">
                        <c:choose>
                            <c:when test="${p eq pi.currentPage}">
                                <button class="btn-primary" disabled>${p}</button>
                            </c:when>
                            <c:otherwise>
                                <button class="btn-secondary"
                                    onclick="location.href='adoption.postmanage?currentPage=${p}&animalNo=${animalNo}&onlyPending=${onlyPending}'">${p}</button>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${pi.currentPage ne pi.maxPage}">
                        <button class="btn-secondary"
                            onclick="location.href='adoption.postmanage?currentPage=${pi.currentPage+1}&animalNo=${animalNo}&onlyPending=${onlyPending}'">&gt;</button>
                    </c:if>
                </div>
            </div>

            <script>
                // 알림 메시지 처리
                <c:if test="${not empty sessionScope.alertMsgAd}">
                    alert(`${sessionScope.alertMsgAd}`);
                    <c:remove var="alertMsgAd" scope="session" />
                </c:if>
            </script>
        </body>

        </html>