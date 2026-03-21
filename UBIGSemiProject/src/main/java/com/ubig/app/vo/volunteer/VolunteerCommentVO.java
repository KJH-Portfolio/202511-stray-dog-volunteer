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
public class VolunteerCommentVO {
	
	private int cmtNo;          // CMT_NO (댓글번호/PK)
	private int actId;          // ACT_ID (프로그램ID/FK)
	private String userId;      // USER_ID (회원아이디/FK)
	
	private String cmtAnswer;   // CMT_ANSWER (봉사활동댓글)
	
	private Date cmtDate;       // CMT_DATE (작성일시)
	private Date cmtUpdate;     // CMT_UPDATE (수정)
	
	private int cmtRemove;      // CMT_REMOVE (삭제)
	
	private Integer cmtRate;    // CMT_RATE (평점, NULL 허용)
	
	private Integer reviewNo;   // REVIEW_NO (후기 번호, NULL 허용)
}
