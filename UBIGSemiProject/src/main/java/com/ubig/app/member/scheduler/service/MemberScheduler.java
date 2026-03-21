package com.ubig.app.member.scheduler.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.ubig.app.member.service.MemberService;

@Service
public class MemberScheduler {
	
	@Autowired
	private MemberService service;
	
	// 연도가 바뀔 때마다 수행할 작업.
	// 1. 나이에 1 더하기
	@Scheduled(cron = "0 0 0 1 1 *")
	//@Scheduled(cron = "0 * * * * *")
	public void yearlyScheduler() {
		
		int result = service.addAge();
		
		System.out.println("yearlyScheduler : " + result + "명의 나이를 1 증가시켰습니다.");
	}
}
