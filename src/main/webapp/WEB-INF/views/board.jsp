<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>KNOU CS - ${topicGroup.description}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>

<header>
    <%--  네비게이션 바  --%>
    <jsp:include page="fragment/header.jsp" flush="false"/>
</header>

<main>
    <div class="row">
        <!--    왼쪽 영역    -->
        <div class="col-md-2 d-md-block d-none d-sm-none"></div>

        <!--    가운데 영역    -->
        <div class="col-md-8 px-3">
            <div class="my-4 p-3">
                <h2 class="fs-3">${topicGroup.description}</h2>
            </div>
            <!--    토픽 네비게이션    -->
            <c:if test="${topicGroup != 'NOTICE'}"> <%-- 공지사항은 하위 topic 없음 --%>
            <div class="my-2 row d-flex justify-content-between">
                <div class="py-2 order-sm-2 col-sm-auto col-12">
                    <ul class="list-unstyled list-inline d-flex justify-content-center m-0">
                        <c:forEach var="topic" items="${topicGroup.topics}">
                            <li class="list-inline-item">
                                <button type="button" class="btn text-decoration-none">${topic.description}</button>
                            </li>
                        </c:forEach>
                        <li class="list-inline-item">
                            <button type="button" class="btn text-decoration-none">전체</button>
                        </li>
                    </ul>
                </div>
                <div class="ps-4 pe-0 py-2 order-sm-1 col-sm-auto col-6">
                    <button type="button" class="btn btn-dark"><span class="small">글쓰기</span></button>
                </div>
                <div class="pe-4 ps-0 py-2 order-sm-3 col-sm-auto col-6 text-end">
                    <button type="button" class="btn btn-outline-secondary"><span class="small">최신순</span></button>
                </div>
            </div>
            </c:if>

            <!--    게시글 목록    -->
            <div>
                <ul class="list-group list-group-flush list-unstyled">
                    <c:forEach var="post" items="${posts}">
                        <li class="p-2 py-3 border-top text-decoration-none">
                            <div>
                                <a href="#">${post.author.nickname}</a>
                                <span>
                                ·
                            </span>
                                <span>${post.createdDate}</span>
                            </div>
                            <div>
                                <a href="#">${post.title}</a>
                            </div>
                            <div>
                                <span> View : ${post.viewCount}</span>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>

        <!--    오른쪽 영역    -->
        <div class="col-md-2 d-md-block d-none d-sm-none"></div>
    </div>
</main>
<%@include file="fragment/footer.jsp" %>
</body>
</html>