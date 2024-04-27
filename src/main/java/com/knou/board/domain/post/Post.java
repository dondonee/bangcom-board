package com.knou.board.domain.post;

import com.knou.board.domain.member.Member;
import com.knou.board.domain.typehandler.CodeEnum;
import com.knou.board.domain.typehandler.CodeEnumTypeHandler;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.apache.ibatis.type.MappedTypes;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
public class Post {

    private Long id;
    private Enum<Topic> topic;
    private String title;
    private String content;
    private LocalDateTime createdDate;
    private LocalDateTime modifiedDate;
    private int viewCount;

    private Member author;


    @Getter
    @AllArgsConstructor
    public enum Topic implements CodeEnum {

        NOTICE("NOTICE", "공지사항"),
        I_MENTOR("I-MENTOR", "멘토알림"),
        I_USER("I-USER", "정보공유"),
        C_CAMPUS("C-STUDY", "학교생활"),
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
}
