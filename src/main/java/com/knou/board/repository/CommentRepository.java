package com.knou.board.repository;

import com.knou.board.domain.comment.Comment;
import com.knou.board.domain.comment.ParentCommentInfo;

import java.util.List;

public interface CommentRepository {

    Comment insert(Comment comment);
    Comment selectById(Long id);
    List<Comment> selectByPostId(Long postId);
    ParentCommentInfo selectParentInfoById(Long id);
    int countChildrenById(Long id);
    void updateOrderNo(Comment comment);
    int delete(Long id);
}
