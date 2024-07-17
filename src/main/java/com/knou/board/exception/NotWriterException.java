package com.knou.board.exception;

public class NotWriterException extends RuntimeException {

    public NotWriterException() {
        super();
    }

    public NotWriterException(String message) {
        super(message);
    }

    @Override
    public synchronized Throwable fillInStackTrace() {
        return this;  // off stack trace
    }
}
