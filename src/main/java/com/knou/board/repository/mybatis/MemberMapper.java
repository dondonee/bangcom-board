package com.knou.board.repository.mybatis;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberMapper {

    void insertUser(MemberLogin memberLogin);
    void insertPassword(MemberLogin memberLogin);
    void insertProfile(Member member);
    Member selectProfileById(Long userNo);
    MemberLogin selectUserByLoginName(String loginName);
    Member selectProfileByNickName(String nickName);
    MemberLogin selectUserByIdAndPassword(@Param("userNo") Long userNo, @Param("password") String password);
}
