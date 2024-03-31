package com.knou.board.config;

import com.knou.board.repository.mybatis.MyBatisPostRepository;
import com.knou.board.repository.PostRepository;
import com.knou.board.repository.mybatis.PostMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
public class MyBatisConfig {

    private final PostMapper postMapper;

    @Bean
    public PostRepository postRepository() {
        return new MyBatisPostRepository(postMapper);
    }
}
