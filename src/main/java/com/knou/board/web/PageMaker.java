package com.knou.board.web;

import com.knou.board.domain.post.Criteria;
import lombok.Data;

@Data
public class PageMaker {

    private Criteria criteria;
    private long totalArticles;    // 전체 게시글 수
    private int startPageButton;   // 표시되는 첫 페이지 버튼 번호
    private int endPageButton;     // 표시되는 마지막 페이지 버튼 번호
    private boolean prevButton;      // 이전 페이지 버튼 존재 여부
    private boolean nextButton;      // 다음 페이지 버튼 존재 여부
    private int displayButtonSize = 5;   // 한 번에 표시되는 네비게이션 버튼 개수


    public void setTotalArticles(long totalArticle) {
        this.totalArticles = totalArticle;
        doPaging();
    }

    private void doPaging() {
        // 페이지 네비게이션
        endPageButton = (int) (Math.ceil((double) criteria.getPage() / displayButtonSize) * displayButtonSize);
        startPageButton = endPageButton - displayButtonSize + 1;
        if (startPageButton <= 0) {
            startPageButton = 1;
        }

        int boardEndPage = (int) Math.ceil((double) totalArticles / criteria.getPageSize());
        if (boardEndPage < endPageButton) {  // 마지막 페이지가 displayButtonSize 배수로 떨어지지 않는 경우
            endPageButton = boardEndPage;
        }

        // 페이지 네비게이션 이전 & 다음 버튼 여부
        prevButton = startPageButton == 1 ? false : true;
        nextButton = (endPageButton < boardEndPage) ? true : false;
    }
}
