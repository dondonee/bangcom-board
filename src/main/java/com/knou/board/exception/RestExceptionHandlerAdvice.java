package com.knou.board.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class RestExceptionHandlerAdvice {

    @ExceptionHandler(MethodArgumentNotValidException.class)  // @Validated 바인딩 오류
    public ResponseEntity<ErrorResponse> handleValidationException(final MethodArgumentNotValidException e) {
        return new ResponseEntity<>(new ErrorResponse(ErrorCode.INVALID_FORM, e.getAllErrors().get(0).getDefaultMessage()), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ErrorResponse> handleBusinessException(final BusinessException e) {
        return e.makeResponseEntity();
    }
}
