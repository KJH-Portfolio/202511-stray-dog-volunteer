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

public class TagInfoVO {
	//수정
	private int tagId;          // TAG_ID (태그 고유 ID/PK)
	private String tagName;     // TAG_NAME (태그 이름 / 예: "산책", "봉사", "대형견" 등)
	
	

}
