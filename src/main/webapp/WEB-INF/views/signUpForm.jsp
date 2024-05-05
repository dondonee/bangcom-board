<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page import="com.knou.board.domain.member.Member" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="fragment/head.jsp" %>
    <title>KNOU CS - 회원가입</title>
</head>
<body>
<div class="d-flex justify-content-center x-margin-top__form">
    <div class="x-member-form px-2 pb-5">
        <div class="text-center">
            <h2 class="mt-4 fs-1 x-font-bolder">환영합니다.</h2>
            <p class="mt-2 x-text-gray-600">'방콤'은 한국방송통신대학교 컴퓨터과학과 커뮤니티입니다.</p>
        </div>
        <div class="position-relative">
            <div class="position-absolute d-flex align-items-center x-inset-0">
                <div class="border-top border-1 x-width-full">
                </div>
            </div>
            <div class="position-relative mt-5 mb-4 text-center">
                <span class="px-2 small x-text-gray-600 bg-white">회원가입에 필요한 기본정보를 입력해주세요.</span>
            </div>
        </div>

        <form action="/signUp" method="post">
            <div class="mb-4">
                <label for="loginName" class="form-label">아이디</label>
                <input type="text" class="form-control" name="loginName" id="loginName" placeholder="4~15자 이내로 입력해주세요">
            </div>
            <div class="mb-4">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" class="form-control" name="password" id="password"
                       placeholder="최소 6자 이상(알파벳, 숫자 필수)">
            </div>
            <div class="mb-4">
                <label for="nickname" class="form-label">닉네임</label>
                <input type="text" class="form-control" name="nickname" id="nickname"
                       placeholder="별명을 20자 이하로 입력해 주세요(알파벳, 한글, 숫자)">
            </div>
            <div class="mb-4 row">
                <div class="col-6">
                    <label class="form-label">학년</label>
                    <select class="form-select form-select-md" name="grade" id="grade">
                        <option selected disabled>학년</option>
                        <c:forEach var="grade" items="${grades}">
                            <option value="${grade}">${grade.description}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-6 ps-0">
                    <label class="form-label">지역</label>
                    <select class="form-select form-select-md" name="region" id="region">
                        <option selected disabled>지역</option>
                        <c:forEach var="region" items="${regions}">
                            <option value="${region}">${region.description}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label">편입여부</label>
                <div class="x-form-check-group">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="transferred" id="transferredY"
                               value="true">
                        <label class="form-check-label" for="transferredY">예</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="transferred" id="transferredN"
                               value="false">
                        <label class="form-check-label" for="transferredN">아니오</label>
                    </div>
                </div>
            </div>
            <button type="submit" class="my-4 btn btn-primary form-control">회원가입</button>
        </form>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="fragment/script.jsp" %>
</body>
</html>