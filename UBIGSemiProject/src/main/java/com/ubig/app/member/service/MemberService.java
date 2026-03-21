package com.ubig.app.member.service;

import java.util.ArrayList;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.member.MemberVO;

public interface MemberService {

	MemberVO loginMember(MemberVO inputMember);

	int insertMember(MemberVO m);

	int checkId(String userId);

	int messageCheckId(String userId);

	int deleteMember(String userId);

	int updateMember(MemberVO m);

	int addAge();
	
	ArrayList<MemberVO> selectListByUserIdAsc(PageInfo pi);

	int listCount();

}
