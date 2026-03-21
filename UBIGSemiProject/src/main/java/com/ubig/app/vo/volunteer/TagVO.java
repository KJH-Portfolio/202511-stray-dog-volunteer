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
public class TagVO {
	//수정
	private int tagNo;      // TAG_NO (태그 연결 고유 번호/PK)
	private int actId;      // ACT_ID (활동 ID/FK - Activity 참조)
	private int tagId;      // TAG_ID (태그 키워드 ID/FK - 태그 종류를 모아둔 테이블 참조 예상)
	
	

}
