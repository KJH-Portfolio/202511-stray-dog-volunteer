package com.ubig.app.member.service;

import java.util.ArrayList;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.member.MessageVO;

public interface MessageService {

	ArrayList<MessageVO> selectInbox(String userId, PageInfo pi);

	int unreadCount(String userId);

	int insertMessage(MessageVO message);

	ArrayList<MessageVO> selectSent(String userId, PageInfo pi);

	int readMessage(int messageNo);

	int receiveListCount(String userId);

	int sendListCount(String userId);

}
