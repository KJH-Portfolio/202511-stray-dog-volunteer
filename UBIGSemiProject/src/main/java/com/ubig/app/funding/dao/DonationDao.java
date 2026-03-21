package com.ubig.app.funding.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.funding.DonationVO;

@Repository
public class DonationDao {
	
	public ArrayList<DonationVO> selectDonation(SqlSessionTemplate sqlSession,PageInfo pi) {
		
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
	    int limit = pi.getBoardLimit();

	    RowBounds rowBounds = new RowBounds(offset,limit);
		
		return (ArrayList)sqlSession.selectList("donationMapper.selectDonation",null,rowBounds);
	}
	
	public int donationListCount(SqlSessionTemplate sqlSession) {
		
		return sqlSession.selectOne("donationMapper.donationListCount");
	}
	
	public int donationListCount2(SqlSessionTemplate sqlSession, String userId) {
		
		return sqlSession.selectOne("donationMapper.donationListCount2",userId);
	}
	
	public int donationListCount3(SqlSessionTemplate sqlSession,String userId) {
		
		return sqlSession.selectOne("donationMapper.donationListCount3",userId);
	}
	
	public int donationSearchCount(SqlSessionTemplate sqlSession, String searchKeyword) {
		
		return sqlSession.selectOne("donationMapper.donationSearchCount",searchKeyword);
	}
	
	public ArrayList<DonationVO> searchKeyword(SqlSessionTemplate sqlSession, String searchKeyword,PageInfo pi) {
		
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
	    int limit = pi.getBoardLimit();

	    RowBounds rowBounds = new RowBounds(offset,limit);
		
		return (ArrayList)sqlSession.selectList("donationMapper.searchKeyword",searchKeyword,rowBounds);
	}
	
	public int donation(SqlSessionTemplate sqlSession, DonationVO donationVO) {
		
		return sqlSession.insert("donationMapper.donation",donationVO);
	}

	public int donation2(SqlSessionTemplate sqlSession, DonationVO donationVO) {
		
		return sqlSession.insert("donationMapper.donation2",donationVO);
	}

	public int selectDetailView(SqlSessionTemplate sqlSession,String userId) {
	
		return sqlSession.selectOne("donationMapper.selectDetailView",userId);
	}

	public int cancelDonation(SqlSessionTemplate sqlSession, String userId) {
		
		return sqlSession.delete("donationMapper.cancelDonation",userId);
	}

	public ArrayList<DonationVO> myDonation(SqlSessionTemplate sqlSession, String userId, PageInfo pi) {
		
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
	    int limit = pi.getBoardLimit();

	    RowBounds rowBounds = new RowBounds(offset,limit);
		
		return (ArrayList)sqlSession.selectList("donationMapper.myDonation",userId,rowBounds);
	}

	public ArrayList<DonationVO> myDonation2(SqlSessionTemplate sqlSession, String userId, PageInfo pi) {
		
		int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
	    int limit = pi.getBoardLimit();

	    RowBounds rowBounds = new RowBounds(offset,limit);
		
		return (ArrayList)sqlSession.selectList("donationMapper.myDonation2",userId,rowBounds);
	}

	

	

	
	
	
}