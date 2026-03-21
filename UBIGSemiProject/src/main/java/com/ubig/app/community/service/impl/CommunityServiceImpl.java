package com.ubig.app.community.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ubig.app.community.dao.CommunityDao;
import com.ubig.app.community.service.CommunityService;
import com.ubig.app.vo.community.BoardVO;
import com.ubig.app.vo.community.CommentVO;

@Service
public class CommunityServiceImpl implements CommunityService {

    @Autowired
    private CommunityDao communityDao;

    /*
     * [Step 4: Service 구현체 수정]
     * 실제로 동작하는 Service 코드입니다.
     * 매개변수로 받은 category를 DAO에게 그대로 토스(toss)해줍니다.
     */

    @Override
    public int getBoardListCount(java.util.Map<String, Object> map) {
        return communityDao.selectListCount(map);
    }

    @Override
    public List<BoardVO> getBoardList(com.ubig.app.common.model.vo.PageInfo pi, java.util.Map<String, Object> map) {
        return communityDao.selectBoardList(pi, map);
    }

    @Override
    public BoardVO getBoardDetail(int boardId) {
        return communityDao.selectBoardDetail(boardId);
    }

    @Override
    public int insertBoard(BoardVO board) {
        // [Step 30: 공지사항 상단 고정 및 로테이션]
        if ("Y".equals(board.getIsPinned())) {
            // 1. 현재 카테고리의 고정된 글 개수 확인
            int pinnedCount = communityDao.selectPinnedCount(board.getCategory());

            // 2. 5개 이상이면 가장 오래된 것 해제
            if (pinnedCount >= 5) {
                BoardVO oldest = communityDao.selectOldestPinned(board.getCategory());
                if (oldest != null) {
                    // 고정 해제 ('N') 및 카테고리를 'NOTICE'로 변경 (일반 공지사항 게시판으로 이동)
                    java.util.Map<String, Object> params = new java.util.HashMap<>();
                    params.put("boardId", oldest.getBoardId());
                    params.put("isPinned", "N");
                    params.put("category", "NOTICE");

                    communityDao.updateBoardPinned(params);
                }
            }
        }
        return communityDao.insertBoard(board);
    }

    @Override
    public int updateBoard(BoardVO board) {
        return communityDao.updateBoard(board);
    }

    @Override
    public int deleteBoard(int boardId) {
        return communityDao.deleteBoard(boardId);
    }

    @Override
    public int increaseCount(int boardId) {
        return communityDao.increaseCount(boardId);
    }

    @Override
    public List<CommentVO> getCommentList(int boardId) {
        return communityDao.selectCommentList(boardId);
    }

    @Override
    public int insertComment(CommentVO comment) {
        return communityDao.insertComment(comment);
    }

    @Override
    public int updateComment(CommentVO comment) {
        return communityDao.updateComment(comment);
    }

    @Override
    public int deleteComment(int commentId) {
        return communityDao.deleteComment(commentId);
    }

    // Likes
    @Override
    public int checkLike(com.ubig.app.vo.community.BoardLikeVO like) {
        return communityDao.checkBoardLike(like);
    }

    @Override
    public int getLikeCount(int boardId) {
        return communityDao.countBoardLike(boardId);
    }

    @Override
    public int toggleLike(com.ubig.app.vo.community.BoardLikeVO like) {
        int count = communityDao.checkBoardLike(like);
        if (count > 0) {
            communityDao.deleteBoardLike(like);
            return 0; // 취소됨 (Unliked)
        } else {
            communityDao.insertBoardLike(like);
            return 1; // 좋아요됨 (Liked)
        }
    }

    // Comment Likes
    @Override
    public int checkCommentLike(com.ubig.app.vo.community.CommentLikeVO like) {
        return communityDao.checkCommentLike(like);
    }

    @Override
    public int getCommentLikeCount(int commentId) {
        return communityDao.countCommentLike(commentId);
    }

    @Override
    public int toggleCommentLike(com.ubig.app.vo.community.CommentLikeVO like) {
        int count = communityDao.checkCommentLike(like);
        if (count > 0) {
            communityDao.deleteCommentLike(like);
            return 0; // Unliked
        } else {
            communityDao.insertCommentLike(like);
            return 1; // Liked
        }
    }

    // Attachments
    @Override
    public void insertBoardAttachment(com.ubig.app.vo.community.BoardAttachmentVO attachment) {
        communityDao.insertBoardAttachment(attachment);
    }

    @Override
    public void insertCommentAttachment(com.ubig.app.vo.community.CommentAttachmentVO attachment) {
        communityDao.insertCommentAttachment(attachment);
    }

    @Override
    public com.ubig.app.vo.community.BoardAttachmentVO getBoardAttachment(int boardId) {
        return communityDao.selectBoardAttachment(boardId);
    }

    @Override
    public com.ubig.app.vo.community.CommentAttachmentVO getCommentAttachment(int commentId) {
        return communityDao.selectCommentAttachment(commentId);
    }
}
