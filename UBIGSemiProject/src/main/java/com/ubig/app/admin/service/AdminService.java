package com.ubig.app.admin.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.community.BoardVO;
import com.ubig.app.vo.funding.DonationVO;
import com.ubig.app.vo.funding.FundingVO;
import com.ubig.app.vo.member.MemberVO;
import com.ubig.app.vo.volunteer.ActivityVO;

public interface AdminService {
	
	ArrayList<MemberVO> selectUser(PageInfo pi);
	
	int adminListCount();
	
	int adminListCount2();
	
	ArrayList<MemberVO> searchKeyword(String searchKeyword, PageInfo pi);

	int updateStatus(HashMap<String,String> map);

	int deleteUser(String userId);

	int insertBoard(BoardVO b);

	int insertActivity(ActivityVO a);

	int changeStatus(HashMap<String, String> map);

	ArrayList<BoardVO> selectBoard();

	ArrayList<ActivityVO> selectActivity();

	

	

}
