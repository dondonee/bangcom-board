package com.knou.board.domain.post;

import com.knou.board.domain.member.Member;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class Post {

    private Long id;
    private Topic topic;
    private String title;
    private String content;
    private LocalDateTime createdDate;
    private LocalDateTime modifiedDate;
    private int viewCount;

    private Member author;

}
