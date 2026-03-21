package com.ubig.app.funding.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.funding.common.FundingException;
import com.ubig.app.funding.dao.FundingDao;
import com.ubig.app.vo.funding.FundingHistoryVO;
import com.ubig.app.vo.funding.FundingVO;

@Service
public class FundingServiceImpl implements FundingService{
	
	@Autowired
	private FundingDao dao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Override
	public ArrayList<FundingVO> selectFunding(PageInfo pi) {

	    return dao.selectFunding(sqlSession,pi);
	}
	
	@Override
	public int fundingListCount() {
		
		return dao.fundingListCount(sqlSession);
	}
	
	@Override
	public int fundingListCount2(String searchKeyword) {

		return dao.fundingListCount2(sqlSession,searchKeyword);
	}
	
	@Override
	public int insertFunding(FundingVO fundingVO) {
	
		return dao.insertFunding(sqlSession,fundingVO);
	}
	
	@Override
	public int insertMoney(FundingHistoryVO fundingHistoryVO) {
	    try {
	        return dao.insertMoney(sqlSession,fundingHistoryVO);
	    } catch (Exception e) {
	        // DB 트리거 ORA-20001 체크
	        if (e.getMessage() != null && e.getMessage().contains("ORA-20001")) {
	            throw new FundingException("펀딩 목표 금액을 초과할 수 없습니다.");
	        }

	        // 다른 예외
	        throw new FundingException("펀딩 처리 중 오류가 발생했습니다.");
	    }
	}

	@Override
	public FundingVO fundingDetailView(int fundingNo) {
		
		return dao.fundingDetailView(sqlSession,fundingNo);
	}
	
	@Override
	public ArrayList<FundingVO> searchKeyword(String searchKeyword,PageInfo pi) {

		return dao.searchKeyword(sqlSession,searchKeyword,pi);
	}
	
	
}
