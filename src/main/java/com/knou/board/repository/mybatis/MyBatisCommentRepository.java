package com.knou.board.repository.mybatis;

import com.knou.board.domain.comment.Comment;
import com.knou.board.domain.comment.CommentHistoryDto;
import com.knou.board.domain.comment.ParentCommentInfo;
import com.knou.board.domain.post.Criteria;
import com.knou.board.repository.CommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MyBatisCommentRepository implements CommentRepository {

    private final CommentMapper commentMapper;

    @Override
    public Comment insert(Comment comment) {
        commentMapper.insert(comment);
        return comment;
    }

    @Override
    public Comment selectById(Long id) {
        return commentMapper.selectById(id);
    }

    @Override
    public List<CommentHistoryDto> selectByUserNo(Long userNo, Criteria criteria) {
        return commentMapper.selectByUserNo(userNo, criteria);
    }

    @Override
    public List<Comment> selectByPostId(Long postId) {
        return commentMapper.selectByPostId(postId);
    }

    @Override
    public ParentCommentInfo selectParentInfoById(Long id) {
        return commentMapper.selectParentInfoById(id);
    }

    @Override
    public long countTotalSelectedByUserNo(Long userNo) {
        return commentMapper.countTotalSelectedByUserNo(userNo);
    }

    @Override
    public int update(Comment comment) {
        return commentMapper.update(comment);
    }

    @Override
    public void updateOrderNo(Comment comment) {
        commentMapper.updateOrderNo(comment);
    }

    @Override
    public int countChildrenById(Long id) {
        return commentMapper.countChildrenById(id);
    }

    @Override
    public int delete(Long id) {
        return commentMapper.delete(id);
    }
}
