package com.ubig.app.volunteer.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ubig.app.common.model.vo.PageInfo;
import com.ubig.app.vo.volunteer.ActivityVO;
import com.ubig.app.vo.volunteer.SignVO;
import com.ubig.app.vo.volunteer.VolunteerCommentVO;
import com.ubig.app.vo.volunteer.VolunteerReviewVO;

@Repository
public class VolunteerDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    public int selectActivityCount(HashMap<String, String> map) {
        return sqlSession.selectOne("volunteerMapper.selectActivityCount", map);
    }

    public List<ActivityVO> selectActivityList(HashMap<String, String> map, PageInfo pi) {

        // MyBatis RowBounds: (건너뛸 개수, 가져올 개수)
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        int limit = pi.getBoardLimit();

        RowBounds rowBounds = new RowBounds(offset, limit);

        // 3번째 인자에 rowBounds 전달
        return sqlSession.selectList("volunteerMapper.selectActivityList", map, rowBounds);
    }

    // ... (중략) ...

    public int selectReviewCount(HashMap<String, String> map) {
        return sqlSession.selectOne("volunteerMapper.selectReviewCount", map);
    }

    public List<VolunteerReviewVO> selectReviewListAll(HashMap<String, String> map, PageInfo pi) {

        // 건너뛸 게시글 수 계산
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        int limit = pi.getBoardLimit();

        RowBounds rowBounds = new RowBounds(offset, limit);

        return sqlSession.selectList("volunteerMapper.selectReviewListAll", map, rowBounds);
    }

    public int insertActivity(ActivityVO a) {
        return sqlSession.insert("volunteerMapper.insertActivity", a);
    }

    // 3. 상세 조회
    public ActivityVO selectActivityOne(int actId) {
        return sqlSession.selectOne("volunteerMapper.selectActivityOne", actId);
    }

    // 4. 삭제
    public int deleteActivity(int actId) {
        return sqlSession.delete("volunteerMapper.deleteActivity", actId);
    }

    // 5. 수정
    public int updateActivity(ActivityVO a) {
        return sqlSession.update("volunteerMapper.updateActivity", a);
    }

    // --- 댓글 관련 ---
    // 봉사 프로그램 댓글 조회
    // --- 댓글 관련 (후기 전용) ---
    // 봉사 후기 댓글 조회
    public List<VolunteerCommentVO> selectReplyList(VolunteerCommentVO vo) {
        return sqlSession.selectList("volunteerMapper.selectReplyList", vo);
    }

    // 봉사 후기 댓글 등록
    public int insertReply(VolunteerCommentVO r) {
        return sqlSession.insert("volunteerMapper.insertReply", r);
    }

    public int deleteReply(int cmtNo) {
        return sqlSession.delete("volunteerMapper.deleteReply", cmtNo);
    }

    public VolunteerCommentVO selectCommentOne(int cmtNo) {
        return sqlSession.selectOne("volunteerMapper.selectCommentOne", cmtNo);
    }

    // --- 신청 관련 ---
    public int insertSign(SignVO s) {
        return sqlSession.insert("volunteerMapper.insertSign", s);
    }

    public List<SignVO> selectSignList(int actId) {
        return sqlSession.selectList("volunteerMapper.selectSignList", actId);
    }

    // --- 후기 관련 ---
    public int insertReview(VolunteerReviewVO r) {
        return sqlSession.insert("volunteerMapper.insertReview", r);
    }

    public List<VolunteerReviewVO> selectReviewList(int actId) {
        return sqlSession.selectList("volunteerMapper.selectReviewList", actId);
    }

    public List<VolunteerReviewVO> selectReviewListAll() {
        return sqlSession.selectList("volunteerMapper.selectReviewListAll");
    }

    public VolunteerReviewVO selectReviewOne(int reviewNo) {
        return sqlSession.selectOne("volunteerMapper.selectReviewOne", reviewNo);
    }

    public int updateReview(VolunteerReviewVO r) {
        return sqlSession.update("volunteerMapper.updateReview", r);
    }

    public int deleteReview(int reviewNo) {
        return sqlSession.update("volunteerMapper.deleteReview", reviewNo);
    }

    // 봉사 신청 중복 체크 메소드
    public int checkDuplicateSign(SignVO s) {
        return sqlSession.selectOne("volunteerMapper.checkDuplicateSign", s);
    }

    public int updateActivityRate(int actId) {
        return sqlSession.update("volunteerMapper.updateActivityRate", actId);
    }

    // VolunteerDao.java 에 추가
    public int checkDuplicateReview(int actId) {
        // 해당 봉사활동 ID로 작성된(삭제되지 않은) 후기가 있는지 개수 확인
        return sqlSession.selectOne("volunteerMapper.checkDuplicateReview", actId);
    }

    public List<ActivityVO> selectActivityNoReview() {
        return sqlSession.selectList("volunteerMapper.selectActivityNoReview");
    }


    // 1. 신청 상태 변경 (대기0 -> 승인1 / 반려2 / 취소3)
    public int updateSignStatus(SignVO s) {
        return sqlSession.update("volunteerMapper.updateSignStatus", s);
    }

    // 2. 승인 시 -> 활동 현재 인원 1명 증가
    public int increaseActivityCur(int actId) {
        return sqlSession.update("volunteerMapper.increaseActivityCur", actId);
    }

    // 3. 취소 시 -> 활동 현재 인원 1명 감소 (기존 Mapper 활용)
    public int decreaseActivityCur(int actId) {
        return sqlSession.update("volunteerMapper.decreaseActivityCur", actId);
    }

    // 4. 신청 정보 단건 조회 (상태 변경 전, 현재 상태나 활동ID 확인용)
    public SignVO selectSignOne(int signsNo) {
        return sqlSession.selectOne("volunteerMapper.selectSignOne", signsNo);
    }

    // 봉사 완료 시 회원 테이블의 참여 횟수 증가
    public int increaseUserAttendanceCount(String userId) {
        return sqlSession.update("volunteerMapper.increaseUserAttendanceCount", userId);
    }

    public int selectMySignCount(String userId) {
        return sqlSession.selectOne("volunteerMapper.selectMySignCount", userId);
    }

    public List<SignVO> selectMySignList(String userId, PageInfo pi) {

        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        int limit = pi.getBoardLimit();

        RowBounds rowBounds = new RowBounds(offset, limit);

        return sqlSession.selectList("volunteerMapper.selectMySignList", userId, rowBounds);
    }

    public int deleteSignsByActId(int actId) {
        return sqlSession.delete("volunteerMapper.deleteSignsByActId", actId);
    }

    public int deleteReviewsByActId(int actId) {
        return sqlSession.delete("volunteerMapper.deleteReviewsByActId", actId);
    }

    public int deleteCommentsByActId(int actId) {
        return sqlSession.delete("volunteerMapper.deleteCommentsByActId", actId);
    }
}
