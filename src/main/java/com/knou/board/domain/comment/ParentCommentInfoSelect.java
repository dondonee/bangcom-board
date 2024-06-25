package com.knou.board.domain.comment;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ParentCommentInfoSelect extends ParentCommentInfo {

    private long parentId;
    private long mentionedId;
    private String mentionedName;   // SELECT 전용
}
