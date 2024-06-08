package com.knou.board.repository.mybatis;

import com.knou.board.domain.post.Comment;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CommentMapper {

    void insert(Comment comment);
    List<Comment> selectByPostId(Long postId);
    long countTotalSelectedByPostId(Long postId);
}
