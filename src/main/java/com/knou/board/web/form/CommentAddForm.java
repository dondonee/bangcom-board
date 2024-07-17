package com.knou.board.web.form;

import com.knou.board.domain.comment.ParentCommentInfo;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CommentAddForm {

    @NotNull
    private long postId;

    @NotBlank(message = "내용을 최소 1자 이상 입력해주세요.")
    @Size(max = 2000, message = "내용은 2000자 이하로 입력하세요.")
    private String content;

    private ParentCommentInfo parentCommentInfo;

    public void setParentId (String parentId) {
        ParentCommentInfo parentCommentInfo = new ParentCommentInfo();
        parentCommentInfo.setParentId(Long.parseLong(parentId));
        this.parentCommentInfo = parentCommentInfo;
    }
}
