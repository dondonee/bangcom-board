package com.knou.board.web.form;

import com.knou.board.domain.post.Topic;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

@Data
public class PostAddForm {

    @NotNull
    private Topic topic;

    @NotBlank  // null, 공백문자 허용 X (String 타입 필드 검증)
    @Length(max = 50, message = "제목은 50자 이하로 입력하세요.")
    private String title;

    @NotBlank
    @Length(max = 4000, message = "내용은 4000자 이하로 입력하세요.")
    private String content;


    public void setTopic(String topic) {
        this.topic = Topic.valueOf(topic);  // 일치하는 상수가 없으면 400 Bad Request
    }
}
