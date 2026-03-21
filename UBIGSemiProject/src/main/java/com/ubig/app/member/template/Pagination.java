package com.ubig.app.member.template;

import com.ubig.app.common.model.vo.PageInfo;

public class Pagination {
	
	// 페이징 처리용 PageInfo 객체에 필드를 담아주는 메소드 (계산처리까지)
	
	public static PageInfo getPageInfo(int listCount, int currentPage,
									   int boardLimit, int pageLimit) {
		
		int maxPage = (int) Math.ceil((double) listCount / boardLimit);
		int startPage = (currentPage - 1) / pageLimit * pageLimit + 1;
		int endPage = startPage + pageLimit - 1;
		
		// endPage가 maxPage보다 클때
		if (maxPage < endPage) {
			endPage = maxPage;
		}
		
		
		PageInfo pi2 = PageInfo.builder()
							   .currentPage(currentPage)
							   .listCount(listCount)
							   .boardLimit(boardLimit)
							   .pageLimit(pageLimit)
							   .maxPage(maxPage)
							   .startPage(startPage)
							   .endPage(endPage)
							   .build();
		
		return pi2;
	}
}
