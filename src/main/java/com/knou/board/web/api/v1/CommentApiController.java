package com.knou.board.web.api.v1;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.comment.Comment;
import com.knou.board.exception.*;
import com.knou.board.service.CommentService;
import com.knou.board.service.PostService;
import com.knou.board.web.argumentresolver.Login;
import com.knou.board.web.form.CommentAddForm;
import com.knou.board.web.form.CommentEditForm;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequestMapping("/api/v1")
@RestController
@RequiredArgsConstructor
public class CommentApiController {

    private final CommentService commentService;
    private final PostService postService;


    @PostMapping("/articles/comments")
    public ResponseEntity<Map<String, Object>> addComment(@Validated @ModelAttribute CommentAddForm form, @Login Member loginMember) {

        // 존재하는 게시물인지 확인
        long postId = form.getPostId();
        postService.findPost(postId);

        // 검증 성공 => 댓글 등록
        Comment comment = new Comment();
        comment.setPostId(postId);
        comment.setWriter(loginMember);
        comment.setContent(form.getContent());
        if (form.getParentCommentInfo() != null) {
            comment.setParentCommentInfo(form.getParentCommentInfo());
        }
        commentService.createComment(comment);

        Map<String, Object> resultMap = new HashMap<>();
        List<Comment> comments = commentService.findListByPostId(postId);
        resultMap.put("comments", comments);
        resultMap.put("loginMember", loginMember);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);  // 댓글 목록 반환
    }

    @GetMapping("/articles/{postId}/comments")
    public ResponseEntity<List<Comment>> getCommentList(@PathVariable long postId) {
        // 존재하는 게시글인지 확인
        postService.findPost(postId);

        List<Comment> comments = commentService.findListByPostId(postId);// 댓글 목록 및 개수 반환
        return new ResponseEntity<>(comments, HttpStatus.OK);
    }

    @PutMapping("/articles/comments/{commentId}")
    public ResponseEntity<Map<String, Object>> editComment(@Validated CommentEditForm form, @Login Member loginMember) {

        // 존재하는 댓글인지 확인
        Comment comment = commentService.findComment(form.getCommentId());

        // 작성자 여부 체크
        if (loginMember.getUserNo() != comment.getWriter().getUserNo()) {
            throw BusinessException.NOT_WRITER;
        }

        // 검증 성공 => 댓글 삭제
        comment.setContent(form.getContent());
        commentService.editComment(comment);

        Map<String, Object> resultMap = new HashMap<>();
        List<Comment> comments = commentService.findListByPostId(comment.getPostId());
        resultMap.put("comments", comments);
        resultMap.put("loginMember", loginMember);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    @DeleteMapping("/articles/comments/{commentId}")
    public ResponseEntity<Map<String, Object>> deleteComment(@PathVariable long commentId, @Login Member loginMember) {

        // 존재하는 댓글인지 확인
        Comment comment = commentService.findComment(commentId);

        // 작성자 여부 체크
        if (loginMember.getUserNo() != comment.getWriter().getUserNo()) {
            throw BusinessException.NOT_WRITER;
        }

        // 검증 성공 => 댓글 삭제
        commentService.deleteComment(commentId);

        Map<String, Object> resultMap = new HashMap<>();
        List<Comment> comments = commentService.findListByPostId(comment.getPostId());
        resultMap.put("comments", comments);
        resultMap.put("loginMember", loginMember);
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }
}
