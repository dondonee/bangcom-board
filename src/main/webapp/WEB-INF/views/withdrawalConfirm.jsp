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
    <title>Bangcom - 회원탈퇴</title>
    <script>
        $(document).ready(function () {
            $('#reasonCode').on('change', function () {
                if ($(this).val() == 'ETC') {
                    $('#reasonText').prop('disabled', false)
                    $('#reasonText').trigger('change');
                } else {
                    $('#reasonText').prop('disabled', true);
                    $('#submitBtn').prop('disabled', false);
                }
            });

            $('#reasonText').on('change', function () {
                let text = $('#reasonText').val();
                if (text.trim() === '') {
                    $('#submitBtn').prop('disabled', true);
                } else {
                    $('#submitBtn').prop('disabled', false);
                }
            });

            $('#submitBtn').on('click', function () {
                // 탈퇴 사유 선택 확인
                const code = $('#reasonCode option:selected').val();
                if (code == '') { // 탈퇴 사유 미선택
                    $('#reasonCode').focus();
                    return;
                } else if (code === 'ETC') {  // 탈퇴 사유: 기타 선택
                    // 기타 선택 시 reasonText 확인
                    const text = $('#reasonText').val();
                    if (text.trim() === '') {
                        $('#reasonText').val('');
                        $('#reasonText').focus();
                        return;
                    }
                }

                $.ajax({
                    url: '/api/v1/me/withdrawal',
                    type: 'post',
                    data: $('#form').serialize(),
                    success: function (xhr) {
                        const response = JSON.parse(xhr.responseText);
                        const status = response.status;
                        if (status == 'success') {
                            location.href = '/withdrawal-complete';
                        } else {
                            $('#errorModal').modal('show');
                        }
                    },
                    error: function (xhr) {
                        const response = JSON.parse(xhr.responseText);
                        const title = response.title;
                        const message = response.message;

                        let clone = $('#errorModal').clone();
                        clone.find('.modal-title').text(title);
                        clone.find('.modal-body > div').text(message);

                        let errorModal = new bootstrap.Modal(clone, {backdrop: 'static'});
                        errorModal.show();
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="d-flex justify-content-center x-margin-top__form x-paddingx-v640">
    <div class="x-max-width-md x-width-full pb-5">
        <div class="mb-4 text-center">
            <h3 class="mt-4 fs-3 x-font-bold">회원 탈퇴 시 아래와 같이 처리됩니다.</h3>
        </div>
        <div class="mb-4 py-4 px-3 small rounded-3 x-text-gray-700 x-width-full text-center"
             style="background-color: #F9FAFB">
            <p>모든 개인 정보는 완전히 삭제되며 더 이상 복구할 수 없게 됩니다. 게시물은 삭제되지 않으며, 익명처리 후 Bangcom으로 소유권이 귀속됩니다.</p>
        </div>
        <form id="form" action="/settings/withdrawal" method="post">
            <div class="mb-2">
                <div>
                    <div>
                        <label class="form-label">탈퇴 사유</label>
                        <select class="form-select form-select-md" name="reasonCode" id="reasonCode">
                            <option value="" selected disabled>탈퇴 사유를 선택해 주세요.</option>
                            <option value="NO_LONGER_RELEVANT">졸업/휴학/편입 등으로 더 이상 이용하지 않음</option>
                            <option value="USING_OTHER_SERVICE">다른 커뮤니티 사용</option>
                            <option value="LOW_FREQUENCY_USE">접속 빈도 낮음</option>
                            <option value="ETC">기타</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="mb-4">
                <div>
                    <textarea disabled type="text" class="form-control" name="reasonText" id="reasonText"
                              placeholder="(기타를 선택한 경우) 탈퇴 사유를 작성해 주세요." value="${form.loginName}"></textarea>
                </div>
            </div>
            <div class="d-flex">
                <a href="/settings/account" class="me-2 my-4 py-2 col-6 btn btn-outline-secondary">취소</a>
                <button id="submitBtn" disabled type="button" class="my-4 py-2 col-6 btn btn-danger">예, 탈퇴하겠습니다.
                </button>
            </div>
        </form>
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

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="fragment/script.jsp" %>
</body>
</html>