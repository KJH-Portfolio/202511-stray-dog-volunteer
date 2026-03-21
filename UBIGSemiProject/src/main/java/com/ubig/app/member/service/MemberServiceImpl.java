package com.ubig.app.member.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.member.dao.MemberDao;
import com.ubig.app.vo.member.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private MemberDao dao;
	
	// 로그인 정보 가져오기
	@Override
	public MemberVO loginMember(MemberVO inputMember) {
		return dao.loginMember(sqlSession, inputMember);
	}
	
	// 회원가입 처리하기
	@Override
	public int insertMember(MemberVO m) {
		return dao.insertMember(sqlSession, m);
	}
	
	// 아이디 중복 체크
	@Override
	public int checkId(String userId) {
		return dao.checkId(sqlSession, userId);
	}
	
	// 쪽지 전송 시 가입되어 있는 아이디인지 확인
	@Override
	public int messageCheckId(String userId) {
		return dao.messageCheckId(sqlSession, userId);
	}
	
	// 회원 수정 처리
	@Override
	public int updateMember(MemberVO m) {
		return dao.updateMember(sqlSession, m);
	}
	
	// 회원 탈퇴 처리
	@Override
	public int deleteMember(String userId) {
		return dao.deleteMember(sqlSession, userId);
	}
	
	// 나이에 1 더하기
	@Override
	public int addAge() {
		return dao.addAge(sqlSession);
	}
	
	// 회원 아이디 오름차순으로 전부 가져오기
	@Override
	public ArrayList<MemberVO> selectListByUserIdAsc(PageInfo pi) {
		return dao.selectListByUserIdAsc(sqlSession, pi);
	}
	
	// 현재 회원 수 가져오기
	@Override
	public int listCount() {
		return dao.listCount(sqlSession);
	}
	
}
