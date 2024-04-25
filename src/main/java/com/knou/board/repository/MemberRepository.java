package com.knou.board.repository;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;

public interface MemberRepository {
    MemberLogin insertUser(MemberLogin memberLogin);

    MemberLogin insertPassword(MemberLogin memberLogin);
    Member insertProfile(Member member);
    Member selectProfileById(Long userNo);
}
