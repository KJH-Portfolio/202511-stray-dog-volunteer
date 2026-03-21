package com.ubig.app.vo.volunteer;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class SignVO {
	
	private int signsNo;        // SIGNS_NO (신청번호/PK)
	private int actId;          // ACT_ID (프로그램ID/FK)
	private String signsId;     // SIGNS_ID (회원아이디/FK)
	
	private int signsWait;      // SIGNS_WAIT (대기번호)
	private int signsStatus;    // SIGNS_STATUS (신청상태)
	
	private Date signsDate;     // SIGNS_DATE (신청날짜)
	
	// [추가] 마이페이지 목록 조회용 (JOIN된 데이터 담을 변수)
		private String actTitle;    // 활동 제목
		private Date actDate;       // 활동 시작일
		private String actAddress;  // 활동 장소
}
