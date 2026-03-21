package com.ubig.app.vo.community;

import java.sql.Date;
import lombok.Data;

@Data
public class BoardAttachmentVO {
    private int fileId; // FILE_ID
    private int boardId; // BOARD_ID (Also used for REF_ID)
    private String refType; // REF_TYPE ('BOARD')
    private String refId; // REF_ID (String version of boardId)
    private String originalName; // ORIGINAL_NAME
    private String savedName; // SAVED_NAME
    private String filePath; // FILE_PATH
    private long fileSize; // FILE_SIZE
    private Date createDate; // CREATE_DATE
}
