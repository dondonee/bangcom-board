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

}
