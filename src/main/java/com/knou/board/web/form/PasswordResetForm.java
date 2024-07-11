package com.knou.board.web.form;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;


@Data
public class PasswordResetForm {

    @NotBlank
    private String currentPassword;

    @NotBlank
    @Size(min = 6, message = "비밀번호는 최소 6자 이상 입력하세요.")
    @Size(max = 25, message = "비밀번호는 25자 이하로 입력하세요.")
    @Pattern(regexp = "^[a-zA-Z0-9!@#$%^&*]*$", message = "비밀번호는 알파벳, 숫자, 특수문자(!@#$%^&*)만 가능합니다.")
    @Pattern(regexp = "^(?=.*[a-zA-Z0-9])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]*$", message = "비밀번호는 알파벳, 숫자, 특수문자(!@#$%^&*)가 각 1개 이상 포함되어야 합니다.")
    private String password;

    @NotBlank  // 비밀번호 확인이 유효하지 않으면 컨트롤러에서 BindingResult에 에러 추가
    private String passwordCheck;
}
