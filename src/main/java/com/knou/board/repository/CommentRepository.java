package com.knou.board.repository;

import com.knou.board.domain.comment.Comment;
import com.knou.board.domain.comment.CommentHistoryDto;
import com.knou.board.domain.comment.ParentCommentInfo;
import com.knou.board.domain.post.Criteria;

import java.util.List;

public interface CommentRepository {

    Comment insert(Comment comment);
    Comment selectById(Long id);
    List<CommentHistoryDto> selectByUserNo(Long userNo, Criteria criteria);
    List<Comment> selectByPostId(Long postId);
    ParentCommentInfo selectParentInfoById(Long id);
    int countChildrenById(Long id);
    long countTotalSelectedByUserNo(Long userNo);
    int update(Comment comment);
    void updateOrderNo(Comment comment);
    int delete(Long id);
}
