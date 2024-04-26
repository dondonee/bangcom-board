package com.knou.board.repository;

import com.knou.board.domain.post.Post;

import java.util.List;

public interface PostRepository {

    Post insert(Post post);
    Post selectById(Long id);

    List<Post> selectAll();
    Post update(Post post);
    void delete(Long id);
}
