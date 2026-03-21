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
public class MemberVO {
	private String userId;//	USER_ID	VARCHAR2(30 BYTE)
	private String userPwd;//	USER_PWD	VARCHAR2(100 BYTE)
	private String userName;//	USER_NAME	VARCHAR2(50 BYTE)
	private String userNickname;//	USER_NICKNAME	VARCHAR2(30 BYTE)
	private String userAddress;//	USER_ADDRESS	VARCHAR2(200 BYTE)
	private String userContact;//	USER_CONTACT	VARCHAR2(20 BYTE)
	private String userGender;//	USER_GENDER	VARCHAR2(1 BYTE)
	private int userAge;//	USER_AGE	NUMBER
	private int userAttendedCount;//	USER_ATTENDED_COUNT	NUMBER
	private Date userRestrictEndDate;//	USER_RESTRICT_END_DATE	DATE
	private String userStatus;//	USER_STATUS	VARCHAR2(1 BYTE)
	private String userRole;//	USER_ROLE	VARCHAR2(10 BYTE)
	private Date userEnrollDate;//	USER_ENROLL_DATE	DATE
	private Date userModifyDate;//	USER_MODIFY_DATE	DATE
}
