package com.knou.board.exception;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum ErrorCode {
    // 검증
    INVALID_FORM(HttpStatus.BAD_REQUEST, "400001", null, null),
    UPLOAD_FILE_NOT_EXIST(HttpStatus.BAD_REQUEST, "400901", "파일 없음", "파일을 업로드 해주세요."),
    UPLOAD_FILE_SIZE_EXCEEDED(HttpStatus.BAD_REQUEST, "400902", "용량제한 초과", "업로드 용량제한 초과입니다."),
    UPLOAD_FILE_NOT_SUPPORTED(HttpStatus.BAD_REQUEST, "400903", "지원하지 않는 형식", "지원하지 않는 파일 형식입니다."),
    // 인증.인가
    NOT_WRITER(HttpStatus.FORBIDDEN, "403002", "권한 없음", "작성자가 아닙니다."),
    TEST_FORBIDDEN(HttpStatus.FORBIDDEN, "403001", "권한 없음", "테스트 계정은 변경 또는 삭제가 불가합니다."),
    NOT_MATCHED_PASSWORD(HttpStatus.UNAUTHORIZED, "401002", "비밀번호 불일치", "비밀번호가 올바르지 않습니다."),
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
