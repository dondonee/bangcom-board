<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ page import="com.knou.board.domain.member.Member" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="fragment/head.jsp" %>
    <title>KNOU CS - 로그인</title>
</head>
<body>
<div class="d-flex justify-content-center x-margin-top__form">
    <div class="x-member-form">
        <c:if test="${not empty newMember}">
            <div>
                <h3 class="fs-3">환영합니다!</h3>
                <p class="fs-3">${newMember.nickname}님</p>
                <p>회원가입이 완료되었습니다. 로그인 해 주세요.</p>
            </div>
        </c:if>
    </div>
</div>
</body>