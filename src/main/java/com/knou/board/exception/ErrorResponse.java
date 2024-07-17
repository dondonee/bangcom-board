package com.knou.board.exception;

import lombok.Getter;

@Getter
public class ErrorResponse {

    private String code;
    private String message;


    public ErrorResponse(ErrorCode errorCode, String message) {
        this.code = errorCode.getCode();
        this.message = message;
    }
}
