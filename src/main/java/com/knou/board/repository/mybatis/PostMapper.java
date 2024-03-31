package com.knou.board.repository.mybatis;

import com.knou.board.domain.Post;
import org.apache.ibatis.annotations.*;

@Mapper
public interface PostMapper {

    void save(Post post);
    Post findById(Long id);
}
