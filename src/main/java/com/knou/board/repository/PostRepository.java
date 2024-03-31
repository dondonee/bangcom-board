package com.knou.board.repository;

import com.knou.board.domain.Post;

public interface PostRepository {

    Post save(Post post);
    Post findById(Long id);
}
