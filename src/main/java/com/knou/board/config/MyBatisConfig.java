package com.knou.board.config;

import com.knou.board.repository.CommentRepository;
import com.knou.board.repository.MemberRepository;
import com.knou.board.repository.mybatis.*;
import com.knou.board.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
public class MyBatisConfig {

    private final MemberMapper memberMapper;
    private final PostMapper postMapper;
    private final CommentMapper commentMapper;

    @Bean
    public MemberRepository memberRepository() {
        return new MyBatisMemberRepository(memberMapper);
    }

    @Bean
    public PostRepository postRepository() {
        return new MyBatisPostRepository(postMapper);
    }

    @Bean
    public CommentRepository commentRepository() {
        return new MyBatisCommentRepository(commentMapper);
    }

}
