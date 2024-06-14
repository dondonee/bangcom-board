package com.knou.board.domain.comment;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ParentCommentInfo {

    private long parentId;          // Comment id
    private long mentionedId;       // Member userNo
}
