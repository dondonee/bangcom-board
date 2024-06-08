package com.knou.board.web.controller;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.post.Comment;
import com.knou.board.domain.post.Post;
import com.knou.board.exception.ErrorResult;
import com.knou.board.service.CommentService;
import com.knou.board.service.PostService;
import com.knou.board.web.argumentresolver.Login;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static org.springframework.http.HttpStatus.BAD_REQUEST;

@Slf4j
@RestController
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;
    private final PostService postService;


    @PostMapping("/articles/{postId}/comments")
    public ResponseEntity addComment(@PathVariable long postId, @ModelAttribute("content") String content, @Login Member loginMember) {

        // 로그인 체크
        if (loginMember == null) {
            ErrorResult errorResult = new ErrorResult("UNAUTHORIZED", "로그인 사용자만 댓글을 작성할 수 있습니다.");
            return new ResponseEntity<>(errorResult, HttpStatus.UNAUTHORIZED);
        }

        // 댓글 유효성 검증
        Post post = postService.findPost(postId);  // 존재하는 게시물인지 확인
        if (post == null) {
            ErrorResult errorResult = new ErrorResult("BAD_REQUEST", "존재하지 않는 게시글입니다.");
            return new ResponseEntity<>(errorResult, BAD_REQUEST);
        }
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

        commentService.createComment(comment);
        List<Comment> comments = commentService.findListByPostId(postId);
        return new ResponseEntity<>(comments, HttpStatus.OK);  // 댓글 목록 반환
    }

    @GetMapping("/articles/{postId}/comments")
    public ResponseEntity getCommentList(@PathVariable long postId) {
        // 존재하는 게시룸인지 확인
        Post post = postService.findPost(postId);
        if (post == null) {
            ErrorResult errorResult = new ErrorResult("BAD_REQUEST", "존재하지 않는 게시글입니다.");
            return new ResponseEntity<>(errorResult, BAD_REQUEST);
        }

        List<Comment> comments = commentService.findListByPostId(postId);
        return new ResponseEntity<>(comments, HttpStatus.OK);
    }
}
