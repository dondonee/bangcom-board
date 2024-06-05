package com.knou.board.service;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.file.FileStore;
import com.knou.board.file.UploadFile;
import com.knou.board.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final FileStore fileStore;

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

    public String findLoginNameByUserNo(Long userNo) {
        return memberRepository.selectLoginNameById(userNo);
    }

    public MemberLogin findMemberByLoginName(String loginName) {
        return memberRepository.selectUserByLoginName(loginName);
    }

    public Member findProfileByUserNo(Long userNo) {
        return memberRepository.selectProfileById(userNo);
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
        return memberRepository.selectProfileById(findUserNo);  // 애플리케이션에서 사용할 회원 프로필 조회
    }

    public Member updateProfile(Member member) {
        memberRepository.updateProfile(member);
        return memberRepository.selectProfileById(member.getUserNo());
    }

    public Member updateProfileImage(Member loginMember, MultipartFile file) throws IOException {
        // 파일 로컬에 저장
        UploadFile uploadFile = fileStore.storeFile(file, "profile/");

        // 파일 이름 DB에 저장
        Long userNo = loginMember.getUserNo();
        memberRepository.updateProfileImage(userNo, uploadFile);      // 프로필에 파일 이름 저장
        memberRepository.updateProfileImageName(userNo, uploadFile);  // 별도 테이블에 원본 이름 저장

        // 기존 파일 로컬에서 삭제
        String oldImageName = loginMember.getImageName();
        boolean deleted = fileStore.deleteFile(oldImageName, "profile/");
        if (!deleted) {
            log.error("기존 프로필 이미지 삭제 실패: {}", oldImageName);
        }

        return memberRepository.selectProfileById(userNo);
    }
}
