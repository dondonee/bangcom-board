package com.knou.board.web.dto;

import com.knou.board.domain.comment.Comment;
import lombok.Data;

import java.util.List;

@Data
public class CommentListDto {

    private List<Comment> comments;
    private long commentTotal;
}
