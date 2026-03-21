package com.ubig.app.vo.community;

import java.sql.Date;
import lombok.Data;

@Data
public class CommentVO {
    private int commentId;
    private String userId;
    private int boardId;
    private String content;
    private Date createDate;
    private Date updateDate;
    private String isDeleted;
    private Integer parentId; // Nullable
    private int level; // Hierarchical query level

    // UI purposes
    private int likeCount;
    private boolean isLiked;

    private CommentAttachmentVO attachment; // For file attachment info
}
