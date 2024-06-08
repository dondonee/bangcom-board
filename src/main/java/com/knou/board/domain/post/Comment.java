package com.knou.board.domain.post;

import com.knou.board.domain.member.Member;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Comment {
    private long id;
    private long postId;
    private Member writer;
    private String content;
    private LocalDateTime createdDate;
    private LocalDateTime modifiedDate;
}
