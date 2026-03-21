package com.ubig.app.member.service;

import java.util.ArrayList;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.member.KickVO;
import com.ubig.app.vo.member.MessageVO;

public interface KickService {
	int isKicked(KickVO kick);

	int insertKick(KickVO kick);

	ArrayList<KickVO> selectKick(String userId, PageInfo pi);

	int deleteKick(int kickNo);

	int kickListCount(String userId);
}
