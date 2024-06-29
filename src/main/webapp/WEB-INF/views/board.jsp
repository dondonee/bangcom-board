<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="customFn" class="com.knou.board.web.JspFunction"/>
<c:set var="cpath" value="${pageContext.request.contextPath}"/>
<c:choose>
    <c:when test="${empty topic}">
        <c:set var="curi" value="/${topicGroup.uri}"/>
    </c:when>
    <c:otherwise>
        <c:set var="curi" value="/${topicGroup.uri}/${topic.uri}"/>
    </c:otherwise>
</c:choose>

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
            <div class="mb-3 row d-flex ${topicGroup eq 'NOTICE' && loginMember.authority ne 'ADMIN'? 'justify-content-end': 'justify-content-between'}">
                <c:if test="${topicGroup != 'NOTICE'}"> <%-- 공지사항은 하위 topic 없음 --%>
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
                </c:if>
                <c:if test="${topicGroup ne 'NOTICE' || topicGroup eq 'NOTICE' && loginMember.authority eq 'ADMIN'}">
                    <div class="order-md-1 col-md-auto col-6 col-sm-6">
                        <a href="${curi}/new"
                           class="btn btn-primary px-3 py-1"><i
                                class="bi bi-pencil-fill pe-1"></i><span>글쓰기</span></a>
                    </div>
                </c:if>
                <div class="order-md-3 col-md-auto col-6 col-sm-6 text-end">
                    <div class="dropdown">
                        <button class="dropdown-toggle btn btn-outline-secondary px-3 py-1" type="button"
                                id="sortDropdown" role="button"
                                data-bs-toggle="dropdown" aria-expanded="false"><i
                                class="bi bi-filter pe-1"></i>
                            <c:if test="${empty param.sort || param.sort eq 'ID'}"><span>최신순</span></c:if>
                            <c:if test="${param.sort eq 'VIEW_COUNT'}"><span>조회순</span></c:if>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end x-text-sm" aria-labelledby="sortDropdown">
                            <li><a class="dropdown-item"
                                   href="${cpath}?sort=ID<c:if test="${!empty param.page}">&page=${param.page}</c:if>">최신순</a>
                            </li>
                            <li><a class="dropdown-item"
                                   href="${cpath}?sort=VIEW_COUNT<c:if test="${!empty param.page}">&page=${param.page}</c:if>">조회순</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!--    게시글 목록    -->
            <div>
                <ul class="list-group list-group-flush list-unstyled">
                    <c:forEach var="vo" items="${posts}">
                        <li class="py-3 border-top text-decoration-none">
                                <%--    작성자 정보    --%>
                            <div class="x-text-sm">
                                <span>
                                    <a href="/members/${vo.author.userNo}">
                                        <img src="/images/profile/${not empty vo.author.imageName? vo.author.imageName: 'temporary.gif'}"
                                             style="width: 20px; height: 20px"
                                             alt="프로필사진">
                                        </a>
                                </span>
                                <span>
                                    <c:if test="${not empty vo.author}">
                                    <a class="x-text-gray-600" href="/members/${vo.author.userNo}">
                                        <span>${vo.author.nickname}</span>
                                        <c:choose>
                                            <c:when test="${vo.author.authority ne 'ADMIN'}">
                                                <span> / ${vo.author.grade.description} / ${vo.author.region.description}</span>
                                            </c:when>
                                            <c:when test="${vo.author.authority eq 'ADMIN'}">
                                                <span class="ms-1 x-badge-admin x-text-xs">관리자</span>
                                            </c:when>
                                        </c:choose>
                                    </a>
                                    </c:if>
                                    <c:if test="${empty vo.author}">
                                        <span class="x-text-gray-600">(알 수 없음)</span>
                                    </c:if>
                                </span>
                                <span class="x-text-gray-600">·</span>
                                <span class="x-text-gray-600">${customFn.getElapsedTime(vo.createdDate)}</span>
                            </div>
                            <div class="my-2 x-text-ellipsis">
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
            <div class="border-top">
                <nav class="d-flex justify-content-center">
                    <ul class="pagination">
                        <c:if test="${pageMaker.prevButton}">
                            <li class="page-item">
                                <a class="x-text-sm page-link x-page-link"
                                   href="${cpath}?<c:if test="${!empty param.sort}">sort=${param.sort}&</c:if>page=${pageMaker.startPageButton - 1}"
                                   aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="page" varStatus="pageStatus" begin="${pageMaker.startPageButton}"
                                   end="${pageMaker.endPageButton}">
                            <li class="page-item">
                                <a class="x-text-sm page-link x-page-link ${pageMaker.criteria.page eq pageStatus.current?'active':''}"
                                   href="${cpath}?<c:if test="${!empty param.sort}">sort=${param.sort}&</c:if>page=${pageStatus.current}">${pageStatus.current}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${pageMaker.nextButton}">
                            <li class="page-item">
                                <a class="x-text-sm page-link x-page-link"
                                   href="${cpath}?<c:if test="${!empty param.sort}">sort=${param.sort}&</c:if>page=${pageMaker.endPageButton + 1}"
                                   aria-label="Next">
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