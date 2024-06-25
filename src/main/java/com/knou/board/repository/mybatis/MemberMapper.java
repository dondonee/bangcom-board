package com.knou.board.repository.mybatis;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.domain.member.MemberWithdrawal;
import com.knou.board.file.UploadFile;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;

@Mapper
public interface MemberMapper {

    // 회원가입 관련
    void insertUser(MemberLogin memberLogin);
    int insertPassword(MemberLogin memberLogin);
    void insertProfile(Member member);

    // SELECT
    Member selectProfileById(Long userNo);
    Member selectProfileByNickName(String nickName);
    String selectLoginNameById(Long userNo);
    MemberLogin selectUserByLoginName(String loginName);
    MemberLogin selectUserAndPasswordByLoginName(@Param("userNo") Long userNo, @Param("password") String password);

    // 프로필 수정 관련
    int updateProfile(Member member);
    int updatePassword(@Param("memberLogin") MemberLogin memberLogin, @Param("updatedDate") LocalDateTime updatedDate);

    // 프로필 수정 - 이미지 업로드 관련
    String selectUploadFileNameById(Long userNo);
    int updateProfileImage(@Param("member") Member member, @Param("uploadFile") UploadFile uploadFile);
    int updateProfileImageName(@Param("userNo") Long userNo, @Param("uploadFile") UploadFile uploadFile);

    // 탈퇴 관련
    int deleteUser(long UserNo);
    int deleteUserPassword(long UserNo);
    int updateNullProfileByUserNo(Long userNo);
    int insertWithdrawalUser(MemberWithdrawal memberWithdrawal);
    int insertWithdrawalLog(MemberWithdrawal memberWithdrawal);
}
