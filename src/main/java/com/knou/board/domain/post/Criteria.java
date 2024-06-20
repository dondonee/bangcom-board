package com.knou.board.domain.post;

import com.knou.board.domain.typehandler.CodeEnum;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Optional;

public class Criteria {

    private int page;  // 현재 페이지
    private int pageSize;  // 페이지당 게시글 수
    private Sort sort;  // 정렬 기준


    public Criteria() {
        this.page = 1;
        this.pageSize = 20;
        this.sort = Sort.ID;  // default: 최신순
    }

    // getter
    public int getPage() {
        return page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public Sort getSort() {
        return sort;
    }

    public int getStartRow() {  // PostMapper.xml 에서 사용할 시작 게시글 계산 메서드
        return (this.page - 1) * pageSize;
    }

    // setter
    public void setPage(int page) {
        this.page = page;
    }

    public void setSort(String sort) {
        Optional<Sort> findSort = Optional.ofNullable(Sort.valueOf(sort));
        if (findSort.isPresent()) {
            this.sort = findSort.get();
            return;
        }

        this.sort = Sort.ID;  // default: 최신순
    }


    @Getter
    @AllArgsConstructor
    public enum Sort implements CodeEnum {

        ID("post_id", "최신순"),
        VIEW_COUNT("view_count", "조회순");

        private String code;
        private String description;
    }
}