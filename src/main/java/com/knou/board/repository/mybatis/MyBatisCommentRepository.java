package com.knou.board.repository.mybatis;

import com.knou.board.domain.post.Comment;
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
    public List<Comment> selectByPostId(Long postId) {
        return commentMapper.selectByPostId(postId);
    }

    @Override
    public long countTotalSelectedByPostId(Long postId) {
        return commentMapper.countTotalSelectedByPostId(postId);
    }
}
