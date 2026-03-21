package com.ubig.app.member.controller;

import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ubig.app.member.service.MemberService;
import com.ubig.app.vo.member.MemberVO;

@Controller
@RequestMapping("/user")
public class MemberController {

	// MemberService
	@Autowired
	private MemberService service;

	// 테스트 로그인 (관리자 권한)
	@GetMapping("/testLogin")
	public String testLogin(HttpSession session) {
		MemberVO testAdmin = MemberVO.builder()
				.userId("admin")
				.userPwd("1234") // Any password
				.userName("관리자")
				.userNickname("개발자")
				.userRole("ADMIN")
				.build();
		session.setAttribute("loginMember", testAdmin);
		session.setAttribute("loginUser", testAdmin); // Compatibility
		return "redirect:/community/list?category=NOTICE";
	}

	// BCryptPasswordEncoder 사용하기 위해서 스프링에게 주입 처리 하기
	@Autowired
	private BCryptPasswordEncoder bcrypt;

	// 로그인 페이지로 이동
	@GetMapping("/login.me")
	public String login() {

		return "member/login";
	}

	// 로그인 처리
	@PostMapping("/login.me")
	public String loginMember(HttpSession session,
			String userId,
			String userPwd,
			Model model) {

		System.out.println(userId);
		System.out.println(userPwd);
		// 사용자가 입력한 아이디와 비밀번호를 가져온다.

		MemberVO inputMember = MemberVO.builder().userId(userId).userPwd(userPwd).build();
		
		MemberVO loginMember = service.loginMember(inputMember);
		
		System.out.println(inputMember);
		System.out.println(loginMember);
		
		// 아이디와 암호화된 비밀번호가 일치하는 컬럼이 데이터베이스에 존재한다면 로그인 성공 및 세션에 로그인 정보 저장
		if (loginMember != null && bcrypt.matches(inputMember.getUserPwd(), loginMember.getUserPwd())) {
			
			LocalDate userRestrictEndDate = loginMember.getUserRestrictEndDate().toLocalDate(); // 정지가 걸려있는 일자
			LocalDate currentDate = new Date(System.currentTimeMillis()).toLocalDate(); // 현재 일자
			
			// 현재 날짜가 정지 일자를 지나지 않았다면, 정지된 상태임을 알리고 로그인 처리를 거부해야 한다.
			if (currentDate.isBefore(userRestrictEndDate)) {
				String dateFormatString = DateTimeFormatter.ofPattern("yyyy-MM-dd").format(userRestrictEndDate);
				session.setAttribute("msg", "현재 " + dateFormatString + "까지 계정이 정지되어있습니다. 자세한 사항은 관리자에게 문의해주세요.");
				return "member/login";
			}
			
			session.setAttribute("loginMember", loginMember);
			return "redirect:/";
		}
		// 존재하지 않는다면 로그인 실패 처리 및 login 페이지로 다시 이동 후 실패 알림
		else {
			session.setAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
			return "member/login";
		}
	}
	
	// 로그아웃 처리
	@PostMapping("/logout.me")
	public String logout(HttpSession session, Model model) {
		// HttpSession에서 loginMember에 대한 정보를 가져온다.
		// 만약 loginMember 정보가 없다면 이미 로그아웃된 상태이고,
		// loginMember에 정보가 있다면 로그아웃 시켜준다.
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		if (loginMember != null) {
			session.removeAttribute("loginMember");
			session.setAttribute("alertMsg", "로그아웃되었습니다.");
		} else {
			session.setAttribute("alertMsg", "이미 로그아웃 되어있습니다.");
		}
		return "redirect:/";
	}

	// 회원가입 페이지 이동
	@GetMapping("/signup.me")
	public String signup() {
		return "member/signup";
	}

	// 회원가입 처리
	@PostMapping("/sign.me")
	public String insertMember(HttpSession session, MemberVO m) {
		
		// 비밀번호 암호화
		m.setUserPwd(bcrypt.encode(m.getUserPwd()));
		
		int result = service.insertMember(m);
		
		if (result > 0) {
			session.setAttribute("alertMsg", "회원가입에 성공하였습니다.");
			return "redirect:/user/login.me";
		} else {
			session.setAttribute("alertMsg", "회원가입에 실패하였습니다.");
			return "redirect:/user/signup.me";
		}

		
		// TODO 회원가입에 실패했을 경우 기존에 입력된 내용이 유지되도록?
	}

	// 아이디 중복 체크
	@ResponseBody
	@RequestMapping("/checkId.me")
	public String checkId(String userId) {
		// 이미 존재하는 아이디라면 fail, 존재하지 않는 아이디라면 success 추가

		int result = service.checkId(userId);

		if (result > 0) {
			return "fail";
		} else {
			return "success";
		}
	}
	
	// 쪽지 전송 시 가입되어있는 아이디인지 확인
	@ResponseBody
	@RequestMapping("/messageCheckId.me")
	public String messageCheckId(String userId) {
		// 이미 존재하는 아이디라면 fail, 존재하지 않는 아이디라면 success 추가

		int result = service.messageCheckId(userId);

		if (result > 0) {
			return "success";
		} else {
			return "fail";
		}
	}

	// 마이페이지 이동
	@RequestMapping("/mypage.me")
	public String mypage() {
		return "member/mypage";
	}
	
	// TODO 회원수정 처리
	@PostMapping("/update.me")
	public String updateMember(HttpSession session, Model model, MemberVO m) {
		
		int result = service.updateMember(m);
		
		if (result > 0) {
			session.setAttribute("alertMsg", "정보 수정에 성공했습니다.");
			MemberVO loginMember = service.loginMember(m);
			session.setAttribute("loginMember", loginMember);
		}
		else {
			session.setAttribute("alertMsg", "정보 수정에 실패했습니다.");
		}
		
		return "redirect:/user/mypage.me";
	}

	// 회원탈퇴 처리
	@PostMapping("/delete.me")
	public String deleteMember(HttpSession session, Model model) {
		
		// 현재 로그인되어 있는 상태일 경우 로그인 되어있는 ID에 해당하는 유저의 가입 상태를 N으로 변경한다.
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		
		if (loginMember != null) {
			// 회원탈퇴 처리
			int result = service.deleteMember(loginMember.getUserId());
			if (result > 0) {
				session.removeAttribute("loginMember");
				session.setAttribute("alertMsg", "회원 탈퇴가 정상적으로 처리되었습니다.");
				return "redirect:/";
			}
			else {
				session.setAttribute("alertMsg", "회원 탈퇴에 실패했습니다.");
			}
			
			
		}
		else {
			session.setAttribute("alertMsg", "회원 탈퇴에 실패했습니다.");
		}
		
		return "redirect:/";
	}
}
