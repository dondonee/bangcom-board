package com.knou.board.web;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.post.Post;
import com.knou.board.domain.post.Topic;
import com.knou.board.domain.post.TopicGroup;
import com.knou.board.service.PostService;
import com.knou.board.web.argumentresolver.Login;
import com.knou.board.web.form.PostForm;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@Controller
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;

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
    public String getPostList(@PathVariable String board, Model model) {

        try {
            TopicGroup topicGroup = TopicGroup.valueOf(board.toUpperCase());
            model.addAttribute("topicGroup", topicGroup);
            List<Post> posts = postService.findByTopicGroup(topicGroup);
            model.addAttribute("posts", posts);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
        }

        return "board";
    }

    /**
     * 게시판 조회 (Topic) : @GetMapping({"/info/{topic}", "/community/{topic}"})
     */
    @GetMapping("/{board}/{boardTopic}")
    public String getPostList(@PathVariable String board, @PathVariable String boardTopic, Model model) {

        try {
            TopicGroup topicGroup = TopicGroup.valueOf(board.toUpperCase());

            if (!(topicGroup == TopicGroup.INFO || topicGroup == TopicGroup.COMMUNITY)) {
                throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
            }

            Topic topic = Topic.uriValueOf(boardTopic);
            List<Post> posts = postService.findByTopic(topic);

            model.addAttribute("topicGroup", topicGroup);
            model.addAttribute("topic", topic);
            model.addAttribute("posts", posts);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
        }

        return "board";
    }

    /**
     * 게시글 등록 폼 : @GetMapping({"questions", "/info", "/community", "/notice"})
     */
    @GetMapping("/{board}/new")
    public String addPostForm(@PathVariable String board, @Login Member loginMember, Model model) {

        TopicGroup topicGroup = TopicGroup.valueOf(board.toUpperCase());

        try {
            // INFO 게시판 -> 일반 사용자(USER)는 '정보알림' 토픽에만 글쓰기 가능
            if (topicGroup == TopicGroup.INFO) {
                if (loginMember.getAuthority() == Member.Authority.USER) {
                    model.addAttribute("topic", Topic.USER);
                }
            }

            model.addAttribute("topicGroup", topicGroup);

        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
        }

        return "postAddForm";
    }

    /**
     * 게시글 등록 : @GetMapping({"/questions", "/community", "/notice"})
     */
    @PostMapping("/{board}/new")
    public String addPost(@PathVariable String board, @Validated @ModelAttribute PostForm form, BindingResult bindingResult, @Login Member loginMember, Model model) {

        try {
            TopicGroup topicGroup = TopicGroup.valueOf(board.toUpperCase());

            if (bindingResult.hasErrors()) {
                System.out.println("form : " + form);
                model.addAttribute("topicGroup", topicGroup);
                model.addAttribute("form", form);  // 사용자가 입력했던 값 다시 전달
                return "postAddForm";
            }
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(NOT_FOUND, "게시판을 찾을 수 없습니다.");
        }


        Post post = new Post();
        post.setTopic(form.getTopic());
        post.setTitle(form.getTitle());
        post.setContent(form.getContent());
        post.setAuthor(loginMember);

        long postId = postService.createPost(post);

        return "redirect:/articles/" + postId;  // [!] 작성글 상세보기로 수정 필요
    }

    /**
     * INFO 게시글 등록 : 권한 체크 필요
     */
//    @PostMapping("/info/new")
//    public String addInfoPost(@Login Member loginMember, @ModelAttribute Post post, Model model) {
//

//        return "redirect:/info";
//    }


    /**
     * 게시글 상세 조회 (모든 게시판 공용)
     */
    @GetMapping("/articles/{postId}")
    public String getPostDetail(@PathVariable long postId, Model model) {

        Post post = postService.findPost(postId);
        TopicGroup topicGroup = TopicGroup.findGroup(post.getTopic());
        model.addAttribute("topicGroup", topicGroup);
        model.addAttribute("post", post);

        return "postDetail";
    }
}
