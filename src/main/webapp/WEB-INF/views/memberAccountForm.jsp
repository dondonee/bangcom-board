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
            $('#withdraw-agreements').change(function () {
                if ($(this).is(':checked')) {
                    $('#submitBtn').prop('disabled', false);
                } else {
                    $('#submitBtn').prop('disabled', true);
                }
            });

            $('#submitBtn').click(function () {
                if ($('#withdraw-agreements').is(':checked')) {
                    location.href = '/withdrawal';
                }
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
        <div class="x-aside__bi" style="border-right: 1px solid #dee2e6">
            <div class="ps-2">
                <div class="pb-2">
                    <span class="x-font-medium" style="font-size: 1.15rem">내 계정</span>
                </div>
                <ul class="list-group">
                    <li class="x-setting-btn list-group-item x-list-group-item x-text-gray-600"><a style="display: block; color:inherit"
                                                                                     href="/settings/profile"><i
                            class="me-2 bi bi-person-circle" style="font-size:18px"></i><span style="line-height: 18px">프로필</span></a>
                    </li>
                    <li class="x-setting-btn active list-group-item x-list-group-item x-text-gray-600"><a style="display: block; color:inherit"
                                                                                            href="/settings/account"><i
                            class="me-2 bi bi-gear" style="font-size:18px"></i><span
                            style="line-height: 18px">계정관리</span></a></li>
                </ul>
            </div>
        </div>

        <!--    가운데 영역    -->
        <div style="min-width: 340px;">
            <div class="x-main px-sm-5 mb-5">
                <h2 class="fs-5 d-flex x-font-semibold">비밀번호 변경</h2>
            </div>
            <div class="x-main border-top px-sm-5 pt-5">
                <h2 class="mb-3 fs-5 d-flex x-font-semibold">계정삭제</h2>
                <div class="mb-2 py-3 px-2 small rounded-3 x-text-gray-600" style="border: 1px solid #adb5bd">
                    <p class="mb-0">탈퇴 즉시 모든 개인 정보는 완전히 삭제되며 더 이상 복구할 수 없게 됩니다. 게시물은 삭제되지 않으며, 익명처리 후 Bangcom으로 소유권이 귀속됩니다.</p>
                </div>
                <div class="d-flex row justify-content-between">
                    <div class="d-flex align-items-center col-12 col-sm-9">
                    <input id="withdraw-agreements" name="agreements" type="checkbox" class="me-1">
                        <label class="x-text-sm" for="withdraw-agreements">계정 삭제에 관한 정책을 읽고 이에 동의합니다.</label>
                    </div>
                    <div class="col-12 col-sm-3">
                    <button id="submitBtn" disabled type="button" class="position-relative my-4 py-2 btn btn-danger x-width-full"><i class="position-absolute bi bi-person-slash" style="top: 10%; left: 5%; font-size: 1.2rem"></i><span class="ps-2">회원탈퇴</span></button>
                    </div>
                </div>
            </div>
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
                    <form id="imgUploadForm" class="mb-2" action="${cpath}/settings/profile/image" method="post"
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
                    <button id="imgUploadBtn" type="button" class="px-3 py-1 btn btn-primary">업로드</button>
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