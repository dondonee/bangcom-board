<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="fragment/head.jsp" %>
    <title>Bangcom - ${topicGroup.description} 게시글 수정</title>
</head>
<body>
<header>
    <%--  네비게이션 바  --%>
    <jsp:include page="fragment/header.jsp" flush="false"/>
</header>
<main>
    <main class="mx-auto x-container-width">
        <div class="d-flex justify-content-between">
            <!--    왼쪽 영역    -->
            <div class="x-aside"></div>

            <!--    가운데 영역    -->
            <div class="x-main" style="min-width: 340px">
                <div class="my-5 p-3">
                    <h2 class="fs-2 x-font-bold x-text-gray-800">${topicGroup.description}</h2>
                    <p class="fs-5 x-font-medium x-text-gray-700">게시글 수정하기</p>
                </div>
                <form class="mb-4" action="/articles/${form.id}/edit" method="post">
                    <input type="hidden" name="id" value="${form.id}">
                    <input type="hidden" name="authorId" value="${form.authorId}">
                    <div class="mb-5">
                        <div class="mb-4">
                            <label for="topic" class="form-label">토픽</label>
                            <select class="form-select form-select-md" name="topic" id="topic">
                                <option selected disabled>토픽을 선택해주세요.</option>
                                <c:forEach var="topic" items="${topicGroup.topics}">
                                    <option value="${topic}" <c:if
                                            test="${form.topic eq topic}"> selected</c:if><c:if
                                            test="${topic eq 'MENTOR' && loginMember.authority eq 'USER'}"> disabled</c:if>>${topic.description}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-4">
                            <label for="title" class="form-label">제목</label>
                            <input type="text" class="form-control" name="title" id="title"
                                   placeholder="제목을 입력해주세요." value="<c:out value="${form.title}"></c:out>">
                        </div>
                        <div class="mb-4">
                            <label for="content" class="form-label">본문</label>
                            <textarea class="form-control" name="content" id="content" rows="10"
                                      placeholder="내용을 입력해주세요"><c:out value="${form.content}"></c:out></textarea>

                        </div>
                    </div>
                    <div class="d-flex justify-content-end">
                        <div>
                            <button type="button" class="px-3 py-1 btn btn-outline-secondary" onclick="history.back()">취소</button>
                            <button type="submit" class="px-3 py-1 btn btn-primary">등록</button>
                        </div>
                    </div>
                </form>
            </div>

            <!--    오른쪽 영역    -->
            <div class="x-aside"></div>
        </div>
    </main>
</main>

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="fragment/script.jsp" %>

<script>

    $(document).ready(function () {

    });

    function changeTopicSelect() {

    }
</script>
</body>
</html>