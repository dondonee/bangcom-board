package com.knou.board.repository.mybatis;

import com.knou.board.domain.member.*;
import com.knou.board.domain.post.Post;
import com.knou.board.domain.post.Topic;
import com.knou.board.domain.post.TopicGroup;
import com.knou.board.repository.MemberRepository;
import com.knou.board.repository.PostRepository;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import static com.knou.board.domain.member.Member.*;
import static org.assertj.core.api.Assertions.assertThat;

@Slf4j
@Transactional
@SpringBootTest
@Sql(scripts = "classpath:/testInit.sql")
public class MyBatisPostRepositoryTest {

    @Autowired
    PostRepository postRepository;
    @Autowired
    MemberRepository memberRepository;

    @Test
    void insertAndSelectById() {
        //given
        Post post = setPost();

        //when
        post = postRepository.insert(post);
        System.out.println("post = " + post);

        //then
        Post selectPost = postRepository.selectById(post.getId());
        System.out.println("selectPost = " + selectPost);
        assertThat(selectPost).isEqualTo(post);
    }

    @Test
    void selectAll() {
        //given
        Post post = setPost();
        postRepository.insert(post);
        postRepository.insert(post);

        //when
        List<Post> posts = postRepository.selectAll();

        //then
        assertThat(posts.size()).isEqualTo(2);
    }

    @Test
    void update() {
        //given
        Post post = setPost();
        post = postRepository.insert(post);
        post = postRepository.selectById(post.getId());

        //when
        post.setModifiedDate(LocalDateTime.now());
        postRepository.update(post);

        //then
        Post updatePost = postRepository.selectById(post.getId());
        assertThat(updatePost.getModifiedDate()).isEqualTo(post.getModifiedDate());
    }

    @Test
    void delete() {
        //given
        Post post = setPost();
        post = postRepository.insert(post);

        //when
        postRepository.delete(post.getId());

        //then
        Post selectPost = postRepository.selectById(post.getId());
        assertThat(selectPost).isNull();
    }

    @Test
    void selectByTopicGroup() {
        //given
        Post post1 = setPost();
        Post post2 = post1;
        post1.setTopic(Topic.CAMPUS);
        post2.setTopic(Topic.LIFE);

        postRepository.insert(post1);
        postRepository.insert(post2);

        //when
        Topic[] topics = TopicGroup.COMMUNITY.getTopics();
        List<Post> posts = postRepository.selectByTopics(topics);

        //then
        assertThat(posts.size()).isEqualTo(2);
    }

    @Test
    void selectByTopicGroupNotice() {
        //given
        Post post = setPost();
        post.setTopic(Topic.NOTICE);

        postRepository.insert(post);
        postRepository.insert(post);

        //when
        Topic[] topics = TopicGroup.NOTICE.getTopics();
        List<Post> posts = postRepository.selectByTopics(topics);

        //then
        assertThat(posts.size()).isEqualTo(2);
    }

    private Member insertMember() {
        MemberLogin memberLogin = new MemberLogin();
        memberLogin.setLoginName("loginName");
        memberLogin.setPassword("password");

        Member member = new Member();
        member.setNickname("nickname");
        member.setGrade(Grade.GRADE_1);
        member.setTransferred(false);
        member.setRegion(Region.SEOUL);
        member.setAuthority(Authority.USER);
        member.setJoinedDate(LocalDateTime.now());

        memberLogin = memberRepository.insertUser(memberLogin);
        member.setUserNo(memberLogin.getUserNo());
        member = memberRepository.insertProfile(member);

        return member;
    }

    private Post setPost() {
        Member member = insertMember();

        Post post = new Post();
        post.setTopic(Topic.LIFE);
        post.setTitle("title");
        post.setContent("content");
        post.setCreatedDate(LocalDateTime.now());
        post.setAuthor(member);

        return post;
    }
}