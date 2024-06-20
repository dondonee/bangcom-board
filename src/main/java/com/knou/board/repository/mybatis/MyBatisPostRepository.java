package com.knou.board.repository.mybatis;

import com.knou.board.domain.post.Criteria;
import com.knou.board.domain.post.Post;
import com.knou.board.domain.post.Topic;
import com.knou.board.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MyBatisPostRepository implements PostRepository {

    private final PostMapper postMapper;

    @Override
    public Post insert(Post post) {
        postMapper.insert(post);
        return post;
    }

    @Override
    public Post selectById(Long id) {
        return postMapper.selectById(id);
    }

    @Override
    public List<Post> selectAll() {
        return postMapper.selectAll();
    }

    @Override
    public List<Post> selectByUserNo(Long userNo, Criteria criteria) {
        return postMapper.selectByUserNo(userNo, criteria);
    }

    @Override
    public List<Post> selectByTopics(Topic[] topics, Criteria criteria) {
        return postMapper.selectByTopics(topics, criteria);
    }

    @Override
    public long countTotalSelectedByUserNo(Long userNo) {
        return postMapper.countTotalSelectedByUserNo(userNo);
    }

    @Override
    public long countTotalSelectedByTopics(Topic[] topics) {
        return postMapper.countTotalSelectedByTopics(topics);
    }

    @Override
    public Post update(Post post) {
        postMapper.update(post);
        return post;
    }

    @Override
    public void updateViewCount(Long id) {
        postMapper.updateViewCount(id);
    }

    @Override
    public void delete(Long id) {
        postMapper.delete(id);
    }
}
