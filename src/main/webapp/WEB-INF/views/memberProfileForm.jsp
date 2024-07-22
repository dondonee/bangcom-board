<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="fragment/head.jsp" %>
    <title>Bangcom - 회원정보</title>
    <script>
        $(document).ready(function () {
            const imgUploadModal = new bootstrap.Modal(document.getElementById('imgUploadModal'))
            const imgUploadErrorModal = new bootstrap.Modal(document.getElementById('imgUploadErrorModal'))

            $('#profileEditForm').on('change', function () {
                $('#profileEditBtn').prop('disabled', false);
            });

            $('#imgUploadForm').on('change', function () {
                let file = $('#file').val();
                if (file) {
                    $('#imgUploadBtn').prop('disabled', false);
                }
            });

            if ($('#successLight').css('display') === 'block') {
                setTimeout(() => {
                    $('#successLight').fadeOut(1000)
                }, 1000);
            }

            $('#imgInitBtn').click(function () {
                $.ajax({
                    url: '/api/v1/me/image',
                    method: 'DELETE',
                    success: function (xhr) {
                        imgUploadModal.hide()
                        $('#navProfileImg').attr('src', '/images/profile/temporary.gif');
                        $('#formImg').load(location.href + ' #formImg', null, function () {
                            $('#imgSuccessLight').show()
                            setTimeout(() => {
                                $('#imgSuccessLight').fadeOut(1000)
                            }, 1000);
                        });

                    },
                    error: function () {
                        imgUploadModal.hide()

                        $('#imgUploadErrorModalLabel').text('기본사진 적용 오류');
                        imgUploadErrorModal.show();
                    }
                });
            });

            $('#imgUploadBtn').click(function () {
                $.ajax({
                    url: '/api/v1/me/image',
                    method: 'PUT',
                    data: new FormData($('#imgUploadForm')[0]),
                    enctype: 'multipart/form-data',
                    processData: false,
                    contentType: false,
                    cache: false,
                    success: function (xhr) {
                        imgUploadModal.hide()
                        const imgName = xhr.imageName;

                        $('#file').val('');
                        $('#navProfileImg').attr('src', '/images/profile/' + imgName);
                        $('#formImg').load(location.href + ' #formImg', null, function () {
                            $('#imgSuccessLight').show()
                            setTimeout(() => {
                                $('#imgSuccessLight').fadeOut(1000)
                            }, 1000);
                        });

                    },
                    error: function (xhr) {
                        imgUploadModal.hide()
                        const response = JSON.parse(xhr.responseText);
                        const exMessage = response.exMessage;
                        const exDescription = response.exDescription;

                        $('#file').val('');
                        $('#imgUploadErrorModalLabel').text(exMessage);
                        $('#imgUploadErrorModal').find('.modal-body > div').text(exDescription);
                        imgUploadErrorModal.show();
                    }
                })
            });
        });
    </script>
</head>
<body>
<header id="header">
    <%--  네비게이션 바  --%>
    <jsp:include page="fragment/header.jsp" flush="false"/>
</header>
<main class="mx-auto mb-3 x-container-width x-margin-top__inner-form">
    <div class="d-flex justify-content-between">
        <!--    왼쪽 영역    -->
        <div class="x-aside__bi">
            <div class="ps-2">
                <div class="pb-2">
                    <span class="x-font-medium" style="font-size: 1.15rem">내 계정</span>
                </div>
                <ul class="list-group">
                    <li class="x-setting-btn active list-group-item x-list-group-item x-text-gray-600"><a
                            style="display: block;color:inherit"
                            href="/settings/profile"><i
                            class="me-2 bi bi-person-circle" style="font-size:18px"></i><span style="line-height: 18px">프로필</span></a>
                    </li>
                    <li class="x-setting-btn list-group-item x-list-group-item x-text-gray-600"><a
                            style="display: block; color:inherit" href="/settings/account"><i
                            class="me-2 bi bi-gear" style="font-size:18px"></i><span
                            style="line-height: 18px">계정관리</span></a></li>
                </ul>
            </div>
        </div>

        <!--    가운데 영역    -->
        <div class="x-main px-sm-5" style="min-width: 340px;border-left: 1px solid #dee2e6">
            <div class="mb-5">
                <h2 class="fs-3 d-flex x-font-semibold">회원정보
                    <i id="successLight" class="ms-2 bi bi-check-circle-fill x-color-greenLight"
                       style="display:${updateSuccess eq true?'block': 'none'}"></i></h2>
            </div>
            <form id="profileEditForm" class="d-flex row" action="/settings/profile" method="post">
                <div class="order-sm-1 col-sm-5 pb-4 pb-sm-0 d-flex justify-content-center">
                    <button id="formImg" class="btn x-profile-img rounded-circle p-0 position-relative" type="button"
                            data-bs-toggle="modal"
                            data-bs-target="#imgUploadModal">
                        <img style="border:1px solid #f8f9fa" class="x-profile-img rounded-circle"
                             src="/images/profile/${loginMember.imageName ne null? loginMember.imageName: 'temporary.gif'}"
                             alt="프로필사진">
                        <div id="imgSuccessLight"
                             class="position-absolute top-50 start-50 translate-middle x-border-greenlight x-profile-img rounded-circle"
                             style="display: none"></div>
                    </button>
                </div>
                <div class="order-sm-0 col-sm-7">
                    <div class="mb-4">
                        <div>
                            <label for="loginName" class="form-label">아이디</label>
                            <input type="text" class="form-control" name="loginName" id="loginName"
                                   value="${form.loginName}" readonly>
                        </div>
                    </div>
                    <div class="mb-4">
                        <div>
                            <label for="nickname" class="form-label">닉네임</label>
                            <input type="text" class="form-control" name="nickname" id="nickname"
                                   value="${form.nickname}">
                        </div>
                        <spring:hasBindErrors name="memberProfileForm">
                            <c:if test="${not empty errors.getFieldError('nickname')}">
                                <div class="mt-1 x-field-error">
                                    <i class="bi bi-exclamation-circle"></i>
                                    <span><spring:message message="${errors.getFieldError('nickname')}"/></span>
                                </div>
                            </c:if>
                        </spring:hasBindErrors>
                    </div>
                    <div class="mb-4">
                        <div>
                            <label for="bio" class="form-label">한 줄 소개</label>
                            <textarea class="form-control" name="bio" id="bio" placeholder="나를 소개해주세요."
                                      value="${form.bio}"><c:out value="${form.bio}"></c:out></textarea>
                        </div>
                    </div>
                    <div class="mb-4 row">
                        <div class="col-6">
                            <div>
                                <label for="grade" class="form-label">학년</label>
                                <select class="form-select form-select-md" name="grade" id="grade">
                                    <option selected disabled>학년</option>
                                    <c:forEach var="grade" items="${grades}">
                                        <option value="${grade}" <c:if
                                                test="${form.grade eq grade}"> selected</c:if>>${grade.description}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <spring:hasBindErrors name="memberProfileForm">
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
                                <label for="region" class="form-label">지역</label>
                                <select class="form-select form-select-md" name="region" id="region">
                                    <option selected disabled>지역</option>
                                    <c:forEach var="region" items="${regions}">
                                        <option value="${region}" <c:if
                                                test="${form.region eq region}"> selected</c:if>>${region.description}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <spring:hasBindErrors name="memberProfileForm">
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
                            <label for="transferredY" class="form-label">편입여부</label>
                            <div class="x-form-check-group">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="transferred"
                                           id="transferredY"
                                           value="true" <c:if test="${form.transferred eq true}"> checked</c:if>>
                                    <label class="form-check-label" for="transferredY">예</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="transferred"
                                           id="transferredN"
                                           value="false" <c:if test="${form.transferred eq false}"> checked</c:if>>
                                    <label class="form-check-label" for="transferredN">아니오</label>
                                </div>
                            </div>
                        </div>
                        <spring:hasBindErrors name="memberProfileForm">
                            <c:if test="${not empty errors.getFieldError('transferred')}">
                                <div class="x-field-error">
                                    <i class="bi bi-exclamation-circle"></i>
                                    <span><spring:message message="${errors.getFieldError('transferred')}"/></span>
                                </div>
                            </c:if>
                        </spring:hasBindErrors>
                    </div>
                </div>
                <div class="order-sm-2 col-sm-12 mt-3 mt-sm-5 mb-2 d-flex justify-content-end">
                    <button id="profileEditBtn" type="submit" class="px-5 py-2 btn btn-primary" disabled>저장
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- 이미지 업로드 Modal -->
    <div class="modal fade" id="imgUploadModal" tabindex="-1" aria-labelledby="imgUploadModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header x-font-medium">
                    <h5 class="modal-title" id="imgUploadModalLabel">프로필 사진 업로드</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body pb-0 x-text-sm x-text-gray-700">
                    <form id="imgUploadForm" class="mb-2" action="/api/v1/me/image" method="put"
                          enctype="multipart/form-data">
                        <input class="form-control" type="file" id="file" name="file" accept="image/jpeg, image/png">
                        <div class="mt-1 x-text-sm x-text-gray-600 x-font-light">권장 사이즈 150px, 최대 250KB</div>
                    </form>
                    <%--                    <div id="imgDownload" class="d-flex justify-content-end"--%>
                    <%--                         style="display:${!empty loginMember.imageName? 'blcok': 'none'};">--%>
                    <%--                        <button id="imgDownloadBtn" class="p-0 pe-1 btn x-link text-truncate text-end" type="button">--%>
                    <%--                            <i class="bi bi-download"></i>--%>
                    <%--                            <span style="text-decoration: underline">다운로드</span>--%>
                    <%--                        </button>--%>
                    <%--                    </div>--%>
                </div>
                <div class="modal-footer d-flex justify-content-end">
                    <button id="imgInitBtn" type="button" class="px-3 py-1 btn btn-outline-secondary">기본사진 사용</button>
                    <button id="imgUploadBtn" type="button" class="px-3 py-1 btn btn-primary" disabled>업로드</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 이미지 업로드 오류 Modal -->
    <div class="modal modal-sm fade" id="imgUploadErrorModal" data-bs-backdrop="static" data-bs-keyboard="false"
         tabindex="-1"
         aria-labelledby="staticBackdropLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body p-4 text-center">
                    <h5 class="modal-title mb-1 x-font-medium" style="font-size: 1.1rem"
                        id="imgUploadErrorModalLabel">
                        프로필 사진 업로드 오류</h5>
                    <div class="x-text-sm x-font-light x-text-gray-600">
                        오류가 발생했습니다. 다시 시도해 주세요.
                    </div>
                    <button type="button" class="mt-4 btn btn-primary form-control" data-bs-dismiss="modal">확인
                    </button>
                </div>
            </div>
        </div>
    </div>
</main>
<footer>
    <%@include file="fragment/footer.jsp" %>
</footer>

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="fragment/script.jsp" %>
</body>
</html>