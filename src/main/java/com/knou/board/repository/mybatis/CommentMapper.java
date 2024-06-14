package com.knou.board.repository.mybatis;

import com.knou.board.domain.comment.Comment;
import com.knou.board.domain.comment.ParentCommentInfo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CommentMapper {

    void insert(Comment comment);
    Comment selectById(Long id);
    List<Comment> selectByPostId(Long postId);
    ParentCommentInfo selectParentInfoById(Long id);
    long countTotalSelectedByPostId(Long postId);
    void updateOrderNo(Comment comment);
}
