package com.knou.board.repository;

import com.knou.board.domain.post.Comment;

import java.util.List;

public interface CommentRepository {

    Comment insert(Comment comment);
    List<Comment> selectByPostId(Long postId);
    long countTotalSelectedByPostId(Long postId);
}
