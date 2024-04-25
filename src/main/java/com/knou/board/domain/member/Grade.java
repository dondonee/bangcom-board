package com.knou.board.domain.member;

import com.knou.board.domain.typehandler.CodeEnum;
import com.knou.board.domain.typehandler.CodeEnumTypeHandler;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.apache.ibatis.type.MappedTypes;

@Getter
@AllArgsConstructor
public enum Grade implements CodeEnum {

    GRADE_1("1", "1학년"),
    GRADE_2("2", "2학년"),
    GRADE_3("3", "3학년"),
    GRADE_4("4", "4학년"),
    GRADUATE("graduate", "졸업생");

    private String code;
    private String description;

    @MappedTypes(Grade.class)
    public static class TypeHandler extends CodeEnumTypeHandler<Grade> {
        public TypeHandler() {
            super(Grade.class);
        }
    }
}
