package com.ubig.app.member.controller;

import java.util.ArrayList;
import java.util.Collections;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.member.service.AdminChatService;
import com.ubig.app.member.service.MemberService;
import com.ubig.app.member.template.Pagination;
import com.ubig.app.vo.member.AdminChatHistoryVO;
import com.ubig.app.vo.member.MemberVO;

@Controller
@RequestMapping("/admin")

public class AdminChatController {
	
	@Autowired
	private AdminChatService adminChatService;
	
	@Autowired
	private MemberService memberService;
	
	/*
	 * 어드민 페이지에서는 모든 일반 회원과 의사소통할 수 있어야한다.
	 * chatList에서는 모든 일반 회원 리스트가 뜨도록 하며
	 * 버튼을 누르면 해당 회원과의 1:1 채팅창으로 이동한다.
	 * 
	 * 발신인이 어드민이면 수신인은 일반회원이고
	 * 발신인이 일반회원이면 수신인은 어드민이다.
	 * 
	 * 
	 * 
	 */
	
	@RequestMapping("/chatList.ch")
	public String chatList(Model model, @RequestParam(value="curPage", defaultValue="1") int curPage) {
		// 가장 최근 채팅이 올라온 유저부터 순서대로 표시한다.
		// ...구현이 힘들어질 것 같으니 일단 MEMBERS에서 리스트 뽑아서 채팅 버튼 만들기
		
		int listCount = memberService.listCount();
		int boardLimit = 15;
		int pageLimit = 10;
		
		PageInfo pi = Pagination.getPageInfo(listCount, curPage, boardLimit, pageLimit);
		System.out.println(pi);
		
		ArrayList<MemberVO> list = memberService.selectListByUserIdAsc(pi);
		
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		
		return "admin/chatlist";
	}
	
	@RequestMapping("/chat.ch")
	public String chat(HttpSession session, String userId, Model model) {
		
		// 최근 100개의 메시지 가져오기
		ArrayList<AdminChatHistoryVO> list = adminChatService.selectChat(userId);
		
		// 표시될 때는 먼저 보내진 메시지부터 가져와야하므로 reverse
		Collections.reverse(list);
		
		session.setAttribute("chatReceiveUserId", userId);
		session.setAttribute("list", list);
		
		System.out.println(userId);
		
		System.out.println(list);
		
		return "admin/chat";
	}
}
