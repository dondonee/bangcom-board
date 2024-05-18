package com.knou.board.domain.post;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;

@Getter
@AllArgsConstructor
public enum TopicGroup {

    NOTICE("공지사항", new Topic[]{Topic.NOTICE}, "notice"),
    INFO("정보", new Topic[]{Topic.MENTOR, Topic.USER}, "info"),
    COMMUNITY("커뮤니티", new Topic[]{Topic.CAMPUS, Topic.LIFE, Topic.MARKET}, "community"),
    QUESTIONS("Q&A", new Topic[]{Topic.CAREER, Topic.STUDY, Topic.QNA_ETC}, "questions");

    private String description;
    private Topic[] topics;
    private String uri;


    public static TopicGroup findGroup(Topic topic) {
        return Arrays.stream(TopicGroup.values())
                .filter(topicGroup -> Arrays.asList(topicGroup.topics).contains(topic))
                .findAny()
                .orElseThrow(() -> new IllegalArgumentException("해당하는 TopicGroup이 없습니다."));
    }
}
