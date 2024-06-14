package com.knou.board.service;

import com.knou.board.domain.comment.Comment;
import com.knou.board.domain.comment.ParentCommentInfo;
import com.knou.board.repository.CommentRepository;
import com.knou.board.web.dto.CommentListDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

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

    public CommentListDto findListByPostId(long postId) {
        CommentListDto result = new CommentListDto();
        result.setComments(commentRepository.selectByPostId(postId));
        result.setCommentTotal(commentRepository.countTotalSelectedByPostId(postId));
        return result;
    }
}
