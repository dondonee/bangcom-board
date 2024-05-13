package com.knou.board.config;

import com.knou.board.web.interceptor.LoginCheckInterceptor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Slf4j
@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final String uploadImagesPath;

    public WebConfig(@Value("${custom.path.upload.images}") String uploadImagesPath) {
        this.uploadImagesPath = uploadImagesPath;  // 보안 문제로 인해 application-sensitive.yml에 설정한 경로를 가져옴
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginCheckInterceptor())
                .order(1)
                .addPathPatterns("/**")
                .excludePathPatterns("/", "/questions", "/info", "/community", "/notice", "/signup/**", "/login",
                        "/logout", "/resources/css/**", "/**/scss/*.scss", "/images/**", "/*.ico", "/error");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        log.info("uploadImagesPath: " + uploadImagesPath);
        registry.addResourceHandler("/images/**")
                .addResourceLocations(uploadImagesPath);
    }
}