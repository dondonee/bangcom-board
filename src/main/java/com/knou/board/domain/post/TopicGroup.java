package com.knou.board.domain.post;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;
import java.util.Optional;

@Getter
@AllArgsConstructor
public enum TopicGroup {

    NOTICE("공지사항", new Topic[]{Topic.NOTICE}),
    INFO("정보", new Topic[]{Topic.I_MENTOR, Topic.I_USER}),
    COMMUNITY("커뮤니티", new Topic[]{Topic.C_CAMPUS, Topic.C_LIFE, Topic.C_MARKET}),
    QUESTIONS("Q&A", new Topic[]{Topic.Q_CAREER, Topic.Q_STUDY, Topic.Q_ETC});

    private String description;
    private Topic[] topics;

    public static TopicGroup findGroup(Topic topic) {
        return Arrays.stream(TopicGroup.values())
                .filter(topicGroup -> Arrays.asList(topicGroup.topics).contains(topic))
                .findAny()
                .orElseThrow(() -> new IllegalArgumentException("해당하는 TopicGroup이 없습니다."));
    }
}
