package com.knou.board.repository.mybatis;

import com.knou.board.domain.member.*;
import com.knou.board.repository.MemberRepository;
import lombok.extern.slf4j.Slf4j;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

import static com.knou.board.domain.member.Member.*;
import static org.assertj.core.api.Assertions.*;

@Slf4j
@Transactional
@SpringBootTest
@Sql(scripts = "classpath:/testInit.sql")
public class MyBatisMemberRepositoryTest {

    @Autowired
    MemberRepository memberRepository;

    @Test
    void insertUserAndProfileTest() {
        //given
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

        //when
        memberLogin = memberRepository.insertUser(memberLogin);
        member.setUserNo(memberLogin.getUserNo());
        member = memberRepository.insertProfile(member);

        //then
        Member selectMember = memberRepository.selectProfileById(member.getUserNo());
        assertThat(selectMember.getUserNo()).isEqualTo(member.getUserNo());
        assertThat(selectMember.getProfileId()).isEqualTo(member.getProfileId());
    }
}