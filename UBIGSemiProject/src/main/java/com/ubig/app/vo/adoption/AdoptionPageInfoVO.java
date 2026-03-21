package com.ubig.app.vo.adoption;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder

public class AdoptionPageInfoVO {
	
	public int currentPage;//현재 페이지
	public int listCount;//리스트의 갯수
	
	public int boardLimit;//페이지당 보드 갯수
	public int PageLimit;//페이징바 개수
	
	public int maxPage;//전체 페이지수가 몇개인지
	public int startPage;//시작 페이지(몇페이지인지)
	public int endPage;//마지막 페이지(몇페이지인지)

}
