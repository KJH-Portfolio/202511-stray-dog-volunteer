package com.ubig.app.vo.volunteer;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class ActivityVO {
	// 수정
	private int actId; // ACT_ID (PK예상)
	private String adminId; // ADMIN_ID (작성자 ID)
	// ★ HTML에서 날짜를 받아올 때 "yyyy-MM-dd" 모양이라고 알려주는 설정
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date actDate; // 봉사 시작일

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date actEnd; // 봉사 종료일
	private String actAddress; // ACT_ADDRESS (주소)

	// 위도(LAT), 경도(LON)는 소수점이 있으므로 double 사용
	private double actLat; // ACT_LAT
	private double actLon; // ACT_LON

	private Date actLoad; // ACT_LOAD (등록일/업로드일?)
	private String actTitle; // ACT_TITLE (제목)

	private int actMax; // ACT_MAX (최대 인원)
	private int actCur; // ACT_CUR (현재 인원)
	private int actMoney; // ACT_MONEY (금액/회비)

	private double actRate; // 관리자 전용 봉사후기에 회원들이 평점부여하는 필드

}
