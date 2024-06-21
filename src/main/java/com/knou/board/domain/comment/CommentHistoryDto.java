package com.knou.board.domain.comment;

import com.knou.board.domain.post.Topic;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class CommentHistoryDto {

    private long id;
    private LocalDateTime createdDate;
    private long postId;
    private String postTitle;
    private Topic postTopic;
    private long authorId;
    private String authorNickname;
}
