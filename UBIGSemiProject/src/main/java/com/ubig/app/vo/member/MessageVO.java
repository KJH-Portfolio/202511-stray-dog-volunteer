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
public class MessageVO {
	private int messageNo;//	MESSAGE_NO	NUMBER
	private String messageSendUserId;//	MESSAGE_SEND_USER_ID	VARCHAR2(30 BYTE)
	private String messageReceiveUserId;//	MESSAGE_RECEIVE_USER_ID	VARCHAR2(30 BYTE)
	private String messageContent;//	MESSAGE_CONTENT	VARCHAR2(200 BYTE)
	private String messageIsCheck;//	MESSAGE_IS_CHECK	VARCHAR2(1 BYTE)
	private Date messageCreateDate;//	MESSAGE_CREATE_DATE	DATE
}
