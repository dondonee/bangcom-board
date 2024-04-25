package com.knou.board.domain.member;

import com.knou.board.domain.typehandler.CodeEnum;
import com.knou.board.domain.typehandler.CodeEnumTypeHandler;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.apache.ibatis.type.MappedTypes;

@Getter
@AllArgsConstructor
public enum Authority implements CodeEnum {

    ADMIN("A", "관리자"),
    MENTOR("M", "멘토"),
    USER("U", "사용자");

    private String code;
    private String description;

    @MappedTypes(Authority.class)
    public static class TypeHandler extends CodeEnumTypeHandler<Authority> {
        public TypeHandler() {
            super(Authority.class);
        }
    }
}
