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
    <title>Bangcom - 회원가입</title>
</head>
<body>
<div class="d-flex justify-content-center x-margin-top__form x-paddingx-v640">
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
                <span class="px-2 small x-font-light x-text-gray-600 bg-white">회원가입에 필요한 기본정보를 입력해주세요.</span>
            </div>
        </div>

        <form action="/signup" method="post">
            <div class="mb-4">
                <div>
                    <label for="loginName" class="form-label">아이디</label>
                    <input type="text" class="form-control" name="loginName" id="loginName"
                           placeholder="4~15자 이내로 입력해주세요" value="${form.loginName}">
                </div>
                <spring:hasBindErrors name="memberSignUpForm">
                    <c:if test="${not empty errors.getFieldError('loginName')}">
                        <div class="mt-1 x-field-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span><spring:message message="${errors.getFieldError('loginName')}"/></span>
                        </div>
                    </c:if>
                </spring:hasBindErrors>
            </div>
            <div class="mb-4">
                <div>
                    <label for="password" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" name="password" id="password"
                           placeholder="최소 6자 이상">
                </div>
                <spring:hasBindErrors name="memberSignUpForm">
                    <c:if test="${not empty errors.getFieldError('password')}">
                        <div class="mt-1 x-field-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span><spring:message message="${errors.getFieldError('password')}"/></span>
                        </div>
                    </c:if>
                </spring:hasBindErrors>
            </div>
            <div class="mb-4">
                <div>
                    <label for="password" class="form-label">비밀번호 확인</label>
                    <input type="password" class="form-control" name="passwordCheck" id="passwordCheck"
                           placeholder="비밀번호를 다시 입력해주세요.">
                </div>
                <spring:hasBindErrors name="memberSignUpForm">
                    <c:if test="${not empty errors.getFieldError('passwordCheck')}">
                        <div class="mt-1 x-field-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span><spring:message message="${errors.getFieldError('passwordCheck')}"/></span>
                        </div>
                    </c:if>
                </spring:hasBindErrors>
            </div>
            <div class="mb-4">
                <div>
                    <label for="nickname" class="form-label">닉네임</label>
                    <input type="text" class="form-control" name="nickname" id="nickname"
                           placeholder="별명을 20자 이하로 입력해 주세요(알파벳, 한글, 숫자)" value="${form.nickname}">
                </div>
                <spring:hasBindErrors name="memberSignUpForm">
                    <c:if test="${not empty errors.getFieldError('nickname')}">
                        <div class="mt-1 x-field-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span><spring:message message="${errors.getFieldError('nickname')}"/></span>
                        </div>
                    </c:if>
                </spring:hasBindErrors>
            </div>
            <div class="mb-4 row">
                <div class="col-6">
                    <div>
                        <label class="form-label">학년</label>
                        <select class="form-select form-select-md" name="grade" id="grade">
                            <option selected disabled>학년</option>
                            <c:forEach var="grade" items="${grades}">
                                <option value="${grade}" <c:if
                                        test="${form.grade eq grade}"> selected</c:if>>${grade.description}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <spring:hasBindErrors name="memberSignUpForm">
                        <c:if test="${not empty errors.getFieldError('grade')}">
                            <div class="mt-1 x-field-error">
                                <i class="bi bi-exclamation-circle"></i>
                                <span><spring:message message="${errors.getFieldError('grade')}"/></span>
                            </div>
                        </c:if>
                    </spring:hasBindErrors>
                </div>
                <div class="col-6 ps-0">
                    <div>
                        <label class="form-label">지역</label>
                        <select class="form-select form-select-md" name="region" id="region">
                            <option selected disabled>지역</option>
                            <c:forEach var="region" items="${regions}">
                                <option value="${region}" <c:if
                                        test="${form.region eq region}"> selected</c:if>>${region.description}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <spring:hasBindErrors name="memberSignUpForm">
                        <c:if test="${not empty errors.getFieldError('region')}">
                            <div class="mt-1 x-field-error">
                                <i class="bi bi-exclamation-circle"></i>
                                <span><spring:message message="${errors.getFieldError('region')}"/></span>
                            </div>
                        </c:if>
                    </spring:hasBindErrors>
                </div>
            </div>
            <div class="mb-4">
                <div>
                    <label class="form-label">편입여부</label>
                    <div class="x-form-check-group">
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="transferred" id="transferredY"
                                   value="true" <c:if test="${form.transferred eq true}"> checked</c:if>>
                            <label class="form-check-label" for="transferredY">예</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="transferred" id="transferredN"
                                   value="false" <c:if test="${form.transferred eq false}"> checked</c:if>>
                            <label class="form-check-label" for="transferredN">아니오</label>
                        </div>
                    </div>
                </div>
                <spring:hasBindErrors name="memberSignUpForm">
                    <c:if test="${not empty errors.getFieldError('transferred')}">
                        <div class="x-field-error">
                            <i class="bi bi-exclamation-circle"></i>
                            <span><spring:message message="${errors.getFieldError('transferred')}"/></span>
                        </div>
                    </c:if>
                </spring:hasBindErrors>
            </div>
            <div>
                <button type="submit" class="my-4 py-2 btn btn-primary form-control">회원가입</button>
            </div>
        </form>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="fragment/script.jsp" %>
</body>
</html>