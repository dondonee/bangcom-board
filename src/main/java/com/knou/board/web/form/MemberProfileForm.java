package com.knou.board.web.form;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

import static com.knou.board.domain.member.Member.Grade;
import static com.knou.board.domain.member.Member.Region;

@Data
public class MemberProfileForm {

    @NotBlank  // null, 공백문자 허용 X (String 타입 필드 검증)
    private String loginName;

    @NotBlank
    @Size(min = 1, max = 20, message = "닉네임은 20자 이하로 입력하세요.")
    @Pattern(regexp = "^[a-zA-Z가-힣0-9]*$", message = "닉네임은 한글(음절), 알파벳, 숫자만 가능합니다.")
    private String nickname;

    @NotNull  // Enum 필드 유효성 검사는 setter 바인딩 시 수행됨
    private Grade grade;

    @Size(max = 150, message = "한 줄 소개는 150자 이하로 작성해주세요.")
    private String bio;

    @NotNull
    private Region region;

    @NotNull
    private Boolean transferred;


    public void setGrade(Grade grade) {
        this.grade = grade;
    }

    public void setRegion(Region region) {
        this.region = region;
    }

    // Model 바인딩용 setter - 일치하는 상수가 없으면 400 Bad Request

    public void setGrade(String grade) {
        this.grade = Grade.valueOf(grade);
    }

    public void setRegion(String region) {
        this.region = Region.valueOf(region);
    }
}
