package com.knou.board;

import com.knou.board.config.MyBatisConfig;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(MyBatisConfig.class)
@SpringBootTest
class BoardApplicationTests {

	@Test
	void contextLoads() {
	}

}
