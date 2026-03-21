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

public class AdoptionApplicationVO {
    private int adoptionAppId; // 신청번호
    private int animalNo; // 동물 상세 고유 번호
    private String userId; // 회원 아이디
    private int adoptStatus; // 신청 상태
    private Date applyDt; // 신청 날짜
    private String photoUrl; // 동물 사진 URL (JOIN)
    private String applyDateStr; // 신청 날짜 (String Formatted)
    private String animalName; // 동물 이름 (JOIN)
    private String userName; // 신청자 이름 (JOIN)
    private String userNickname; // 신청자 닉네임 (JOIN)
}
