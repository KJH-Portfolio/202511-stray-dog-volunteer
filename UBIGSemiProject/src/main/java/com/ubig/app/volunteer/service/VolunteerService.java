package com.ubig.app.volunteer.service;

import java.util.List;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.volunteer.ActivityVO;
import com.ubig.app.vo.volunteer.SignVO;
import com.ubig.app.vo.volunteer.VolunteerCommentVO;
import com.ubig.app.vo.volunteer.VolunteerReviewVO;

public interface VolunteerService {

	
    int selectActivityCount(java.util.HashMap<String, String> map);

    List<ActivityVO> selectActivityList(java.util.HashMap<String, String> map, PageInfo pi);
	
	
	//2.활동 등록
	int insertActivity(ActivityVO a);
	
	
	// 3. 활동 글 상세 조회
	ActivityVO selectActivityOne(int actId);
	
	// 4. 활동 글 삭제
		int deleteActivity(int actId);
		
		
	// 5. 수정
	int updateActivity(ActivityVO a);
	
	// --- 댓글 관련 (봉사 후기 전용으로 변경) ---
    List<VolunteerCommentVO> selectReplyList(VolunteerCommentVO vo);
    List<VolunteerCommentVO> selectReviewReplyList(VolunteerCommentVO vo);
    int insertReply(VolunteerCommentVO r);
    int insertReviewReply(VolunteerCommentVO r);

    // --- 댓글 삭제 (공통) ---
    int deleteReply(int cmtNo);

    // --- 신청 관련 ---
    int insertSign(SignVO s);
    List<SignVO> selectSignList(int actId);

    // --- 후기 관련 ---
    int insertReview(VolunteerReviewVO r);
    List<VolunteerReviewVO> selectReviewList(int actId);
    
    int selectReviewCount(java.util.HashMap<String, String> map);

    List<VolunteerReviewVO> selectReviewListAll(java.util.HashMap<String, String> map, com.ubig.app.common.model.vo.PageInfo pi);
    
    VolunteerReviewVO selectReviewOne(int reviewNo);

    int updateReview(VolunteerReviewVO r);

    int deleteReview(int reviewNo);
    
    // VolunteerService.java (인터페이스)

    List<ActivityVO> selectActivityNoReview();
    


    // 신청 승인/반려 처리
    // 리턴값 설명 -> 1:성공, 0:실패, -1:정원초과
    int updateSignStatusAdmin(int signsNo, String status); 

    // 신청 취소 처리
    // 리턴값 설명 -> 1:성공, 0:실패
    int updateSignStatusUser(int signsNo);
    
    int selectMySignCount(String userId);
    
    List<SignVO> selectMySignList(String userId, PageInfo pi);
    
    int updateSignStatusMulti(List<Integer> signsNos);
    

}
