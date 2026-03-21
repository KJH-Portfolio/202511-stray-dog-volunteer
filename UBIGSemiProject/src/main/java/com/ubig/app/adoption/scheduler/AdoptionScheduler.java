package com.ubig.app.adoption.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.ubig.app.adoption.service.AdoptionService;

@Component
public class AdoptionScheduler {

    @Autowired
    private AdoptionService adoptionService;

    // 매일 자정(00:00:00)에 실행
    @Scheduled(cron = "0 0 0 * * *")
    public void scheduleExpireAdoptions() {
        System.out.println("[AdoptionScheduler] 마감 기한 체크 및 상태 업데이트 시작");

        int count = adoptionService.expireOverdueAdoptions();

        if (count > 0) {
            System.out.println("[AdoptionScheduler] " + count + "건의 입양 게시글이 마감 처리되었습니다.");
        } else {
            System.out.println("[AdoptionScheduler] 마감 처리된 게시글이 없습니다.");
        }
    }
}
