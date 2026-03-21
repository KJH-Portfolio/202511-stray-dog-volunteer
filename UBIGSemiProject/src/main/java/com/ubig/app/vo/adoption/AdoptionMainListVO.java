package com.ubig.app.vo.adoption;

import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
// adoption 게시물 조회용 VO(table없음)
public class AdoptionMainListVO {
    // Post Data
    private int postNo; // 게시물 번호
    private String postTitle; // 제목
    private Date postUpdateDate; // 수정일
    private int views; // 조회수
    private String postRegDate; // 게시글 등록일 (String Formatted)

    // Animal Data
    private int animalNo; // 동물 번호 (Link)
    private String photoUrl; // 사진 경로
    private String animalName; // 동물 이름 (확장성 고려)
    private String adoptionStatus; // 입양 상태

    // Additional Animal Data for Main Page Display
    private String animalAge; // 나이
    private String animalGender; // 성별
    private String animalWeight; // 몸무게
    private String hopeRegion; // 지역
}
