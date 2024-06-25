<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>


<!DOCTYPE html>
<html lang="ko">
<head>
<%--      [!] refresh 경로 추후 home으로 변경  --%>
    <meta http-equiv="Refresh" content="3; /">
    <%@ include file="fragment/head.jsp" %>
    <title>Bangcom - 탈퇴 완료</title>
</head>
<body>
<c:if test="${status eq 'success'}">
    <div class="x-paddingx-v640 d-flex min-vh-100 justify-content-center align-items-center">
        <div class="x-max-width-md x-width-full pb-5">
            <div class="fs-2 mb-2 text-center">
                <p class="mb-0 x-font-bold">탈퇴 완료</p>
            </div>
            <div class="py-4 px-3 small rounded-3 x-text-gray-700 x-width-full text-center"
                 style="background-color: #F9FAFB">
                <p class="m-0">회원 탈퇴가 정상적으로 처리되었습니다.</p>
                <p class="m-0">3초 후 메인 화면으로 이동합니다.</p>
            </div>
            <div class="mt-4 d-flex justify-content-center">
                <a href="/" class="btn btn-primary" style="width: 10rem">메인 화면</a>
            </div>
        </div>
    </div>
</c:if>

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="fragment/script.jsp" %>
</body>