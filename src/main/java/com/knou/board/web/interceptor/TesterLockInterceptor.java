package com.knou.board.web.interceptor;

import com.knou.board.domain.member.Member;
import com.knou.board.exception.BusinessException;
import com.knou.board.web.SessionConst;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
public class TesterLockInterceptor implements HandlerInterceptor {

    public static final Map<String, List<String>> targetMap = new HashMap<>();

    static {
        targetMap.put("PUT", List.of("/me/password"));
        targetMap.put("POST", List.of("/me/withdrawal"));
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {

        String method = request.getMethod();
        String apiURI = request.getRequestURI().replace("/api/v1", "");

        // 대상 요청인지 체크
        if (!targetMap.containsKey(method)) {
            return true;
        } else if (!targetMap.get(method).contains(apiURI)) {
            return true;
        }

        HttpSession session = request.getSession();
        Member loginMember = (Member) session.getAttribute(SessionConst.LOGIN_MEMBER);
        Long userNo = loginMember.getUserNo();

        // 테스트 유저 사용 제한
        if (userNo == 4 || userNo == 5) {
            throw BusinessException.TEST_FORBIDDEN;
        }

        return true;
    }
}
