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
public class DonationVO {
	
	private int donationNo;
	private String userId;
	private int donationType;
	private int donationMoney;
	private int donationYn;
	private Date donationDate;
	
}
