package com.ubig.app.vo.adoption;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder

public class AdoptionPostVO {
	
	private int postNo;             // 게시물 고유 번호
    private int animalNo;           // 동물 상세 고유 번호
    private String userId;          // 관리자 아이디
    private String postTitle;       // 게시물 제목
    private Date postRegDate;       // 게시물 등록일
    private Date postUpdateDate;    // 게시물 최종 수정일
    private int views;              // 게시물 조회수

}
