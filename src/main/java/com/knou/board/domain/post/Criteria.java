package com.knou.board.domain.post;

import lombok.Data;

@Data
public class Criteria {

    private int page;  // 현재 페이지
    private int pageSize;  // 페이지당 게시글 수


    public Criteria() {
        this.page = 1;
        this.pageSize = 20;
    }

    public int getStartRow() {
        return (this.page - 1) * pageSize;
    }
}