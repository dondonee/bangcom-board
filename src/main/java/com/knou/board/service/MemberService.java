package com.knou.board.service;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class MemberService {

    @Autowired
    private final MemberRepository memberRepository;

    public boolean isDuplicatedLoginName(String loginName) {
        MemberLogin memberLogin = memberRepository.selectUserByLoginName(loginName);
        if (memberLogin == null) {
            return false;
        }
        return true;
    }

    public boolean isDuplicatedNickname(String nickname) {
        Member member = memberRepository.selectProfileByNickName(nickname);
        if (member == null) {
            return false;
        }
        return true;
    }

    public Member createMember(MemberLogin memberLogin, Member member) {

        // 회원 INSERT
        memberLogin = memberRepository.insertUser(memberLogin);

        // 비밀번호 INSERT ( [!] 추후 암호화 필요 )
        memberRepository.insertPassword(memberLogin);

        // 회원 프로필 INSERT
        member.setUserNo(memberLogin.getUserNo());
        member.setJoinedDate(LocalDateTime.now());
        member.setAuthority(Member.Authority.USER);
        member = memberRepository.insertProfile(member);

        return memberRepository.selectProfileById(member.getUserNo());
    }

    public MemberLogin findMemberByLoginName(String loginName) {
        return memberRepository.selectUserByLoginName(loginName);
    }

    public Member authenticate(MemberLogin memberLogin) {
        Long userNoInput = memberLogin.getUserNo();
        String passwordInput = memberLogin.getPassword();

        // 인증 시도
        MemberLogin authenticated = memberRepository.selectUserByIdAndPassword(userNoInput, passwordInput);

        if (authenticated == null) {
            return null;
        }

        // 인증 성공
        Long findUserNo = authenticated.getUserNo();
        Member findMember = memberRepository.selectProfileById(findUserNo);  // 애플리케이션에서 사용할 회원 프로필 조회

        return findMember;
    }
}
