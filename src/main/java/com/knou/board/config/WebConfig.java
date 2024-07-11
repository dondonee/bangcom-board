package com.knou.board.config;

import com.knou.board.web.argumentresolver.LoginMemberArgumentResolver;
import com.knou.board.web.interceptor.LoginCheckInterceptor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.List;

@Slf4j
@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final String uploadImagesPath;

    // application-sensitive.yml에 설정한 경로를 가져옴 (이미지 업로드 경로)
    public WebConfig(@Value("${custom.path.image}") String uploadImagesPath) {
        this.uploadImagesPath = uploadImagesPath;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginCheckInterceptor())
                .order(1)
                .addPathPatterns("/*/new", "/*/*/edit", "/*/*/delete", "/settings/{*path}");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        log.info("uploadImagesPath: " + uploadImagesPath);
        registry.addResourceHandler("/images/**")
                .addResourceLocations(uploadImagesPath);
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(new LoginMemberArgumentResolver());
    }
}