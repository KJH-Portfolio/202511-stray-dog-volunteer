package com.ubig.app.member.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.member.service.KickService;
import com.ubig.app.member.service.MessageService;
import com.ubig.app.member.template.Pagination;
import com.ubig.app.vo.member.KickVO;
import com.ubig.app.vo.member.MemberVO;
import com.ubig.app.vo.member.MessageVO;

@Controller
@RequestMapping("/kick")
public class KickController {
	
	@Autowired
	private KickService kickService;
	
	@Autowired
	private MessageService messageService;
	
	// 차단 여부 확인
	@ResponseBody
	@PostMapping("/isKicked.ki")
	public String isKicked(HttpSession session, String messageSendUserId, String messageReceiveUserId) {
		KickVO kick = KickVO.builder()
						    .kicker(messageReceiveUserId)
						    .kickedUser(messageSendUserId)
						    .build();
		
		int result = kickService.isKicked(kick);
		
		// 이미 차단 상태라면 차단 테이블에 등록되어 있으므로 result > 0이다.
		if (result > 0) {
			return "kicked";
		}
		else {
			return "notkicked";
		}
	}
	
	// 차단 처리
	@ResponseBody
	@PostMapping("/insertKick.ki")
	public String insertKick(HttpSession session, KickVO kick) {
		int result = kickService.insertKick(kick);
		
		// 차단에 성공했다면 success, 아니라면 fail을 리턴한다.
		if (result > 0) {
			return "success";
		}
		else {
			return "fail";
		}
	}
	
	// 차단 리스트로 이동
	@RequestMapping("/kickList.ki")
	public String selectKick(HttpSession session, Model model, @RequestParam(value="curPage", defaultValue="1") int curPage) {
		
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		// 현재 회원의 차단 리스트를 담아서 반환
		
		int listCount = kickService.kickListCount(loginMember.getUserId());
		
		int boardLimit = 20;
		int pageLimit = 10;
		
		PageInfo pi = Pagination.getPageInfo(listCount, curPage, boardLimit, pageLimit);
		System.out.println("kickList pi : " + pi);
		
		ArrayList<KickVO> list = kickService.selectKick(loginMember.getUserId(), pi);
		
		System.out.println(listCount);
		System.out.println(list);
		
		int unreadCount = messageService.unreadCount(loginMember.getUserId());
		
		model.addAttribute("list", list);
		model.addAttribute("unreadCount", unreadCount);
		model.addAttribute("pi", pi);
		
		return "member/kicklist";
	}
	
	// 차단 삭제
	@PostMapping("/deleteKick.ki")
	public String deleteKick(int kickNo, HttpSession session) {
		
		MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
		
		// 차단 삭제 처리
		int result = kickService.deleteKick(kickNo);
		
		if (result > 0) {
			session.setAttribute("alertMsg", "차단이 해제되었습니다.");
		}
		else {
			session.setAttribute("alertMsg", "차단 해제에 실패했습니다.");
		}
		
		return "redirect:/kick/kickList.ki";
	}
}
