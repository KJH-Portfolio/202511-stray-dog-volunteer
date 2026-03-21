package com.ubig.app.admin.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ubig.app.admin.service.AdminService;
import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.common.util.Pagination;
import com.ubig.app.vo.community.BoardVO;
import com.ubig.app.vo.funding.FundingVO;
import com.ubig.app.vo.member.MemberVO;
import com.ubig.app.vo.volunteer.ActivityVO;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	private AdminService service;
	
	//관리자 페이지 이동
	@RequestMapping("")
	public String adminPage(Model model) {
		
		int listCount = service.adminListCount();
		
		model.addAttribute("listCount",listCount);
		
		return "admin/adminPage";
	}
	
	//회원 관리 페이지
	@RequestMapping("/userStatus")
	public String selectUser(
				@RequestParam(value = "curPage", defaultValue = "1") int curPage,
				Model model) {
		
		int listCount = service.adminListCount();
		
	    int boardLimit = 10; // 한 페이지에 보여줄 개수
	    int pageLimit = 10;  // 페이징 바 개수
	
	    PageInfo pi = Pagination.getPageInfo(listCount, curPage, pageLimit, boardLimit);
	    
	    ArrayList<MemberVO> list = service.selectUser(pi);
	
	    model.addAttribute("list", list);
	    model.addAttribute("pi", pi);
		
		return "admin/userStatusView";
	}
	
	//검색 기능
	@RequestMapping("/searchKeyword")
	public String searchKeyword(@RequestParam(value = "curPage", defaultValue = "1") int curPage,
	        Model model,@RequestParam(value = "searchKeyword", required = false) String searchKeyword) {
				
		int listCount = service.adminListCount2();
		
	    int boardLimit = 10; // 한 페이지에 보여줄 개수
	    int pageLimit = 10;  // 페이징 바 개수
	
	    PageInfo pi = Pagination.getPageInfo(listCount, curPage, pageLimit, boardLimit);
	    
	    ArrayList<MemberVO> list = service.searchKeyword(searchKeyword,pi);
	
	    model.addAttribute("list", list);
	    model.addAttribute("pi", pi);
	    model.addAttribute("keyword", searchKeyword);
				
		return "admin/userStatusView";
				
	}
	
	//회원 정지
	@RequestMapping("/stopUser")
	@ResponseBody
	public String updateStatus(HttpSession session,String userId,String days) {
		
		HashMap<String,String> map = new HashMap<>();
		map.put("days", days);
		map.put("userId", userId);
		
		int result = service.updateStatus(map);
		
		if(result>0) {
			session.setAttribute("alertMsg", "회원 정지 성공");
			return "success";
		}else {
			session.setAttribute("alertMsg", "회원 정지 실패");
			return "fail";
		}
		
		
	}
	
	//회원 정지 해제
	@RequestMapping("/openUser")
	public String changeStatus(HttpSession session,String userId,String days) {
	
		HashMap<String,String> map = new HashMap<>();
		map.put("days", days);
		map.put("userId", userId);
		
		int result = service.changeStatus(map);
		
		if(result>0) {
			session.setAttribute("alertMsg", "회원 정지 해제 성공");
		}else {
			session.setAttribute("alertMsg", "회원 정지 해제 실패");
		}
		
		return "redirect:userStatus";
	}
	
	//회원 추방
	@RequestMapping("/deleteUser")
	public String deleteUser(HttpSession session,String userId) {
		
		int result = service.deleteUser(userId);
		
		if(result>0) {
			session.setAttribute("alertMsg", "회원 추방 성공");
		}else {
			session.setAttribute("alertMsg", "회원 추방 성공");
		}
		
		return "redirect:userStatus";
	}
	
	//공지글 관리 페이지 이동
	@RequestMapping("/boardPage")
	public String boardPage(Model model) {
		
		ArrayList<BoardVO> list = service.selectBoard();
		
		model.addAttribute("list",list);
		
		return "admin/boardPage";
	}
	
	@RequestMapping("/selectBoard")
	public String selectBoard(Model model) {
		
		return "";
	}
	
	//공지글 등록 페이지로 이동
	@RequestMapping("/insertBoardPage")
	public String insertBoardPage() {
		
		return "admin/insertBoard";
	}
	
	//공지글 등록
	@RequestMapping("/insertBoard")
	public String insertBoard(HttpSession session,BoardVO b) {
		
		int result = service.insertBoard(b);
		
		if(result>0) {
			session.setAttribute("alertMsg", "공지글 등록 성공");
		}else {
			session.setAttribute("alertMsg", "공지글 등록 성공");
		}
		
		return "redirect:boardPage";
	}
	
	//봉사활동 관리 페이지 이동
	@RequestMapping("/activityPage")
	public String activityPage(Model model) {
		
		ArrayList<ActivityVO> list = service.selectActivity();
		
		model.addAttribute("list",list);
		
		return "admin/activityPage";
	}
	
	//봉사활동 등록
	@RequestMapping("/insertActivity")
	public String insertActivity(HttpSession session,ActivityVO a) {
		
		int result = service.insertActivity(a);
			
		if(result>0) {
			session.setAttribute("alertMsg", "봉사활동 등록 성공");
		}else {
			session.setAttribute("alertMsg", "봉사활동 등록 실패");
		}
		
		return "redirect:activityPage";
	}
	
}
