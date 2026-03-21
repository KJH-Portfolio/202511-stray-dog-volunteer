package com.ubig.app.member.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.member.MessageVO;

@Repository
public class MessageDao {
	
	// 메시지 수신함 가져오기
	public ArrayList<MessageVO> selectInbox(SqlSessionTemplate sqlSession, String userId, PageInfo pi) {
		int offset = pi.getBoardLimit() * (pi.getCurrentPage() - 1);
		int limit = pi.getBoardLimit();
		RowBounds rb = new RowBounds(offset, limit);
		return (ArrayList) sqlSession.selectList("messageMapper.selectInbox", userId, rb);
	}
	
	// 읽지 않은 메시지 개수 가져오기
	public int unreadCount(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("messageMapper.unreadCount", userId);
	}
	
	// 메시지 전송하기
	public int insertMessage(SqlSessionTemplate sqlSession, MessageVO message) {
		return sqlSession.insert("messageMapper.insertMessage", message);
	}
	
	// 메시지 발신함 가져오기
	public ArrayList<MessageVO> selectSent(SqlSessionTemplate sqlSession, String userId, PageInfo pi) {
		int offset = pi.getBoardLimit() * (pi.getCurrentPage() - 1);
		int limit = pi.getBoardLimit();
		RowBounds rb = new RowBounds(offset, limit);
		return (ArrayList) sqlSession.selectList("messageMapper.selectSent", userId, rb);
	}
	
	// 메시지 읽음 처리
	public int readMessage(SqlSessionTemplate sqlSession, int messageNo) {
		return sqlSession.update("messageMapper.readMessage", messageNo);
	}

	// 받은 메시지 개수 가져오기
	public int receiveListCount(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("messageMapper.receiveListCount", userId);
	}
	
	// 보낸 메시지 개수 가져오기
	public int sendListCount(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("messageMapper.sendListCount", userId);
	}
	
	

}
