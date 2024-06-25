package com.knou.board.repository.mybatis;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.domain.member.MemberWithdrawal;
import com.knou.board.file.UploadFile;
import com.knou.board.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
@RequiredArgsConstructor
public class MyBatisMemberRepository implements MemberRepository {

    private final MemberMapper memberMapper;


    // 회원가입 관련

    @Override
    public MemberLogin insertUser(MemberLogin memberLogin) {
        memberMapper.insertUser(memberLogin);
        return memberLogin;
    }

    @Override
    public int insertPassword(MemberLogin memberLogin) {
        return memberMapper.insertPassword(memberLogin);
    }

    @Override
    public Member insertProfile(Member member) {
        memberMapper.insertProfile(member);
        return member;
    }


    // SELECT

    @Override
    public Member selectProfileById(Long userNo) {
        return memberMapper.selectProfileById(userNo);
    }

    @Override
    public Member selectProfileByNickName(String nickName) {
        return memberMapper.selectProfileByNickName(nickName);
    }

    @Override
    public String selectLoginNameById(Long userNo) {
        return memberMapper.selectLoginNameById(userNo);
    }

    @Override
    public MemberLogin selectUserByLoginName(String loginName) {
        return memberMapper.selectUserByLoginName(loginName);
    }

    @Override
    public MemberLogin selectUserAndPasswordByLoginName(Long userNo, String password) {
        return memberMapper.selectUserAndPasswordByLoginName(userNo, password);
    }


    // 프로필 수정 관련

    @Override
    public int updateProfile(Member member) {
        return memberMapper.updateProfile(member);
    }

    @Override
    public int updatePassword(MemberLogin memberLogin, LocalDateTime updatedDate) {
        return memberMapper.updatePassword(memberLogin, updatedDate);
    }


    // 프로필 수정 - 이미지 업로드 관련

    @Override
    public String selectUploadFileNameById(Long userNo) {
        return memberMapper.selectUploadFileNameById(userNo);
    }
    @Override
    public int updateProfileImage(Member member, UploadFile uploadFile) {
        return memberMapper.updateProfileImage(member, uploadFile);
    }

    @Override
    public int updateProfileImageName(Long userNo, UploadFile uploadFile) {
        return memberMapper.updateProfileImageName(userNo, uploadFile);
    }


    // 탈퇴 관련

    @Override
    public int deleteUser(long UserNo) {
        return memberMapper.deleteUser(UserNo);
    }

    @Override
    public int deleteUserPassword(long UserNo) {
        return memberMapper.deleteUserPassword(UserNo);
    }

    @Override
    public int deleteProfileImage(long UserNo) {
        return memberMapper.deleteProfileImage(UserNo);
    }

    @Override
    public int updateNullProfileByUserNo(Long userNo) {
        return memberMapper.updateNullProfileByUserNo(userNo);
    }

    @Override
    public int insertWithdrawalUser(MemberWithdrawal memberWithdrawal) {
        return memberMapper.insertWithdrawalUser(memberWithdrawal);
    }

    @Override
    public int insertWithdrawalLog(MemberWithdrawal memberWithdrawal) {
        return memberMapper.insertWithdrawalLog(memberWithdrawal);
    }
}
