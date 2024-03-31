package com.knou.board.repository;

import com.knou.board.config.MyBatisConfig;
import com.knou.board.domain.Post;
import com.knou.board.repository.mybatis.PostMapper;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.Assert.*;

@Slf4j
@Transactional
@SpringBootTest
public class MyBatisPostRepositoryTest {

    @Autowired
    PostRepository postRepository;

    @Test
    void save() {
        //given
        Post post = new Post("title 1", "Lorem Ipsum");

        //when
        Post savePost = postRepository.save(post);
        System.out.println("savePost = " + savePost);

        //then
        Post findPost = postRepository.findById(savePost.getId());
        System.out.println("findPost = " + findPost);
        assertThat(findPost).isEqualTo(savePost);
    }
}