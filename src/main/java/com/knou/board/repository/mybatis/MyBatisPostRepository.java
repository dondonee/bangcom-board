package com.knou.board.repository.mybatis;

import com.knou.board.domain.Post;
import com.knou.board.repository.PostRepository;
import com.knou.board.repository.mybatis.PostMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class MyBatisPostRepository implements PostRepository {

    private final PostMapper postMapper;

    @Override
    public Post save(Post post) {
        postMapper.save(post);
        return post;
    }

    @Override
    public Post findById(Long id) {
        return postMapper.findById(id);
    }
}
