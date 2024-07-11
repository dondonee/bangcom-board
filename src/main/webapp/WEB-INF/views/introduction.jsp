<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="fragment/head.jsp" %>
    <title>Bangcom - 사이트 소개</title>
</head>
<body>
<header>
    <%--  네비게이션 바  --%>
    <jsp:include page="fragment/header.jsp" flush="false"/>
</header>
<main class="mx-auto x-container-width">
    <div class="d-flex justify-content-between">
        <!--    왼쪽 영역    -->
        <div class="x-aside"></div>

        <!--    가운데 영역    -->
        <div class="x-main" style="min-width: 340px">
            <div class="mt-5 container">
                <div class="mb-5 text-center">
                    <a class="text-primary fst-italic x-font-bold" href="/"><h1 class="mb-2">Bangcom</h1></a>
                    <p class="x-font-medium" style="color: #006a9b">Bangcom은 한국방송통신대학교 컴퓨터과학과 가상 커뮤니티 게시판입니다.</p>
                </div>
                <div class="mb-5 text-center x-font-light">
                    <div>
                        <p class="mb-0">게시판의 주제는 방송대 컴퓨터과학과 오픈카톡에서 아이디어를 얻었으며,</p>
                        <p class="mb-4">UI는 개발자 커뮤니티 OKKY를 참고하였습니다.</p>
                    </div>
                    <div>
                    <p class="mb-0">본 사이트는 포트폴리오 용도로 운영중입니다.</p>
                    <p class="mb-4">가입 없이 테스트 계정을 사용하실 수 있습니다.</p>
                    </div>
                    <div>
                    <ul class="list-unstyled">
                        <li class="row">
                            <span class="x-font-medium">일반 사용자</span>
                            <span>아이디: user</span>
                            <span>비밀번호: password123!</span>
                        </li>
                        <li class="mt-2 row">
                            <span class="x-font-medium">멘토 권한</span>
                            <span>아이디: mentor</span>
                            <span>비밀번호: password123!</span>
                        </li>
                    </ul>
                    </div>
                </div>
                <div class="d-flex flex-column align-items-center">
                    <a href="/login" class="btn btn-primary mb-2 col-12 col-sm-6">로그인</a>
                    <a href="/signup" class="btn btn-primary mb-2 col-12 col-sm-6">회원가입</a>
                    <a href="/" class="btn btn-outline-secondary mb-2 col-12 col-sm-6">메인 화면</a>
                </div>
            </div>
        </div>

        <!--    오른쪽 영역    -->
        <div class="x-aside"></div>
    </div>
</main>
<footer>
    <%@include file="fragment/footer.jsp" %>
</footer>

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="fragment/script.jsp" %>
</body>
</html>