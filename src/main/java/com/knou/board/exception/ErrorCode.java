package com.knou.board.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum ErrorCode {
    // 검증
    INVALID_INPUT(HttpStatus.BAD_REQUEST, "400001", null, null),
    // 인증.인가
    NOT_WRITER(HttpStatus.FORBIDDEN, "403002", "권한 없음", "작성자가 아닙니다."),
    // 리소스
    COMMENT_NOT_EXIST(HttpStatus.NOT_FOUND, "404003", "댓글 없음", "댓글이 존재하지 않습니다."),
    POST_NOT_EXIST(HttpStatus.NOT_FOUND, "404002", "게시글 없음", "게시글이 존재하지 않습니다."),
    // 기타
    COMMENT_HAS_CHILD(HttpStatus.BAD_REQUEST, "400300", "댓글 삭제 오류", "댓글이 존재하는 경우 삭제할 수 없습니다.");

    private final HttpStatus status;
    private final String code;
    private final String title;
    private final String message;
}
