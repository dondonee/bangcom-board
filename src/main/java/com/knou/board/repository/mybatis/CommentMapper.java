package com.knou.board.repository.mybatis;

import com.knou.board.domain.comment.Comment;
import com.knou.board.domain.comment.CommentHistoryDto;
import com.knou.board.domain.comment.ParentCommentInfo;
import com.knou.board.domain.post.Criteria;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommentMapper {

    void insert(Comment comment);
    Comment selectById(Long id);
    List<CommentHistoryDto> selectByUserNo(@Param("userNo") Long userNo, @Param("criteria") Criteria criteria);
    List<Comment> selectByPostId(Long postId);
    ParentCommentInfo selectParentInfoById(Long id);
    int countChildrenById(Long id);
    long countTotalSelectedByUserNo(Long userNo);
    int update(Comment comment);
    void updateOrderNo(Comment comment);
    int delete(Long id);
}
