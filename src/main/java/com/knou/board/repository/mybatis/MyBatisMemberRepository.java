package com.knou.board.repository.mybatis;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class MyBatisMemberRepository implements MemberRepository {

    private final MemberMapper memberMapper;

    @Override
    public MemberLogin insertUser(MemberLogin memberLogin) {
        memberMapper.insertUser(memberLogin);
        return memberLogin;
    }

    @Override
    public MemberLogin insertPassword(MemberLogin memberLogin) {
        memberMapper.insertPassword(memberLogin);
        return memberLogin;
    }

    @Override
    public Member insertProfile(Member member) {
        memberMapper.insertProfile(member);
        return member;
    }

    @Override
    public Member selectProfileById(Long userNo) {
        return memberMapper.selectProfileById(userNo);
    }
}
