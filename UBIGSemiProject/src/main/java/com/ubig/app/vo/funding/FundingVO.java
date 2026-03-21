package com.ubig.app.vo.funding;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class FundingVO {
	
	private int fundingNo;
	private String userId;
	private String fundingTitle;
	private String fundingContent;
	private int fundingMaxMoney;
	private int fundingCurrentMoney;
	
}
