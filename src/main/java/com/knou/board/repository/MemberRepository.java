package com.knou.board.repository;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.domain.member.MemberWithdrawal;
import com.knou.board.file.UploadFile;

import java.time.LocalDateTime;

public interface MemberRepository {

    // 회원가입 관련
    MemberLogin insertUser(MemberLogin memberLogin);
    int insertPassword(MemberLogin memberLogin);
    Member insertProfile(Member member);

    // SELECT
    Member selectProfileById(Long userNo);
    Member selectProfileByNickName(String nickName);
    String selectLoginNameById(Long userNo);
    MemberLogin selectUserByLoginName(String loginName);
    MemberLogin selectUserAndPasswordByLoginName(Long userNo, String password);

    // 프로필 수정 관련
    int updateProfile(Member member);
    int updatePassword(MemberLogin memberLogin, LocalDateTime updatedDate);

    // 프로필 수정 - 이미지 업로드 관련
    String selectUploadFileNameById(Long userNo);
    int updateProfileImage(Member member, UploadFile uploadFile);
    int updateProfileImageName(Long userNo, UploadFile uploadFile);

    // 탈퇴 관련
    int deleteUser(long UserNo);
    int deleteUserPassword(long UserNo);
    int deleteProfileImage(long UserNo);
    int updateNullProfileByUserNo(Long userNo);
    int insertWithdrawalUser(MemberWithdrawal memberWithdrawal);
    int insertWithdrawalLog(MemberWithdrawal memberWithdrawal);
}
