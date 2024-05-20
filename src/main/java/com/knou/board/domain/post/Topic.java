package com.knou.board.domain.post;

import com.knou.board.domain.typehandler.CodeEnum;
import com.knou.board.domain.typehandler.CodeEnumTypeHandler;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.apache.ibatis.type.MappedTypes;

import java.util.Arrays;

@Getter
@AllArgsConstructor
public enum Topic implements CodeEnum {

    NOTICE("NOTICE", "공지사항", "notice"),
    MENTOR("I-MENTOR", "멘토알림", "mentor"),
    USER("I-USER", "정보공유", "user"),
    CAMPUS("C-CAMPUS", "학교생활", "campus"),
    LIFE("C-LIFE", "사는얘기", "life"),
    MARKET("C-MARKET", "벼룩시장", "market"),
    CAREER("Q-CAREER", "학사", "career"),
    STUDY("Q-STUDY", "학습", "study"),
    QNA_ETC("Q-ETC", "기타", "qna-etc");

    private String code;
    private String description;
    private String uri;


    @MappedTypes(Topic.class)
    public static class TypeHandler extends CodeEnumTypeHandler<Topic> {
        public TypeHandler() {
            super(Topic.class);
        }
    }

    public static Topic uriValueOf(String uri) {
        return Arrays.stream(Topic.values())
                .filter(topic -> topic.getUri().equals(uri.toLowerCase()))
                .findAny()
                .orElseThrow(() -> new IllegalArgumentException("해당하는 Topic이 없습니다."));
    }
}
