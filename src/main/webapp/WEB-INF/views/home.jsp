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
    <title>Bangcom - 한국방송통신대학교 컴퓨터과학과 커뮤니티입니다.</title>
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
            <div class="mt-5 container">
                <div class="row">
                    <div class="mb-2 col-12 col-sm-6">
                        <a href="/notice"><h3 class="x-home-category-title">공지사항</h3></a>
                        <ul class="list-group list-group-flush list-unstyled">
                            <c:forEach var="vo" varStatus="status" items="${noticeList}">
                                <li class="py-2 text-decoration-none ${status.index eq 0? '': ' border-top'}">
                                        <%--    작성자 정보    --%>
                                    <div class="d-flex justify-content-between x-text-sm">
                                        <div>
                                <span>
                                    <a href="/members/${vo.author.userNo}">
                                        <img src="/images/profile/${not empty vo.author.imageName? vo.author.imageName: 'temporary.gif'}"
                                             style="width: 20px; height: 20px"
                                             alt="프로필사진">
                                        </a>
                                </span>
                                            <span>
                                    <a class="x-text-gray-600"
                                       href="/members/${vo.author.userNo}">${not empty vo.author.nickname? vo.author.nickname: '(알 수 없음)'}
                                    <c:if test="${vo.author.authority eq 'ADMIN'}">
                                        <span class="x-badge-admin x-text-xs">관리자</span>
                                    </c:if>
                                    </a>
                                </span>
                                            <span class="x-text-gray-600">·</span>
                                            <span class="x-text-gray-600">${customFn.getElapsedTime(vo.createdDate)}</span>
                                        </div>
                                        <div>
                                            <i class="me-1 bi bi-eye"></i><span class="x-text-sm">${vo.viewCount}</span>
                                        </div>
                                    </div>
                                    <div class="my-2 x-text-ellipsis">
                                        <a href="/articles/${vo.id}"><span class="x-font-semibold"><c:out
                                                value="${vo.title}"></c:out></span></a>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                    <div class="mb-2 col-12 col-sm-6">
                        <a href="/community"><h3 class="x-home-category-title">커뮤니티</h3></a>
                        <ul class="list-group list-group-flush list-unstyled">
                            <c:forEach var="vo" varStatus="status" items="${communityList}">
                                <li class="py-2 text-decoration-none ${status.index eq 0? '': ' border-top'}">
                                        <%--    작성자 정보    --%>
                                    <div class="d-flex justify-content-between x-text-sm">
                                        <div>
                                <span>
                                    <a href="/members/${vo.author.userNo}">
                                        <img src="/images/profile/${not empty vo.author.imageName? vo.author.imageName: 'temporary.gif'}"
                                             style="width: 20px; height: 20px"
                                             alt="프로필사진">
                                        </a>
                                </span>
                                            <span>
                                    <a class="x-text-gray-600"
                                       href="/members/${vo.author.userNo}">${not empty vo.author.nickname? vo.author.nickname: '(알 수 없음)'}
                                </span>
                                            <c:if test="${vo.author.authority eq 'ADMIN'}">
                                                <span class="x-badge-admin x-text-xs">관리자</span>
                                            </c:if>
                                            </a>
                                            <span class="x-text-gray-600">·</span>
                                            <span class="x-text-gray-600">${customFn.getElapsedTime(vo.createdDate)}</span>
                                        </div>
                                        <div>
                                            <i class="me-1 bi bi-eye"></i><span class="x-text-sm">${vo.viewCount}</span>
                                        </div>
                                    </div>
                                    <div class="my-2 x-text-ellipsis">
                                        <a href="/articles/${vo.id}"><span class="x-font-semibold"><c:out
                                                value="${vo.title}"></c:out></span></a>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                <div class="row">
                    <div class="mb-2 col-12 col-sm-6">
                        <a href="/questions"><h3 class="x-home-category-title">Q&A</h3></a>
                        <ul class="list-group list-group-flush list-unstyled">
                            <c:forEach var="vo" varStatus="status" items="${qnaList}">
                                <li class="py-2 text-decoration-none ${status.index eq 0? '': ' border-top'}">
                                        <%--    작성자 정보    --%>
                                    <div class="d-flex justify-content-between x-text-sm">
                                        <div>
                                <span>
                                    <a href="/members/${vo.author.userNo}">
                                        <img src="/images/profile/${not empty vo.author.imageName? vo.author.imageName: 'temporary.gif'}"
                                             style="width: 20px; height: 20px"
                                             alt="프로필사진">
                                        </a>
                                </span>
                                            <span>
                                    <a class="x-text-gray-600"
                                       href="/members/${vo.author.userNo}">${not empty vo.author.nickname? vo.author.nickname: '(알 수 없음)'}
                                    <c:if test="${vo.author.authority eq 'ADMIN'}">
                                        <span class="x-badge-admin x-text-xs">관리자</span>
                                    </c:if>
                                    </a>
                                </span>
                                            <span class="x-text-gray-600">·</span>
                                            <span class="x-text-gray-600">${customFn.getElapsedTime(vo.createdDate)}</span>
                                        </div>
                                        <div>
                                            <i class="me-1 bi bi-eye"></i><span class="x-text-sm">${vo.viewCount}</span>
                                        </div>
                                    </div>
                                    <div class="my-2 x-text-ellipsis">
                                        <a href="/articles/${vo.id}"><span class="x-font-semibold"><c:out
                                                value="${vo.title}"></c:out></span></a>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                    <div class="mb-2 col-12 col-sm-6">
                        <a href="/info"><h3 class="x-home-category-title">정보</h3></a>
                        <ul class="list-group list-group-flush list-unstyled">
                            <c:forEach var="vo" varStatus="status" items="${infoList}">
                                <li class="py-2 text-decoration-none ${status.index eq 0? '': ' border-top'}">
                                        <%--    작성자 정보    --%>
                                    <div class="d-flex justify-content-between x-text-sm">
                                        <div>
                                <span>
                                    <a href="/members/${vo.author.userNo}">
                                        <img src="/images/profile/${not empty vo.author.imageName? vo.author.imageName: 'temporary.gif'}"
                                             style="width: 20px; height: 20px"
                                             alt="프로필사진">
                                        </a>
                                </span>
                                            <span>
                                    <a class="x-text-gray-600"
                                       href="/members/${vo.author.userNo}">${not empty vo.author.nickname? vo.author.nickname: '(알 수 없음)'}
                                    <c:if test="${vo.author.authority eq 'ADMIN'}">
                                        <span class="x-badge-admin x-text-xs">관리자</span>
                                    </c:if>
                                    </a>
                                </span>
                                            <span class="x-text-gray-600">·</span>
                                            <span class="x-text-gray-600">${customFn.getElapsedTime(vo.createdDate)}</span>
                                        </div>
                                        <div>
                                            <i class="me-1 bi bi-eye"></i><span class="x-text-sm">${vo.viewCount}</span>
                                        </div>
                                    </div>
                                    <div class="my-2 x-text-ellipsis">
                                        <a href="/articles/${vo.id}"><span class="x-font-semibold"><c:out
                                                value="${vo.title}"></c:out></span></a>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>

                </div>
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