package com.knou.board.exception;

public class HasCommentException extends RuntimeException {

    public HasCommentException() {
        super();
    }

    public HasCommentException(String message) {
        super(message);
    }

    @Override
    public synchronized Throwable fillInStackTrace() {
        return this;  // off stack trace
    }
}
