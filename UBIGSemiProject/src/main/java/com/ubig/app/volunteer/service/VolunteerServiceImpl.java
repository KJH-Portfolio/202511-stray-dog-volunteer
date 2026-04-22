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
	
	
	@Override
    public int selectActivityCount(HashMap<String, String> map) {
        return volunteerDao.selectActivityCount(map);
    }

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
        // 무결성 제약조건 위배 방지: 자식 레코드 먼저 삭제
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

    @Override
    public List<VolunteerCommentVO> selectReplyList(VolunteerCommentVO vo) {
        return volunteerDao.selectReplyList(vo);
    }

    @Override
    public int insertReply(VolunteerCommentVO r) {
        int result = volunteerDao.insertReply(r);
        // 후기 댓글도 평점이 있으면 ACT_RATE 업데이트
        if (result > 0 && r.getCmtRate() != null) {
            volunteerDao.updateActivityRate(r.getActId());
        }
        return result;
    }
    @Override
    public int deleteReply(int cmtNo) {
        // 삭제 전 미리 정보 조회
        VolunteerCommentVO c = volunteerDao.selectCommentOne(cmtNo);

        int result = volunteerDao.deleteReply(cmtNo);

        // 삭제 성공 & 평점이 있었던 댓글이라면 재계산
        if (result > 0 && c != null && c.getCmtRate() != null) {
            volunteerDao.updateActivityRate(c.getActId());
        }
        return result;
    }
    
    @Override
    public int insertSign(SignVO s) {
        // 1. 중복 신청 체크
        // 이미 신청했다면 count가 1이 나옴
        int count = volunteerDao.checkDuplicateSign(s);

        if (count > 0) {
            System.out.println("❌ 중복 신청 감지! (" + s.getSignsId() + ")");
            return -2; // -2는 "이미 신청함"이라는 우리만의 신호입니다.
        }

        // 2. 정원 체크
        ActivityVO activity = volunteerDao.selectActivityOne(s.getActId());
        if (activity == null)
            return 0;

        if (activity.getActCur() >= activity.getActMax()) {
            System.out.println("❌ 정원 초과!");
            return -1; // -1은 "정원 초과"
        }

        // 3. 모든 검사 통과 -> 등록 진행
        return volunteerDao.insertSign(s);
    }
    @Override
    public List<SignVO> selectSignList(int actId) {
        return volunteerDao.selectSignList(actId);
    }

    @Override
    public int insertReview(VolunteerReviewVO r) {
        // 1. 중복 체크 먼저 수행
        // DAO에 checkDuplicateReview 메서드가 없으면 빨간줄이 뜨니,
        // 꼭 DAO와 Mapper에 먼저 추가해야 합니다.
        int count = volunteerDao.checkDuplicateReview(r.getActId());

        if (count > 0) {
            System.out.println("❌ 중복 후기 감지! ACT_ID: " + r.getActId());
            return -2; // "이미 등록됨"을 뜻하는 -2를 리턴 (Controller로 전달됨)
        }

        // 2. 후기 등록
        int result = volunteerDao.insertReview(r);

        // 3. 등록 성공 시 활동 평균 평점 재계산
        if (result > 0) {
            volunteerDao.updateActivityRate(r.getActId());
        }

        return result;
    }

    @Override
    public List<VolunteerReviewVO> selectReviewList(int actId) {
        return volunteerDao.selectReviewList(actId);
    }
    
    @Override
    public int selectReviewCount(HashMap<String, String> map) {
        return volunteerDao.selectReviewCount(map);
    }

    @Override
    public List<VolunteerReviewVO> selectReviewListAll(HashMap<String, String> map, PageInfo pi) {
        // DAO로 PageInfo 전달
        return volunteerDao.selectReviewListAll(map, pi);
    }
    
    @Override
    public VolunteerReviewVO selectReviewOne(int reviewNo) {
        return volunteerDao.selectReviewOne(reviewNo);
    }
    
    @Override
    public int updateReview(VolunteerReviewVO r) {
        // 후기 내용/평점 수정 시에도 평균 평점 업데이트가 필요할 수 있음
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

    @Override
    public int deleteReview(int reviewNo) {
        // 삭제 전 actId를 조회해야 함
        // 하지만 Soft Delete(R_REMOVE=1)이므로 조회는 가능.
        VolunteerReviewVO r = volunteerDao.selectReviewOne(reviewNo);

        int result = volunteerDao.deleteReview(reviewNo);

        if (result > 0 && r != null) {
            // 후기 삭제(숨김) 성공 시, 해당 활동의 평균 평점 업데이트
            volunteerDao.updateActivityRate(r.getActId());
        }
        return result;
    }


    @Override
    public List<VolunteerCommentVO> selectReviewReplyList(VolunteerCommentVO vo) {
        // 기존에 만들어둔 DAO 메서드 재사용
        return volunteerDao.selectReplyList(vo);
    }

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

    @Override
    public List<ActivityVO> selectActivityNoReview() {
        return volunteerDao.selectActivityNoReview();
    }

    // 관리자 승인/반려 및 완료 프로세스 구현
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

        // '참여 완료(complete)' 요청일 때 (봉사 끝난 후)
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

    // 사용자 취소 프로세스 구현
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
    
    @Override
    public int selectMySignCount(String userId) {
        return volunteerDao.selectMySignCount(userId);
    }
    @Override
    public List<SignVO> selectMySignList(String userId, PageInfo pi) {
        return volunteerDao.selectMySignList(userId, pi);
    }
    
    
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
