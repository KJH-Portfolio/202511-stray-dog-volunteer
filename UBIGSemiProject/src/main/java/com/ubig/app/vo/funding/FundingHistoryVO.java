package com.ubig.app.vo.funding;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class FundingHistoryVO {
	
	private int fhNo;
	private String userId;
	private int fundingNo;
	private int fundingMoney;
	private Date inputDate;
	
}
