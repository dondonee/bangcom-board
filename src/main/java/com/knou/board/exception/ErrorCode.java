package com.knou.board.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum ErrorCode {

    NOT_WRITER("A1"),
    NOT_FOUND("N1"),
    HAS_COMMENT("C1"),
    NOT_VALID("V1");

    private final String code;
}
