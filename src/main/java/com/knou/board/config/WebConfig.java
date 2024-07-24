package com.knou.board.config;

import com.knou.board.web.argumentresolver.LoginMemberArgumentResolver;
import com.knou.board.web.interceptor.LoginCheckInterceptor;
import com.knou.board.web.interceptor.TesterLockInterceptor;
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
        // 미인증 사용자 접근 제한
        registry.addInterceptor(new LoginCheckInterceptor())
                .order(1)
                .addPathPatterns("/*/new", "/*/*/edit", "/*/*/delete", "/settings/{*path}", "/api/**");

        // 테스터 기능 제한 - 비밀번호 변경, 회원탈퇴
        registry.addInterceptor(new TesterLockInterceptor())
                .order(2)
                .addPathPatterns("/api/v1/me/password", "/api/v1/me/withdrawal");
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