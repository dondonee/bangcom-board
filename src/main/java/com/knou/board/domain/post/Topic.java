package com.knou.board.domain.post;

import com.knou.board.domain.typehandler.CodeEnum;
import com.knou.board.domain.typehandler.CodeEnumTypeHandler;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.apache.ibatis.type.MappedTypes;

@Getter
@AllArgsConstructor
public enum Topic implements CodeEnum {

        NOTICE("NOTICE", "공지사항"),
        I_MENTOR("I-MENTOR", "멘토알림"),
        I_USER("I-USER", "정보공유"),
        C_CAMPUS("C-CAMPUS", "학교생활"),
        C_LIFE("C-LIFE", "사는얘기"),
        C_MARKET("C-MARKET", "벼룩시장"),
        Q_CAREER("Q-CAREER", "학사"),
        Q_STUDY("Q-STUDY", "학습"),
        Q_ETC("Q-ETC", "기타");

        private String code;
        private String description;

        @MappedTypes(Topic.class)
        public static class TypeHandler extends CodeEnumTypeHandler<Topic> {
            public TypeHandler() {
                super(Topic.class);
            }
        }
}
