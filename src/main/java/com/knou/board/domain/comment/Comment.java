package com.knou.board.domain.comment;

import com.knou.board.domain.member.Member;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
public class Comment {

    private long id;
    private long postId;
    private Member writer;
    private String content;
    private int groupNo;
    private int depthNo;
    private int orderNo;
    private LocalDateTime createdDate;
    private LocalDateTime modifiedDate;
    private ParentCommentInfo parentCommentInfo;
    private List<Comment> branchComments;
}
