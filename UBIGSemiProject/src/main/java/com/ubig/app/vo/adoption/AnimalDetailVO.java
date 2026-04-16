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
public class AnimalDetailVO {

    private Integer animalNo; // 동물 상세 고유 번호
    private Integer species; // 강아지/고양이 여부 (1:강아지, 2:고양이 등)
    private String animalName; // 동물의 이름
    private String breed; // 품종
    private Integer gender; // 성별 (1:남성, 2:여성 등)
    private Double age; // 나이
    private Double weight; // 체중
    private Double petSize; // 크기
    private Integer neutered; // 중성화여부 (0:미완료, 1:완료)
    private String vaccinationStatus; // 접종 상태
    private String healthNotes; // 특이사항
    private String adoptionStatus; // 입양 상태
    private String adoptionConditions; // 입양 조건
    private String photoUrl; // 동물사진/파일
    private String hopeRegion; // 입양 희망 지역
    private Date deadlineDate; // 마감 기한
    private String userId; // 사용자 ID
    private Integer postNo; // 게시글 번호 (Left Join)

}
