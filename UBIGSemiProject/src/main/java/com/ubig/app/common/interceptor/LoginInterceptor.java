package com.ubig.app.common.interceptor;

import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import com.ubig.app.member.service.MemberService;
import com.ubig.app.vo.member.MemberVO;

//로그인 해야지만 접근 가능한 페이지 인터셉터(로그인 정보가 없으면 로그인 페이지로 이동)
public class LoginInterceptor implements HandlerInterceptor {
	
	@Autowired
	private MemberService service;

	// 요청 처리 전 간섭
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		MemberVO loginMember = (MemberVO) request.getSession().getAttribute("loginMember");

		// 로그인 정보가 없으면 로그인 페이지로 이동
		if (loginMember == null) {
			request.getSession().setAttribute("alertMsg", "로그인 후 접근 가능합니다.");
			response.sendRedirect(request.getContextPath() + "/user/login.me");
			return false;
		}
		else {
			loginMember = service.loginMember(loginMember);
			System.out.println("인터셉터에서 세션 로그인 정보를 갱신하였습니다.");
			// TODO : 정지 기한이 현재 시간보다 늦다면 강제로 로그아웃시킨다.
			
			LocalDate userRestrictEndDate = loginMember.getUserRestrictEndDate().toLocalDate(); // 정지가 걸려있는 일자
			LocalDate currentDate = new Date(System.currentTimeMillis()).toLocalDate(); // 현재 일자
			
			// 현재 날짜가 정지 일자를 지나지 않았다면, 정지된 상태임을 알리고 로그아웃 처리한다.
			if (currentDate.isBefore(userRestrictEndDate)) {
				String dateFormatString = DateTimeFormatter.ofPattern("yyyy-MM-dd").format(userRestrictEndDate);
				request.getSession().setAttribute("alertMsg", "관리자에 의해 " + dateFormatString + "까지 계정이 정지되어 있어 로그아웃됩니다. 자세한 사항은 관리자에게 문의해주세요.");
				request.getSession().removeAttribute("loginMember");
				response.sendRedirect(request.getContextPath());
				return false;
			}
			
			request.getSession().setAttribute("loginMember", loginMember);
		}

		return true;
	}
}
