package com.ubig.app.member.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.member.dao.KickDao;
import com.ubig.app.vo.member.KickVO;

@Service
public class KickServiceImpl implements KickService {
	
	@Autowired
	private KickDao dao;
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	// 수신자가 발신자를 차단했는지 유무 체크
	@Override
	public int isKicked(KickVO kick) {
		return dao.isKicked(sqlSession, kick);
	}
	
	// 차단 목록 삽입하기
	@Override
	public int insertKick(KickVO kick) {
		return dao.insertKick(sqlSession, kick);
	}
	
	// 차단 목록 가져오기
	@Override
	public ArrayList<KickVO> selectKick(String userId, PageInfo pi) {
		return dao.selectKick(sqlSession, userId, pi);
	}
	
	// 차단 목록 삭제하기
	@Override
	public int deleteKick(int kickNo) {
		return dao.deleteKick(sqlSession, kickNo);
	}
	
	// 차단 목록 개수 가져오기
	@Override
	public int kickListCount(String userId) {
		return dao.kickListCount(sqlSession, userId);
	}
	
}
