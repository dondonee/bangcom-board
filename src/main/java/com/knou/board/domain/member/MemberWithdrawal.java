package com.knou.board.domain.member;

import com.knou.board.domain.typehandler.CodeEnum;
import com.knou.board.domain.typehandler.CodeEnumTypeHandler;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import org.apache.ibatis.type.MappedTypes;

import java.time.LocalDateTime;

@Data
public class MemberWithdrawal {

    private Long userNo;
    private StatusCode statusCode;
    private ReasonCode reasonCode;
    private String reasonText;
    private LocalDateTime withdrawalDate;


    @Getter
    @AllArgsConstructor
    public enum StatusCode implements CodeEnum {

        LONG_TERM_INACTIVE("1", "장기 미사용자(1년)"),
        VOLUNTARY_WITHDRAWAL("2", "직접 탈퇴"),
        PERMANENTLY_BANNED("3", "부정 사용자"),
        ETC("9", "기타");

        private String code;
        private String description;

        @MappedTypes(MemberWithdrawal.StatusCode.class)
        public static class TypeHandler extends CodeEnumTypeHandler<MemberWithdrawal.StatusCode> {
            public TypeHandler() {
                super(MemberWithdrawal.StatusCode.class);
            }
        }
    }

    @Getter
    @AllArgsConstructor
    public enum ReasonCode implements CodeEnum {

        LONG_TERM_INACTIVE("1", "장기 미사용자(1년)"),
        NO_LONGER_RELEVANT("2", "졸업/휴학/편입 등"),
        USING_OTHER_SERVICE("3", "다른 서비스 사용"),
        LOW_FREQUENCY_USE("4", "접속 빈도 낮음"),
        ETC("9", "기타");

        private String code;
        private String description;

        @MappedTypes(MemberWithdrawal.ReasonCode.class)
        public static class TypeHandler extends CodeEnumTypeHandler<MemberWithdrawal.ReasonCode> {
            public TypeHandler() {
                super(MemberWithdrawal.ReasonCode.class);
            }
        }
    }
}
