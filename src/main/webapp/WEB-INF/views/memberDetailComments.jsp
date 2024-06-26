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
    <title>Bangcom - 유저 활동 내역</title>
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

            <!--    프로필 박스    -->
            <div class="mt-3 mb-5 border rounded">
                <div class="px-3 py-4">
                    <div class="mb-2 d-flex">
                        <div class="me-3">
                            <a href="">
                                <img class="x-border-thin rounded-circle"
                                     src="/images/profile/${not empty member.imageName? member.imageName: 'temporary.gif'}"
                                     style="width: 64px; height: 64px;"
                                     alt="프로필사진">
                            </a>
                        </div>
                        <div class="my-auto">
                            <div class="d-flex align-items-center">
                                <h2 class="fs-4 mb-0 x-font-semibold">${not empty member.nickname? member.nickname: '(알 수 없음)'}</h2>
                                <c:if test="${member.authority eq 'ADMIN'}">
                                    <span class="ms-2 x-text-sm x-badge-admin">관리자</span>
                                </c:if>
                            </div>
                            <div>
                                <c:if test="${not empty member.nickname}">
                            <span class="x-text-sm x-text-gray-800 x-font-light"
                                  style="font-size: 0.95rem">${member.grade.description} / ${member.region.description}${member.transferred eq true? ' / 편입': ''}</span>
                                </c:if>
                                <c:if test="${empty member.nickname}">
                            <span class="x-text-sm x-text-gray-800 x-font-light"
                                  style="font-size: 0.95rem">존재하지 않는 사용자입니다.</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="x-text-gray-700 x-font-light" style="font-size: 0.95rem">
                        <span>${member.bio}</span>
                    </div>
                </div>
                <%--    탭    --%>
                <div class="px-3 border-top">
                    <nav class="d-flex justify-content-start">
                        <ul class="mb-0 pagination">
                            <li class="page-item"><a href="/members/${member.userNo}"
                                                     class="x-text-sm page-link x-tab-link">게시물</a></li>
                            <li class="page-item"><a href="/members/${member.userNo}/comments"
                                                     class="x-text-sm page-link x-tab-link active">댓글</a></li>
                        </ul>
                    </nav>
                </div>
            </div>

            <!--    목록    -->
            <div>
                <ul class="list-group list-group-flush list-unstyled">
                    <c:forEach var="vo" varStatus="status" items="${commentHistory}">
                        <li class="py-3 text-decoration-none ${status.index eq 0? '': 'border-top'}">
                            <div class="d-flex justify-content-between x-text-sm x-text-gray-600 x-font-light">
                                <div class="d-flex align-items-center">
                                <a class="x-topic-pill x-link x-text-xs" href="${cpath}/${customFn.getTopicListUrl(vo.postTopic)}">${vo.postTopic.description}</a><div class="ms-1"><a href="/members/${vo.authorId}" class="x-text-gray-800">${vo.authorNickname}</a>님의 게시물에 <span class="x-text-primary">댓글</span>을 달았습니다.</div>
                                </div>
                                <div class="d-flex align-items-center d-none d-sm-block">
                                    <fmt:parseDate value="${vo.createdDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate"/>
                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </div>
                            </div>
                            <div class="my-2 text-truncate">
                                <a href="/articles/${vo.postId}"><span class="x-font-semibold"><c:out
                                        value="${vo.postTitle}"></c:out></span></a>
                            </div>
                            <div class="d-block d-sm-none x-text-sm x-text-gray-600 x-font-light">
                                <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
                                <a class="x-text-sm page-link x-page-link"
                                   href="${cpath}?page=${pageMaker.startPageButton - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="page" varStatus="pageStatus" begin="${pageMaker.startPageButton}"
                                   end="${pageMaker.endPageButton}">
                            <li class="page-item">
                                <a class="x-text-sm page-link x-page-link ${pageMaker.criteria.page eq pageStatus.current?'active':''}"
                                   href="${cpath}?page=${pageStatus.current}">${pageStatus.current}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${pageMaker.nextButton}">
                            <li class="page-item">
                                <a class="x-text-sm page-link x-page-link"
                                   href="${cpath}?page=${pageMaker.endPageButton + 1}" aria-label="Next">
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