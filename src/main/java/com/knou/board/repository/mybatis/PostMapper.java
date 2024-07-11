package com.knou.board.repository.mybatis;

import com.knou.board.domain.post.Criteria;
import com.knou.board.domain.post.Post;
import com.knou.board.domain.post.Topic;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface PostMapper {

    void insert(Post post);
    Post selectById(Long id);
    List<Post> selectAll();
    List<Post> selectByUserNo(@Param("userNo") Long userNo,@Param("criteria") Criteria criteria);
    List<Post> selectByTopics(@Param("topics") Topic[] topics, @Param("criteria") Criteria criteria);
    long countTotalSelectedByUserNo(Long userNo);
    long countTotalSelectedByTopics(Topic[] topics);
    void update(Post post);
    void updateViewCount(Long id);
    void delete(Long id);
}
