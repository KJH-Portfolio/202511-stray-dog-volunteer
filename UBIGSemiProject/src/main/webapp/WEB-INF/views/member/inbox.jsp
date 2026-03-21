<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>유봉일공 - 쪽지함</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?v=3">
    <style>
        body { background-color: #f8f9fa; }
        .msg-container { max-width: 1000px; margin: 50px auto; }
        
        /* 탭 스타일 */
        .nav-tabs .nav-link { color: #495057; font-weight: 500; }
        .nav-tabs .nav-link.active { color: #000; font-weight: bold; border-bottom: 3px solid #FFC107; }
        
        /* 테이블 스타일 */
        .table-hover tbody tr { cursor: pointer; transition: 0.2s; }
        .unread-msg { font-weight: bold; background-color: #fffef0; } /* 읽지 않은 쪽지 배경색 */
        .msg-preview {
            display: inline-block;
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            vertical-align: middle;
        }
        
        .btn-write { background-color: #FFC107; border: none; font-weight: bold; color: white; }
        .btn-write:hover { background-color: #e0a800; color: white; }
        
        body {
        	padding-top: 50px;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/menubar.jsp" />

<div class="container msg-container">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">📬 나의 쪽지함</h2>
        <button class="btn btn-write px-4 py-2" data-bs-toggle="modal" data-bs-target="#writeModal">
            + 쪽지 쓰기
        </button>
    </div>

    <ul class="nav nav-tabs mb-3">
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/message/inbox.ms">받은 쪽지함 <span class="badge bg-danger rounded-pill ms-1">${unreadCount}</span></a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/message/sent.ms">보낸 쪽지함</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/kick/kickList.ki">차단 목록</a>
        </li>
    </ul>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 text-center align-middle">
                <thead class="table-light">
                    <tr>
                        <th scope="col" style="width: 10%;">상태</th>
                        <th scope="col" style="width: 15%;">보낸 사람</th>
                        <th scope="col" style="width: 60%;">내용</th>
                        <th scope="col" style="width: 15%;">날짜</th>
                    </tr>
                </thead>
                <tbody>
                	<!-- 받은 쪽지가 없으면 받은 쪽지가 없습니다. 텍스트를 출력하고, 아니라면 받은 메시지 리스트를 보여주기 -->
                    <c:choose>
                        <c:when test="${empty list}">
                            <tr>
                                <td colspan="5" class="py-5 text-secondary">받은 쪽지가 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="msg" items="${list}">
                                <tr class="${msg.messageIsCheck == 'N' ? 'unread-msg' : ''}" 
                                	data-message-no="${msg.messageNo }"
                                	data-message-send-user-id="${msg.messageSendUserId }"
                                	data-message-content="${fn:escapeXml(msg.messageContent) }"
                                	data-message-create-date="${msg.messageCreateDate }"
                                	data-message-is-check="${msg.messageIsCheck }"
                                    id="messageInfo">
                                    
                                    <td>
                                        <c:if test="${msg.messageIsCheck == 'N'}">
                                            <span class="badge bg-danger">안 읽음</span>
                                        </c:if>
                                        <c:if test="${msg.messageIsCheck == 'Y'}">
                                            <span class="badge bg-secondary">읽음</span>
                                        </c:if>
                                    </td>

                                    <td>${msg.messageSendUserId}</td>

                                    <td class="text-start ps-4">
                                        <span class="msg-preview text-dark text-decoration-none">
                                        	<c:out value="${msg.messageContent}"></c:out>
                                        </span>
                                    </td>

                                    <td class="text-secondary small">
                                        <fmt:formatDate value="${msg.messageCreateDate}" pattern="yyyy.MM.dd HH:mm"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
    
   		<div id="pagingArea">
			<ul class="pagination">
				<c:choose>
               		<c:when test="${pi.currentPage le 1 }"> <!-- 현재페이지 1이면 이전버튼 비활성화 -->
	                    <li class="page-item disabled"><a class="page-link" href="${pageContext.request.contextPath}/message/inbox.ms?curPage=${pi.currentPage - 1}">Prev</a></li>
               		</c:when>
               		<c:otherwise>
               			<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/message/inbox.ms?curPage=${pi.currentPage - 1}">Prev</a></li>
               		</c:otherwise>
               	</c:choose>
                   
                   <c:forEach var="i" begin="${pi.startPage }" end="${pi.endPage }">
<!--                     	el표기법으로 3항연산자를 이용하여 조건이 부합할 땐 disabled 속성 넣기 아니면 빈값처리 -->
                   	<li class="page-item ${i eq pi.currentPage ? 'disabled' : '' }"><a class="page-link" href="${pageContext.request.contextPath}/message/inbox.ms?curPage=${i}">${i }</a></li>
                   </c:forEach>
                   
                   <c:choose>
                   	<c:when test="${pi.currentPage ge pi.maxPage }">
	                    <li class="page-item disabled"><a class="page-link" href="${pageContext.request.contextPath}/message/inbox.ms?curPage=${pi.currentPage + 1}">Next</a></li>
                   	</c:when>
                   	<c:otherwise>
                   		<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/message/inbox.ms?curPage=${pi.currentPage + 1}">Next</a></li>
                   	</c:otherwise>
                   </c:choose>
			</ul>
		</div>
    </div>

<!-- 쪽지 상세 보기 모달 -->
<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h5 class="modal-title fw-bold">쪽지 내용</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3 border-bottom pb-2">
                    <label class="text-secondary small">보낸 사람</label>
                    <div class="fw-bold fs-5" id="modalSender"></div>
                </div>
                <div class="mb-3 border-bottom pb-2">
                    <label class="text-secondary small">보낸 날짜</label>
                    <div id="modalDate"></div>
                </div>
                <div class="mb-3">
                    <label class="text-secondary small">내용</label>
                    <div class="p-3 bg-light rounded" id="modalContent" style="min-height: 100px; white-space: pre-wrap;"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-bs-dismiss="modal" id="btnKick"></button>
                <button type="button" class="btn btn-primary" id="btnReply">답장하기</button>
            </div>
        </div>
    </div>
</div>

<!-- 쪽지 보내기 모달 -->
<div class="modal fade" id="writeModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header" style="background-color: #FFC107; color: white;">
                <h5 class="modal-title fw-bold">쪽지 보내기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/message/insert.ms" method="post">
            	<input type="hidden" name="messageSendUserId" value="${loginMember.userId }">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">받는 사람 ID</label>
                        <input type="text" class="form-control" name="messageReceiveUserId" id="inputMessageReceiveUserId" placeholder="회원 ID를 입력하세요" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">내용</label>
                        <textarea class="form-control" name="messageContent" id="inputMessageContent" rows="5" placeholder="내용을 입력하세요 (최대 60자)" maxlength="60" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-warning text-white fw-bold" onclick="return sendMessage();">보내기</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>

	$(function() {
		$(document).on("click", "#messageInfo", function() {
			let msgNo = $(this).data("messageNo");
			let sender = $(this).data("messageSendUserId");
			let content = $(this).data("messageContent");
			let date = $(this).data("messageCreateDate");
			let isCheck = $(this).data("messageIsCheck");
			
	    	console.log(content);
	        // 모달 내용 채우기
	        $("#modalSender").text(sender);
	        $("#modalContent").text(content); 
	        $("#modalDate").text(date);
	        $("#btnKick").text(sender + " 차단하기");
	        
	        // 답장하기 버튼 클릭 시 -> 쓰기 모달의 받는 사람에 세팅하고 쓰기 모달 띄우기
	        $("#btnReply").off("click").on("click", function() {
	             // 상세 모달 닫고
	             $("#detailModal").modal("hide");
	             // 쓰기 모달 열기 + ID 세팅
	             $("#inputMessageReceiveUserId").val(sender)
	             $("#writeModal").modal("show");
	        });
	        
	        // 차단하기 버튼 클릭 시 -> 차단할 건지 한번 더 물어본 후 yes를 누르면 차단 테이블에 등록
	        var isKicked = true;
	        $("#btnKick").off("click").on("click", function() {
	        	var isSuccess = false;
	        	if (confirm(sender + "님을 차단하시겠습니까?")) {
	        		$.ajax({
	        			url : "${pageContext.request.contextPath}/kick/insertKick.ki",
	        			type : "POST",
	        			async : false,
	        			data : {
	        				kicker : '${loginMember.userId}',
	        				kickedUser : sender
	        			},
	        			success : function(data) {
	        				console.log(data);
	        				if (data == "success") {
	        					alert("차단되었습니다.");
	        					isSuccess = true;
	        				}
	        				else {
	        					alert("차단에 실패했습니다.");
	        				}
	        			},
	        			error : function() {
	        				alert("알 수 없는 오류가 발생했습니다.");
	        			}
	        		});
	        	}
	        	
	        	if (isSuccess) {
	        		$("#detailModal").modal("hide");
	        	}
	        });
	        
	        // 만약 이미 차단되어있는 상태라면 차단 버튼을 disable한다.
	        $.ajax({
	        	url :  "${pageContext.request.contextPath}/kick/isKicked.ki",
	        	type: "POST",
	        	async : false,
	        	data : {
	        		messageSendUserId : sender,
	        		messageReceiveUserId : '${loginMember.userId}'
	        	},
	        	success : function(data) {
	        		console.log(data);
	        		if (data == "notkicked") {
	        			isKicked = false;
	        		}
	        	},
	        	error : function() {
	        		alert("알 수 없는 오류가 발생했습니다.");
	        	}
	        });
	        
	        $("#btnKick").prop("disabled", isKicked);
	        $("#btnReply").prop("disabled", isKicked);

	        // 모달 띄우기
	        $("#detailModal").modal("show");

	        // 만약 선택된 쪽지가 아직 읽지 않은 쪽지라면, 읽음 상태로 변경한다.
	        if(isCheck === 'N') {
	            $.ajax({
	                url: "${pageContext.request.contextPath}/message/read.ms",
	                type: "POST",
	                data: { messageNo: msgNo },
	                success: function(res) {
	                    console.log("읽음 처리 완료");
	                }
	            });
	        }
		});
	});
    // 1. 쪽지 상세 보기 함수
    function openMessageDetail(msgNo, sender, content, date, isCheck) {
    	console.log(content);
        // 모달 내용 채우기
        $("#modalSender").text(sender);
        $("#modalContent").text(content); 
        $("#modalDate").text(date);
        $("#btnKick").text(sender + " 차단하기");
        
        // 답장하기 버튼 클릭 시 -> 쓰기 모달의 받는 사람에 세팅하고 쓰기 모달 띄우기
        $("#btnReply").off("click").on("click", function() {
             // 상세 모달 닫고
             $("#detailModal").modal("hide");
             // 쓰기 모달 열기 + ID 세팅
             $("#inputMessageReceiveUserId").val(sender)
             $("#writeModal").modal("show");
        });
        
        // 차단하기 버튼 클릭 시 -> 차단할 건지 한번 더 물어본 후 yes를 누르면 차단 테이블에 등록
        var isKicked = true;
        $("#btnKick").off("click").on("click", function() {
        	var isSuccess = false;
        	if (confirm(sender + "님을 차단하시겠습니까?")) {
        		$.ajax({
        			url : "${pageContext.request.contextPath}/kick/insertKick.ki",
        			type : "POST",
        			async : false,
        			data : {
        				kicker : '${loginMember.userId}',
        				kickedUser : sender
        			},
        			success : function(data) {
        				console.log(data);
        				if (data == "success") {
        					alert("차단되었습니다.");
        					isSuccess = true;
        				}
        				else {
        					alert("차단에 실패했습니다.");
        				}
        			},
        			error : function() {
        				alert("알 수 없는 오류가 발생했습니다.");
        			}
        		});
        	}
        	
        	if (isSuccess) {
        		$("#detailModal").modal("hide");
        	}
        });
        
        // 만약 이미 차단되어있는 상태라면 차단 버튼을 disable한다.
        $.ajax({
        	url :  "${pageContext.request.contextPath}/kick/isKicked.ki",
        	type: "POST",
        	async : false,
        	data : {
        		messageSendUserId : sender,
        		messageReceiveUserId : '${loginMember.userId}'
        	},
        	success : function(data) {
        		console.log(data);
        		if (data == "notkicked") {
        			isKicked = false;
        		}
        	},
        	error : function() {
        		alert("알 수 없는 오류가 발생했습니다.");
        	}
        });
        
        $("#btnKick").prop("disabled", isKicked);
        $("#btnReply").prop("disabled", isKicked);

        // 모달 띄우기
        $("#detailModal").modal("show");

        // 만약 선택된 쪽지가 아직 읽지 않은 쪽지라면, 읽음 상태로 변경한다.
        if(isCheck === 'N') {
            $.ajax({
                url: "${pageContext.request.contextPath}/message/read.ms",
                type: "POST",
                data: { messageNo: msgNo },
                success: function(res) {
                    console.log("읽음 처리 완료");
                }
            });
        }
    }
    
    // 2. 쪽지 보내기 버튼 함수
    function sendMessage() {
    	
    	let receiveId = $("#inputMessageReceiveUserId").val();
    	let content = $("#inputMessageContent").val();
    	
    	console.log(receiveId);
    	console.log(content);
    	
    	// 자기 자신에게는 쪽지를 보낼 수 없다.
    	if ('${loginMember.userId}' == receiveId) {
    		alert("자기 자신에게는 쪽지를 보낼 수 없습니다.");
    		return false;
    	}
    	
    	let isExist = true;
    	let isError = false;
    	
    	// 존재하지 않는 유저에게 쪽지를 보낼 수 없다.
    	// 동기 방식으로 처리한다.
    	$.ajax({
    		url : "${pageContext.request.contextPath}/user/messageCheckId.me",
    		async : false,
    		data : {
    			userId: receiveId
    		},
    		success : function(data) {
    			console.log(data);
    			if (data == "fail") {
    				alert("존재하지 않는 유저입니다.");
    				isExist = false;
    			}
    		},
    		error : function() {
    			console.log("통신 실패");
    			alert("알 수 없는 오류가 발생했습니다.");
    			isError = false;
    		}
    	});
    	
    	if (isError) {
    		return false;
    	}
    	
    	if (!isExist) {
    		return false;
    	}
    	
    	// 내용이 비어 있으면 쪽지를 보낼 수 없다.
    	if (content === "") {
    		alert("쪽지 내용을 입력하세요.");
    		return false;
    	}
    	
    	// 자신이 차단한 회원에게 쪽지를 보낼 수 없다.
    	let isKicked = true;
        $.ajax({
        	url :  "${pageContext.request.contextPath}/kick/isKicked.ki",
        	type: "POST",
        	async : false,
        	data : {
        		messageSendUserId : receiveId,
        		messageReceiveUserId : '${loginMember.userId}'
        	},
        	success : function(data) {
        		console.log(data);
        		if (data == "notkicked") {
        			isKicked = false;
        		}
        	},
        	error : function() {
        		alert("알 수 없는 오류가 발생했습니다.");
        	}
        });
        
        if (isKicked) {
        	alert("차단한 회원입니다. 차단 해제 후 다시 시도해주세요.");
        	return false;
        }
    	
		// 쪽지 보내기 요청
		return confirm("쪽지를 보내시겠습니까?");
    }
</script>

</body>
</html>