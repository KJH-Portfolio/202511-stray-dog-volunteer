package com.ubig.app.vo.volunteer;

import java.sql.Date; // DB 날짜형 호환을 위해 sql.Date 권장
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class VolunteerReviewVO {

    private int reviewNo; // REVIEW_NO (후기번호/PK)
    private int actId; // ACT_ID (프로그램ID/FK)

    private String rId; // R_ID (회원아이디/FK)
    private String rReview; // R_REVIEW (봉사활동후기)
    private int rRate; // R_RATE (봉사평점)

    private String rTitle; // R_TITLE (후기제목)

    private Date rCreate; // R_CREATE (작성일시)
    private Date rUpdate; // R_UPDATE (수정일시)
    private int rRemove; // R_REMOVE (후기삭제)

    private String actTitle; // ACT_TITLE (목록 표시용 제목)

    public String getrId() {
        return rId;
    }

    public String getrReview() {
        return rReview;
    }

    public int getrRate() {
        return rRate;
    }

    public String getrTitle() {
        return rTitle;
    }

    public Date getrCreate() {
        return rCreate;
    }

    public Date getrUpdate() {
        return rUpdate;
    }

    public int getrRemove() {
        return rRemove;
    }

    private double actRate;

    public double getActRate() {
        return actRate;
    }

}