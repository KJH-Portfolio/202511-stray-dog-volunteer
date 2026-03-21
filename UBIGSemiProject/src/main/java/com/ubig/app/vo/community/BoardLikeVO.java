package com.ubig.app.vo.community;

import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class BoardLikeVO {
    private int likeId;
    private int boardId;
    private String userId;
    private String targetType;
    private Date createDate;
}
