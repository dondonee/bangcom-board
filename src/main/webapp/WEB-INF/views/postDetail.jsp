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
    <script>
function getElapsedTime(createdTime) {
    const now = new Date();
    const created = new Date(createdTime);

    const seconds = Math.floor((now - created) / 1000); // Milliseconds -> Seconds

    if (seconds < 60) {
        return "방금 전";
    }

    const minutes = Math.floor(seconds / 60);
    if (minutes < 60) {
        return minutes + "분 전";
    }

    const hours = Math.floor(minutes / 60);
    if (hours < 24) {
        return hours + "시간 전";
    }

    const days = Math.floor(hours / 24);
    const weeks = Math.floor(days / 7);
    const months = Math.floor(days / 30.43685); // 한 달은 약 30.43685일
    const years = Math.floor(months / 12);

    if (days < 7) {
        return days + "일 전";
    }

    if (months < 1) {
        return "약 " + weeks + "주 전";
    }

    if (months < 12) {
        return "약 " + months + "개월 전";
    }

    return "약 " + years + "년 전";
}

        $(document).ready(function () {
            $('#commentAddBtn').click(function () {
                const form = $('#commentAddForm');
                const url = form.attr('action');
                $.ajax({
                    url: url,
                    type: 'POST',
                    data: form.serializeArray(),
                    success: function (xhr) {
                        var html = '';
                        for (let i = 0; i < xhr.length; i++) {
                            let imageName = xhr[i].writer.imageName || 'temporary.gif';
                            html += '<li class="py-3 border-top text-decoration-none">'
                                + '<div class="d-flex">'
                                + ' <div class="me-2">'
                                + '     <a href=""><img src="/images/profile/' + imageName + '" style="width: 48px; height: 48px" class="x-border-thin rounded-circle" alt="프로필사진"></a>'
                                + ' </div>'
                                + ' <div class="d-flex flex-column my-auto">'
                                + '     <a class="x-text-sm" href="">' + xhr[i].writer.nickname + '</a>'
                                + '     <div class="x-text-xs x-text-gray-600 x-font-light" style="line-height: 1.2rem">'
                                + '     <span>' + xhr[i].writer.grade + ' / ' + xhr[i].writer.region + '</span>'
                                + '     <span>·</span>'
                                + '     <span class="">' + getElapsedTime(xhr[i].createdDate) + '</span>'
                                + ' </div>'
                                + '</div>'
                                + '</div>'
                                + ' <div class="my-2 x-text-sm x-text-gray-800">'
                                + xhr[i].content
                                + ' </div>'
                                + '</li>';
                        }

                        $('#commentList').html(html);
                        $('#commentList li:first').removeClass('border-top');
                        $('#commentCount').text(parseInt($('#commentCount').text()) + 1);
                        // 초기화
                        $('#commentErr').html('');
                        $('#commentAddForm textarea').val('');
                    },
                    error: function (xhr) {
                        const response = JSON.parse(xhr.responseText);
                        const exMessage = response.exMessage;

                        if (exMessage) {
                            let html = '<i class="me-1 bi bi-exclamation-circle"></i>'
                                + '<span>' + exMessage + '</span>';
                            $('#commentErr').html(html);
                        }

                        // 작성 댓글 내용이 empty인 경우 초기화
                        if ($('#commentAddForm textarea').val().trim() == '') {
                            $('#commentAddForm textarea').val('');
                        }
                    }
                });
            });
        });
    </script>
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
            <%--    간단한 토픽 네비게이션    --%>
            <div class="mt-4 position-relative">
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
            <%--    제목 상단    --%>
            <div class="mt-5 mb-4 d-flex justify-content-between" style="line-height: 1.25rem">
                <%--    작성자 정보    --%>
                <div class="d-flex">
                    <div>
                        <a href="">
                            <c:if test="${not empty post.author.imageName}">
                                <img src="/images/profile/${post.author.imageName}"
                                     style="width: 40px; height: 40px"
                                     alt="프로필사진">
                            </c:if>
                            <c:if test="${empty post.author.imageName}">
                                <img src="/images/profile/temporary.gif" style="width: 40px; height: 40px"
                                     alt="프로필사진">
                            </c:if>
                        </a>
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
            <%--    게시글 제목 및 내용    --%>
            <div class="pb-5 border-bottom">
                <h1 class="my-5 fs-2 x-font-semibold"><c:out value="${post.title}"></c:out></h1>
                <div style="white-space: pre" class="pb-5 x-text-gray-700"><c:out
                        value="${post.content}"></c:out></div>
            </div>
            <%--    댓글 영역    --%>
            <div class="mt-3">
                <div>
                    <span id="commentCount">${commentCount}</span>개의 댓글
                </div>
                <%--    댓글 작성 폼    --%>
                <div class="mt-4 mb-5 p-3 d-flex border rounded">
                    <div class="me-3">
                        <img style="width: 48px; height: 48px;"
                             class="x-comment-profile-img x-border-thin rounded-circle"
                             src="/images/profile/${loginMember.imageName ne null? loginMember.imageName: 'temporary.gif'}"
                             style="border:1px solid #f8f9fa">
                    </div>
                    <form id="commentAddForm" action="/articles/${post.id}/comments" method="post" class="w-100">
                        <c:if test="${!empty loginMember}">
                        <textarea class="form-control" name="content" id="content" placeholder="댓글을 남겨주세요."
                                  rows="3"></textarea>
                        </c:if>
                        <c:if test="${empty loginMember}">
                            <div class="form-control x-text-gray-600" style="height:87.5px">
                                작성하려면 <a href="/login" class="x-link x-font-medium" style="text-decoration:underline">로그인</a>이
                                필요합니다.
                            </div>
                        </c:if>
                        <div class="mt-3 d-flex justify-content-end">
                            <div id="commentErr" class="mt-1 me-2 x-field-error"></div>
                            <button id="commentAddBtn" class="px-3 py-1 btn btn-primary"
                                    type="button" ${empty loginMember?'disabled':''}>댓글 쓰기
                            </button>
                        </div>
                    </form>
                </div>
                <%--    댓글 목록    --%>
                <div class="mb-5">
                    <ul id="commentList" class="list-group list-group-flush list-unstyled">
                        <c:forEach var="vo" varStatus="status" items="${comments}">
                            <li class="py-3 ${status.index ne 0?'border-top':''} text-decoration-none">
                                <div class="d-flex">
                                    <div class="me-2">
                                        <a href=""><img
                                                src="/images/profile/${vo.writer.imageName ne null? vo.writer.imageName: 'temporary.gif'}"
                                                style="width: 48px; height: 48px" class="x-border-thin rounded-circle"
                                                alt="프로필사진"></a>
                                    </div>
                                    <div class="d-flex flex-column my-auto">
                                        <a class="x-text-sm" href="">${vo.writer.nickname}</a>
                                        <div class="x-text-xs x-text-gray-600 x-font-light" style="line-height: 1.2rem">
                                            <span>${vo.writer.grade.description} / ${vo.writer.region.description}</span>
                                            <span>·</span>
                                            <span class="">${customFn.getElapsedTime(vo.createdDate)}</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="my-2 x-text-sm x-text-gray-800">
                                    <c:out value="${vo.content}"></c:out>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
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