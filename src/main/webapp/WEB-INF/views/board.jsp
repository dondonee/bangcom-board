<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="customFn" class="com.knou.board.web.JspFunction"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="fragment/head.jsp" %>
    <title>Bangcom - ${topicGroup.description}</title>
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
            <div class="my-4 p-3">
                <h2 class="fs-2 x-font-bold x-text-gray-800">${topicGroup.description}</h2>
            </div>
            <!--    토픽 네비게이션    -->
            <c:if test="${topicGroup != 'NOTICE'}"> <%-- 공지사항은 하위 topic 없음 --%>
                <div class="mb-3 row d-flex justify-content-between">
                    <div class="order-md-2 col-md-auto col-12 x-mb-sm-3 align-content-center">
                        <ul class="list-unstyled list-inline d-flex justify-content-center m-0">
                            <c:forEach var="topic" items="${topicGroup.topics}">
                                <li class="list-inline-item">
                                    <button type="button"
                                            class="btn btn-link x-btn-link x-v390-text-sm text-decoration-none px-3 py-1">${topic.description}</button>
                                </li>
                            </c:forEach>
                            <li class="list-inline-item">
                                <button type="button"
                                        class="btn btn-link x-btn-link x-v390-text-sm text-decoration-none px-3 py-1">전체
                                </button>
                            </li>
                        </ul>
                    </div>
                    <div class="order-md-1 col-md-auto col-6 col-sm-6">
                        <button type="button" class="btn btn-primary px-3 py-1"><i
                                class="bi bi-pencil-fill pe-1"></i><span class="x-text-sm">글쓰기</span></button>
                    </div>
                    <div class="order-md-3 col-md-auto col-6 col-sm-6 text-end">
                        <button type="button" class="btn btn-outline-secondary px-3 py-1"><span
                                class="x-text-sm">최신순</span></button>
                    </div>
                </div>
            </c:if>

            <!--    게시글 목록    -->
            <div>
                <ul class="list-group list-group-flush list-unstyled">
                    <c:forEach var="post" items="${posts}">
                        <li class="py-3 border-top text-decoration-none">
                            <div class="x-text-sm">
                                <span>
                                    <c:if test="${not empty post.author.imageUrl}">
                                        <img src="/images/profile/${post.author.imageUrl}"
                                             style="width: 20px; height: 20px"
                                             alt="프로필사진">
                                    </c:if>
                                    <c:if test="${empty post.author.imageUrl}">
                                        <img src="/images/profile/temporary.gif" style="width: 20px; height: 20px"
                                             alt="프로필사진">
                                    </c:if>
                                </span>
                                <span>
                                    <a class="x-text-gray-600"
                                       href="#">${post.author.nickname} / ${post.author.grade.description} / ${post.author.region.description}</a>
                                </span>
                                <span class="x-text-gray-600">·</span>
                                <span class="x-text-gray-600">${customFn.getElapsedTime(post.createdDate)}</span>
                            </div>
                            <div class="my-2">
                                <a href="#"><span class="x-font-semibold">${post.title}</span></a>
                            </div>
                            <div class="d-flex justify-content-end x-text-md" style="line-height: 1.2rem">
                                <i class="me-1 bi bi-eye" style="font-size: 1.2rem"></i><span
                                    class="x-text-sm">${post.viewCount}</span>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
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