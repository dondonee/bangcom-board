package com.knou.board.repository;

import com.knou.board.domain.comment.Comment;
import com.knou.board.domain.comment.ParentCommentInfo;

import java.util.List;

public interface CommentRepository {

    Comment insert(Comment comment);
    Comment selectById(Long id);
    List<Comment> selectByPostId(Long postId);
    ParentCommentInfo selectParentInfoById(Long id);
    long countTotalSelectedByPostId(Long postId);
    void updateOrderNo(Comment comment);
}
