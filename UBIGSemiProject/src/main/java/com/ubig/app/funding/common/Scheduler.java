package com.ubig.app.funding.common;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.ubig.app.funding.service.FundingService;

@Service
public class Scheduler {
	
	@Autowired
	private FundingService service;
	
	@Autowired
	private SqlSession session;
	
	@Scheduled(cron = "*/30 * * * * *")
	public void donation() {
		
		
		
	}
		
}

