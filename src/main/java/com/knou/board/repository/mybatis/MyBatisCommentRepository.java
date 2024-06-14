package com.knou.board.repository.mybatis;

import com.knou.board.domain.comment.Comment;
import com.knou.board.domain.comment.ParentCommentInfo;
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
    public List<Comment> selectByPostId(Long postId) {
        return commentMapper.selectByPostId(postId);
    }

    @Override
    public ParentCommentInfo selectParentInfoById(Long id) {
        return commentMapper.selectParentInfoById(id);
    }

    @Override
    public long countTotalSelectedByPostId(Long postId) {
        return commentMapper.countTotalSelectedByPostId(postId);
    }

    @Override
    public void updateOrderNo(Comment comment) {
        commentMapper.updateOrderNo(comment);
    }
}
