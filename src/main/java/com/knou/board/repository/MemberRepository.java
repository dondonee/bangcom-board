package com.knou.board.repository;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.domain.member.MemberWithdrawal;
import com.knou.board.file.UploadFile;

public interface MemberRepository {

    MemberLogin insertUser(MemberLogin memberLogin);
    MemberLogin insertPassword(MemberLogin memberLogin);
    Member insertProfile(Member member);
    Member selectProfileById(Long userNo);
    Member selectProfileByNickName(String nickName);
    String selectLoginNameById(Long userNo);
    MemberLogin selectUserByLoginName(String loginName);
    MemberLogin selectUserByIdAndPassword(Long userNo, String password);
    String selectUploadFileNameById(Long userNo);
    int updateProfile(Member member);
    int updateProfileImage(Member member, UploadFile uploadFile);
    int updateProfileImageName(Long userNo, UploadFile uploadFile);

    // 탈퇴 관련
    int deleteUser(long UserNo);
    int deleteUserPassword(long UserNo);
    int updateNullProfileByUserNo(Long userNo);
    int insertWithdrawalUser(MemberWithdrawal memberWithdrawal);
    int insertWithdrawalLog(MemberWithdrawal memberWithdrawal);
}
