package com.knou.board.web.controller;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.post.*;
import com.knou.board.service.CommentService;
import com.knou.board.service.PostService;
import com.knou.board.web.PageMaker;
import com.knou.board.web.argumentresolver.Login;
import com.knou.board.web.dto.CommentListDto;
import com.knou.board.web.form.PostAddForm;
import com.knou.board.web.form.PostEditForm;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

import static org.springframework.http.HttpStatus.*;

@Slf4j
@Controller
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;
    private final CommentService commentService;

//    @GetMapping("/questions")
//    public String getQuestionList(Model model) {
//        TopicGroup topicGroup = TopicGroup.QUESTIONS;
//        List<Post> posts = postService.findByTopicGroup(topicGroup);
//        model.addAttribute("topicGroup", topicGroup);
//        model.addAttribute("posts", posts);
//        return "question-board";
//    }

    /**
     * 게시판 조회 : @GetMapping({"/info", "/community", "/notice"})
     */
    @GetMapping("/{board}")
    public String getPostList(@PathVariable String board, Criteria criteria, Model model) {

        try {
            TopicGroup topicGroup = TopicGroup.uriValueOf(board);
            Topic[] topics = topicGroup.getTopics();
            model.addAttribute("topicGroup", topicGroup);

            List<Post> posts = postService.findListByTopics(topics, criteria);
            model.addAttribute("posts", posts);

            PageMaker pageMaker = new PageMaker();
            pageMaker.setCriteria(criteria);
            pageMaker.setTotalArticles(postService.getTotalCountByTopics(topics));
            model.addAttribute("pageMaker", pageMaker);

        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
        }

        return "board";
    }

    /**
     * 게시판 조회 (Topic) : @GetMapping({"/info/{topic}", "/community/{topic}"})
     */
    @GetMapping("/{board}/{boardTopic}")
    public String getPostList(@PathVariable String board, @PathVariable String boardTopic, Criteria criteria, Model model) {

        try {
            TopicGroup topicGroup = TopicGroup.uriValueOf(board);
            Topic topic = Topic.uriValueOf(boardTopic);

            if (TopicGroup.findGroup(topic) != topicGroup) {
                throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
            }

            List<Post> posts = postService.findListByTopics(topic, criteria);
            model.addAttribute("posts", posts);
            model.addAttribute("topicGroup", topicGroup);
            model.addAttribute("topic", topic);

            PageMaker pageMaker = new PageMaker();
            pageMaker.setCriteria(criteria);
            pageMaker.setTotalArticles(postService.getTotalCountByTopics(topic));
            model.addAttribute("pageMaker", pageMaker);

        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
        }

        return "board";
    }

    /**
     * 게시글 상세 조회 : 모든 게시판 공용
     */
    @GetMapping("/articles/{postId}")
    public String getPostDetail(@PathVariable long postId, Model model) {

        Post post = postService.findPost(postId);
        if (post == null) {
            throw new ResponseStatusException(NOT_FOUND, "게시글을 찾을 수 없습니다.");
        }

        // 조회수 증가
        postService.increaseViewCount(postId);
        post.setViewCount(post.getViewCount() + 1);

        TopicGroup topicGroup = TopicGroup.findGroup(post.getTopic());
        model.addAttribute("topicGroup", topicGroup);
        model.addAttribute("post", post);

        // 댓글 목록 조회
        CommentListDto commentListDto = commentService.findListByPostId(postId);
        model.addAttribute("comments", commentListDto.getComments());
        model.addAttribute("commentTotal", commentListDto.getCommentTotal());

        return "postDetail";
    }

    /**
     * 게시글 등록 폼 : 모든 게시판 공용
     */
    @GetMapping("/{board}/new")
    public String addPostForm(@PathVariable String board, Model model) {

        try {
            TopicGroup topicGroup = TopicGroup.uriValueOf(board);
            model.addAttribute("topicGroup", topicGroup);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
        }

        return "postAddForm";
    }

    /**
     * 게시글 등록 : 모든 게시판 공용
     */
    @PostMapping("/{board}/new")
    public String addPost(@PathVariable String board, @Validated @ModelAttribute PostAddForm form, BindingResult bindingResult, @Login Member loginMember, Model model) {

        // 검증
        try {
            TopicGroup topicGroup = TopicGroup.uriValueOf(board);

            if (bindingResult.hasErrors()) {
                model.addAttribute("topicGroup", topicGroup);
                model.addAttribute("form", form);  // 사용자가 입력했던 값 다시 전달
                return "postAddForm";
            }

        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
        }

        // 멘토게시판의 경우 권한 체크
        if (form.getTopic() == Topic.MENTOR) {
            if (loginMember.getAuthority() == Member.Authority.USER) {
                throw new ResponseStatusException(FORBIDDEN, "멘토링 게시판은 멘토만 글을 작성할 수 있습니다.");
            }
        }

        // 게시글 등록
        Post post = new Post();
        post.setTopic(form.getTopic());
        post.setTitle(form.getTitle());
        post.setContent(form.getContent());
        post.setAuthor(loginMember);
        long postId = postService.createPost(post);

        return "redirect:/articles/" + postId;  // 작성 글 보기
    }

    /**
     * 게시글 수정 폼 : 모든 게시판 공용
     */
    @GetMapping("/articles/{postId}/edit")
    public String editPostForm(@PathVariable long postId, @Login Member loginMember, Model model) {

        Post post = postService.findPost(postId);
        if (post == null) {
            throw new ResponseStatusException(NOT_FOUND, "게시글을 찾을 수 없습니다.");
        }

        if (post.getAuthor().getUserNo() != loginMember.getUserNo()) {
            throw new ResponseStatusException(FORBIDDEN, "게시글 작성자만 수정할 수 있습니다.");
        }

        try {
            TopicGroup topicGroup = TopicGroup.findGroup(post.getTopic());
            model.addAttribute("topicGroup", topicGroup);

        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
        }

        // 수정 폼에 기존 게시글 정보 전달
        PostEditForm form = new PostEditForm();
        form.setId(post.getId());
        form.setTopic(post.getTopic());
        form.setTitle(post.getTitle());
        form.setContent(post.getContent());
        form.setAuthorId(post.getAuthor().getUserNo());
        model.addAttribute("form", form);

        return "postEditForm";
    }

    /**
     * 게시글 수정 : 모든 게시판 공용
     */
    @PostMapping("/articles/{postId}/edit")
    public String editPost(@ModelAttribute PostEditForm form, BindingResult bindingResult, @Login Member loginMember, Model model) {

        // 바인딩 오류 검증
        try {
            TopicGroup topicGroup = TopicGroup.findGroup(form.getTopic());

            if (bindingResult.hasErrors()) {
                model.addAttribute("topicGroup", topicGroup);
                model.addAttribute("form", form);  // 사용자가 입력했던 값 다시 전달
                return "postEditForm";
            }
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
        }

        // 멘토게시판의 경우 권한 체크
        if (form.getTopic() == Topic.MENTOR) {
            if (loginMember.getAuthority() == Member.Authority.USER) {
                throw new ResponseStatusException(FORBIDDEN, "멘토링 게시판은 멘토만 글을 작성할 수 있습니다.");
            }
        }

        // 작성자만 수정 가능
        if (form.getAuthorId() != loginMember.getUserNo()) {
            throw new ResponseStatusException(FORBIDDEN, "게시글 작성자만 수정할 수 있습니다.");
        }

        // 게시글 업데이트
        Post post = new Post();
        post.setId(form.getId());
        post.setTopic(form.getTopic());
        post.setTitle(form.getTitle());
        post.setContent(form.getContent());
        post.setAuthor(loginMember);

        post = postService.updatePost(post);
        long postId = post.getId();

        return "redirect:/articles/" + postId;  // 수정 글 보기
    }

    /**
     * 게시글 삭제 : 모든 게시판 공용
     */
    @GetMapping("/articles/{postId}/delete")
    public String deletePost(@PathVariable long postId, @Login Member loginMember) {

        Post post = postService.findPost(postId);
        if (post == null) {
            throw new ResponseStatusException(NOT_FOUND, "게시글을 찾을 수 없습니다.");
        }

        // 작성자만 삭제 가능
        if (loginMember == null || post.getAuthor().getUserNo() != loginMember.getUserNo()) {
            throw new ResponseStatusException(FORBIDDEN, "게시글 작성자만 수정할 수 있습니다.");
        }

        // 게시글 삭제
        postService.deletePost(postId);

        Topic topic = post.getTopic();
        TopicGroup topicGroup = TopicGroup.findGroup(topic);
        String redirectUri = topicGroup.getUri();
        if (topic != Topic.NOTICE) {
            redirectUri += "/" + topic.getUri();
        }

        return "redirect:/" + redirectUri;  // 해당 토픽 게시판으로 이동
    }
}
