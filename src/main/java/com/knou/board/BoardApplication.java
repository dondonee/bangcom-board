package com.knou.board;

import com.knou.board.config.MyBatisConfig;
import com.knou.board.config.WebConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

@Import({MyBatisConfig.class, WebConfig.class})
@SpringBootApplication(scanBasePackages = {"com.knou.board.web", "com.knou.board.service"})
public class BoardApplication {

	public static void main(String[] args) {
		SpringApplication.run(BoardApplication.class, args);
	}

}
