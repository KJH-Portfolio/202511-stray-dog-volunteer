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
public class DonationFileVO {
	
	private int fileId;
	private int fNo;
	private String originalName;
	private String savedName;
	private String filePath;
	private int fileSize;
	private Date createDate;
	
}
