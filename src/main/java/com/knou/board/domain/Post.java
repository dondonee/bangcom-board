package com.knou.board.domain;

import lombok.Data;

@Data
public class Post {

    private Long id;
    private String postTitle;
    private String postContent;

    public Post() {
    }

    public Post(String postTitle, String postContent) {
        this.postTitle = postTitle;
        this.postContent = postContent;
    }
}
