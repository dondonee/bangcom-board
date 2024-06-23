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
    <title>Bangcom - 로그인</title>
</head>
<body>
<div class="x-paddingx-v640 d-flex min-vh-100 justify-content-center align-items-center">
    <div class="x-max-width-md x-width-full pb-5">
        <div class="text-center">
            <a class="navbar-brand text-primary fst-italic x-font-bold" href="/"><h1>Bangcom</h1></a>
        </div>
        <div class="text-center">
            <h2 class="mt-4 fs-3 x-font-bold">환영합니다.</h2>
            <p class="mt-2 x-font-light x-text-gray-600">'방콤'은 한국방송통신대학교 컴퓨터과학과 커뮤니티입니다.</p>
        </div>
        <div class="position-relative">
            <div class="position-absolute d-flex align-items-center x-inset-0">
                <div class="border-top border-1 x-width-full">
                </div>
            </div>
            <div class="position-relative mt-5 mb-4 text-center">
                <span class="px-2 small x-font-light x-text-gray-600 bg-white">방콤 아이디로 로그인</span>
            </div>
        </div>
        <form action="/login" method="post">
            <div class="mb-3">
                <div>
                    <label for="loginName" class="form-label">아이디</label>
                    <input type="text" class="form-control" name="loginName" id="loginName" value="${form.loginName}">
                </div>
            </div>
            <div>
                <div>
                    <label for="password" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" name="password" id="password">
                </div>
            </div>
            <spring:hasBindErrors name="memberLoginForm">
                <div class="mt-1 x-field-error">
                    <c:forEach var="error" items="${errors.globalErrors}">
                        <i class="bi bi-exclamation-circle"></i>
                        <span><spring:message message="${error}"/></span>
                    </c:forEach>
                </div>
            </spring:hasBindErrors>
            <div>
                <button type="submit" class="my-4 py-2 btn btn-primary form-control">로그인</button>
            </div>
            <div class="d-flex justify-content-center small x-font-light x-text-gray-700">
                <span>아직 회원이 아니신가요?</span><a class="ms-1 x-link" style="text-decoration: underline" href="/signup">회원가입</a>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <%@ include file="fragment/script.jsp" %>
</body>
</html>