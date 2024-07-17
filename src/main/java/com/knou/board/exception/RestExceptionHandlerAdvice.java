package com.knou.board.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@Slf4j
@RestControllerAdvice
public class RestExceptionHandlerAdvice {

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(MethodArgumentNotValidException.class)  // @Validated 바인딩 오류
    public ErrorResponse handleNotValidException(MethodArgumentNotValidException e) {
        return new ErrorResponse(ErrorCode.NOT_VALID, e.getAllErrors().get(0).getDefaultMessage());
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(NotWriterException.class)
    public ErrorResponse handleNotWriterException(NotWriterException e) {
        return new ErrorResponse(ErrorCode.NOT_WRITER, e.getMessage());
    }

    @ResponseStatus(HttpStatus.NOT_FOUND)
    @ExceptionHandler(NotFoundException.class)
    public ErrorResponse handleNotFoundException(NotFoundException e) {
        return new ErrorResponse(ErrorCode.NOT_FOUND, e.getMessage());
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(HasCommentException.class)
    public ErrorResponse handleHasCommentException(HasCommentException e) {
        return new ErrorResponse(ErrorCode.HAS_COMMENT, e.getMessage());
    }
}
