package com.ubig.app.adoption.common;

import com.ubig.app.vo.adoption.AdoptionPageInfoVO;

public class AdoptionPagination {
	//페이징 처리용
	public static AdoptionPageInfoVO getPageInfo(int listCount,int currentPage,int boardLimit,int pageLimit) {
		//리스트 갯수
		//현재 페이지
		//보드를 한 페이지에 몇개 보여줄지
		//페이지를 한 페이지에 몇개 보여줄지
	int maxPage = (int)Math.ceil((double)listCount/boardLimit);
	int startPage = (currentPage-1)/pageLimit*pageLimit+1;
	int endPage = startPage+pageLimit-1;
	
	if(maxPage<endPage) {
	endPage = maxPage;
	}
	
	AdoptionPageInfoVO pi =	AdoptionPageInfoVO.builder()
			.listCount(listCount)
		    .currentPage(currentPage)
		    .boardLimit(boardLimit)
		    .PageLimit(pageLimit)
		    .maxPage(maxPage)
		    .startPage(startPage)
		    .endPage(endPage)
		    .build(); 
		    
	return pi;
	}
}
