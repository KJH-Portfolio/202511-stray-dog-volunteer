package com.ubig.app.vo.adoption;

import java.util.List;
import lombok.Data;

@Data
public class AdoptionSearchFilterVO {
    private Integer species; // 1:강아지, 2:고양이
    private Integer gender; // 1:남, 2:여
    private Integer neutered; // 0:X, 1:O

    private Double ageMin;
    private Double ageMax;

    private Double weightMin;
    private Double weightMax;

    private String breed;
    private String hopeRegion;

    private String keyword; // 통합 검색어 (제목 등)
}
