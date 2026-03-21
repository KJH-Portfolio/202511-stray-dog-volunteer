package com.ubig.app.funding.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.funding.DonationVO;
import com.ubig.app.vo.funding.FundingHistoryVO;
import com.ubig.app.vo.funding.FundingVO;

@Repository
public class FundingDao {

	public ArrayList<FundingVO> selectFunding(SqlSessionTemplate sqlSession,PageInfo pi) {
		
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
	    int limit = pi.getBoardLimit();

	    RowBounds rowBounds = new RowBounds(offset,limit);
	   
		return (ArrayList)sqlSession.selectList("fundingMapper.selectFunding",null,rowBounds);
	}
	
	public int fundingListCount(SqlSessionTemplate sqlSession) {
		
		return sqlSession.selectOne("fundingMapper.fundingListCount");
	}
	
	public int fundingListCount2(SqlSessionTemplate sqlSession, String searchKeyword) {
		
		return sqlSession.selectOne("fundingMapper.fundingListCount2",searchKeyword);
	}
	
	public int insertFunding(SqlSessionTemplate sqlSession, FundingVO fundingVO) {
		
		return sqlSession.insert("fundingMapper.insertFunding",fundingVO);
	}

	public int insertMoney(SqlSessionTemplate sqlSession, FundingHistoryVO fundingHistoryVO) {
		
		return sqlSession.insert("fundingMapper.insertMoney",fundingHistoryVO);
	}

	public FundingVO fundingDetailView(SqlSessionTemplate sqlSession,int fundingNo) {
		
		return sqlSession.selectOne("fundingMapper.fundingDetailView",fundingNo);
	}

	public ArrayList<FundingVO> searchKeyword(SqlSessionTemplate sqlSession, String searchKeyword, PageInfo pi) {
		
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
	    int limit = pi.getBoardLimit();

	    RowBounds rowBounds = new RowBounds(offset,limit);
		
		return (ArrayList)sqlSession.selectList("fundingMapper.searchKeyword",searchKeyword,rowBounds);
	}

	

	

	

	
}
