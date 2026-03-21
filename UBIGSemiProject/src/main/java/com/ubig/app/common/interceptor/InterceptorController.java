package com.ubig.app.common.interceptor;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class InterceptorController {
	// 에러 페이지로 이동시키기
	@GetMapping("/common/errerpage")
	public String errerpage() {
		return "common/errorpage";
	}

}
