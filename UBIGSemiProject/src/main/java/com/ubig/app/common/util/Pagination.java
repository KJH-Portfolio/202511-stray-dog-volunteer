package com.ubig.app.common.util;

import com.ubig.app.common.model.vo.PageInfo;

public class Pagination {

    public static PageInfo getPageInfo(int listCount, int currentPage, int pageLimit, int boardLimit) {

        // * maxPage : 가장 마지막 페이지(총 페이지 수)
        // listCount가 101개이고 boardLimit가 10이면 -> 11페이지
        int maxPage = (int) Math.ceil((double) listCount / boardLimit);

        // * startPage : 페이징 바의 시작 수
        // pageLimit가 10일 때, currentPage가 1~10 -> 1 / 11~20 -> 11
        int startPage = (currentPage - 1) / pageLimit * pageLimit + 1;

        // * endPage : 페이징 바의 끝 수
        // startPage가 1이면 -> 10 / 11이면 -> 20
        int endPage = startPage + pageLimit - 1;

        // endPage가 maxPage보다 클 경우 처리
        if (endPage > maxPage) {
            endPage = maxPage;
        }

        return PageInfo.builder()
                .listCount(listCount)
                .currentPage(currentPage)
                .pageLimit(pageLimit)
                .boardLimit(boardLimit)
                .maxPage(maxPage)
                .startPage(startPage)
                .endPage(endPage)
                .build();
    }
}
