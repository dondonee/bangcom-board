package com.knou.board.exception;

import org.springframework.http.ResponseEntity;

public class BusinessException extends RuntimeException {

    public static final BusinessException UPLOAD_FILE_NOT_EXIST = new BusinessException(ErrorCode.UPLOAD_FILE_NOT_EXIST);
    public static final BusinessException NOT_WRITER = new BusinessException(ErrorCode.NOT_WRITER);
    public static final BusinessException TEST_FORBIDDEN = new BusinessException(ErrorCode.TEST_FORBIDDEN);
    public static final BusinessException COMMENT_NOT_EXIST = new BusinessException(ErrorCode.COMMENT_NOT_EXIST);
    public static final BusinessException POST_NOT_EXIST = new BusinessException(ErrorCode.POST_NOT_EXIST);
    public static final BusinessException COMMENT_HAS_CHILD = new BusinessException(ErrorCode.COMMENT_HAS_CHILD);


    private final ErrorCode code;

    public BusinessException(ErrorCode code) {
        super();
        this.code = code;
    }

    public BusinessException(ErrorCode code, String message) {
        super(message);
        this.code = code;
    }

    @Override
    public synchronized Throwable fillInStackTrace() {
        return this; // stack trace 사용하지 않음
    }

    public ResponseEntity<ErrorResponse> makeResponseEntity() {
        // BusinessException 생성시 지정한 message -> 없으면 ErrorCode의 message 사용
        String message = getMessage();
        if (getMessage() == null) {
            message = code.getMessage();
        }
        return ResponseEntity.status(code.getStatus()).body(new ErrorResponse(code, message));
    }
}
