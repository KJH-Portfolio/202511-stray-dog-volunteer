package com.ubig.app.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;

import com.ubig.app.vo.member.MemberVO;

//admin이어야지만 접근 가능한 곳에 접근 제한 걸기(오류 페이지로)
public class AdminInterceptor implements HandlerInterceptor {

	// 요청 처리 전 간섭
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		Object loginMember = request.getSession().getAttribute("loginMember");

		// 관리자가 아니라면 관리자만 가능한 페이지임을 알림
		MemberVO member = (MemberVO) loginMember;
		if (member == null || !"ADMIN".equals(member.getUserRole())) {

			request.getSession().setAttribute("alertMsg", "관리자만 접근 가능합니다.");
			response.sendRedirect(request.getContextPath());
			return false;
		}

		return true;
	}
}