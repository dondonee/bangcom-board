package com.knou.board.repository.mybatis;

import com.knou.board.domain.member.*;
import com.knou.board.repository.MemberRepository;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;

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

    @Test
    public void selectUserByLoginName() {
        //given
        Map<String, Object> memberMap = setMember();
        MemberLogin memberLogin = (MemberLogin) memberMap.get("memberLogin");
        memberLogin.setLoginName("knou01");
        memberRepository.insertUser(memberLogin);

        //when
        MemberLogin findMember = memberRepository.selectUserByLoginName("knou01");

        //then
        assertThat(findMember).isNotNull();
    }

    @Test
    public void selectUserByLoginName_CaseInsensitive_True() {
        //given
        Map<String, Object> memberMap = setMember();
        MemberLogin memberLogin = (MemberLogin) memberMap.get("memberLogin");
        memberLogin.setLoginName("knou01");
        memberRepository.insertUser(memberLogin);

        //when
        MemberLogin findMember = memberRepository.selectUserByLoginName("KNOU01");  // 대문자로 검색

        //then
        assertThat(findMember).isNotNull();
    }

    @Test
    public void selectProfileByNickName() {
        //given
        Map<String, Object> memberMap = setMember();
        MemberLogin memberLogin = (MemberLogin) memberMap.get("memberLogin");
        memberLogin = memberRepository.insertUser(memberLogin);

        Member member = (Member) memberMap.get("member");
        member.setUserNo(memberLogin.getUserNo());
        member.setNickname("bangcom");
        member = memberRepository.insertProfile(member);

        //when
        Member findMember = memberRepository.selectProfileByNickName("bangcom");

        //then
        assertThat(findMember).isNotNull();
    }

    @Test
    public void selectProfileByNickName_CaseInsensitive_True() {
        //given
        Map<String, Object> memberMap = setMember();
        MemberLogin memberLogin = (MemberLogin) memberMap.get("memberLogin");
        memberLogin = memberRepository.insertUser(memberLogin);

        Member member = (Member) memberMap.get("member");
        member.setUserNo(memberLogin.getUserNo());
        member.setNickname("bangcom");
        member = memberRepository.insertProfile(member);

        //when
        Member findMember = memberRepository.selectProfileByNickName("BANGCOM"); // 대문자로 검색

        //then
        assertThat(findMember).isNotNull();
    }


    // private 메서드

    private Map<String, Object> setMember() {
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

        return Map.of("memberLogin", memberLogin, "member", member);
    }
}