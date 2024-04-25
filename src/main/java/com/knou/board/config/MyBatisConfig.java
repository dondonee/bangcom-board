package com.knou.board.config;

import com.knou.board.domain.member.Member;
import com.knou.board.repository.MemberRepository;
import com.knou.board.repository.mybatis.MemberMapper;
import com.knou.board.repository.mybatis.MyBatisMemberRepository;
import com.knou.board.repository.mybatis.MyBatisPostRepository;
import com.knou.board.repository.PostRepository;
import com.knou.board.repository.mybatis.PostMapper;
import com.knou.board.service.PostService;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.type.TypeHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
public class MyBatisConfig {

    private final MemberMapper memberMapper;
    private final PostMapper postMapper;

    @Bean
    public MemberRepository memberRepository() { return new MyBatisMemberRepository(memberMapper); }
    @Bean
    public PostRepository postRepository() {
        return new MyBatisPostRepository(postMapper);
    }

}
