package com.knou.board.service;

import com.knou.board.domain.post.Post;
import com.knou.board.domain.post.Topic;
import com.knou.board.domain.post.TopicGroup;
import com.knou.board.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;

    public long createPost(Post post) {
        post.setCreatedDate(LocalDateTime.now());
        post.setViewCount(0);

        post = postRepository.insert(post);

        return post.getId();
    }

    public List<Post> findByTopicGroup(TopicGroup topicGroup) {
        Topic[] topics = topicGroup.getTopics();
        return postRepository.selectByTopics(topics);
    }

    public List<Post> findByTopic(Topic topic) {
        return postRepository.selectByTopics(new Topic[]{topic});
    }

    public Post findPost(long postId) {
        return postRepository.selectById(postId);
    }

    public void increaseViewCount(long postId) {
        postRepository.updateViewCount(postId);
    }

    public Post updatePost(Post post) {
        post.setModifiedDate(LocalDateTime.now());
        return postRepository.update(post);
    }

    public void deletePost(long postId) {
        postRepository.delete(postId);
    }
}
