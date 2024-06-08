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
        // 로컬에 파일 저장 후 파일명 받아오기
        UploadFile uploadFile = fileStore.storeFile(file, "profile/");

        // 파일명 DB 업데이트 후 최신 프로필 반환
        return doUpdateProfileImage(loginMember, uploadFile);
    }

    public Member initProfileImage(Member loginMember) throws IOException {
        // 파일명 DB 업데이트 후 최신 프로필 반환
        return doUpdateProfileImage(loginMember, new UploadFile(null, null));
    }

    private Member doUpdateProfileImage(Member member, UploadFile uploadFile) throws IOException {

        // 프로필 테이블의 저장 파일명 삭제 (+ 수정일 업데이트)
        member.setUpdatedDate(LocalDateTime.now());
        memberRepository.updateProfileImage(member, uploadFile);

        // 별도 테이블의 원본 파일명 삭제
        Long userNo = member.getUserNo();
        memberRepository.updateProfileImageName(userNo, uploadFile);

        // 기존 파일 로컬에서 삭제
        String oldImageName = member.getImageName();
        if (oldImageName != null) {
            if (!fileStore.deleteFile(oldImageName, "profile/")) {
                log.error("기존 프로필 이미지 삭제 실패: {}", oldImageName);
            }
        }

        return memberRepository.selectProfileById(userNo);
    }
}
