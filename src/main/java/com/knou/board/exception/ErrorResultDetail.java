package com.knou.board.exception;

import lombok.Data;

@Data
public class ErrorResultDetail extends ErrorResult {

    private String exDescription;

    public ErrorResultDetail(String code, String message, String description) {
        super(code, message);
        this.exDescription = description;
    }
}
