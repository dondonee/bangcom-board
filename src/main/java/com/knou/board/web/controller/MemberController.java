package com.knou.board.web.controller;

import com.knou.board.domain.comment.CommentHistoryDto;
import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.domain.member.MemberWithdrawal;
import com.knou.board.domain.post.Criteria;
import com.knou.board.domain.post.Post;
import com.knou.board.exception.ErrorResult;
import com.knou.board.exception.ErrorResultDetail;
import com.knou.board.file.FileStore;
import com.knou.board.service.CommentService;
import com.knou.board.service.MemberService;
import com.knou.board.service.PostService;
import com.knou.board.web.PageMaker;
import com.knou.board.web.SessionConst;
import com.knou.board.web.argumentresolver.Login;
import com.knou.board.web.form.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

import static com.knou.board.domain.member.Member.*;
import static org.springframework.http.HttpStatus.BAD_REQUEST;

@Slf4j
@Controller
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final PostService postService;
    private final CommentService commentService;
    private final FileStore fileStore;


    // Model 초기화

    @ModelAttribute("grades")
    public List<Grade> grades() {
        return Arrays.asList(Grade.values());
    }

    @ModelAttribute("regions")
    public List<Region> regions() {
        return Arrays.asList(Region.values());
    }


    // 컨트롤러 메서드

    @GetMapping("/signup")
    public String signUpForm() {
        return "signUpForm";
    }

    @PostMapping("/signup")
    public String signUp(@Validated @ModelAttribute MemberSignUpForm form, BindingResult bindingResult, Model model, RedirectAttributes redirectAttributes) {

        // 아이디 중복 검증 (아이디는 가입 후 수정 불가하므로 메서드 분리 X)
        String loginName = form.getLoginName();
        if (memberService.isDuplicatedLoginName(loginName)) {
            bindingResult.rejectValue("loginName", "duplicated", "이미 사용중인 아이디입니다.");
        }
        // 닉네임 중복 검증
        validateUniqueNickname(form.getNickname(), bindingResult);
        // 비밀번호 확인 검증
        validatePasswordCheck(form.getPassword(), form.getPasswordCheck(), bindingResult);

        // 검증 실패 => 회원가입 폼으로 이동
        if (bindingResult.hasErrors()) {
            form.setPassword("");  // 비밀번호는 초기화
            model.addAttribute("form", form);  // 사용자가 입력했던 값 다시 전달
            return "signUpForm";
        }

        // 검증 통과 => 회원가입 로직
        MemberLogin memberLogin = new MemberLogin();
        memberLogin.setLoginName(form.getLoginName());
        memberLogin.setPassword(form.getPassword());

        Member member = new Member();
        member.setNickname(form.getNickname());
        member.setGrade(form.getGrade());
        member.setRegion(form.getRegion());
        member.setTransferred(form.getTransferred());

        Member newMember = memberService.createMember(memberLogin, member);

        // 회원가입 로직 성공
        if (newMember != null) {
            redirectAttributes.addFlashAttribute("newMember", newMember);
            return "redirect:/signup/celebration";
        }

        return "redirect:/login";
    }

    @GetMapping("/signup/celebration")
    public String signUpCelebration(Model model) {

        // 회원가입 성공 후 리다이렉트된 경우
        if (model.containsAttribute("newMember")) {
            return "signUpCelebration";
        }

        // URL을 통한 비정상 접근의 경우
        return "redirect:/";
    }

    @GetMapping("/login")
    public String loginForm(HttpServletRequest request, HttpSession session) {
        // 로그인 이전 페이지 저장
        String referer = request.getHeader("Referer");
        session.setAttribute(SessionConst.PREV_URL, referer);

        return "loginForm";
    }

    @PostMapping("/login")
    public String login(@Validated @ModelAttribute MemberLoginForm form, BindingResult bindingResult, Model model, HttpSession session, @SessionAttribute(name = SessionConst.PREV_URL, required = false) String prevUrl) {

        // @NotBlank 필드 검증
        if (bindingResult.hasErrors()) {
            bindingResult.reject("blankValue", "아이디와 비밀번호를 모두 입력해 주세요.");

            // 입력한 아이디가 공백이 아닌 경우 -> 리다이렉트 후 로그인 폼에 표시
            if (!form.getLoginName().isBlank()) {
                form.setPassword("");  // 비밀번호는 초기화
                model.addAttribute("form", form);
            }

            return "loginForm";
        }

        // [!] 계정찾기 기능 도입 전 까지는 로그인 오류 상세하게(아이디 불일치/비밀번호 불일치) 제공
        // 아이디와 일치하는 회원 조회
        MemberLogin findMemberLogin = memberService.findMemberByLoginName(form.getLoginName());
        if (findMemberLogin == null) {
            bindingResult.reject("invalidLoginName", "아이디와 일치하는 회원이 없습니다.");
            form.setPassword("");  // 비밀번호는 초기화
            model.addAttribute("form", form);
            return "loginForm";
        }

        // 로그인 시도 (userNo + password)
        findMemberLogin.setPassword(form.getPassword());
        Member member = memberService.authenticate(findMemberLogin);

        // 로그인 실패
        if (member == null) {
            bindingResult.reject("invalidPassword", "비밀번호가 일치하지 않습니다.");
            form.setPassword("");  // 비밀번호는 초기화
            model.addAttribute("form", form);
            return "loginForm";
        }

        // 로그인 성공
        session.setAttribute(SessionConst.LOGIN_MEMBER, member);

        if (prevUrl != null) {  // 세션에 로그인 이전 페이지가 존재하는 경우
            session.removeAttribute(SessionConst.PREV_URL);  // 불필요한 세션 속성 제거
            return "redirect:" + prevUrl;
        }

        return "redirect:/community";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping(value = {"/members/{userNo}", "/members/{userNo}/articles"})
    public String getMemberDetail(@PathVariable long userNo, Criteria criteria, Model model) {
        // 회원 조회
        Member member = memberService.findProfileByUserNo(userNo);
        if (member == null) {
            return "redirect:/";
        }

        List<Post> posts = postService.findListByMember(userNo, criteria);

        PageMaker pageMaker = new PageMaker();
        pageMaker.setCriteria(criteria);
        pageMaker.setTotalArticles(postService.getTotalCountByMember(userNo));

        model.addAttribute("pageMaker", pageMaker);
        model.addAttribute("member", member);
        model.addAttribute("posts", posts);
        return "memberDetail";
    }

    @GetMapping(value = {"/members/{userNo}/comments"})
    public String getMemberComments(@PathVariable long userNo, Criteria criteria, Model model) {
        // 회원 조회
        Member member = memberService.findProfileByUserNo(userNo);
        if (member == null) {
            return "redirect:/";
        }

        // 작성 댓글 조회
        List<CommentHistoryDto> commentHistory = commentService.findListByMember(userNo, criteria);

        PageMaker pageMaker = new PageMaker();
        pageMaker.setCriteria(criteria);
        pageMaker.setTotalArticles(commentService.getTotalCountByMember(userNo));

        model.addAttribute("pageMaker", pageMaker);
        model.addAttribute("member", member);
        model.addAttribute("commentHistory", commentHistory);
        return "memberDetailComments";
    }

    @GetMapping(value = {"/settings", "/settings/profile"})
    public String profileSettingForm(@Login Member loginMember, Model model) {

        String loginName = memberService.findLoginNameByUserNo(loginMember.getUserNo());
        Member member = memberService.findProfileByUserNo(loginMember.getUserNo());

        MemberProfileForm form = new MemberProfileForm();
        form.setLoginName(loginName);
        form.setNickname(member.getNickname());
        form.setBio(member.getBio());
        form.setGrade(member.getGrade());
        form.setRegion(member.getRegion());
        form.setTransferred(member.getTransferred());

        model.addAttribute("form", form);

        return "memberProfileForm";
    }

    @PostMapping("/settings/profile")
    public String editProfile(@Validated @ModelAttribute MemberProfileForm form, BindingResult bindingResult, @Login Member loginMember, Model model, HttpSession session, RedirectAttributes redirectAttributes) {

        // 닉네임 중복 검증
        if (!form.getNickname().equals(loginMember.getNickname())) {  // 닉네임을 변경하려는 경우
            validateUniqueNickname(form.getNickname(), bindingResult);
        }

        // 검증 실패 => 프로필 수정 폼으로 이동
        if (bindingResult.hasErrors()) {
            model.addAttribute("form", form);  // 사용자가 입력했던 값 다시 전달
            return "memberProfileForm";
        }

        // 프로필 수정 로직
        Member member = new Member();
        member.setUserNo(loginMember.getUserNo());
        member.setNickname(form.getNickname());
        member.setBio(form.getBio().trim());  // 앞뒤 공백 제거
        member.setGrade(form.getGrade());
        member.setRegion(form.getRegion());
        member.setTransferred(form.getTransferred());
        member.setUpdatedDate(LocalDateTime.now());  // 수정일 업데이트

        Member updatedMember = memberService.updateProfile(member);
        session.setAttribute(SessionConst.LOGIN_MEMBER, updatedMember); // loginMember 세션 업데이트

        redirectAttributes.addFlashAttribute("updateSuccess", "true");
        return "redirect:/settings/profile";  // 수정 완료 후 프로필 수정 폼으로 리다이렉트
    }

    @PostMapping("/settings/profile/image")
    public ResponseEntity editProfileImage(@RequestParam(required = false) MultipartFile file, @Login Member loginMember, HttpSession session) throws IOException {

        // 업로드 파일 검증
        if (file.isEmpty()) {
            ErrorResultDetail errorResultDetail = new ErrorResultDetail("BAD_REQUEST", "파일 없음", "파일을 업로드 해주세요.");
            return new ResponseEntity<>(errorResultDetail, BAD_REQUEST);
        } else {
            // 파일 크기 검사
            long size = file.getSize() / 1024;  // KB
            if (size > 250) {  // 프로필 이미지 용량제한 초과
                ErrorResultDetail errorResultDetail = new ErrorResultDetail("BAD_REQUEST", "프로필 이미지 용량제한 초과", "프로필 이미지 파일 용량은 최대 250KB 까지만 가능합니다.");
                return new ResponseEntity<>(errorResultDetail, BAD_REQUEST);
            }

            // 지원하는 포맷인지 검사 (JPEG, PNG)
            String fileExt = fileStore.extractExtension(file.getOriginalFilename());
            Set<String> accpetExts = Set.of("jpg", "jpeg", "png");
            if (!accpetExts.contains(fileExt) || !fileStore.isSupportedImageType(file)) {
                ErrorResultDetail errorResultDetail = new ErrorResultDetail("BAD_REQUEST", "지원하지 않는 이미지 형식", "JPEG, PNG 형식의 이미지 파일만 업로드 가능합니다.");
                return new ResponseEntity<>(errorResultDetail, BAD_REQUEST);
            }
        }

        // 검증 통과 => 프로필 이미지 저장
        Member updatedMember = memberService.updateProfileImage(loginMember, file);
        session.setAttribute(SessionConst.LOGIN_MEMBER, updatedMember);  // loginMember 세션 업데이트

        Map<String, String> response = Map.of("imageName", updatedMember.getImageName());  // 네비게이션 바 이미지 업데이트용
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/settings/account")
    public String accountSettingForm(@Login Member loginMember) {
        return "memberAccountForm";
    }

    @DeleteMapping("/settings/profile/image")
    public ResponseEntity deleteProfileImage(@Login Member loginMember, HttpSession session) throws IOException {

        if (loginMember.getImageName() == null) {
            return new ResponseEntity<>(HttpStatus.OK);
        }

        // 기존 프로필 이미지 삭제
        Member updatedMember = memberService.initProfileImage(loginMember);
        session.setAttribute(SessionConst.LOGIN_MEMBER, updatedMember);  // loginMember 세션 업데이트

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/withdrawal")
    public String withdrawalConfirm(@Login Member loginMember) {
        return "withdrawalConfirm";
    }

    @PostMapping("/withdrawal")
    public String withdraw(MemberWithdrawalForm form, @Login Member loginMember, HttpSession session, RedirectAttributes redirectAttributes) throws IOException {
        // 회원 조회
        Member member = memberService.findProfileByUserNo(form.getUserNo());
        if (member == null || form.getUserNo() != loginMember.getUserNo()) {
            throw new IllegalStateException("올바른 요청이 아닙니다.");
        }

        // 탈퇴 요청 유효성 검사
        MemberWithdrawal.ReasonCode reasonCode = form.getReasonCode();
        List<MemberWithdrawal.ReasonCode> availableCodes = Arrays.asList(MemberWithdrawal.ReasonCode.NO_LONGER_RELEVANT, MemberWithdrawal.ReasonCode.USING_OTHER_SERVICE, MemberWithdrawal.ReasonCode.LOW_FREQUENCY_USE, MemberWithdrawal.ReasonCode.ETC);
        if (reasonCode == null || !availableCodes.contains(reasonCode)) {
            throw new IllegalStateException("올바른 요청이 아닙니다.");
        }
        String reasonText = form.getReasonText();
        if (reasonCode == MemberWithdrawal.ReasonCode.ETC && reasonText.isBlank()) {
            throw new IllegalStateException("올바른 요청이 아닙니다.");
        }

        // 회원 탈퇴
        MemberWithdrawal mw = new MemberWithdrawal();
        mw.setUserNo(loginMember.getUserNo());
        mw.setStatusCode(MemberWithdrawal.StatusCode.VOLUNTARY_WITHDRAWAL);
        mw.setReasonCode(form.getReasonCode());
        if (reasonCode == MemberWithdrawal.ReasonCode.ETC) {  // 기타 사유인 경우
            mw.setReasonText(reasonText);
        }
        memberService.withdrawMember(mw);
        session.invalidate(); // 로그아웃

        redirectAttributes.addFlashAttribute("status", "success");
        return "redirect:/withdrawal-complete";
    }

    @GetMapping("/withdrawal-complete")
    public String withdrawalComplete(Model model) {
        // 탈퇴 후 리다이렉트된 경우
        if (model.containsAttribute("status")) {
            return "withdrawalComplete";
        }

        // URL을 통한 비정상 접근의 경우
        return "redirect:/";
    }

    @PostMapping("/settings/account/password-reset")
    public ResponseEntity resetPassword(@Validated PasswordResetForm form, BindingResult bindingResult, @Login Member loginMember) {

        // 현재 비밀번호 검증
        Long userNo = loginMember.getUserNo();
        String loginName = memberService.findLoginNameByUserNo(userNo);

        MemberLogin memberLogin = new MemberLogin();
        memberLogin.setUserNo(userNo);
        memberLogin.setLoginName(loginName);
        memberLogin.setPassword(form.getCurrentPassword());
        if (memberService.authenticate(memberLogin) == null) {  // 인증 불가
            ErrorResult errorResult = new ErrorResultDetail("BAD_REQUEST", "비밀번호 불일치", "현재 비밀번호가 일치하지 않습니다.");
            return new ResponseEntity<>(errorResult, BAD_REQUEST);
        }

        // 변경 비밀번호 유효성 검사
        if (bindingResult.hasErrors()) {
            FieldError err = bindingResult.getFieldError("password");
            if (err != null) {
                ErrorResult errorResult = new ErrorResultDetail("BAD_REQUEST", "유효하지 않은 비밀번호 형식", err.getDefaultMessage());
                return new ResponseEntity<>(errorResult, BAD_REQUEST);
            }
        }

        // 변경 비밀번호가 이전과 동일한지 체크
        if (form.getCurrentPassword().equals(form.getPassword())) {
            ErrorResult errorResult = new ErrorResultDetail("BAD_REQUEST", "비밀번호 동일", "현재 비밀번호와 다르게 설정해주세요.");
            return new ResponseEntity<>(errorResult, BAD_REQUEST);
        }

        // 비밀번호 확인이 일치한지 체크
        validatePasswordCheck(form.getPassword(), form.getPasswordCheck(), bindingResult);
        if (bindingResult.hasErrors()) {
            FieldError fieldError = bindingResult.getFieldError("passwordCheck");
            ErrorResult errorResult = new ErrorResultDetail("BAD_REQUEST", "비밀번호 불일치", fieldError.getDefaultMessage());
            return new ResponseEntity<>(errorResult, BAD_REQUEST);
        }

        // 검증 통과 => 비밀번호 변경
        MemberLogin resetML = new MemberLogin();
        resetML.setUserNo(userNo);
        resetML.setPassword(form.getPassword());
        MemberLogin resultML = memberService.resetPassword(resetML);

        // 비밀번호 변경 성공
        Map<String, String> resultMap = new HashMap<>();
        if (resultML != null) {
            resultMap.put("status", "success");
        }
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }


    // private 메서드

    private void validateUniqueNickname(String nickname, BindingResult bindingResult) {

        if (memberService.isDuplicatedNickname(nickname)) {
            bindingResult.rejectValue("nickname", "duplicated", "이미 사용중인 닉네임입니다.");
        }
    }

    private void validatePasswordCheck(String password, String passwordCheck, BindingResult bindingResult) {

        if (!passwordCheck.equals(password)) {
            bindingResult.rejectValue("passwordCheck", "passwordCheck", "비밀번호가 일치하지 않습니다.");
        }
    }
}