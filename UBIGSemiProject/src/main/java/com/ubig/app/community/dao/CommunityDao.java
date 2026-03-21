package com.ubig.app.community.dao;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.ubig.app.vo.community.BoardVO;
import com.ubig.app.vo.community.CommentVO;

@Repository
public class CommunityDao {

    @Autowired
    private SqlSessionTemplate sqlSession;

    // Board
    /*
     * [Step 2: DAO 수정]
     * Mapper에게 '이 카테고리 데이터만 줘'라고 전달하기 위해
     * 매개변수에 category를 추가했습니다.
     */
    /*
     * [Step 3: DAO 메소드 작성]
     * DB에게 SQL을 실행하라고 명령하는 메소드입니다.
     * sqlSession을 이용해서 쿼리를 실행합니다.
     */

    public int selectListCount(java.util.Map<String, Object> map) {
        return sqlSession.selectOne("communityMapper.selectListCount", map);
    }

    public List<BoardVO> selectBoardList(com.ubig.app.common.model.vo.PageInfo pi, java.util.Map<String, Object> map) {

        // RowBounds 객체 생성 (건너뛸 갯수 offset, 가져올 갯수 limit)
        // offset : (currentPage - 1) * boardLimit
        int offset = (pi.getCurrentPage() - 1) * pi.getBoardLimit();
        org.apache.ibatis.session.RowBounds rowBounds = new org.apache.ibatis.session.RowBounds(offset,
                pi.getBoardLimit());

        return sqlSession.selectList("communityMapper.selectBoardList", map, rowBounds);
    }

    public BoardVO selectBoardDetail(int boardId) {
        return sqlSession.selectOne("communityMapper.selectBoardDetail", boardId);
    }

    public int insertBoard(BoardVO board) {
        return sqlSession.insert("communityMapper.insertBoard", board);
    }

    public int updateBoard(BoardVO board) {
        return sqlSession.update("communityMapper.updateBoard", board);
    }

    // [Step 30: Rotation Logic Methods]
    public int selectPinnedCount(String category) {
        return sqlSession.selectOne("communityMapper.selectPinnedCount", category);
    }

    public BoardVO selectOldestPinned(String category) {
        return sqlSession.selectOne("communityMapper.selectOldestPinned", category);
    }

    public int updateBoardPinned(java.util.Map<String, Object> params) {
        return sqlSession.update("communityMapper.updateBoardPinned", params);
    }

    public int deleteBoard(int boardId) {
        return sqlSession.update("communityMapper.deleteBoard", boardId);
    }

    public int increaseCount(int boardId) {
        return sqlSession.update("communityMapper.increaseCount", boardId);
    }

    // Comment
    public List<CommentVO> selectCommentList(int boardId) {
        return sqlSession.selectList("communityMapper.selectCommentList", boardId);
    }

    public int insertComment(CommentVO comment) {
        return sqlSession.insert("communityMapper.insertComment", comment);
    }

    public int updateComment(CommentVO comment) {
        return sqlSession.update("communityMapper.updateComment", comment);
    }

    public int deleteComment(int commentId) {
        return sqlSession.delete("communityMapper.deleteComment", commentId);
    }

    // Likes
    public int insertBoardLike(com.ubig.app.vo.community.BoardLikeVO like) {
        return sqlSession.insert("communityMapper.insertBoardLike", like);
    }

    public int deleteBoardLike(com.ubig.app.vo.community.BoardLikeVO like) {
        return sqlSession.delete("communityMapper.deleteBoardLike", like);
    }

    public int checkBoardLike(com.ubig.app.vo.community.BoardLikeVO like) {
        return sqlSession.selectOne("communityMapper.checkBoardLike", like);
    }

    public int countBoardLike(int boardId) {
        return sqlSession.selectOne("communityMapper.countBoardLike", boardId);
    }

    // Comment Likes
    public int insertCommentLike(com.ubig.app.vo.community.CommentLikeVO like) {
        return sqlSession.insert("communityMapper.insertCommentLike", like);
    }

    public int deleteCommentLike(com.ubig.app.vo.community.CommentLikeVO like) {
        return sqlSession.delete("communityMapper.deleteCommentLike", like);
    }

    public int checkCommentLike(com.ubig.app.vo.community.CommentLikeVO like) {
        return sqlSession.selectOne("communityMapper.checkCommentLike", like);
    }

    public int countCommentLike(int commentId) {
        return sqlSession.selectOne("communityMapper.countCommentLike", commentId);
    }

    // Attachments
    public int insertBoardAttachment(com.ubig.app.vo.community.BoardAttachmentVO attachment) {
        return sqlSession.insert("communityMapper.insertBoardAttachment", attachment);
    }

    public int insertCommentAttachment(com.ubig.app.vo.community.CommentAttachmentVO attachment) {
        return sqlSession.insert("communityMapper.insertCommentAttachment", attachment);
    }

    public com.ubig.app.vo.community.BoardAttachmentVO selectBoardAttachment(int boardId) {
        return sqlSession.selectOne("communityMapper.selectBoardAttachment", boardId);
    }

    public com.ubig.app.vo.community.CommentAttachmentVO selectCommentAttachment(int commentId) {
        return sqlSession.selectOne("communityMapper.selectCommentAttachment", commentId);
    }
}
