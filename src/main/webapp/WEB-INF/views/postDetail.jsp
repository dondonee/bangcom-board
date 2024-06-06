<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="customFn" class="com.knou.board.web.JspFunction"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="fragment/head.jsp" %>
    <title>Bangcom - ${post.title}</title>
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
            <%--    토픽 네비게이션    --%>
            <div class="mt-4 pb-5 border-bottom">
                <div class="position-relative">
                    <div class="position-absolute d-flex align-items-center x-inset-0">
                        <div class="border-top border-1 x-width-full">
                        </div>
                    </div>
                    <div class="position-relative">
                            <span class="ms-3 px-2 small x-font-light x-text-gray-600 bg-white"><a class="x-link sub"
                                                                                                   href="/${topicGroup.uri}">${topicGroup.description}</a> / <a
                                    href="/${topicGroup.uri}/${post.topic.uri}"
                                    class="x-link active">${post.topic.description}</a></span>
                    </div>
                </div>
                <div class="mt-5 mb-4 d-flex justify-content-between" style="line-height: 1.25rem">
                    <%--    작성자 정보    --%>
                    <div class="d-flex">
                        <div>
                            <a href=""><c:if test="${not empty post.author.imageName}">
                                <img src="/images/profile/${post.author.imageName}"
                                     style="width: 40px; height: 40px"
                                     alt="프로필사진">
                            </c:if>
                                <c:if test="${empty post.author.imageName}">
                                    <img src="/images/profile/temporary.gif" style="width: 40px; height: 40px"
                                         alt="프로필사진">
                                </c:if></a>
                        </div>
                        <div class="ms-2 d-flex flex-column">
                            <a href="">${post.author.nickname}</a>
                            <div class="x-text-sm x-text-gray-700" style="line-height: 1.2rem">
                                <span>${post.author.grade.description} / ${post.author.region.description}</span>
                                <span>·</span>
                                <span class="">${customFn.getElapsedTime(post.createdDate)}</span>
                                <span>·</span>
                                <span><i class="me-1 bi bi-eye"></i>${post.viewCount}</span>
                            </div>
                        </div>
                    </div>
                    <%--    부가 메뉴    --%>
                    <c:if test="${post.author.userNo eq loginMember.userNo}">
                        <div class="dropdown d-flex align-items-center">
                            <button class="dropdown-toggle" style="background: none; border: none;" type="button"
                                    id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor"
                                     class="bi bi-three-dots x-text-gray-700" viewBox="0 0 16 16">
                                    <path d="M3 9.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3"/>
                                </svg>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end x-text-sm x-text-gray-700"
                                aria-labelledby="dropdownMenuButton1">
                                <li><a class="dropdown-item" href="/articles/${post.id}/edit"><i
                                        class="me-1 bi bi-pencil-square"></i>수정하기</a></li>
                                <li>
                                    <button type="button" class="dropdown-item" data-bs-toggle="modal"
                                            data-bs-target="#exampleModal">
                                        <i class="me-1 bi bi-trash3"></i>삭제하기</a>
                                    </button>
                                </li>
                            </ul>
                        </div>
                    </c:if>
                </div>
                <%--    게시글 내용    --%>
                <h1 class="my-5 fs-2 x-font-semibold"><c:out value="${post.title}"></c:out></h1>
                <div style="white-space: pre" class="pb-5 x-text-gray-700"><c:out value="${post.content}"></c:out></div>
            </div>
        </div>

        <!--    오른쪽 영역    -->
        <div class="x-aside"></div>
    </div>

    <!--    모달 (게시글 삭제 확인)   -->
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title x-font-medium" id="exampleModalLabel">게시글 삭제</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body x-text-sm x-text-gray-700">
                    <p>게시글을 삭제하시겠습니까?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="px-3 py-1 btn btn-outline-secondary" data-bs-dismiss="modal">취소
                    </button>
                    <button type="button" class="px-3 py-1 btn btn-primary"
                            onclick="location.href='/articles/${post.id}/delete'">삭제
                    </button>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="fragment/script.jsp" %>
</body>
</html>