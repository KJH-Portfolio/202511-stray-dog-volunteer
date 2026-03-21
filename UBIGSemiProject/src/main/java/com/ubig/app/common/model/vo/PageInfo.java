package com.ubig.app.common.model.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PageInfo {
    private int listCount; // 총 게시글 수
    private int currentPage; // 현재 페이지 (cpage)
    private int pageLimit; // 하단 페이징 바의 페이지 갯수 (예: 10개씩)
    private int boardLimit; // 한 페이지에 보여질 게시글 갯수 (예: 10, 20, 50)

    private int maxPage; // 가장 마지막 페이지
    private int startPage; // 페이징 바의 시작 수
    private int endPage; // 페이징 바의 끝 수
}
