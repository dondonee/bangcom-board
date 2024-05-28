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
                            <c:forEach var="vo" items="${topicGroup.topics}">
                                <li class="list-inline-item">
                                    <a href="/${topicGroup.uri}/${vo.uri}"
                                       class="<c:if test="${vo.uri eq topic.uri}"> active </c:if> btn btn-link x-btn-link x-v390-text-sm text-decoration-none px-3 py-1">${vo.description}</a>
                                </li>
                            </c:forEach>
                            <li class="list-inline-item">
                                <a href="/${topicGroup.uri}"
                                   class="<c:if test="${empty topic}"> active </c:if>btn btn-link x-btn-link x-v390-text-sm text-decoration-none px-3 py-1">전체
                                </a>
                            </li>
                        </ul>
                    </div>
                    <div class="order-md-1 col-md-auto col-6 col-sm-6">
                        <a href="/${fn:toLowerCase(topicGroup)}/new" class="btn btn-primary px-3 py-1"><i
                                class="bi bi-pencil-fill pe-1"></i><span>글쓰기</span></a>
                    </div>
                    <div class="order-md-3 col-md-auto col-6 col-sm-6 text-end">
                        <button type="button" class="btn btn-outline-secondary px-3 py-1"><i
                                class="bi bi-arrow-bar-down pe-1"></i><span>최신순</span></button>
                    </div>
                </div>
            </c:if>

            <!--    게시글 목록    -->
            <div>
                <ul class="list-group list-group-flush list-unstyled">
                    <c:forEach var="vo" items="${posts}">
                        <li class="py-3 border-top text-decoration-none">
                            <div class="x-text-sm">
                                <span>
                                    <c:if test="${not empty vo.author.imageUrl}">
                                        <img src="/images/profile/${vo.author.imageUrl}"
                                             style="width: 20px; height: 20px"
                                             alt="프로필사진">
                                    </c:if>
                                    <c:if test="${empty vo.author.imageUrl}">
                                        <img src="/images/profile/temporary.gif" style="width: 20px; height: 20px"
                                             alt="프로필사진">
                                    </c:if>
                                </span>
                                <span>
                                    <a class="x-text-gray-600"
                                       href="#">${vo.author.nickname} / ${vo.author.grade.description} / ${vo.author.region.description}</a>
                                </span>
                                <span class="x-text-gray-600">·</span>
                                <span class="x-text-gray-600">${customFn.getElapsedTime(vo.createdDate)}</span>
                            </div>
                            <div class="my-2">
                                <a href="/articles/${vo.id}"><span class="x-font-semibold"><c:out
                                        value="${vo.title}"></c:out></span></a>
                            </div>
                            <div class="d-flex justify-content-end x-text-md" style="line-height: 1.2rem">
                                <i class="me-1 bi bi-eye" style="font-size: 1.2rem"></i><span
                                    class="x-text-sm">${vo.viewCount}</span>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!--    페이징    -->
            <div class="border-top mb-5">
                <nav class="d-flex justify-content-center">
                    <ul class="pagination">
                        <c:if test="${pageMaker.prevButton}">
                            <li class="page-item">
                                <a class="x-text-sm page-link x-page-link" href="${cpath}?page=${pageMaker.startPageButton - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="page" varStatus="pageStatus" begin="${pageMaker.startPageButton}" end="${pageMaker.endPageButton}">
                            <li class="page-item">
                                <a class="x-text-sm page-link x-page-link ${pageMaker.criteria.page eq pageStatus.current?'active':''}" href="${cpath}?page=${pageStatus.current}">${pageStatus.current}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${pageMaker.nextButton}">
                            <li class="page-item">
                                <a class="x-text-sm page-link x-page-link" href="${cpath}?page=${pageMaker.endPageButton + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
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