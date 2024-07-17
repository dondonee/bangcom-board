package com.knou.board.web.form;

import com.knou.board.domain.comment.ParentCommentInfo;
import com.knou.board.domain.member.Member;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class CommentEditForm {

    @NotNull
    private long commentId;

    @NotBlank(message = "내용을 최소 1자 이상 입력해주세요.")
    @Size(max = 2000, message = "내용은 2000자 이하로 입력하세요.")
    private String content;
}
