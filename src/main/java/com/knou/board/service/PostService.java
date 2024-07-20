package com.knou.board.service;

import com.knou.board.domain.post.Criteria;
import com.knou.board.domain.post.Post;
import com.knou.board.domain.post.Topic;
import com.knou.board.exception.BusinessException;
import com.knou.board.exception.ErrorCode;
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

    public List<Post> findListByMember(long userNo, Criteria criteria) {
        return postRepository.selectByUserNo(userNo, criteria);
    }

    public List<Post> findListByTopics(Topic[] topics, Criteria criteria) {
        return postRepository.selectByTopics(topics, criteria);
    }

    public List<Post> findListByTopics(Topic topic, Criteria criteria) {
        return postRepository.selectByTopics(new Topic[]{topic}, criteria);
    }

    public long getTotalCountByTopics(Topic[] topics) {
        return postRepository.countTotalSelectedByTopics(topics);
    }

    public long getTotalCountByTopics(Topic topic) {
        return postRepository.countTotalSelectedByTopics(new Topic[]{topic});
    }

    public long getTotalCountByMember(long userNo) {
        return postRepository.countTotalSelectedByUserNo(userNo);
    }

    public Post findPost(long postId) {
        Post post = postRepository.selectById(postId);
        if (post == null) {
            throw BusinessException.POST_NOT_EXIST;
        }
        return post;
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
