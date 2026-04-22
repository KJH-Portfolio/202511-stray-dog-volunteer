<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <c:if test="${empty sessionScope.loginMember}">
                <script>
                    alert("로그인이 필요한 서비스입니다.");
                    location.href = "${pageContext.request.contextPath}/user/login.me";
                </script>
            </c:if>

            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <title>유봉일공 - 마이페이지</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Outfit:wght@300;500;700&display=swap"
                    rel="stylesheet">

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

                <link rel="stylesheet" href="<c:url value='/resources/css/style.css'/>">

                <style>
                    body {
                        background-color: var(--body-bg);
                        padding-top: 120px;
                    }

                    .mypage-header {
                        background-color: var(--primary-color);
                        color: var(--white);
                        padding: 40px 0;
                        margin-bottom: 30px;
                    }

                    .sidebar-menu .list-group-item {
                        border: none;
                        padding: 15px 20px;
                        font-weight: 500;
                        color: #495057;
                    }

                    .sidebar-menu .list-group-item.active {
                        background-color: var(--primary-color);
                        border-color: var(--primary-color);
                        color: var(--white);
                        font-weight: 700;
                    }

                    .sidebar-menu .list-group-item:hover:not(.active) {
                        background-color: #ffeeba;
                        color: #212529;
                    }

                    .stat-card {
                        border-left: 5px solid var(--primary-color);
                        transition: transform 0.2s;
                    }

                    .stat-card:hover {
                        transform: translateY(-5px);
                    }

                    .readonly-input {
                        background-color: #e9ecef;
                        cursor: not-allowed;
                    }

                    .error-msg {
                        color: #ff6b6b;
                        font-size: 0.8rem;
                        display: none;
                    }

                    #myadoption2 .table td,
                    #myadoption2 .table th {
                        vertical-align: middle;
                    }

                    .btn-xs {
                        padding: 0.1rem 0.3rem;
                        font-size: 0.75rem;
                    }
                </style>
            </head>

            <body>

                <c:if test="${not empty sessionScope.alertMsgAd}">
                    <script>
                        alert(`${sessionScope.alertMsgAd}`);
                    </script>
                    <c:remove var="alertMsgAd" scope="session" />
                </c:if>
                <%@ include file="/WEB-INF/views/common/menubar.jsp" %>

                    <div class="mypage-header text-center">
                        <div class="container">
                            <h2 class="fw-bold">MY PAGE</h2>
                            <p class="lead mb-0">안녕하세요, <strong>${loginMember.userNickname}</strong>님!</p>
                            <div class="mt-3">
                                <span class="badge bg-light text-dark fs-6 p-2">
                                    🐶 봉사활동 참여 횟수: <span
                                        class="text-danger fw-bold">${loginMember.userAttendedCount}</span>회
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="container pb-5">
                        <div class="row">

                            <div class="col-lg-3 mb-4">
                                <div class="card shadow-sm">
                                    <div class="card-header bg-white fw-bold py-3">
                                        마이 메뉴
                                    </div>
                                    <div class="list-group list-group-flush sidebar-menu" id="myMenu">
                                        <button id="myupdate" class="list-group-item list-group-item-action active">내 정보
                                            수정</button>
                                        <button id="myvolunteer" class="list-group-item list-group-item-action">봉사 신청
                                            내역</button>
                                        <button id="myadoption" class="list-group-item list-group-item-action">입양 신청
                                            내역</button>
                                        <button id="myboard" class="list-group-item list-group-item-action">내가 쓴
                                            글</button>

                                        <form action="${pageContext.request.contextPath}/user/delete.me" method="post">
                                            <button id="delete"
                                                class="list-group-item list-group-item-action text-danger"
                                                onclick="return deleteMember();">회원 탈퇴</button>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-9">
                                <div class="card shadow-sm">

                                    <div class="card-body p-4" id="myupdate2">
                                        <h4 class="mb-4 fw-bold border-bottom pb-2">내 정보 수정</h4>
                                        <form action="${pageContext.request.contextPath}/user/update.me" method="post"
                                            id="updateForm">
                                            <input type="hidden" name="userId" value="${loginMember.userId}">

                                            <div class="row mb-3">
                                                <label class="col-sm-3 col-form-label fw-bold">아이디</label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="form-control readonly-input"
                                                        value="${loginMember.userId}" readonly>
                                                </div>
                                            </div>

                                            <div class="row mb-3">
                                                <label class="col-sm-3 col-form-label fw-bold">이름</label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="form-control" name="userName"
                                                        id="userName" maxlength="10" value="${loginMember.userName}">
                                                    <div class="error-msg" id="userNameError">1~10자의 한글로 작성해주세요.</div>
                                                </div>
                                            </div>

                                            <div class="row mb-3">
                                                <label class="col-sm-3 col-form-label fw-bold">닉네임</label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="form-control" name="userNickname"
                                                        id="userNickname" maxlength="10"
                                                        value="${loginMember.userNickname}" required>
                                                    <div class="error-msg" id="userNicknameError">1~10자의 영문, 한글, 숫자로
                                                        작성해주세요.</div>
                                                </div>
                                            </div>

                                            <div class="row mb-3">
                                                <label class="col-sm-3 col-form-label fw-bold">연락처</label>
                                                <div class="col-sm-9">
                                                    <input type="text" class="form-control" name="userContact"
                                                        id="userContact" maxlength="11"
                                                        value="${loginMember.userContact}" required>
                                                    <div class="error-msg" id="userContactError">숫자로만 11자리 작성해주세요.</div>
                                                </div>
                                            </div>

                                            <div class="row mb-3">
                                                <label class="col-sm-3 col-form-label fw-bold">주소</label>
                                                <div class="col-sm-9">
                                                    <div class="input-group mb-2">
                                                        <input type="text" class="form-control" id="postcode"
                                                            placeholder="우편번호" readonly>
                                                        <button class="btn btn-outline-secondary" type="button"
                                                            onclick="execDaumPostcode()">주소 검색</button>
                                                    </div>
                                                    <input type="text" class="form-control mb-2" id="roadAddress"
                                                        placeholder="기본 주소" readonly>
                                                    <input type="text" class="form-control" id="detailAddress"
                                                        maxlength="20" placeholder="상세 주소를 입력해주세요">
                                                    <div class="error-msg" id="detailAddressError">20자 이하의 한글, 숫자, 공백으로
                                                        작성해주세요.</div>
                                                    <input type="hidden" id="userAddress" name="userAddress"
                                                        value="${loginMember.userAddress}">
                                                </div>
                                            </div>

                                            <div class="row mb-3">
                                                <label class="col-sm-3 col-form-label fw-bold">성별</label>
                                                <div class="col-sm-9">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="userGender"
                                                            id="genderM" value="M" checked>
                                                        <label class="form-check-label" for="genderM">남성</label>
                                                    </div>
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="userGender"
                                                            id="genderF" value="F">
                                                        <label class="form-check-label" for="genderF">여성</label>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row mb-3">
                                                <label class="col-sm-3 col-form-label fw-bold">가입일</label>
                                                <div class="col-sm-9">
                                                    <span class="form-control-plaintext">
                                                        <fmt:formatDate value="${loginMember.userEnrollDate}"
                                                            pattern="yyyy년 MM월 dd일" />
                                                    </span>
                                                </div>
                                            </div>

                                            <hr class="my-4">

                                            <div class="d-flex justify-content-between">
                                                <button type="submit" class="btn btn-primary fw-bold text-white px-4">정보
                                                    수정 저장</button>
                                            </div>
                                        </form>
                                    </div>

                                    <div class="card-body p-4" style="display: none;" id="myvolunteer2">
                                        <h4 class="mb-4 fw-bold border-bottom pb-2">봉사 신청 내역</h4>
                                        <table class="table table-hover text-center">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>신청일</th>
                                                    <th>활동명</th>
                                                    <th>활동날짜</th>
                                                    <th>상태</th>
                                                </tr>
                                            </thead>
                                            <tbody id="volunteerTableBody">
                                            </tbody>
                                        </table>
                                        <div id="volPagingArea" class="d-flex justify-content-center mt-3 gap-1"></div>
                                    </div>

                                    <div class="card-body p-4" style="display: none;" id="myadoption2">
                                        <h4> 입양 등록 내역 </h4>
                                        <div class="input-group mb-3" style="max-width: 300px;">
                                            <input type="text" id="searchKeyword" class="form-control"
                                                placeholder="동물 이름 검색">
                                            <button class="btn btn-outline-secondary" type="button"
                                                onclick="getAdoptionData(1, currPage2)">검색</button>
                                        </div>

                                        <table class="table table-bordered text-center" style="table-layout: fixed;">
                                            <thead class="table-light">
                                                <tr>
                                                    <th style="width: 10%;">등록번호</th>
                                                    <th style="width: 10%;">사진</th>
                                                    <th style="width: 15%;">동물 이름</th>
                                                    <th style="width: 15%;">등록일</th>
                                                    <th style="width: 10%;">상태</th>
                                                    <th style="width: 20%;">정보 관리</th>
                                                    <th style="width: 20%;">입양 관리</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                        <div id="pagingArea1" class="d-flex justify-content-center mt-3 gap-1"></div>

                                        <h4 class="mt-4"> 입양 신청 내역 </h4>
                                        <table class="table table-bordered text-center" style="table-layout: fixed;">
                                            <thead class="table-light">
                                                <tr>
                                                    <th style="width: 10%;">신청번호</th>
                                                    <th style="width: 10%;">사진</th>
                                                    <th style="width: 15%;">동물 이름</th>
                                                    <th style="width: 15%;">신청일</th>
                                                    <th style="width: 10%;">신청 상태</th>
                                                    <th style="width: 40%;">설정</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            </tbody>
                                        </table>
                                        <div id="pagingArea2" class="d-flex justify-content-center mt-3 gap-1"></div>
                                    </div>

                                    <div class="card-body p-4" style="display: none;" id="myboard2">
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal fade" id="applicantModal" tabindex="-1">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title fw-bold">입양 신청자 목록</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <p class="text-muted small">입양을 확정할 신청자를 선택해주세요. 선택 시 다른 신청자는 자동 반려됩니다.</p>
                                    <table class="table table-hover text-center">
                                        <thead class="table-light">
                                            <tr>
                                                <th>신청번호</th>
                                                <th>신청자</th>
                                                <th>신청일</th>
                                                <th>선택</th>
                                            </tr>
                                        </thead>
                                        <tbody id="applicantTableBody">
                                        </tbody>
                                    </table>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                    <script>
                        // 정규표현식
                        let nameRegExr = /^[가-힣]{1,10}$/;
                        let nicknameRegExr = /^[a-zA-Z0-9가-힣]{1,10}$/;
                        let contactRegExr = /^[0-9]{11}$/;
                        let addressRegExr = /^[가-힣0-9\s]{0,20}$/;

                        // 0. 메뉴 클릭 이벤트 및 초기화
                        document.addEventListener("DOMContentLoaded", function () {
                            const update = document.querySelector("#myupdate");
                            const myupdate2 = document.querySelector("#myupdate2");
                            const myvolunteer2 = document.querySelector("#myvolunteer2");
                            const myadoption2 = document.querySelector("#myadoption2");
                            const myboard2 = document.querySelector("#myboard2");

                            const list = [myupdate2, myvolunteer2, myadoption2, myboard2];
                            const mymenu = document.querySelector("#myMenu");

                            mymenu.addEventListener("click", function (e) {
                                if (!e.target.classList.contains('list-group-item')) return;

                                if (e.target.id === 'myvolunteer') {
                                    list.forEach(el => el.style.display = "none");
                                    myvolunteer2.style.display = "block";
                                    getMyVolunteerList();
                                } else if (e.target.id === 'myboard') {
                                    list.forEach(el => el.style.display = "none");
                                    myboard2.style.display = "block";
                                    getMyPosts();
                                } else {
                                    if (e.target.id === 'delete') return;

                                    list.forEach(el => el.style.display = "none");
                                    const targetId = e.target.id + "2";
                                    const targetContent = document.querySelector("#" + targetId);
                                    if (targetContent) {
                                        targetContent.style.display = "block";
                                        if (e.target.id === 'myadoption') {
                                            getAdoptionData(currPage1, currPage2);
                                        }
                                    }
                                }

                                const allButtons = mymenu.querySelectorAll('.list-group-item');
                                allButtons.forEach(btn => btn.classList.remove('active'));
                                e.target.classList.add('active');
                            });

                            // 초기 로딩 시 남성/여성 체크
                            let gender = '${loginMember.userGender}';
                            if (gender == 'M') $("#genderM").prop("checked", true);
                            else $("#genderF").prop("checked", true);

                            // 초기 로딩 시 주소 분리
                            var fullAddr = "${loginMember.userAddress}";
                            if (fullAddr) {
                                var addrParts = fullAddr.split(", ");
                                if (addrParts.length >= 1) $("#roadAddress").val(addrParts[0]);
                                if (addrParts.length >= 2) $("#detailAddress").val(addrParts[1]);
                            }
                        });

                        // 1. 주소 API
                        function execDaumPostcode() {
                            new daum.Postcode({
                                oncomplete: function (data) {
                                    var roadAddr = data.roadAddress;
                                    document.getElementById('postcode').value = data.zonecode;
                                    document.getElementById("roadAddress").value = roadAddr;
                                    document.getElementById("detailAddress").focus();
                                }
                            }).open();
                        }

                        // 2. 유효성 검사 (입력 시 바로 체크)
                        $("#userName").on("keyup", function () {
                            if (!nameRegExr.test($(this).val())) $("#userNameError").show();
                            else $("#userNameError").hide();
                        });
                        $("#userNickname").on("keyup", function () {
                            if (!nicknameRegExr.test($(this).val())) $("#userNicknameError").show();
                            else $("#userNicknameError").hide();
                        });
                        $("#userContact").on("keyup", function () {
                            if (!contactRegExr.test($(this).val())) $("#userContactError").show();
                            else $("#userContactError").hide();
                        });
                        $("#detailAddress").on("keyup", function () {
                            if (!addressRegExr.test($(this).val())) $("#detailAddressError").show();
                            else $("#detailAddressError").hide();
                        });

                        // 3. 폼 제출 전 조건 확인
                        $("#updateForm").on("submit", function () {
                            let userName = $("#userName").val();
                            let userNickname = $("#userNickname").val();
                            let userContact = $("#userContact").val();
                            let detailAddress = $("#detailAddress").val();

                            if (!nameRegExr.test(userName)) { alert("이름은 1~10글자 사이의 한글만 가능합니다."); return false; }
                            if (!nicknameRegExr.test(userNickname)) { alert("닉네임은 1~10글자 사이의 영문, 한글, 숫자만 가능합니다."); return false; }
                            if (!contactRegExr.test(userContact)) { alert("연락처는 11자리의 숫자만 가능합니다."); return false; }
                            if (!addressRegExr.test(detailAddress)) { alert("상세주소는 20자 이하의 한글, 숫자, 공백만 포함 가능합니다."); return false; }

                            var road = $("#roadAddress").val();
                            var detail = $("#detailAddress").val();
                            var fullAddr = road;
                            if (detail) fullAddr += ", " + detail;
                            $("#userAddress").val(fullAddr);
                            return true;
                        });

                        // 4. 회원 탈퇴
                        function deleteMember() {
                            return confirm("정말로 탈퇴하시겠습니까? 탈퇴 시 복구할 수 없습니다.");
                        }

                        let currPage1 = 1;
                        let currPage2 = 1;

                        async function getAdoptionData(page1 = currPage1, page2 = currPage2) {
                            currPage1 = page1;
                            currPage2 = page2;
                            const keyword = document.querySelector("#searchKeyword") ? document.querySelector("#searchKeyword").value : "";
                            const url = '${pageContext.request.contextPath}/adoption.mypage';

                            try {
                                const response = await fetch(url, {
                                    method: 'POST',
                                    headers: { "Content-Type": "application/json" },
                                    body: JSON.stringify({ page1, page2, keyword })
                                });
                                const ResultMap = await response.json();

                                if (ResultMap.error === "not_login") {
                                    alert(ResultMap.message);
                                    location.href = '${pageContext.request.contextPath}/user/login.me';
                                    return;
                                }

                                // 1. 등록 내역
                                const tbody1 = document.querySelector("#myadoption2 table:nth-of-type(1) tbody");
                                tbody1.innerHTML = "";
                                const myAdoptions = ResultMap.myAdoptions;
                                if (myAdoptions && myAdoptions.length > 0) {
                                    let html = "";
                                    myAdoptions.forEach(item => {
                                        html += "<tr onclick='location.href=\"${pageContext.request.contextPath}/adoption.detailpage?anino=" + item.animalNo + "\"'>";
                                        html += "<td>" + item.animalNo + "</td>";
                                        html += "<td><img src='${pageContext.request.contextPath}/resources/download/adoption/" + item.photoUrl + "' style='width:50px; height:50px; object-fit:cover;'></td>";
                                        html += "<td>" + (item.animalName ? item.animalName : "-") + "</td>";
                                        html += "<td>" + (item.postRegDate ? item.postRegDate : "-") + "</td>";
                                        html += "<td>" + (!item.postRegDate ? "미승인" : "승인/" + item.adoptionStatus) + "</td>";
                                        html += "<td>";
                                        if (!item.postRegDate) {
                                            html += "<button type='button' class='btn btn-secondary btn-xs' onclick='event.stopPropagation(); updateAdoption(" + item.animalNo + ")'>정보수정</button> ";
                                        }
                                        if (item.adoptionStatus !== '입양완료') {
                                            html += "<button type='button' class='btn btn-secondary btn-xs' onclick='event.stopPropagation(); cancelAdoption(" + item.animalNo + ")'>등록취소</button>";
                                        }
                                        html += "</td>";
                                        if (item.adoptionStatus === "신청중") {
                                            html += "<td><button type='button' class='btn btn-success btn-xs' onclick='event.stopPropagation();openApplicantModal(" + item.animalNo + ")'>수락</button> ";
                                            html += "<button type='button' class='btn btn-danger btn-xs' onclick='event.stopPropagation();denyAdoption(" + item.animalNo + ")'>거절</button></td>";
                                        }
                                        html += "</tr>";
                                    });
                                    tbody1.innerHTML = html;

                                    // 페이징 1
                                    const pi1 = ResultMap.pi1;
                                    let p1Html = "";
                                    if (pi1) {
                                        if (pi1.currentPage > 1) p1Html += '<button type="button" class="btn btn-sm btn-outline-secondary mx-1" onclick="getAdoptionData(' + (pi1.currentPage - 1) + ', currPage2)">&lt;</button>';
                                        for (let i = pi1.startPage; i <= pi1.endPage; i++) {
                                            let active = (pi1.currentPage == i) ? "btn-secondary" : "btn-outline-secondary";
                                            p1Html += '<button type="button" class="btn btn-sm ' + active + ' mx-1" onclick="getAdoptionData(' + i + ', currPage2)">' + i + '</button>';
                                        }
                                        if (pi1.currentPage < pi1.maxPage) p1Html += '<button type="button" class="btn btn-sm btn-outline-secondary mx-1" onclick="getAdoptionData(' + (pi1.currentPage + 1) + ', currPage2)">&gt;</button>';
                                    }
                                    const area1 = document.querySelector("#pagingArea1");
                                    if (area1) area1.innerHTML = p1Html;
                                } else {
                                    tbody1.innerHTML = "<tr><td colspan='4'>등록한 내역이 없습니다.</td></tr>";
                                }

                                // 2. 신청 내역
                                const tbody2 = document.querySelector("#myadoption2 table:nth-of-type(2) tbody");
                                tbody2.innerHTML = "";
                                const myApplications = ResultMap.myApplications;
                                if (myApplications && myApplications.length > 0) {
                                    let html = "";
                                    myApplications.forEach(item => {
                                        html += "<tr onclick= 'location.href=\"${pageContext.request.contextPath}/adoption.detailpage?anino=" + item.animalNo + "\"' >";
                                        html += "<td>" + item.adoptionAppId + "</td>";
                                        html += "<td><img src='${pageContext.request.contextPath}/resources/download/adoption/" + item.photoUrl + "' style='width:50px; height:50px; object-fit:cover;'></td>";
                                        html += "<td>" + (item.animalName ? item.animalName : "-") + "</td>";
                                        html += "<td>" + (item.applyDateStr || "-") + "</td>";

                                        let statusStr = "";
                                        switch (item.adoptStatus) {
                                            case 1: statusStr = "신청완료"; break;
                                            case 2: statusStr = "입양완료"; break;
                                            case 3: statusStr = "반려"; break;
                                            default: statusStr = "접수중";
                                        }
                                        html += "<td>" + statusStr + "</td>";
                                        html += "<td>";
                                        if (item.adoptStatus !== 2) {
                                            html += "<button type='button' class='btn btn-danger btn-xs' onclick='event.stopPropagation();cancelAdoptionApp(" + item.adoptionAppId + ")'>신청취소</button>";
                                        }
                                        html += "</td>";
                                        html += "</tr>";
                                    });
                                    tbody2.innerHTML = html;

                                    // 페이징 2
                                    const pi2 = ResultMap.pi2;
                                    let p2Html = "";
                                    if (pi2) {
                                        if (pi2.currentPage > 1) p2Html += '<button type="button" class="btn btn-sm btn-outline-secondary mx-1" onclick="getAdoptionData(currPage1, ' + (pi2.currentPage - 1) + ')">&lt;</button>';
                                        for (let i = pi2.startPage; i <= pi2.endPage; i++) {
                                            let active = (pi2.currentPage == i) ? "btn-secondary" : "btn-outline-secondary";
                                            p2Html += '<button type="button" class="btn btn-sm ' + active + ' mx-1" onclick="getAdoptionData(currPage1, ' + i + ')">' + i + '</button>';
                                        }
                                        if (pi2.currentPage < pi2.maxPage) p2Html += '<button type="button" class="btn btn-sm btn-outline-secondary mx-1" onclick="getAdoptionData(currPage1, ' + (pi2.currentPage + 1) + ')">&gt;</button>';
                                    }
                                    const area2 = document.querySelector("#pagingArea2");
                                    if (area2) area2.innerHTML = p2Html;
                                } else {
                                    tbody2.innerHTML = "<tr><td colspan='4'>신청한 내역이 없습니다.</td></tr>";
                                    const area2 = document.querySelector("#pagingArea2");
                                    if (area2) area2.innerHTML = "";
                                }

                            } catch (error) {
                                console.error("Error:", error);
                                alert("데이터 로딩 오류: " + error);
                            }
                        }

                        // 입양 관련 함수들
                        function updateAdoption(animalNo) { location.href = '${pageContext.request.contextPath}/adoption.updateanimal?anino=' + animalNo; }
                        function cancelAdoption(animalNo) { location.href = '${pageContext.request.contextPath}/adoption.deleteanimal?anino=' + animalNo; }
                        function cancelAdoptionApp(adoptionAppId) { location.href = '${pageContext.request.contextPath}/adoption.deleteadoptionapp?adoptionAppId=' + adoptionAppId; }
                        function acceptAdoption(animalNo) { location.href = '${pageContext.request.contextPath}/adoption.acceptadoptionapp?anino=' + animalNo; }
                        function denyAdoption(animalNo) { if (!confirm("정말 거절하시겠습니까?")) return; location.href = '${pageContext.request.contextPath}/adoption.denyadoptionapp?anino=' + animalNo; }

                        async function openApplicantModal(animalNo) {
                            try {
                                const response = await fetch("${pageContext.request.contextPath}/adoption.applicants?anino=" + animalNo);
                                if (!response.ok) throw new Error(await response.text());
                                const list = await response.json();

                                if (typeof list === 'string') { alert(list); return; }

                                let html = "";
                                if (list.length === 0) html = "<tr><td colspan='4'>신청자가 없습니다.</td></tr>";
                                else {
                                    list.forEach(function (app) {
                                        html += "<tr>";
                                        html += "<td>" + app.adoptionAppId + "</td>";
                                        html += "<td>" + app.userId + " (" + (app.userName ? app.userName : "이름없음") + ")</td>";
                                        html += "<td>" + app.applyDateStr + "</td>";
                                        html += "<td><button type='button' class='btn btn-primary btn-sm' onclick='confirmAdoption(" + app.adoptionAppId + ", " + app.animalNo + ")'>선택</button></td>";
                                        html += "</tr>";
                                    });
                                }
                                document.querySelector("#applicantTableBody").innerHTML = html;
                                const modal = new bootstrap.Modal(document.getElementById('applicantModal'));
                                modal.show();
                            } catch (error) {
                                console.error("Error details:", error);
                                alert("신청자 목록 로딩 오류: " + error);
                            }
                        }

                        async function confirmAdoption(appId, animalNo) {
                            if (!confirm("이 신청자를 선택하시겠습니까?\n선택하면 다른 신청자는 모두 반려 처리됩니다.")) return;
                            try {
                                const response = await fetch("${pageContext.request.contextPath}/adoption.confirm?adoptionAppId=" + appId + "&anino=" + animalNo);
                                if (!response.ok) throw new Error(await response.text());
                                const result = await response.json();
                                if (result === "success") { alert("입양이 확정되었습니다."); location.reload(); }
                                else alert("처리 실패: " + result);
                            } catch (error) { alert("처리 실패: " + error); }
                        }

                        async function getMyPosts(page = 1) {
                            let limit = 10;
                            const limitSelect = document.querySelector("#myPostsLimitSelect");
                            if (limitSelect) limit = limitSelect.value;

                            const url = '${pageContext.request.contextPath}/community/myPosts?cpage=' + page + '&limit=' + limit;
                            const container = document.querySelector("#myboard2");

                            try {
                                const response = await fetch(url);
                                const data = await response.json();
                                const list = data.list || [];
                                const pi = data.pi;

                                let html = '<div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">';
                                html += '<h4 class="fw-bold m-0">내가 쓴 글</h4>';
                                html += '<select id="myPostsLimitSelect" class="form-select form-select-sm" style="width:auto;" onchange="getMyPosts(1)">';
                                html += '<option value="10" ' + (limit == 10 ? 'selected' : '') + '>10개씩</option>';
                                html += '<option value="20" ' + (limit == 20 ? 'selected' : '') + '>20개씩</option>';
                                html += '<option value="50" ' + (limit == 50 ? 'selected' : '') + '>50개씩</option>';
                                html += '</select></div>';

                                if (list.length === 0) {
                                    html += '<div class="p-4 text-center">작성한 글이 없습니다.</div>';
                                    container.innerHTML = html;
                                    return;
                                }

                                html += '<table class="table table-hover text-center align-middle">';
                                html += '<thead class="table-light"><tr><th width="10%">번호</th><th width="15%">카테고리</th><th width="45%">제목</th><th width="20%">작성일</th><th width="10%">조회수</th></tr></thead>';
                                html += '<tbody>';

                                const catMap = { 'NOTICE': '공지사항', 'FREE': '자유게시판', 'REVIEW': '봉사후기', 'QNA': '문의사항', 'REQUEST': '건의사항' };
                                const badges = { 'NOTICE': 'bg-danger', 'FREE': 'bg-success', 'REVIEW': 'bg-warning text-dark', 'QNA': 'bg-info text-dark', 'REQUEST': 'bg-primary' };

                                list.forEach(board => {
                                    const catName = catMap[board.category] || board.category;
                                    const badgeClass = badges[board.category] || 'bg-secondary';
                                    let dateStr = board.createDate;
                                    if (dateStr && dateStr.length > 10) dateStr = dateStr.substring(0, 10);

                                    html += '<tr onclick="location.href=\'${pageContext.request.contextPath}/community/detail?boardId=' + board.boardId + '\'" style="cursor:pointer;">';
                                    html += '<td class="text-secondary">' + board.boardId + '</td>';
                                    html += '<td><span class="badge ' + badgeClass + ' rounded-pill" style="font-weight:500; min-width:80px;">' + catName + '</span></td>';
                                    html += '<td class="text-start"><div class="text-truncate" style="max-width: 300px; color:#333;">' + board.title + '</div></td>';
                                    html += '<td class="text-secondary small">' + dateStr + '</td>';
                                    html += '<td class="text-secondary small">' + board.viewCount + '</td>';
                                    html += '</tr>';
                                });
                                html += '</tbody></table>';

                                // 페이징
                                html += '<div id="pagingAreaMyPosts" class="d-flex justify-content-center mt-4 mb-3 gap-1">';
                                if (pi) {
                                    const btnBase = "btn btn-sm d-flex align-items-center justify-content-center";
                                    const btnStyle = "width: 30px; height: 30px; font-size: 0.8rem; padding: 0; border-radius: 50%; box-shadow: 0 1px 2px rgba(0,0,0,0.1);";

                                    if (pi.currentPage > 1) {
                                        html += '<button type="button" class="' + btnBase + ' btn-light border" style="' + btnStyle + '" onclick="getMyPosts(' + (pi.currentPage - 1) + ')">&lt;</button>';
                                    }
                                    for (let i = pi.startPage; i <= pi.endPage; i++) {
                                        if (pi.currentPage == i) {
                                            html += '<button type="button" class="' + btnBase + ' btn-dark text-white fw-bold" style="' + btnStyle + ' border:none;" onclick="getMyPosts(' + i + ')">' + i + '</button>';
                                        } else {
                                            html += '<button type="button" class="' + btnBase + ' btn-white border text-secondary" style="' + btnStyle + ' background:#fff;" onclick="getMyPosts(' + i + ')">' + i + '</button>';
                                        }
                                    }
                                    if (pi.currentPage < pi.maxPage) {
                                        html += '<button type="button" class="' + btnBase + ' btn-light border" style="' + btnStyle + '" onclick="getMyPosts(' + (pi.currentPage + 1) + ')">&gt;</button>';
                                    }
                                }
                                html += '</div>';
                                container.innerHTML = html;

                            } catch (error) {
                                console.error('Error fetching my posts:', error);
                                container.innerHTML = '<div class="alert alert-danger">데이터 로딩 오류</div>';
                            }
                        }

                        async function getMyVolunteerList(cpage = 1) {
                            const url = '${pageContext.request.contextPath}/mySignList.vo?cpage=' + cpage;
                            const tbody = document.querySelector("#volunteerTableBody");
                            const pagingArea = document.querySelector("#volPagingArea");

                            try {
                                const response = await fetch(url);
                                const resultMap = await response.json();
                                const list = resultMap.list;
                                const pi = resultMap.pi;

                                if (!list || list.length === 0) {
                                    tbody.innerHTML = '<tr><td colspan="4" class="p-4">신청한 봉사활동 내역이 없습니다.</td></tr>';
                                    pagingArea.innerHTML = "";
                                    return;
                                }

                                let html = "";
                                list.forEach(sign => {
                                    let signDate = new Date(sign.signsDate).toISOString().split('T')[0];
                                    let actDate = new Date(sign.actDate).toISOString().split('T')[0];

                                    let statusBadge = "";
                                    if (sign.signsStatus === 0) statusBadge = '<span class="badge bg-warning text-dark">대기중</span>';
                                    else if (sign.signsStatus === 1) statusBadge = '<span class="badge bg-success">승인됨</span>';
                                    else if (sign.signsStatus === 2) statusBadge = '<span class="badge bg-danger">반려됨</span>';
                                    else if (sign.signsStatus === 3) statusBadge = '<span class="badge bg-secondary">취소됨</span>';
                                    else if (sign.signsStatus === 4) statusBadge = '<span class="badge bg-primary">활동완료</span>';

                                    let cancelBtn = "";
                                    if (sign.signsStatus === 0 || sign.signsStatus === 1) {
                                        cancelBtn = ' <button class="btn btn-sm btn-outline-danger ms-2" style="font-size: 0.7rem; padding: 2px 8px;" onclick="event.stopPropagation(); cancelMySign(' + sign.signsNo + ')">신청취소</button>';
                                    }

                                    html += '<tr style="cursor:pointer;" onclick="location.href=\'${pageContext.request.contextPath}/volunteerDetail.vo?actId=' + sign.actId + '\'">';
                                    html += '<td>' + signDate + '</td>';
                                    html += '<td class="text-start">' + sign.actTitle + '</td>';
                                    html += '<td>' + actDate + '</td>';
                                    html += '<td>' + statusBadge + cancelBtn + '</td>';
                                    html += '</tr>';
                                });
                                tbody.innerHTML = html;

                                let pageHtml = "";
                                if (pi.currentPage > 1) {
                                    pageHtml += '<button class="btn btn-sm btn-outline-secondary" onclick="getMyVolunteerList(' + (pi.currentPage - 1) + ')">&lt;</button>';
                                }
                                for (let p = pi.startPage; p <= pi.endPage; p++) {
                                    if (p === pi.currentPage) {
                                        pageHtml += '<button class="btn btn-sm btn-secondary active" disabled>' + p + '</button>';
                                    } else {
                                        pageHtml += '<button class="btn btn-sm btn-outline-secondary" onclick="getMyVolunteerList(' + p + ')">' + p + '</button>';
                                    }
                                }
                                if (pi.currentPage < pi.maxPage) {
                                    pageHtml += '<button class="btn btn-sm btn-outline-secondary" onclick="getMyVolunteerList(' + (pi.currentPage + 1) + ')">&gt;</button>';
                                }
                                pagingArea.innerHTML = pageHtml;

                            } catch (error) {
                                console.error('Error:', error);
                                tbody.innerHTML = '<tr><td colspan="4" class="text-danger">데이터 로딩 실패</td></tr>';
                            }
                        }

                        // 봉사 신청 취소 함수
                        function cancelMySign(signsNo) {
                            if (!confirm("정말로 봉사 신청을 취소하시겠습니까?\n(승인된 활동을 취소하면 모집 인원에 반영됩니다.)")) return;

                            $.ajax({
                                url: "${pageContext.request.contextPath}/updateSignStatusUser.vo",
                                type: "post",
                                data: { signsNo: signsNo },
                                success: function (result) {
                                    if (result === "success") {
                                        alert("✅ 신청이 정상적으로 취소되었습니다.");
                                        getMyVolunteerList(1);
                                    } else {
                                        alert("❌ 취소 처리에 실패했습니다. 관리자에게 문의하세요.");
                                    }
                                },
                                error: function () { alert("서버 통신 오류가 발생했습니다."); }
                            });
                        }

                    </script>
            </body>

            </html>