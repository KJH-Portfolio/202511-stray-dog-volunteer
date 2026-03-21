package com.ubig.app.member.service;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.member.dao.MessageDao;
import com.ubig.app.vo.member.MessageVO;


@Service
public class MessageServiceImpl implements MessageService{
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private MessageDao dao;
	
	// 메시지 수신함 가져오기
	@Override
	public ArrayList<MessageVO> selectInbox(String userId, PageInfo pi) {
		return dao.selectInbox(sqlSession, userId, pi);
	}
	
	// 읽지 않은 메시지 개수 가져오기
	@Override
	public int unreadCount(String userId) {
		return dao.unreadCount(sqlSession, userId);
	}
	
	// 메시지 전송 기능
	@Override
	public int insertMessage(MessageVO message) {
		return dao.insertMessage(sqlSession, message);
	}
	
	// 메시지 발신함 가져오기
	@Override
	public ArrayList<MessageVO> selectSent(String userId, PageInfo pi) {
		return dao.selectSent(sqlSession, userId, pi);
	}
	
	// 메시지 읽음 처리
	@Override
	public int readMessage(int messageNo) {
		return dao.readMessage(sqlSession, messageNo);
	}
	
	// 받은 메시지 개수 가져오기
	@Override
	public int receiveListCount(String userId) {
		return dao.receiveListCount(sqlSession, userId);
	}
	
	// 보낸 메시지 개수 가져오기
	@Override
	public int sendListCount(String userId) {
		return dao.sendListCount(sqlSession, userId);
	}

}
