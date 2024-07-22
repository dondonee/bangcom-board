package com.knou.board.web.api.v1;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.exception.BusinessException;
import com.knou.board.exception.ErrorCode;
import com.knou.board.file.FileStore;
import com.knou.board.service.MemberService;
import com.knou.board.web.SessionConst;
import com.knou.board.web.argumentresolver.Login;
import com.knou.board.web.form.PasswordResetForm;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@RequestMapping("/api/v1")
@RestController
@RequiredArgsConstructor
public class MemberApiController {

    private final MemberService memberService;
    private final FileStore fileStore;

    @GetMapping("/me")
    public ResponseEntity<Member> getLoginMember(@Login Member loginMember) {

        Member member = memberService.findProfileByUserNo(loginMember.getUserNo());
        return ResponseEntity.ok(member);
    }

    @PutMapping("/me/image")
    public ResponseEntity<Map<String, String>> editProfileImage(@RequestParam(required = false) MultipartFile file, @Login Member loginMember, HttpSession session) throws IOException {

        // 업로드 파일 검증
        if (file.isEmpty()) {
            throw BusinessException.UPLOAD_FILE_NOT_EXIST;
        } else {
            // 파일 크기 검사
            long size = file.getSize() / 1024;  // KB
            if (size > 250) {  // 프로필 이미지 용량제한 초과
                throw new BusinessException(ErrorCode.UPLOAD_FILE_SIZE_EXCEEDED, "프로필 이미지 파일 용량은 최대 250KB 까지만 가능합니다.");
            }

            // 지원하는 포맷인지 검사 (JPEG, PNG)
            String fileExt = fileStore.extractExtension(file.getOriginalFilename());
            Set<String> accpetExts = Set.of("jpg", "jpeg", "png");
            if (!accpetExts.contains(fileExt) || !fileStore.isSupportedImageType(file)) {
                throw new BusinessException(ErrorCode.UPLOAD_FILE_NOT_SUPPORTED, "JPEG, PNG 형식의 이미지 파일만 업로드 가능합니다.");
            }
        }

        // 검증 통과 => 프로필 이미지 저장
        Member updatedMember = memberService.updateProfileImage(loginMember, file);
        session.setAttribute(SessionConst.LOGIN_MEMBER, updatedMember);  // loginMember 세션 업데이트

        Map<String, String> response = Map.of("imageName", updatedMember.getImageName());  // 네비게이션 바 이미지 업데이트용
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @DeleteMapping("/me/image")
    public ResponseEntity deleteProfileImage(@Login Member loginMember, HttpSession session) throws IOException {

        if (loginMember.getImageName() == null) {
            return new ResponseEntity<>(HttpStatus.OK);
        }

        // 기존 프로필 이미지 삭제
        Member updatedMember = memberService.initProfileImage(loginMember);
        session.setAttribute(SessionConst.LOGIN_MEMBER, updatedMember);  // loginMember 세션 업데이트

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("/me/password")
    public ResponseEntity resetPassword(@Validated PasswordResetForm form, BindingResult bindingResult, @Login Member loginMember) {

        // 테스트 계정 비밀번호 변경 제한 (userNo: 4, 5)
        Long userNo = loginMember.getUserNo();
        if (userNo == 4 || userNo == 5) {
            throw BusinessException.TEST_FORBIDDEN;
        }

        // 현재 비밀번호 검증
        String loginName = memberService.findLoginNameByUserNo(userNo);
        MemberLogin memberLogin = new MemberLogin();
        memberLogin.setUserNo(userNo);
        memberLogin.setLoginName(loginName);
        memberLogin.setPassword(form.getCurrentPassword());
        if (memberService.authenticate(memberLogin) == null) {  // 인증 불가
            throw new BusinessException(ErrorCode.INVALID_FORM, "현재 비밀번호가 일치하지 않습니다.");
        }

        // 변경 비밀번호 유효성 검사
        if (bindingResult.hasErrors()) {
            throw new BusinessException(ErrorCode.INVALID_FORM, bindingResult.getAllErrors().get(0).getDefaultMessage());
        }

        // 변경 비밀번호가 이전과 동일한지 체크
        if (form.getCurrentPassword().equals(form.getPassword())) {
            throw new BusinessException(ErrorCode.INVALID_FORM, "현재 비밀번호와 다르게 설정해주세요.");
        }

        // 비밀번호 확인이 일치한지 체크
        if (!form.getPassword().equals(form.getPasswordCheck())) {
            throw new BusinessException(ErrorCode.INVALID_FORM, "비밀번호 확인이 일치하지 않습니다.");
        }

        // 검증 통과 => 비밀번호 변경
        MemberLogin result = memberService.resetPassword(userNo, form.getPassword());

        // 비밀번호 변경 성공
        Map<String, String> resultMap = new HashMap<>();
        if (result != null) {
            resultMap.put("status", "success");
        }
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }
}
