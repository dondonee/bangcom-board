<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>


<!DOCTYPE html>
<html lang="ko">
<head>
    <%--  [!] refresh 경로 추후 home으로 변경  --%>
    <meta http-equiv="Refresh" content="3; /login">
    <%@ include file="fragment/head.jsp" %>
    <title>Bangcom - 가입을 환영합니다.</title>
</head>
<body>
<c:if test="${not empty newMember}">
    <div class="x-paddingx-v640 d-flex min-vh-100 justify-content-center align-items-center">
        <div class="x-max-width-md x-width-full pb-5">
            <div class="d-flex justify-content-center">
                <i class="x-color-greenLight bi bi-check-circle-fill" style="font-size: 3.5rem;"></i>
            </div>
            <div class="fs-2 text-center">
                <p class="mb-0 x-font-bold">가입을 환영합니다!</p>
                <p class="x-font-bold"><span class="text-primary">${newMember.nickname}</span>님</p>
            </div>
            <div class="py-4 px-3 small rounded-3 x-text-gray-700 x-width-full text-center"
                 style="background-color: #F9FAFB">
                <p class="m-0">회원가입이 성공적으로 완료되었습니다.</p>
                <p class="m-0">로그인 화면으로 이동하여 로그인 해 주세요.</p>
            </div>
            <div class="mt-4 d-flex justify-content-center">
                <a href="/login" class="btn btn-primary" style="width: 10rem">로그인</a>
            </div>
        </div>
    </div>
</c:if>

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="fragment/script.jsp" %>
</body>