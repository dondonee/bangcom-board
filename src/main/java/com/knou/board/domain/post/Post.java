package com.knou.board.domain.post;

import com.knou.board.domain.member.Member;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Objects;

@Data
public class Post {

    private Long id;
    private Long categoryId;
    private String title;
    private String content;
    private LocalDateTime dateCreated;
    private LocalDateTime dateModified;
    private int viewCount;

    private Member author;


    public Post() {
    }

    public Post(Long categoryId, Member author, String title, String content) {
        this.categoryId = categoryId;
        this.author = author;
        this.title = title;
        this.content = content;
        this.dateCreated = LocalDateTime.now();
    }
}
