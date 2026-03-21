package com.ubig.app.admin.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ubig.app.admin.dao.AdminDao;
import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.community.BoardVO;
import com.ubig.app.vo.funding.DonationVO;
import com.ubig.app.vo.member.MemberVO;
import com.ubig.app.vo.volunteer.ActivityVO;

@Service
public class AdminServiceImpl implements AdminService{
	
	@Autowired
	private AdminDao dao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public ArrayList<MemberVO> selectUser(PageInfo pi) {

		return dao.selectUser(sqlSession,pi);
	}
	
	@Override
	public int adminListCount() {
		
		return dao.adminListCount(sqlSession);
	}
	
	@Override
	public int adminListCount2() {

		return dao.adminListCount2(sqlSession);
	}
	
	@Override
	public ArrayList<MemberVO> searchKeyword(String searchKeyword, PageInfo pi) {
		
		return dao.searchKeyword(sqlSession,searchKeyword,pi);
	}
	
	@Override
	public int updateStatus(HashMap<String,String> map) {
		
		return dao.updateStatus(sqlSession,map);
	}
	
	@Override
	public int changeStatus(HashMap<String, String> map) {
		
		return dao.changeStatus(sqlSession,map);
	}
	
	@Override
	public int deleteUser(String userId) {
		
		return dao.deleteUser(sqlSession,userId);
	}
	
	@Override
	public ArrayList<BoardVO> selectBoard() {
		
		return dao.selectBoard(sqlSession);
	}
	
	@Override
	public int insertBoard(BoardVO b) {
		
		return dao.insertBoard(sqlSession,b);
	}
	
	@Override
	public ArrayList<ActivityVO> selectActivity() {

		return dao.selectActivity(sqlSession);
	}
	
	@Override
	public int insertActivity(ActivityVO a) {
		
		return dao.insertActivity(sqlSession,a);
	}
	
	
	
	
}
