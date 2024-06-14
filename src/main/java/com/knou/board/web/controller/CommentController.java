package com.knou.board.web.controller;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.comment.Comment;
import com.knou.board.domain.post.Post;
import com.knou.board.exception.ErrorResult;
import com.knou.board.service.CommentService;
import com.knou.board.service.PostService;
import com.knou.board.web.argumentresolver.Login;
import com.knou.board.web.dto.CommentListDto;
import com.knou.board.web.form.CommentAddForm;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

import static org.springframework.http.HttpStatus.BAD_REQUEST;

@Slf4j
@RestController
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;
    private final PostService postService;


    @PostMapping("/articles/comments")
    public ResponseEntity addComment(@ModelAttribute CommentAddForm form, @Login Member loginMember) {

        // 로그인 체크
        if (loginMember == null) {
            ErrorResult errorResult = new ErrorResult("UNAUTHORIZED", "로그인 사용자만 댓글을 작성할 수 있습니다.");
            return new ResponseEntity<>(errorResult, HttpStatus.UNAUTHORIZED);
        }

        // 댓글 유효성 검증
        long postId = form.getPostId();
        Optional<Post> post = Optional.ofNullable(postService.findPost(postId));  // 존재하는 게시물인지 확인
        if (post.isEmpty()) {
            ErrorResult errorResult = new ErrorResult("BAD_REQUEST", "존재하지 않는 게시글입니다.");
            return new ResponseEntity<>(errorResult, BAD_REQUEST);
        }
        String content = form.getContent();
        if (content == null || content.isBlank()) {
            ErrorResult errorResult = new ErrorResult("BAD_REQUEST", "내용을 최소 1자 이상 입력해주세요.");
            return new ResponseEntity<>(errorResult, BAD_REQUEST);
        } else if (content.length() > 2000) {
            ErrorResult errorResult = new ErrorResult("BAD_REQUEST", "댓글은 2000자 이하로 입력해주세요.");
            return new ResponseEntity<>(errorResult, BAD_REQUEST);
        }

        // 검증 성공 => 댓글 등록
        Comment comment = new Comment();
        comment.setPostId(postId);
        comment.setWriter(loginMember);
        comment.setContent(content);
        if (form.getParentCommentInfo() != null) {
            comment.setParentCommentInfo(form.getParentCommentInfo());
        }
        commentService.createComment(comment);

        CommentListDto findComments = commentService.findListByPostId(postId);
        return new ResponseEntity<>(findComments, HttpStatus.OK);  // 댓글 목록 반환
    }

    @GetMapping("/articles/{postId}/comments")
    public ResponseEntity getCommentList(@PathVariable long postId) {
        // 존재하는 게시룸인지 확인
        Post post = postService.findPost(postId);
        if (post == null) {
            ErrorResult errorResult = new ErrorResult("BAD_REQUEST", "존재하지 않는 게시글입니다.");
            return new ResponseEntity<>(errorResult, BAD_REQUEST);
        }

        CommentListDto comments = commentService.findListByPostId(postId);  // 댓글 목록 및 개수 반환
        return new ResponseEntity<>(comments, HttpStatus.OK);
    }
}
