package com.knou.board.domain.member;

import lombok.Data;

@Data
public class MemberLogin {
    private Long userNo;
    private String loginName;
    private String password;

    public MemberLogin() {
    }
}
