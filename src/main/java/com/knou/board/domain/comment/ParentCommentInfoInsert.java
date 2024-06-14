package com.knou.board.domain.comment;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ParentCommentInfoInsert extends ParentCommentInfo {

    private long parentId;
    private long mentionedId;
    public int parentGroupNo;   // INSERT 전용
    public int parentDepthNo;   // INSERT 전용

    public ParentCommentInfoInsert(ParentCommentInfoInsert object) {
        this.parentId = object.parentId;
        this.mentionedId = object.mentionedId;
        this.parentGroupNo = object.parentGroupNo;
        this.parentDepthNo = object.parentDepthNo;
    }
}
