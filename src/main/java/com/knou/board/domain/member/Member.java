package com.knou.board.domain.member;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Member {
    private Long profileId;
    private Long userNo;
    private String nickname;
    private String imageUrl;
    private Enum<Grade> grade;
    private Boolean transferred;
    private Enum<Region> region;
    private Enum<Authority> authority;
    private LocalDateTime joinedDate;
    private LocalDateTime updatedDate;

    public Member() {
    }
}
