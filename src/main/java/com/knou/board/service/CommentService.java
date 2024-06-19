package com.knou.board.service;

import com.knou.board.domain.comment.Comment;
import com.knou.board.domain.comment.ParentCommentInfo;
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

        if (comment.getParentCommentInfo() == null) {
            // root 댓글인 경우
            comment.setCreatedDate(LocalDateTime.now());
            comment = commentRepository.insert(comment);
        } else {
            // 대댓글인 경우
            // 부모 댓글 정보 조회
            long parentId = comment.getParentCommentInfo().getParentId();
            ParentCommentInfo parentInfo = commentRepository.selectParentInfoById(parentId);
            comment.setParentCommentInfo(parentInfo);
            comment.setCreatedDate(LocalDateTime.now());
            comment = commentRepository.insert(comment);

            // 다른 댓글의 OrderNo 정렬
            Comment created = commentRepository.selectById(comment.getId());
            commentRepository.updateOrderNo(created);
        }

        return comment.getId();
    }

    public Comment findComment (long commentId) {
        return commentRepository.selectById(commentId);
    }

    public List<Comment> findListByPostId(long postId) {
        return commentRepository.selectByPostId(postId);
    }

    public int deleteComment (long commentId) {
        // 자식 댓글이 있는지 확인
        int children = commentRepository.countChildrenById(commentId);
        if (children > 0) {
            return 0;  // 삭제 불가
        }
        return commentRepository.delete(commentId);
    }
}
