package com.knou.board.web.form;

import jakarta.validation.constraints.*;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import static com.knou.board.domain.member.Member.*;

@Data
public class MemberSignUpForm {

    @NotBlank  // null, 공백문자 허용 X (String 타입 필드 검증)
    @Length(min = 4, message = "아이디는 최소 4자 이상 입력하세요.")
    @Length(max = 15, message = "아이디는 15자 이하로 입력하세요.")
    @Pattern(regexp = "^[a-z0-9]*$", message = "아이디는 영문 소문자와 숫자만 가능합니다.")
    private String loginName;

    @NotBlank
    @Length(min = 6, message = "비밀번호는 최소 6자 이상 입력하세요.")
    @Length(max = 25, message = "비밀번호는 25자 이하로 입력하세요.")
    @Pattern(regexp = "^[a-zA-Z0-9!@#$%^&*]*$", message = "비밀번호는 알파벳, 숫자, 특수문자(!@#$%^&*)만 가능합니다.")
    @Pattern(regexp = "^(?=.*[a-zA-Z0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]*$", message = "비밀번호는 알파벳, 숫자, 특수문자(!@#$%^&*)가 각 1개 이상 포함되어야 합니다.")
    private String password;

    @NotBlank  // 비밀번호 확인이 유효하지 않으면 컨트롤러에서 BindingResult에 에러 추가
    private String passwordCheck;

    @NotBlank
    @Length(min = 1, max = 20, message = "닉네임은 20자 이하로 입력하세요.")
    @Pattern(regexp = "^[a-zA-Z가-힣0-9]*$", message = "닉네임은 한글(음절), 알파벳, 숫자만 가능합니다.")
    private String nickname;

    @NotNull(message = "학년을 선택하세요.")  // Enum 필드 유효성 검사는 setter 바인딩 시 수행됨
    private Grade grade;

    @NotNull(message = "지역을 선택하세요.")
    private Region region;

    @NotNull(message = "편입여부를 선택하세요.")
    private Boolean transferred;


    public void setGrade(String grade) {
        this.grade = Grade.valueOf(grade);  // 일치하는 상수가 없으면 400 Bad Request
    }

    public void setRegion(String region) {
        this.region = Region.valueOf(region);
    }
}
