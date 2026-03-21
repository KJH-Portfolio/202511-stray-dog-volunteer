package com.ubig.app.volunteer.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.volunteer.ActivityVO;
import com.ubig.app.vo.volunteer.SignVO;
import com.ubig.app.vo.volunteer.VolunteerCommentVO;
import com.ubig.app.vo.volunteer.VolunteerReviewVO;
import com.ubig.app.volunteer.dao.VolunteerDao;

@Service
public class VolunteerServiceImpl implements VolunteerService {

    @Autowired
    private VolunteerDao volunteerDao;
	
	
	// [기능] 검색 조건에 해당하는 봉사활동 게시글의 총 개수를 조회 (페이징 계산용)
    // [기술] MyBatis selectOne (COUNT 집계 함수)
	@Override
    public int selectActivityCount(HashMap<String, String> map) {
        return volunteerDao.selectActivityCount(map);
    }

    // [기능] 검색 조건과 페이징 정보를 바탕으로 봉사활동 게시글 목록을 조회
    // [기술] MyBatis selectList (RowBounds 사용)
    @Override
    public List<ActivityVO> selectActivityList(HashMap<String, String> map, PageInfo pi) {
        // DAO에게 PageInfo도 같이 넘겨줌
        return volunteerDao.selectActivityList(map, pi);
    }

    @Override
    public int insertActivity(ActivityVO a) {
        return volunteerDao.insertActivity(a);
    }

    @Override
    public ActivityVO selectActivityOne(int actId) {
        return volunteerDao.selectActivityOne(actId);
    }

    @Override
    public int deleteActivity(int actId) {
        // [수정] 무결성 제약조건 위배 방지: 자식 레코드 먼저 삭제
        // 1. 댓글 삭제
        volunteerDao.deleteCommentsByActId(actId);
        // 2. 후기 삭제
        volunteerDao.deleteReviewsByActId(actId);
        // 3. 신청 내역 삭제
        volunteerDao.deleteSignsByActId(actId);

        // 4. 활동 본문 삭제
        return volunteerDao.deleteActivity(actId);
    }

    @Override
    public int updateActivity(ActivityVO a) {
        return volunteerDao.updateActivity(a);
    }

    // [기능] 특정 활동 또는 후기에 달린 댓글 목록을 조회
    // [기술] MyBatis selectList
    @Override
    public List<VolunteerCommentVO> selectReplyList(VolunteerCommentVO vo) {
        return volunteerDao.selectReplyList(vo);
    }

    // [기능] 댓글을 등록하고, 평점이 포함된 경우 활동의 평균 평점을 업데이트
    // [기술] MyBatis insert, update (평점 재계산 Trigger 성격의 로직)
    @Override
    public int insertReply(VolunteerCommentVO r) {
        int result = volunteerDao.insertReply(r);
        // [추가] 후기 댓글도 평점이 있으면 ACT_RATE 업데이트
        if (result > 0 && r.getCmtRate() != null) {
            volunteerDao.updateActivityRate(r.getActId());
        }
        return result;
    }
    // [기능] 댓글을 삭제하고, 평점이 포함되었던 댓글이면 활동의 평균 평점을 재계산
    // [기술] MyBatis delete, update (Data Integrity 유지)
    @Override
    public int deleteReply(int cmtNo) {
        // [추가] 삭제 전 미리 정보 조회
        VolunteerCommentVO c = volunteerDao.selectCommentOne(cmtNo);

        int result = volunteerDao.deleteReply(cmtNo);

        // [추가] 삭제 성공 & 평점이 있었던 댓글이라면 재계산
        if (result > 0 && c != null && c.getCmtRate() != null) {
            volunteerDao.updateActivityRate(c.getActId());
        }
        return result;
    }
    
    // [기능] 봉사활동 신청 처리 (중복 신청 및 정원 초과 여부를 순차적으로 검증 후 신청 진행)
    // [기술] Java Logic (Sequential Checks), Transaction Management
    @Override
    public int insertSign(SignVO s) {
        // [1단계] 중복 신청 체크 (가장 먼저 해야 함!)
        // 이미 신청했다면 count가 1이 나옴
        int count = volunteerDao.checkDuplicateSign(s);

        if (count > 0) {
            System.out.println("❌ 중복 신청 감지! (" + s.getSignsId() + ")");
            return -2; // -2는 "이미 신청함"이라는 우리만의 신호입니다.
        }

        // [2단계] 정원 체크 (아까 만든 로직)
        ActivityVO activity = volunteerDao.selectActivityOne(s.getActId());
        if (activity == null)
            return 0;

        if (activity.getActCur() >= activity.getActMax()) {
            System.out.println("❌ 정원 초과!");
            return -1; // -1은 "정원 초과"
        }

        // [3단계] 모든 검사 통과 -> 등록 진행
        return volunteerDao.insertSign(s);
    }
    // [기능] 특정 활동의 신청자 목록을 조회
    // [기술] MyBatis selectList
    @Override
    public List<SignVO> selectSignList(int actId) {
        return volunteerDao.selectSignList(actId);
    }

    // [기능] 후기를 등록하고, 관련된 활동의 평균 평점을 업데이트 (중복 등록 방지 포함)
    // [기술] MyBatis insert, update, Logic Check
    @Override
    public int insertReview(VolunteerReviewVO r) {
        // [1단계: 추가됨] 중복 체크 먼저 수행
        // DAO에 checkDuplicateReview 메서드가 없으면 빨간줄이 뜨니,
        // 꼭 DAO와 Mapper에 먼저 추가해야 합니다.
        int count = volunteerDao.checkDuplicateReview(r.getActId());

        if (count > 0) {
            System.out.println("❌ 중복 후기 감지! ACT_ID: " + r.getActId());
            return -2; // "이미 등록됨"을 뜻하는 -2를 리턴 (Controller로 전달됨)
        }

        // [2단계: 기존 로직] 후기 등록
        int result = volunteerDao.insertReview(r);

        // [3단계: 기존 로직] 등록 성공 시 활동 평균 평점 재계산
        if (result > 0) {
            volunteerDao.updateActivityRate(r.getActId());
        }

        return result;
    }

    // [기능] 특정 활동에 대한 후기 목록 조회
    // [기술] MyBatis selectList
    @Override
    public List<VolunteerReviewVO> selectReviewList(int actId) {
        return volunteerDao.selectReviewList(actId);
    }
    
    // [기능] 전체 후기 개수 조회 (페이징용)
    // [기술] MyBatis selectOne
    @Override
    public int selectReviewCount(HashMap<String, String> map) {
        return volunteerDao.selectReviewCount(map);
    }

    // [기능] 전체 후기 목록을 페이징 처리하여 조회
    // [기술] MyBatis selectList, RowBounds
    @Override
    public List<VolunteerReviewVO> selectReviewListAll(HashMap<String, String> map, PageInfo pi) {
        // DAO로 PageInfo 전달
        return volunteerDao.selectReviewListAll(map, pi);
    }
    
    // [기능] 특정 후기의 상세 정보 조회
    // [기술] MyBatis selectOne
    @Override
    public VolunteerReviewVO selectReviewOne(int reviewNo) {
        return volunteerDao.selectReviewOne(reviewNo);
    }
    
    // [기능] 후기 정보를 수정하고 평점이 변경되었을 경우 활동 평점을 재계산
    // [기술] MyBatis update, Logic Check (Consistency)
    @Override
    public int updateReview(VolunteerReviewVO r) {
        // [추가] 후기 내용/평점 수정 시에도 평균 평점 업데이트가 필요할 수 있음
        int result = volunteerDao.updateReview(r);
        if (result > 0) {
            // r에는 actId가 없을 수도 있으므로(화면에서 안넘겨줬다면),
            // 안전하게 하려면 DB에서 먼저 조회해야 하지만,
            // 보통 수정화면에서 hidden으로 actId를 넘겨주거나,
            // 여기서 다시 조회해서 업데이트를 하는게 좋습니다.
            // 일단 사용자 요청은 "insert"와 "delete"에 집중되어 있으나,
            // update 시에도 점수가 바뀌면 반영되어야 하므로 추가하는게 맞습니다.
            // 원활한 처리를 위해 actId를 조회 로직 추가
            VolunteerReviewVO temp = volunteerDao.selectReviewOne(r.getReviewNo());
            if (temp != null) {
                volunteerDao.updateActivityRate(temp.getActId());
            }
        }
        return result;
    }

    // [기능] 후기를 삭제하고 활동의 평균 평점을 재계산 (Soft Delete 적용 가능성)
    // [기술] MyBatis delete (or update), Rate Recalculation
    @Override
    public int deleteReview(int reviewNo) {
        // [추가] 삭제 전 actId를 조회해야 함 (삭제 후엔 조회 안될 수도 있거나, FK 문제 등)
        // 하지만 Soft Delete(R_REMOVE=1)이므로 조회는 가능.
        VolunteerReviewVO r = volunteerDao.selectReviewOne(reviewNo);

        int result = volunteerDao.deleteReview(reviewNo);

        if (result > 0 && r != null) {
            // [추가] 후기 삭제(숨김) 성공 시, 해당 활동의 평균 평점 업데이트
            volunteerDao.updateActivityRate(r.getActId());
        }
        return result;
    }

    // ==========================================
    // ▼ [누락된 후기 전용 메서드 추가] ▼ 12월 24일 15:29분 안티그래비티가 백업수정 다안해줌
    // ==========================================

    // [기능] 후기 댓글 목록 조회 (기존 댓글 조회 로직 재사용)
    // [기술] Code Reuse (method wrapping)
    @Override
    public List<VolunteerCommentVO> selectReviewReplyList(VolunteerCommentVO vo) {
        // 기존에 만들어둔 DAO 메서드 재사용
        return volunteerDao.selectReplyList(vo);
    }

    // [기능] 후기 댓글을 등록하고 평점 변화를 반영
    // [기술] DAO Method Reuse, Logic Combining
    @Override
    public int insertReviewReply(VolunteerCommentVO r) {
        // 1. 댓글 등록 (DAO 재사용)
        int result = volunteerDao.insertReply(r);

        // 2. [중요] 평점 반영 로직 (후기 점수 갱신)
        if (result > 0 && r.getCmtRate() != null) {
            volunteerDao.updateActivityRate(r.getActId());
        }
        return result;
    }

    // VolunteerServiceImpl.java (구현 클래스)

    // [기능] 아직 후기가 작성되지 않은 봉사활동 목록을 조회 (후기 작성 폼용)
    // [기술] MyBatis selectList (filtering)
    @Override
    public List<ActivityVO> selectActivityNoReview() {
        return volunteerDao.selectActivityNoReview();
    }

 // [관리자] 승인/반려 및 완료 프로세스 구현
    // [기능] 관리자 기능: 봉사 신청 상태를 승인, 반려 또는 완료로 변경
    // [기술] Java Business Logic (Status Switch), Data Update
    @Override
    public int updateSignStatusAdmin(int signsNo, String status) {
        // 1. 어떤 신청인지 정보 조회
        SignVO sign = volunteerDao.selectSignOne(signsNo);
        if (sign == null)
            return 0; // 신청 정보가 없으면 실패

        SignVO updateVO = new SignVO();
        updateVO.setSignsNo(signsNo);

        // A. '승인(approve)' 요청일 때
        if ("approve".equals(status)) {
            // 정원 체크
            ActivityVO activity = volunteerDao.selectActivityOne(sign.getActId());
            if (activity.getActCur() >= activity.getActMax()) {
                return -1; // 정원 초과!
            }
            // 상태를 '1(승인)'로 변경
            updateVO.setSignsStatus(1);
            int result = volunteerDao.updateSignStatus(updateVO);

            // 활동 인원수 +1 증가
            if (result > 0) {
                volunteerDao.increaseActivityCur(sign.getActId());
            }
            return result;
        }

        // B. '반려(reject)' 요청일 때
        else if ("reject".equals(status)) {
            updateVO.setSignsStatus(2);
            return volunteerDao.updateSignStatus(updateVO);
        }

        // C. [추가됨] '참여 완료(complete)' 요청일 때 (봉사 끝난 후)
        else if ("complete".equals(status)) {
            // 상태를 '4(참여 완료)'로 정의 (DB 약속 필요)
            updateVO.setSignsStatus(4);
            int result = volunteerDao.updateSignStatus(updateVO);

            // 상태 변경 성공 시, 유저의 봉사 횟수 +1
            if (result > 0) {
                volunteerDao.increaseUserAttendanceCount(sign.getSignsId());
            }
            return result;
        }

        return 0; // status 값이 이상할 때
    }

    // [사용자] 취소 프로세스 구현
    // [기능] 사용자가 자신의 봉사 신청을 취소하고, 승인 상태였다면 참여 인원수를 감소시킴
    // [기술] Service Logic (Conditional Update)
    @Override
    public int updateSignStatusUser(int signsNo) {
        // 1. 어떤 신청인지 정보 조회
        SignVO sign = volunteerDao.selectSignOne(signsNo);
        if (sign == null)
            return 0;

        // 2. 상태를 '3(취소)'으로 변경
        SignVO updateVO = new SignVO();
        updateVO.setSignsNo(signsNo);
        updateVO.setSignsStatus(3);

        int result = volunteerDao.updateSignStatus(updateVO);

        // 3. 만약 '승인(1)' 상태였던 것을 취소했다면 -> 인원수 -1 감소
        // (대기 상태였다면 인원수에 반영 안 됐으므로 줄일 필요 없음)
        if (result > 0 && sign.getSignsStatus() == 1) {
            volunteerDao.decreaseActivityCur(sign.getActId());
        }

        return result;
    }
    
    //마이페이지 페이징바 처리
    // [기능] 마이페이지 용: 내 신청 내역의 총 개수 조회
    // [기술] MyBatis selectOne
    @Override
    public int selectMySignCount(String userId) {
        return volunteerDao.selectMySignCount(userId);
    }
    //마이페이지 페이징바 처리
    // [기능] 마이페이지 용: 내 신청 내역 목록을 조회 (페이징 포함)
    // [기술] MyBatis selectList
    @Override
    public List<SignVO> selectMySignList(String userId, PageInfo pi) {
        return volunteerDao.selectMySignList(userId, pi);
    }
    
    
    // [기능] 다수의 신청 건을 일괄적으로 활동 완료 처리 (반복문을 통해 개별 처리 로직 호출)
    // [기술] Java Loop, Code Reuse
    @Override
    public int updateSignStatusMulti(List<Integer> signsNos) {
        int count = 0;

        // 넘어온 번호 리스트를 하나씩 꺼내서 기존의 'complete' 로직을 재활용합니다.
        for (int signsNo : signsNos) {
            // "complete" 파라미터를 넘겨서 기존 로직(상태변경+횟수증가)을 수행
            int result = updateSignStatusAdmin(signsNo, "complete");

            if (result > 0) {
                count++;
            }
        }
        return count; // 성공한 횟수 리턴
    }

}
