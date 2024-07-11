<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="customFn" class="com.knou.board.web.JspFunction"/>
<c:set var="cpath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="../fragment/head.jsp" %>
    <title>Bangcom - 한국방송통신대학교 컴퓨터과학과 커뮤니티입니다.</title>
</head>
<body>
<header>
    <%--  네비게이션 바  --%>
    <jsp:include page="../fragment/header.jsp" flush="false"/>
</header>
<main class="mx-auto x-container-width">
    <div class="d-flex justify-content-between">
        <!--    왼쪽 영역    -->
        <div class="x-aside"></div>

        <!--    가운데 영역    -->
        <div class="x-main" style="min-width: 340px">
            <div class="container text-center x-text-primary" style="margin: 20rem 0; width: 100%">
                <h1 class="x-font-bold" style="font-size: 5rem">500</h1>
                <h2 class="x-font-light x-text-gray-600" style="font-size: 1.5rem">알 수 없는 오류가 발생했습니다.</h2>
                <a class="mt-3 btn btn-primary" href="/">메인 화면</a>
            </div>
        </div>

        <!--    오른쪽 영역    -->
        <div class="x-aside"></div>
    </div>
</main>

<footer>
    <%@include file="../fragment/footer.jsp" %>
</footer>

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="../fragment/script.jsp" %>
</body>
</html>