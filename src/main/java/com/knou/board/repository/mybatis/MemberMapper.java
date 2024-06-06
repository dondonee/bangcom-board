package com.knou.board.repository.mybatis;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.file.UploadFile;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberMapper {

    void insertUser(MemberLogin memberLogin);
    void insertPassword(MemberLogin memberLogin);
    void insertProfile(Member member);
    Member selectProfileById(Long userNo);
    Member selectProfileByNickName(String nickName);
    String selectLoginNameById(Long userNo);
    String selectUploadFileNameById(Long userNo);
    MemberLogin selectUserByLoginName(String loginName);
    MemberLogin selectUserByIdAndPassword(@Param("userNo") Long userNo, @Param("password") String password);
    int updateProfile(Member member);
    int updateProfileImage(@Param("member") Member member, @Param("uploadFile") UploadFile uploadFile);
    int updateProfileImageName(@Param("userNo") Long userNo, @Param("uploadFile") UploadFile uploadFile);
}
