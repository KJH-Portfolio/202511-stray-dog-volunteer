package com.ubig.app.funding.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.common.util.Pagination;
import com.ubig.app.funding.service.DonationService;
import com.ubig.app.vo.funding.DonationVO;
import com.ubig.app.vo.member.MemberVO;

@Controller
@RequestMapping("/donation")
public class DonationController {
	
	@Autowired
	private DonationService service;
	
	//후원 페이지 이동
	@RequestMapping("")
	public String donationViewPage(@RequestParam(value = "curPage", defaultValue = "1") int curPage,
	        Model model) {

	    int listCount = service.donationListCount();
	
	    int boardLimit = 15; // 한 페이지에 보여줄 개수
	    int pageLimit = 10;  // 페이징 바 개수
	
	    PageInfo pi = Pagination.getPageInfo(listCount, curPage, pageLimit, boardLimit);
	    
	    ArrayList<DonationVO> list = service.selectDonation(pi);
	
	    model.addAttribute("list", list);
	    model.addAttribute("pi", pi);
	    
		return "funding/donationPage";
	}
	
	//검색 기능
	@RequestMapping("/searchKeyword")
	public String searchKeyword(@RequestParam(value = "curPage", defaultValue = "1") int curPage,
	        Model model,@RequestParam(value = "searchKeyword", required = false) String searchKeyword) {
		
		int listCount = service.donationSearchCount(searchKeyword);

	    int boardLimit = 15; // 한 페이지에 보여줄 개수
	    int pageLimit = 10;  // 페이징 바 개수

	    PageInfo pi = Pagination.getPageInfo(listCount, curPage, pageLimit, boardLimit);
		
		ArrayList<DonationVO> list = service.searchKeyword(searchKeyword,pi);
		
		// 후원 타입 검색
	    if ("정기".equals(searchKeyword)) {
	        list = service.searchKeyword("1",pi);
	    } 
	    else if ("일시".equals(searchKeyword)) {
	        list = service.searchKeyword("2",pi);
	    } 
	    // 그 외 검색
	    else {
	        list = service.searchKeyword(searchKeyword,pi);
	    }
		
		model.addAttribute("list",list);
		model.addAttribute("pi", pi);
	    model.addAttribute("keyword", searchKeyword); // 검색어 유지
			
		return "funding/donationPage";
			
	}
	
	//내 정기 후원 목록
	@RequestMapping("myDonation")
	public String myDonation(HttpSession session,@RequestParam(value = "curPage", defaultValue = "1") int curPage,
		       Model model) {
			
		MemberVO m = (MemberVO)session.getAttribute("loginMember");
		
		int listCount = service.donationListCount2(m.getUserId());
		
		int boardLimit = 15; // 한 페이지에 보여줄 개수
		int pageLimit = 10;  // 페이징 바 개수
		
		PageInfo pi = Pagination.getPageInfo(listCount, curPage, pageLimit, boardLimit);
		   
		ArrayList<DonationVO> list = service.myDonation(pi,m.getUserId());
		
		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		
		return "funding/donationPage";
	}
	
	//내 일시 후원 목록
		@RequestMapping("myDonation2")
		public String myDonation2(HttpSession session,@RequestParam(value = "curPage", defaultValue = "1") int curPage,
			       Model model) {
				
			MemberVO m = (MemberVO)session.getAttribute("loginMember");
			
			int listCount = service.donationListCount3(m.getUserId());
			
			int boardLimit = 15; // 한 페이지에 보여줄 개수
			int pageLimit = 10;  // 페이징 바 개수
			
			PageInfo pi = Pagination.getPageInfo(listCount, curPage, pageLimit, boardLimit);
			   
			ArrayList<DonationVO> list = service.myDonation2(pi,m.getUserId());
			
			model.addAttribute("list", list);
			model.addAttribute("pi", pi);
			
			System.out.println(pi.getEndPage());
			
			return "funding/donationPage";
		}
	
	
	//후원 상세 페이지 이동
	@RequestMapping("/donationDetailView")
	public String donationPage(HttpSession session,Model model) {
		
		MemberVO m = (MemberVO)session.getAttribute("loginMember");
		
		int result = service.selectDetailView(m.getUserId());
        
		model.addAttribute("result", result);
		
		return "funding/donationDetailView";
	}
	
	//정기 후원
	@RequestMapping("/donation") 
	public String donation(HttpSession session,DonationVO donationVO) {
	  
		int result = service.donation(donationVO);
		  
		if(result>0) { 
			session.setAttribute("alertMsg", "정기 후원 완료"); 
		}else {
			session.setAttribute("alertMsg", "정기 후원 실패"); }
		  
		 return "redirect:/donation"; 
	}
	
	// 정기 후원 해제
    @PostMapping("/cancelDonation")
    @ResponseBody
    public String cancelDonation(HttpSession session) {
        
    	MemberVO m = (MemberVO)session.getAttribute("loginMember");
    	
    	int result = service.cancelDonation(m.getUserId());
    	
    	if(result>0) {
    		return "success";
    	}else {
    		return "fail";
    	}
    	
    }
	
	//일시 후원
	@RequestMapping("/donation2")
	public String donation2(HttpSession session,DonationVO donationVO) {
		
		int result = service.donation2(donationVO);
		
		if(result>0) {
			session.setAttribute("alertMsg", "일시 후원 완료");
		}else {
			session.setAttribute("alertMsg", "일시 후원 실패");
		}
		
		return "redirect:/donation";
	}
	
	
	
}