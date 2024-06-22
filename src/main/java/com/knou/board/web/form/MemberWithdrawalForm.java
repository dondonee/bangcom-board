package com.knou.board.web.form;

import com.knou.board.domain.member.MemberWithdrawal;
import lombok.Data;

@Data
public class MemberWithdrawalForm {

    private long userNo;
    private MemberWithdrawal.ReasonCode reasonCode;
    private String reasonText;

    public void setReasonCode(String reasonCode) {
        this.reasonCode = MemberWithdrawal.ReasonCode.valueOf(reasonCode);  // 일치하는 상수가 없으면 400 Bad Request
    }
}
