package com.ubig.app.vo.community;

import java.sql.Date;
import lombok.Data;

@Data
public class CommentAttachmentVO {
    private int fileId; // FILE_ID
    private int commentId; // COMMENT_ID (Also used for REF_ID)
    private String refType; // REF_TYPE ('COMMENT')
    private String refId; // REF_ID (String version of commentId)
    private String originalName; // ORIGINAL_NAME
    private String savedName; // SAVED_NAME
    private String filePath; // FILE_PATH
    private long fileSize; // FILE_SIZE
    private Date createDate; // CREATE_DATE
}
