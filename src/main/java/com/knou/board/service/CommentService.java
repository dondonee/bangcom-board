package com.knou.board.service;

import com.knou.board.domain.post.Comment;
import com.knou.board.repository.CommentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;

    public long createComment(Comment comment) {
        comment.setCreatedDate(LocalDateTime.now());
        comment = commentRepository.insert(comment);

        return comment.getId();
    }

    public List<Comment> findListByPostId(long postId) {
        return commentRepository.selectByPostId(postId);
    }
}
