package com.knou.board.web;

import com.knou.board.web.form.MemberSignUpForm;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.Arrays;
import java.util.List;

import static com.knou.board.domain.member.Member.*;

@Controller
public class MemberController {

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
    @GetMapping("/signUp")
    public String signUpForm(Model model) {
        return "signUpForm";
    }

    @PostMapping("/signUp")
    public String signUp(@Validated @ModelAttribute MemberSignUpForm form, BindingResult bindingResult) {

        // [!] 아이디, 닉네임 중복 검증 로직 필요

        // 비밀번호 확인 검증
        if (!form.getPassword().equals(form.getPasswordCheck())) {
            bindingResult.rejectValue("passwordCheck", "passwordCheck", "비밀번호가 일치하지 않습니다.");
        }

        if (bindingResult.hasErrors()) {
            return "signUpForm";
        }

        // [!] 검증 통과 => 회원가입 로직 필요

        return "redirect:/board";
    }
}