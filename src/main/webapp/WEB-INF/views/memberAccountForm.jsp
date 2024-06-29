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
            // 부트스트랩 모달 등록
            var errorModal = new bootstrap.Modal(document.getElementById('errorModal'));

            $('#resetPwForm input').keyup(function () {
                var empty = false;
                $('#resetPwForm input').each(function () {
                    if ($(this).val() == '') {
                        empty = true;
                    }
                });

                if (empty) {
                    $('#resetPwBtn').prop('disabled', true);
                } else {
                    $('#resetPwBtn').prop('disabled', false);
                }
            });

            $('#resetPwBtn').click(function () {
                const form = $('#resetPwForm');

                $.ajax({
                    url: '/settings/account/password-reset',
                    type: 'post',
                    data: form.serialize(),
                    success: function (xhr) {
                        if (xhr.status === 'success') {
                            $('#errorModal').find('h5.modal-title').text('비밀번호 변경 성공');
                            $('#errorModal').find('.modal-body > div').text('성공적으로 변경되었습니다.');

                            // 폼 초기화
                            $('#resetPwForm input').val('');
                            $('.x-field-error > div').html('');  // 기존 에러메세지 삭제
                            errorModal.show();
                        }
                    },
                    error: function (xhr) {
                        const errorCode = parseInt(xhr.status / 100);

                        // 폼 초기화
                        $('#resetPwForm input').val('');

                        // 클라이언트 오류는 수정 폼에 오류메세지 표시
                        if (errorCode === 4) {
                            const response = JSON.parse(xhr.responseText);
                            const exMessage = response.exDescription;

                            if (exMessage) {
                                let html = '<i class="me-1 bi bi-exclamation-circle"></i>'
                                    + '<span>' + exMessage + '</span>';
                                $('.x-field-error > div').html('');  // 기존 에러메세지 삭제
                                $(form).find('.x-field-error > div').html(html);  // 에러메세지 표시
                            }
                            return;
                        }

                        // 서버 오류는 모달창 표시
                        if (errorCode === 5) {
                            $('#errorModal').find('h5.modal-title').text('비밀번호 변경 실패');
                            $('#errorModal').find('.modal-body > div').text('오류가 발생했습니다. 다시 시도해 주세요.');
                            errorModal.show();
                        }
                    }
                });
            });

            $('#withdraw-agreements').change(function () {
                if ($(this).is(':checked')) {
                    $('#withdrawalBtn').prop('disabled', false);
                } else {
                    $('#withdrawalBtn').prop('disabled', true);
                }
            });

            $('#withdrawalBtn').click(function () {
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
                    <li class="x-setting-btn list-group-item x-list-group-item x-text-gray-600"><a
                            style="display: block; color:inherit"
                            href="/settings/profile"><i
                            class="me-2 bi bi-person-circle" style="font-size:18px"></i><span style="line-height: 18px">프로필</span></a>
                    </li>
                    <li class="x-setting-btn active list-group-item x-list-group-item x-text-gray-600"><a
                            style="display: block; color:inherit"
                            href="/settings/account"><i
                            class="me-2 bi bi-gear" style="font-size:18px"></i><span
                            style="line-height: 18px">계정관리</span></a></li>
                </ul>
            </div>
        </div>

        <!--    가운데 영역    -->
        <div style="min-width: 340px;">
            <div class="x-main px-sm-5 mb-5">
                <h2 class="mb-4 fs-5 d-flex x-font-semibold">비밀번호 변경</h2>
                <form id="resetPwForm">
                    <div class="d-flex row">
                        <div class="col-12 col-sm-7 mb-4">
                            <div class="mb-2">
                                <div>
                                    <label for="currentPassword" class="form-label"> 현재 비밀번호</label>
                                    <input type="password" class="form-control" name="currentPassword"
                                           id="currentPassword"
                                           placeholder="현재 비밀번호">
                                </div>
                            </div>
                            <div class="mb-2">
                                <div>
                                    <label for="password" class="form-label">비밀번호 변경</label>
                                    <input type="password" class="form-control" name="password" id="password"
                                           placeholder="변경할 비밀번호">
                                </div>
                            </div>
                            <div>
                                <div>
                                    <label for="password" class="form-label">비밀번호 확인</label>
                                    <input type="password" class="form-control" name="passwordCheck" id="passwordCheck"
                                           placeholder="비밀번호를 다시 입력해주세요.">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row d-flex justify-content-end">
                        <div class="col-12 col-sm-8 col-lg-9 x-field-error">
                            <div class="my-auto"></div>
                        </div>
                        <div class="col-12 col-sm-4 col-lg-3">
                            <button id="resetPwBtn" class="my-4 py-2 btn btn-primary x-width-full" type="button"
                                    disabled>저장
                            </button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="x-main border-top px-sm-5 pt-5">
                <h2 class="mb-3 fs-5 d-flex x-font-semibold">계정삭제</h2>
                <div class="mb-2 py-3 px-2 small rounded-3 x-text-gray-600" style="border: 1px solid #adb5bd">
                    <p class="mb-0">탈퇴 즉시 모든 개인 정보는 완전히 삭제되며 더 이상 복구할 수 없게 됩니다. 게시물은 삭제되지 않으며, 익명처리 후 Bangcom으로 소유권이
                        귀속됩니다.</p>
                </div>
                <div class="d-flex row justify-content-between">
                    <div class="d-flex align-items-center col-12 col-sm-8 col-lg-9">
                        <input id="withdraw-agreements" name="agreements" type="checkbox" class="me-2">
                        <label class="x-text-sm" for="withdraw-agreements">계정 삭제에 관한 정책을 읽고 이에 동의합니다.</label>
                    </div>
                    <div class="col-12 col-sm-4 col-lg-3">
                        <button id="withdrawalBtn" disabled type="button"
                                class="position-relative my-4 py-2 btn btn-danger x-width-full"><i
                                class="position-absolute bi bi-person-slash"
                                style="top: 10%; left: 5%; font-size: 1.2rem"></i><span class="ps-2">회원탈퇴</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- 오류 Modal -->
    <div class="modal modal-sm fade" id="errorModal" data-bs-backdrop="static" data-bs-keyboard="false"
         tabindex="-1"
         aria-labelledby="staticBackdropLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body p-4 text-center">
                    <h5 class="modal-title mb-1 x-font-medium" style="font-size: 1.1rem"
                        id="errorModalLabel">
                        오류 발생</h5>
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