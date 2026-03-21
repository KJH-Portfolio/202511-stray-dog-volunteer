package com.ubig.app.member.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.member.MemberVO;

@Repository
public class MemberDao {
	
	// 로그인 정보 가져오기
	public MemberVO loginMember(SqlSessionTemplate sqlSession, MemberVO inputMember) {
		return sqlSession.selectOne("memberMapper.loginMember", inputMember);
	}
	
	// 회원가입 처리하기
	public int insertMember(SqlSessionTemplate sqlSession, MemberVO m) {
		return sqlSession.insert("memberMapper.insertMember", m);
	}
	
	// 아이디 중복 체크하기
	public int checkId(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("memberMapper.checkId", userId);
	}
	
	// 쪽지 전송 시 가입되어있는 아이디인지 확인
	public int messageCheckId(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("memberMapper.messageCheckId", userId);
	}
	
	public int updateMember(SqlSessionTemplate sqlSession, MemberVO m) {
		return sqlSession.update("memberMapper.updateMember", m);
	}

	public int deleteMember(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.update("memberMapper.deleteMember", userId);
	}

	public int addAge(SqlSessionTemplate sqlSession) {
		return sqlSession.update("memberMapper.addAge");
	}
	
	// 회원 아이디 오름차순으로 전부 가져오기
	public ArrayList<MemberVO> selectListByUserIdAsc(SqlSessionTemplate sqlSession, PageInfo pi) {
		int offset = pi.getBoardLimit() * (pi.getCurrentPage() - 1);
		int limit = pi.getBoardLimit();
		RowBounds rb = new RowBounds(offset, limit);
		return (ArrayList) sqlSession.selectList("memberMapper.selectListByUserIdAsc", null, rb);
	}

	public int listCount(SqlSessionTemplate sqlSession) {
		return sqlSession.selectOne("memberMapper.listCount");
	}



}
