package com.knou.board.web;

import com.knou.board.domain.post.Post;
import com.knou.board.domain.post.TopicGroup;
import com.knou.board.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@Controller
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;

//    @GetMapping("/questions")
//    public String getQuestions(Model model) {
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
    public String getPosts(@PathVariable String board, Model model) {

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
}
