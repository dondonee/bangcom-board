package com.knou.board.repository;

import com.knou.board.domain.post.Post;
import com.knou.board.domain.post.Topic;

import java.util.List;

public interface PostRepository {

    Post insert(Post post);
    Post selectById(Long id);

    List<Post> selectAll();
    List<Post> selectByTopicGroup(Topic[] topics);
    Post update(Post post);
    void delete(Long id);
}
