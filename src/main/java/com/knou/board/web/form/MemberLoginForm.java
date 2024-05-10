package com.knou.board.web.form;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class MemberLoginForm {

    @NotBlank  // null, 공백문자 허용 X (String 타입 필드 검증)
    private String loginName;

    @NotBlank
    private String password;
}
