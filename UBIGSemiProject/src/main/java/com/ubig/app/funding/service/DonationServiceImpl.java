package com.ubig.app.funding.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.funding.dao.DonationDao;
import com.ubig.app.vo.funding.DonationVO;

@Service
public class DonationServiceImpl implements DonationService{
	
	@Autowired
	private DonationDao dao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public ArrayList<DonationVO> selectDonation(PageInfo pi) {
		
		return dao.selectDonation(sqlSession,pi);
	}
	
	@Override
	public int donationListCount() {
		
		return dao.donationListCount(sqlSession);
	}
	
	@Override
	public int donationListCount2(String userId) {
		
		return dao.donationListCount2(sqlSession,userId);
	}
	
	@Override
	public int donationListCount3(String userId) {
		
		return dao.donationListCount3(sqlSession,userId);
	}
	
	@Override
	public int donationSearchCount(String searchKeyword) {
		
		return dao.donationSearchCount(sqlSession,searchKeyword);
	}
	
	@Override
	public ArrayList<DonationVO> searchKeyword(String searchKeyword,PageInfo pi) {
		
		return dao.searchKeyword(sqlSession,searchKeyword,pi);
	}
	
	@Override
	public ArrayList<DonationVO> myDonation(PageInfo pi, String userId) {
		
		return dao.myDonation(sqlSession,userId,pi);
	}
	
	@Override
	public ArrayList<DonationVO> myDonation2(PageInfo pi, String userId) {
		
		return dao.myDonation2(sqlSession,userId,pi);
	}
	
	@Override
	public int selectDetailView(String userId) {
		
		return dao.selectDetailView(sqlSession,userId);
	}
	
	@Override
	public int donation(DonationVO donationVO) {
		
		return dao.donation(sqlSession,donationVO);
	}
	
	@Override
	public int cancelDonation(String userId) {
		
		return dao.cancelDonation(sqlSession,userId);
	}
	
	@Override
	public int donation2(DonationVO donationVO) {
		
		return dao.donation2(sqlSession,donationVO);
	}
	
	
	
}