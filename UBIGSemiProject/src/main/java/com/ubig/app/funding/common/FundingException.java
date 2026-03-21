package com.ubig.app.funding.common; // 본인 프로젝트 구조에 맞게 변경

public class FundingException extends RuntimeException {

    // 기본 생성자
    public FundingException() {
        super();
    }

    // 메시지를 받는 생성자
    public FundingException(String message) {
        super(message);
    }

    // 메시지 + 원인 예외 받는 생성자 (선택)
    public FundingException(String message, Throwable cause) {
        super(message, cause);
    }
}
