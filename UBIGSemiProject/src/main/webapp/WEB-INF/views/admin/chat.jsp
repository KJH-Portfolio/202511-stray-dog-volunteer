<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>관리자 대시보드 | 유기동물 플랫폼</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background-color: #343a40; color: white; }
        .sidebar a { color: rgba(255,255,255,.8); text-decoration: none; padding: 10px 15px; display: block; }
        .sidebar a:hover { background-color: #495057; color: white; }
        .card-stat { border: none; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.2s; }
        .card-stat:hover { transform: translateY(-5px); }
        .icon-box { font-size: 2.5rem; opacity: 0.8; }
        .table-card { background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); padding: 20px; }
        .status-badge { font-size: 0.8em; padding: 5px 10px; border-radius: 15px; }
        
		    /* 1. 둥둥 떠있는 채팅 버튼 (Launcher) */
	    #chat-launcher-btn {
	        position: fixed;
	        bottom: 30px;
	        right: 30px;
	        width: 60px;
	        height: 60px;
	        background-color: #FFC107; /* 유봉일공 테마 컬러 */
	        color: white;
	        border-radius: 50%;
	        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
	        display: flex; /* 아이콘 중앙 정렬 */
	        align-items: center;
	        justify-content: center;
	        font-size: 30px;
	        cursor: pointer;
	        z-index: 9990; /* 다른 요소보다 위에 */
	        transition: transform 0.3s;
	    }
	    #chat-launcher-btn:hover {
	        transform: scale(1.1); /* 마우스 올리면 살짝 커짐 */
	        background-color: #e0a800;
	    }
	
	    /* 2. 채팅창 본체 (초기 상태: 숨김) */
	    #chat-widget-window {
	        position: fixed;
	        bottom: 100px; /* 버튼보다 조금 위에 위치 */
	        right: 30px;
	        width: 350px;
	        height: 500px;
	        background-color: white;
	        border-radius: 15px;
	        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
	        z-index: 9999;
	        overflow: hidden;
	        
	        display: flex;          /* 이걸 추가해야 아래 flex-direction이 먹힙니다. */
		    flex-direction: column; /* 세로 방향으로 배치 */
	    }
	
	    /* 채팅창 헤더 */
	    .chat-header {
	        background-color: #FFC107;
	        color: white;
	        padding: 15px;
	        display: flex;
	        justify-content: space-between;
	        align-items: center;
	        font-weight: bold;
	    }
	    .chat-close-btn {
	        cursor: pointer;
	        font-size: 1.2rem;
	    }
	    .chat-close-btn:hover {
	        color: #f8f9fa;
	    }
	
	    /* 채팅 내용 영역 */
	    .chat-body {
	        flex: 1; /* 남은 공간 다 차지 */
	        padding: 15px;
	        overflow-y: auto; /* 스크롤 생김 */
	        background-color: #f8f9fa;
	    }
	    
	    /* 채팅 입력 영역 */
	    .chat-footer {
	        padding: 10px;
	        background-color: white;
	        border-top: 1px solid #dee2e6;
	        display: flex;
	        gap: 10px;
	    }
	    .chat-input {
	        flex: 1;
	        border: 1px solid #ced4da;
	        border-radius: 20px;
	        padding: 5px 15px;
	        outline: none;
	    }
	    .chat-send-btn {
	        background-color: #FFC107;
	        border: none;
	        color: white;
	        border-radius: 50%;
	        width: 35px;
	        height: 35px;
	        display: flex;
	        align-items: center;
	        justify-content: center;
	    }
	    
	    /* 말풍선 스타일 예시 */
	    .msg-row { margin-bottom: 10px; display: flex; }
	    .msg-row.my-msg { justify-content: flex-end; }
	    .msg-bubble {
	        max-width: 70%;
	        padding: 8px 12px;
	        border-radius: 15px;
	        font-size: 0.9rem;
	    }
	    .my-msg .msg-bubble { background-color: #FFC107; color: white; border-bottom-right-radius: 0; }
	    .other-msg .msg-bubble { background-color: #e9ecef; color: black; border-bottom-left-radius: 0; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block sidebar p-0">
            <div class="p-4 text-center border-bottom border-secondary">
                <h4><i class="fas fa-paw"></i> 관리자 센터</h4>
                <small>Welcome, Admin</small>
            </div>
            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/admin" class="active"><i class="fas fa-tachometer-alt me-2"></i> 대시보드</a>
                <a href="${pageContext.request.contextPath}/admin/userStatus"><i class="fas fa-users me-2"></i> 회원 관리</a>
                <a href="${pageContext.request.contextPath}/admin/chatList.ch"><i class="fas fa-headset me-2"></i> 1:1 문의</a>
            </div>
        </nav>

        <main class="col-md-10 ms-sm-auto col-lg-10 px-md-4 py-4">
        	<div id="chat-widget-window">
			    <div class="chat-header">
			        <span>${chatReceiveUserId}</span>
			        <i class="bi bi-x-lg chat-close-btn" onclick="location.href='chatList.ch'"></i>
			    </div>
			
			    <div class="chat-body" id="chatMessageArea">
			    	<c:forEach items="${list}" var="c">
			    		<c:choose>
			    			<c:when test="${c.chatReceiveUserId eq 'admin' }">
						        <div class="msg-row other-msg">
						            <div class="msg-bubble">${c.chatContent }</div>
						        </div>			    			
			    			</c:when>
			    			<c:otherwise>
						        <div class="msg-row my-msg">
						            <div class="msg-bubble">${c.chatContent }</div>
						        </div>					    			
			    			</c:otherwise>
			    		</c:choose>
			    	</c:forEach>
			    </div>
			
			    <div class="chat-footer">
			        <input type="text" class="chat-input" id="chatInput" placeholder="메시지를 입력하세요..." onkeypress="handleEnter(event)">
			        <button class="chat-send-btn" onclick="sendMessage()">
			            <i class="bi bi-send-fill"></i>
			        </button>
			    </div>
			</div>

        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
	
	// chat.jsp가 로딩되면 소켓에 연결되도록 처리
	let socket;
	
	function connect() {
		// 연결 주소
		let url = "ws://localhost:8080/app/chat";
		
		if (!socket) { // 소켓없을때만 처리
			socket = new WebSocket(url);
		}
		
		
		// 연결이 되었을때
		socket.onopen = function() {
			console.log("접속 성공!");
		}
		
		// 에러 발생 시
		socket.onerror = function(e) {
			console.log("오류 발생");
			console.log(e);
		}
		
		// 연결 종료 되었을때
		socket.onclose = function() {
			console.log("접속 종료");
		}
		
		// 메시지 받았을때
		socket.onmessage = function(message) {
			// 전달받은 message.data는 문자열형태로 되어있는 json 문자열이다.
			// json 문자열을 json 객체로 변환하는 작업이 필요하다.
			// JSON.stringify(객체); - json 객체를 문자열로 변환해주는 함수
			// JSON.parse(문자열); - json객체 문자열을 json객체로 변환해주는 함수
			
			console.log(JSON.parse(message.data));
			
			receiveMessage(JSON.parse(message.data));
		}
		
		
	}
	
	function disconnect() {
		socket.close();
	}
    
    // 2. 엔터키 전송 처리
    function handleEnter(e) {
        if (e.key === 'Enter') {
            sendMessage();
        }
    }

    // 3. 메시지 전송 (화면에 뿌리기용 - 추후 DB/Socket 연동 필요)
    function sendMessage() {
        var input = document.getElementById("chatInput");
        var msg = input.value.trim();
        var chatArea = document.getElementById("chatMessageArea");

        if (msg === "") return;

        // 내 메시지 HTML 생성
        var myMsgHtml = '<div class="msg-row my-msg">' +
                            '<div class="msg-bubble">' + msg + '</div>' +
                        '</div>';
        
        chatArea.insertAdjacentHTML('beforeend', myMsgHtml);
        
        // 스크롤 최하단으로 이동
        chatArea.scrollTop = chatArea.scrollHeight;

        // 입력창 초기화
        input.value = "";
        input.focus();
        
        // (선택사항) 여기에 실제 서버로 전송하는 AJAX 코드 작성
        let obj = {
        	message : msg,
        	sendUserId : 'admin',
        	receiveUserId : '${chatReceiveUserId}'
        };
        
        socket.send(JSON.stringify(obj));
    }
    
    // 4. 메시지 수신 (화면에 표시하기)
    function receiveMessage(data) {
        var chatArea = document.getElementById("chatMessageArea");
        
        var msgHtml = "";
        console.log(data.chatSendUserId);
        
        if (data.chatSendUserId === 'admin') {
        	msgHtml = '<div class="msg-row my-msg">' +
		        '<div class="msg-bubble">' + data.chatContent + '</div>' +
		    '</div>';
        }
        else {
        	msgHtml = '<div class="msg-row other-msg">' +
		        '<div class="msg-bubble">' + data.chatContent + '</div>' +
		    '</div>';
        }
					    
		chatArea.insertAdjacentHTML('beforeend', msgHtml);
        
        // 스크롤 최하단으로 이동
        chatArea.scrollTop = chatArea.scrollHeight;
    }
    
    // 웹 페이지가 로딩되는 즉시 웹소켓 연결 처리. 단, 로그인 되어있는 상태여야 한다.
    if (${not empty loginMember}) connect();
    
    document.getElementById("chatMessageArea").scrollTop = document.getElementById("chatMessageArea").scrollHeight;
</script>
</body>
</html>