package com.knou.board.exception;

import lombok.Getter;

@Getter
public class ErrorResponse {

    private String code;
    private String title;
    private String message;


    public ErrorResponse(ErrorCode errorCode, String message) {
        this.code = errorCode.getCode();
        this.title = errorCode.getTitle();
        this.message = message;
    }
}
