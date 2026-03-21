package com.ubig.app.volunteer.service;

import java.util.List;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.volunteer.ActivityVO;
import com.ubig.app.vo.volunteer.SignVO;
import com.ubig.app.vo.volunteer.VolunteerCommentVO;
import com.ubig.app.vo.volunteer.VolunteerReviewVO;

public interface VolunteerService {

	
	// [추가] 총 게시글 수 조회
    int selectActivityCount(java.util.HashMap<String, String> map);

    // [수정] 목록 조회 (PageInfo 추가)
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
    // [수정] 봉사 후기 상세페이지 댓글 목록 조회 (REVIEW_NO 필수)
    List<VolunteerCommentVO> selectReplyList(VolunteerCommentVO vo);
 // [추가] 후기 댓글 목록 조회 (Controller가 찾는 이름) 12월 24일 15:29분 안티그래비티가 백업수정 다안해줌
    List<VolunteerCommentVO> selectReviewReplyList(VolunteerCommentVO vo);
    // [수정] 봉사 후기 댓글 등록 (REVIEW_NO 필수)
    int insertReply(VolunteerCommentVO r);
 // [추가] 후기 댓글 등록 (Controller가 찾는 이름)12월 24일 15:29분 안티그래비티가 백업수정 다안해줌
    int insertReviewReply(VolunteerCommentVO r);

    // --- 댓글 삭제 (공통) ---
    // [추가 사유] 댓글 삭제 비즈니스 로직 수행
    int deleteReply(int cmtNo);

    // --- 신청 관련 ---
    // [추가 사유] 봉사 신청 정보 데이터 전달
    int insertSign(SignVO s);
    // [추가 사유] 신청자 목록 데이터 전달
    List<SignVO> selectSignList(int actId);

    // --- 후기 관련 ---
    // [추가 사유] 봉사 후기 등록 로직 수행
    int insertReview(VolunteerReviewVO r);
    // [추가 사유] 봉사 후기 목록 조회 로직 수행
    List<VolunteerReviewVO> selectReviewList(int actId);
    
 // [추가] 후기 총 갯수 조회
    int selectReviewCount(java.util.HashMap<String, String> map);

    // [수정] 후기 목록 조회 (PageInfo 매개변수 추가)
    List<VolunteerReviewVO> selectReviewListAll(java.util.HashMap<String, String> map, com.ubig.app.common.model.vo.PageInfo pi);
    
    // [추가 사유] 후기 상세 조회 로직 수행
    VolunteerReviewVO selectReviewOne(int reviewNo);

    // [추가 사유] 후기 수정 기능
    int updateReview(VolunteerReviewVO r);

    // [추가 사유] 후기 삭제 기능
    int deleteReview(int reviewNo);
    
    // VolunteerService.java (인터페이스)

    // [추가] 후기 없는 활동 목록 조회
    List<ActivityVO> selectActivityNoReview();
    


    // [관리자] 신청 승인/반려 처리 (signsNo:신청번호, status:처리상태)
    // 리턴값 설명 -> 1:성공, 0:실패, -1:정원초과
    int updateSignStatusAdmin(int signsNo, String status); 

    // [사용자] 신청 취소 처리
    // 리턴값 설명 -> 1:성공, 0:실패
    int updateSignStatusUser(int signsNo);
    
    //마이페이지
    // [추가] 내 신청 개수 조회
    int selectMySignCount(String userId);
    
    //마이페이지
    // [수정] 내 신청 목록 조회 (PageInfo 추가)
    List<SignVO> selectMySignList(String userId, PageInfo pi);
    
    // [추가] 일괄 완료 처리
    int updateSignStatusMulti(List<Integer> signsNos);
    

}
