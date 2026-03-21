package com.ubig.app.vo.member;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class AdminChatHistoryVO {
	private int chatNo;//	CHAT_NO	NUMBER
	private String chatSendUserId;//	CHAT_SEND_USER_ID	VARCHAR2(30 BYTE)
	private String chatReceiveUserId;//	CHAT_RECEIVE_USER_ID	VARCHAR2(30 BYTE)
	private String chatContent;//	CHAT_CONTENT	VARCHAR2(200 BYTE)
	private String chatIsCheck;//	CHAT_IS_CHECK	VARCHAR2(1 BYTE)
	private Date chatCreateDate;//	CHAT_CREATE_DATE	DATE
}
