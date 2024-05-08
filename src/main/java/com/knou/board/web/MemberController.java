package com.knou.board.web;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.member.MemberLogin;
import com.knou.board.service.MemberService;
import com.knou.board.web.form.MemberSignUpForm;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.naming.Binding;
import java.util.Arrays;
import java.util.List;

import static com.knou.board.domain.member.Member.*;

@Controller
@RequiredArgsConstructor
public class MemberController {

    @Autowired
    private final MemberService memberService;


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

        return "redirect:/community";  // [!] 추후 home으로 변경
    }

    @GetMapping("/signup/celebration")
    public String signUpCelebration(Model model) {

        // 회원가입 성공 후 리다이렉트된 경우
        if (model.containsAttribute("newMember")) {
            return "signUpCelebration";
        }

        // URL을 통한 접근의 경우
        return "redirect:/community";  // [!] 추후 home으로 변경
    }

    @GetMapping("/login")
    public String loginForm() {
        return "loginForm";
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