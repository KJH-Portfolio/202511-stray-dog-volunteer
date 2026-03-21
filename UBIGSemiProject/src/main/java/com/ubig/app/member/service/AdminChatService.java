package com.ubig.app.member.service;

import java.util.ArrayList;

import com.ubig.app.vo.member.AdminChatHistoryVO;
import com.ubig.app.vo.member.MemberVO;

public interface AdminChatService {

	ArrayList<MemberVO> chatList();

	int insertChat(AdminChatHistoryVO chat);

	ArrayList<AdminChatHistoryVO> selectChat(String userId);

	int listCount();

}
