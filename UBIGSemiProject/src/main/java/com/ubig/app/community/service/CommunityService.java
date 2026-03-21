package com.ubig.app.community.service;

import java.util.List;
import com.ubig.app.vo.community.BoardVO;
import com.ubig.app.vo.community.CommentVO;

public interface CommunityService {

    // Board
    /*
     * [Step 3: Service Interface 수정]
     * Controller와 DAO 사이의 약속(Interface)도 수정합니다.
     * 목록 요청 시 반드시 카테고리를 받도록 강제합니다.
     */
    // 게시글 총 갯수 조회
    int getBoardListCount(java.util.Map<String, Object> map);

    // 게시글 목록 조회 (페이징)
    List<BoardVO> getBoardList(com.ubig.app.common.model.vo.PageInfo pi, java.util.Map<String, Object> map);

    BoardVO getBoardDetail(int boardId);

    int insertBoard(BoardVO board);

    int updateBoard(BoardVO board);

    int deleteBoard(int boardId);

    int increaseCount(int boardId);

    // Comment
    List<CommentVO> getCommentList(int boardId);

    int insertComment(CommentVO comment);

    int updateComment(CommentVO comment);

    int deleteComment(int commentId);

    // Likes
    int toggleLike(com.ubig.app.vo.community.BoardLikeVO like); // Returns new count or status

    int getLikeCount(int boardId);

    int checkLike(com.ubig.app.vo.community.BoardLikeVO like);

    // Comment Likes
    int toggleCommentLike(com.ubig.app.vo.community.CommentLikeVO like);

    int getCommentLikeCount(int commentId);

    int checkCommentLike(com.ubig.app.vo.community.CommentLikeVO like);

    // Attachments
    void insertBoardAttachment(com.ubig.app.vo.community.BoardAttachmentVO attachment);

    void insertCommentAttachment(com.ubig.app.vo.community.CommentAttachmentVO attachment);

    com.ubig.app.vo.community.BoardAttachmentVO getBoardAttachment(int boardId);

    com.ubig.app.vo.community.CommentAttachmentVO getCommentAttachment(int commentId);
}
