package com.knou.board.web.controller;

import com.knou.board.domain.post.Criteria;
import com.knou.board.domain.post.Post;
import com.knou.board.domain.post.Topic;
import com.knou.board.domain.post.TopicGroup;
import com.knou.board.service.PostService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class HomeController {

    private final PostService postService;

    @GetMapping("/")
    public String home(Model model) {

        Criteria criteria = new Criteria(5);

        Topic[] qnaTopics = TopicGroup.QUESTIONS.getTopics();
        Topic[] infoTopics = TopicGroup.INFO.getTopics();
        Topic[] communityTopics = TopicGroup.COMMUNITY.getTopics();
        Topic[] noticeTopics = TopicGroup.NOTICE.getTopics();

        List<Post> qnaList = postService.findListByTopics(qnaTopics, criteria);
        List<Post> infoList = postService.findListByTopics(infoTopics, criteria);
        List<Post> communityList = postService.findListByTopics(communityTopics, criteria);
        List<Post> noticeList = postService.findListByTopics(noticeTopics, criteria);

        model.addAttribute("qnaList", qnaList);
        model.addAttribute("infoList", infoList);
        model.addAttribute("communityList", communityList);
        model.addAttribute("noticeList", noticeList);

        return "home";
    }

    @GetMapping("/introduction")
    public String introduction() {
        return "introduction";
    }
}
