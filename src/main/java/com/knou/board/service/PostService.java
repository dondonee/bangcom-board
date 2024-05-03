package com.knou.board.service;

import com.knou.board.domain.post.Post;
import com.knou.board.domain.post.Topic;
import com.knou.board.domain.post.TopicGroup;
import com.knou.board.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;

    public List<Post> findByTopicGroup(TopicGroup topicGroup) {
        Topic[] topics = topicGroup.getTopics();
        return postRepository.selectByTopicGroup(topics);
    }
}
