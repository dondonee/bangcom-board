package com.knou.board.web.form;

import com.knou.board.domain.comment.ParentCommentInfo;
import lombok.Data;

@Data
public class CommentAddForm {

    private long postId;
    private String content;
    private ParentCommentInfo parentCommentInfo;

    public void setParentId (String parentId) {
        ParentCommentInfo parentCommentInfo = new ParentCommentInfo();
        parentCommentInfo.setParentId(Long.parseLong(parentId));
        this.parentCommentInfo = parentCommentInfo;
    }
}
