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
        // 댓글 작성일 경과 계산
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

        // JSON 응답 -> 댓글 목록 HTML 생성
        function makeCommentsHTML(xhr) {
            var html = '';
            const loginMember = xhr.loginMember;

            // Root 반복문
            for (let i = 0; i < xhr.comments.length; i++) {
                const vo = xhr.comments[i];
                const branchSize = vo.branchComments.length;

                // Branch 댓글 영역 생성
                let branchBtnHtml = '';
                let branchesHtml = '';

                if (branchSize > 0) {  // Branch 댓글이 있는 경우
                    // 댓글 보기 토글 버튼
                    branchBtnHtml += '<button id="toggleBranchesOf' + vo.id + '" class="ps-0 pe-2 btn x-btn-comments x-text-xs d-flex" type="button">'
                        + '<span style="display: block"><i class="me-1 bi bi-chevron-down"></i>댓글' + branchSize + '개 보기</span>'
                        + '<span style="display: none"><i class="me-1 bi bi-chevron-up"></i>댓글 모두 숨기기</span>'
                        + '</button>';

                    // Branch 반복문
                    for (let j = 0; j < branchSize; j++) {

                        const bvo = vo.branchComments[j];
                        const bvoImageName = bvo.writer.imageName || 'temporary.gif';
                        const bvoNickname = bvo.writer.nickname || '(알 수 없음)';
                        let bvoGradeRegionHtml = '';
                        if (bvo.writer.nickname) {
                            bvoGradeRegionHtml += '<span>' + bvo.writer.grade + ' / ' + bvo.writer.region + '</span>'
                                + '<span>·</span>'
                        }

                        // 대댓글의 댓글인 경우 '@닉네임' 표시
                        let mentionedHtml = ''
                        if (bvo.depthNo > 1) {
                            mentionedHtml += '<div>'
                                + '<span class="x-mention rounded-pill">@' + bvo.parentCommentInfo.mentionedName + '</span>'
                                + '</div>'
                        }
                        // 작성자 == 로그인 사용자 -> 수정 & 삭제 버튼
                        let branchEditBtnHtml = '';
                        if (bvo.writer.userNo == loginMember.userNo) {

                            let branchDataAttr = '';
                            if (bvo.depthNo > 1) {
                                branchDataAttr = 'data-comment="branch2" data-mentioned="' + bvo.parentCommentInfo.mentionedName + '"';
                            } else {
                                branchDataAttr = 'data-comment="branch"';
                            }

                            branchEditBtnHtml += '<div class="dropdown d-flex align-items-center">'
                                + '<button class="dropdown-toggle" style="background: none; border: none;" type="button" id="dropdownMenuButtonOf' + bvo.id + '" data-bs-toggle="dropdown" aria-expanded="false">'
                                + ' <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#6c757d" class="bi bi-three-dots x-text-gray-700" viewBox="0 0 16 16">'
                                + '     <path d="M3 9.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3"/>'
                                + ' </svg>'
                                + '</button>'
                                + '<ul class="dropdown-menu dropdown-menu-end x-text-sm x-text-gray-700" aria-labelledby="dropdownMenuButton' + bvo.id + '">'
                                + ' <li><button id="commentEditFormBtnOf' + bvo.id + '" data-root="' + vo.id + '" ' + branchDataAttr + ' type="button" class="dropdown-item" href="#"><i class="me-1 bi bi-pencil-square"></i>수정하기</button></li>'
                                + ' <li><button id="commentDeleteBtnOf' + bvo.id + '" data-root="' + vo.id + '" type="button" class="dropdown-item"><i class="me-1 bi bi-trash3"></i>삭제하기</a></button></li>'
                                + '</ul>'
                                + '</div>';
                        }

                        let borderTop = '';
                        if (j !== 0) {
                            borderTop = ' x-border-top-dashed';
                        }

                        let marginTop = '';
                        if (bvo.depthNo > 1) {
                            marginTop = 'mt-0';
                        } else {
                            marginTop = 'mt-2';
                        }

                        branchesHtml += '<li class="py-3' + borderTop + '">'
                            + '<div id="commentOf' + bvo.id + '">'
                            // 작성자 정보 및 부가 메뉴
                            + ' <div class="d-flex justify-content-between">'
                            + '     <div class="d-flex">'
                            + '         <div class="me-2">'
                            + '         <a href="/members/' + bvo.writer.userNo + '"><img src="/images/profile/' + bvoImageName + '" class="x-comment-profile-img x-border-thin rounded-circle" alt="프로필사진"></a>'
                            + '     </div>'
                            + '     <div class="d-flex flex-column my-auto">'
                            + '         <a class="x-text-sm" href="/members/' + bvo.writer.userNo + '">' + bvoNickname + '</a>'
                            + '         <div class="x-text-xs x-text-gray-600 x-font-light" style="line-height: 1.2rem">'
                            + bvoGradeRegionHtml
                            + '             <span class="">' + getElapsedTime(bvo.createdDate) + '</span>'
                            + '         </div>'
                            + '     </div>'
                            + ' </div>'
                            + branchEditBtnHtml  // 로그인 사용자 == 작성자 -> 수정 & 삭제 버튼
                            + '</div>'
                            + ' <div class="' + marginTop + ' mb-2 x-text-sm x-text-gray-800">'
                            + mentionedHtml // 대댓글의 댓글인 경우 '@닉네임' 표시
                            + '     <div id="contentOf' + bvo.id + '"  style="white-space: pre">'
                            + '     </div>'
                            + ' </div>'
                            + ' <div class="mb-2">'
                            + ' <button id="commentAddFormBtnOf' + bvo.id + '" data-root="' + vo.id + '" data-mentioned="' + bvo.parentCommentInfo.mentionedName + '" type="button" class="px-0 btn x-btn-comment x-text-xs">'
                            + '댓글 쓰기'
                            + ' </button>'
                            + ' </div>'
                            + '</div>'
                            + '</li>'
                    }
                }

                const imageName = vo.writer.imageName || 'temporary.gif';
                const nickname = vo.writer.nickname || '(알 수 없음)';
                let gradeRegionHtml = '';
                if (vo.writer.nickname) {
                    gradeRegionHtml += '<span>' + vo.writer.grade + ' / ' + vo.writer.region + '</span>'
                    + '<span>·</span>'
                }

                let editBtnHtml = '';
                if (vo.writer.userNo == loginMember.userNo) {
                    editBtnHtml += '<div class="dropdown d-flex align-items-center">'
                        + '<button class="dropdown-toggle" style="background: none; border: none;" type="button" id="dropdownMenuButtonOf' + vo.id + '" data-bs-toggle="dropdown" aria-expanded="false">'
                        + ' <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#6c757d" class="bi bi-three-dots x-text-gray-700" viewBox="0 0 16 16">'
                        + '     <path d="M3 9.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3"/>'
                        + ' </svg>'
                        + '</button>'
                        + '<ul class="dropdown-menu dropdown-menu-end x-text-sm x-text-gray-700" aria-labelledby="dropdownMenuButton' + vo.id + '">'
                        + ' <li><button id="commentEditFormBtnOf' + vo.id + '" data-comment="root" type="button" class="dropdown-item" href="#"><i class="me-1 bi bi-pencil-square"></i>수정하기</button></li>'
                        + ' <li><button id="commentDeleteBtnOf' + vo.id + '" type="button" class="dropdown-item"><i class="me-1 bi bi-trash3"></i>삭제하기</a></button></li>'
                        + '</ul>'
                        + '</div>';
                }

                // Root 댓글 영역
                html += '<li class="py-3 border-top text-decoration-none">'
                    + '<div id="commentOf' + vo.id + '">'
                    // 작성자 정보 및 부가 메뉴
                    + ' <div class="d-flex justify-content-between">'
                    + '     <div class="d-flex">'
                    + '         <div class="me-2">'
                    + '             <a href="/members/' + vo.writer.userNo + '"><img src="/images/profile/' + imageName + '" class="x-comment-profile-img -border-thin rounded-circle" alt="프로필사진"></a>'
                    + '         </div>'
                    + '         <div class="d-flex flex-column my-auto">'
                    + '             <a class="x-text-sm" href="/members/' + vo.writer.userNo + '">' + nickname + '</a>'
                    + '             <div class="x-text-xs x-text-gray-600 x-font-light" style="line-height: 1.2rem">'
                    + gradeRegionHtml
                    + '                 <span class="">' + getElapsedTime(vo.createdDate) + '</span>'
                    + '             </div>'
                    + '         </div>'
                    + '     </div>'
                    + editBtnHtml
                    + ' </div>'
                    + ' <div class="my-2 x-text-sm x-text-gray-800">'
                    + '     <div id="contentOf' + vo.id + '"  style="white-space: pre">'
                    + '     </div>'
                    + ' </div>'
                    + ' <div class="mb-2 d-flex">'
                    + branchBtnHtml
                    + '     <button id="commentAddFormBtnOf' + vo.id + '" data-comment="root" data-root="' + vo.id + '" type="button" class="px-0 btn x-btn-comment x-text-xs">'
                    + '댓글 쓰기'
                    + '     </button>'
                    + ' </div>'
                    + '</div>'
                    // Branch 댓글
                    + '<div id="branchesOf' + vo.id + '" style="display:none;">'
                    + ' <div>'
                    + ' <ul class="ms-2 ps-3 list-unstyled" style="border-left: 2px solid #dee2e6">'
                    + branchesHtml  // Branch 댓글 목록
                    + ' </ul>'
                    + ' </div>'
                    + '</div>'
                    + '</li>';
            }

            return html;
        }

        function putContentsIntoHTML(xhr) {
            for (let i = 0; i < xhr.comments.length; i++) {
                const vo = xhr.comments[i];
                $('#contentOf' + vo.id).text(vo.content);
                if (vo.branchComments.length > 0) {
                    for (let j = 0; j < vo.branchComments.length; j++) {
                        const bvo = vo.branchComments[j];
                        $('#contentOf' + bvo.id).text(bvo.content);
                    }
                }
            }
        }

        $(document).ready(function () {
            // 부트스트랩 모달 등록
            var postDeleteModal = new bootstrap.Modal(document.getElementById('postDeleteModal'));
            var commentDeleteModal = new bootstrap.Modal(document.getElementById('commentDeleteModal'));
            var errorModal = new bootstrap.Modal(document.getElementById('errorModal'), {backdrop: 'static'});

            // 게시글 삭제 버튼 -> 확인 모달
            $(document).on('click', '#postDeleteBtn', function (e) {
                postDeleteModal.show();
            });

            // 대댓글 목록 토글
            $(document).on('click', 'button[id^="toggleBranchesOf"]', function (e) { // 대댓글 목록 보기 토글
                const button = $(e.currentTarget);
                const areaId = button.attr('id').replace(/^toggleB/, 'b');
                const area = $('#' + areaId);
                const areaDisplay = area.css('display');

                if (areaDisplay == 'block') {
                    area.css('display', 'none');
                    button.find('span:first').css('display', 'block');
                    button.find('span:last').css('display', 'none');
                } else {
                    area.css('display', 'block');
                    button.find('span:first').css('display', 'none');
                    button.find('span:last').css('display', 'block');
                }
            });

            // 대댓글 작성 버튼 -> 작성 폼
            $(document).on('click', 'button[id^="commentAddFormBtnOf"]', function (e) {

                const button = $(e.currentTarget);

                const parentCommentId = button.attr('id').replace(/^commentAddFormBtnOf/, '');
                const rootCommentId = button.attr('data-root');
                const addBoxId = 'commentAddBoxOf' + parentCommentId;

                if (!document.getElementById(addBoxId)) {  // 작성 폼이 없는 경우
                    // 대댓글 작성 폼 만들기
                    var clone = $('#addBranch').clone();
                    if (button.attr('data-comment') === 'root') {  // 댓글인 경우
                        $(clone).find('> div').css('border-left', '2px solid #dee2e6').addClass('ms-2 p-3');
                    } else {  // 대댓글인 경우
                        const mentioned = button.attr('data-mentioned') || '(알 수 없음)';
                        $(clone).find('> div').css('border-left', '')
                        $(clone).find('div.form-control').prepend('<div class="ps-2"><span class="x-mention rounded-pill">@' + mentioned + '</span></div>');
                    }
                    $(clone).find('> div').attr('id', addBoxId);
                    $(clone).find('form').attr('id', 'commentAddFormOf' + parentCommentId);
                    $(clone).find('form input[name="parentId"]').val(parentCommentId);
                    $(clone).find('button[data-role="cancel"]').attr('id', 'commentAddCancelBtnOf' + parentCommentId);
                    $(clone).find('button[data-role="submit"]').attr('id', 'commentAddBtnOf' + parentCommentId).attr('data-root', rootCommentId);

                    // 다른 수정, 작성 폼 닫기
                    $('button[id^="commentAddCancelBtnOf"]').trigger('click');
                    $('button[id^="commentEditCancelBtnOf"]').trigger('click');
                    $('#commentOf' + parentCommentId).append(clone.html());
                    button.text('댓글 취소');

                } else {  // 작성 폼이 생성되어 있는 경우
                    const addBox = $('#' + addBoxId);
                    if (addBox.is(':visible')) {  // 폼 숨기기
                        addBox.addClass('d-none');
                        button.text('댓글 쓰기');
                    } else {  // 폼 보이기
                        // 다른 수정, 작성 폼 닫기
                        $('button[id^="commentAddCancelBtnOf"]').trigger('click');
                        $('button[id^="commentEditCancelBtnOf"]').trigger('click');
                        addBox.removeClass('d-none');
                        button.text('댓글 취소');
                    }
                }
            });
            // 대댓글 작성 폼 '취소' 버튼 -> 폼 숨기기
            $(document).on('click', 'button[id^="commentAddCancelBtnOf"]', function (e) {
                const button = $(e.currentTarget);
                const parentCommentId = button.attr('id').replace(/^commentAddCancelBtnOf/, '');
                const addBox = $('#commentAddBoxOf' + parentCommentId);
                addBox.addClass('d-none');
                button.text('댓글 쓰기');
                $('#commentAddFormBtnOf' + parentCommentId).text('댓글 쓰기');
            });
            // 댓글 작성 ajax 요청
            $(document).on('click', 'button[id^="commentAddBtn"]', function (e) {
                const form = e.currentTarget.closest('form');
                const rootCommentId = e.currentTarget.getAttribute('data-root');
                $.ajax({
                    url: '/articles/comments',
                    type: 'POST',
                    data: $(form).serializeArray(),
                    success: function (xhr) {  // 댓글 목록 갱신

                        // 댓글 목록 HTML
                        const html = makeCommentsHTML(xhr);
                        $('#commentList').html(html);
                        $('#commentList li:first').removeClass('border-top');
                        $('#commentTotal').text(xhr.comments.length);
                        // content 내용 초기화
                        putContentsIntoHTML(xhr);

                        // 모든 댓글 작성 폼 초기화
                        $('.x-field-error').html('');
                        $(form).find('textarea').val('');

                        // 작성한 글이 대댓글인 경우 대댓글 목록 토글 열기
                        if (rootCommentId) {
                            $('#toggleBranchesOf' + rootCommentId).trigger('click');
                        }
                    },
                    error: function (xhr) {
                        const errorCode = parseInt(xhr.status / 100);

                        // 클라이언트 오류는 등록 폼에 오류메세지 표시
                        if (errorCode === 4) {
                            const response = JSON.parse(xhr.responseText);
                            const exMessage = response.exMessage;

                            if (exMessage) {
                                let html = '<i class="me-1 bi bi-exclamation-circle"></i>'
                                    + '<span>' + exMessage + '</span>';
                                $('.x-field-error').html('');  // 다른 작성 폼의 에러메세지 삭제
                                $(form).find('.x-field-error').html(html);  // 해당 작성 폼에 에러메세지 표시
                            }
                        }
                        // 작성 내용이 empty인 경우 초기화
                        if ($(form).find('textarea').val().trim() === '') {
                            $(form).find('textarea').val('');
                        }

                        // 서버 오류는 모달창 표시
                        if (errorCode === 5) {
                            $('#errorModal').find('h5.modal-title').text('댓글 등록 실패');
                            $('#errorModal').find('.modal-body > div').text('오류가 발생했습니다. 다시 시도해 주세요.');
                            errorModal.show();
                        }
                    }
                });
            });

            // 댓글 수정 버튼 -> 수정 폼
            $(document).on('click', 'button[id^="commentEditFormBtnOf"]', function (e) {

                const button = $(e.currentTarget);

                const commentId = button.attr('id').replace(/^commentEditFormBtnOf/, '');
                const rootCommentId = button.attr('data-root');
                let writerDiv = $('#commentOf' + commentId).find('> div:first');
                let contentDiv = $('#commentOf' + commentId).find('> div:nth-child(2)');
                const content = $('#contentOf' + commentId).text();
                const editBoxId = 'commentEditBoxOf' + commentId;

                if (!document.getElementById(editBoxId)) {  // 작성 폼이 없는 경우
                    // 대댓글 작성 폼 만들기
                    var clone = $('#addBranch').clone();
                    if (button.attr('data-comment') === 'root') {  // 댓글인 경우
                    } else if (button.attr('data-comment') === 'branch') {  // 대댓글인 경우
                        $(clone).find('> div').css('border-left', '')
                    } else {  // depthNo > 1인 대댓글인 경우 - '@닉네임' 표시
                        const mentioned = button.attr('data-mentioned');
                        $(clone).find('> div').css('border-left', '')
                        $(clone).find('div.form-control').prepend('<div class="ps-2"><span class="x-mention rounded-pill">@' + mentioned + '</span></div>');
                    }
                    $(clone).find('> div').attr('id', editBoxId);
                    $(clone).find('form').attr('id', 'commentEditFormOf' + commentId);
                    $(clone).find('form textarea').text(content);
                    $(clone).find('button[data-role="cancel"]').attr('id', 'commentEditCancelBtnOf' + commentId);
                    $(clone).find('button[data-role="submit"]').attr('id', 'commentEditBtnOf' + commentId);
                    $(clone).find('button[data-role="submit"]').text('수정하기');
                    if (button.attr('data-comment') !== 'root') {
                        $(clone).find('button[data-role="submit"]').attr('data-root', rootCommentId);
                    }

                    // 다른 수정, 작성 폼 닫기
                    $('button[id^="commentEditCancelBtnOf"]').trigger('click');
                    $('button[id^="commentAddCancelBtnOf"]').trigger('click');

                    writerDiv.addClass('d-none');
                    contentDiv.addClass('d-none');
                    contentDiv.after(clone.html());
                } else {  // 작성 폼이 생성되어 있는 경우
                    const editBox = $('#' + editBoxId);
                    if (editBox.is(':visible')) {  // 폼 숨기기
                        writerDiv.removeClass('d-none');
                        contentDiv.removeClass('d-none');
                        editBox.addClass('d-none');
                    } else {  // 폼 보이기
                        // 다른 수정, 작성 폼 닫기
                        $('button[id^="commentEditCancelBtnOf"]').trigger('click');
                        $('button[id^="commentAddCancelBtnOf"]').trigger('click');

                        writerDiv.addClass('d-none');
                        contentDiv.addClass('d-none');
                        editBox.removeClass('d-none');
                    }
                }
            });
            // 댓글 수정 폼 '취소' 버튼 -> 폼 숨기기
            $(document).on('click', 'button[id^="commentEditCancelBtnOf"]', function (e) {
                const button = $(e.currentTarget);
                const commentId = button.attr('id').replace(/^commentEditCancelBtnOf/, '');
                const editBox = $('#commentEditBoxOf' + commentId);
                editBox.addClass('d-none');

                let writerDiv = $('#commentOf' + commentId).find('> div:nth-child(1)');
                let contentDiv = $('#commentOf' + commentId).find('> div:nth-child(2)');

                writerDiv.removeClass('d-none');
                contentDiv.removeClass('d-none');
            });
            // 댓글 수정 ajax 요청
            $(document).on('click', 'button[id^="commentEditBtnOf"]', function (e) {

                const button = $(e.currentTarget);
                const form = e.currentTarget.closest('form');
                const commentId = button.attr('id').replace(/^commentEditBtnOf/, '');
                const rootCommentId = e.currentTarget.getAttribute('data-root');

                $.ajax({
                    url: '/articles/comments/' + commentId,
                    type: 'PUT',
                    data: $(form).serializeArray(),
                    success: function (xhr) {  // 댓글 목록 갱신

                        // 댓글 목록 HTML
                        const html = makeCommentsHTML(xhr);
                        $('#commentList').html(html);
                        $('#commentList li:first').removeClass('border-top');
                        $('#commentTotal').text(xhr.length);
                        // content 내용 초기화
                        putContentsIntoHTML(xhr);

                        // 모든 댓글 작성 폼 초기화
                        $('.x-field-error').html('');
                        $(form).find('textarea').val('');

                        // 작성한 글이 대댓글인 경우 대댓글 목록 토글 열기
                        if (rootCommentId) {
                            $('#toggleBranchesOf' + rootCommentId).trigger('click');
                        }
                    },
                    error: function (xhr) {
                        const errorCode = parseInt(xhr.status / 100);

                        // 클라이언트 오류는 수정 폼에 오류메세지 표시
                        if (errorCode === 4) {
                            const response = JSON.parse(xhr.responseText);
                            const exMessage = response.exMessage;

                            if (exMessage) {
                                let html = '<i class="me-1 bi bi-exclamation-circle"></i>'
                                    + '<span>' + exMessage + '</span>';
                                $('.x-field-error').html('');  // 다른 작성 폼의 에러메세지 삭제
                                $(form).find('.x-field-error').html(html);  // 해당 작성 폼에 에러메세지 표시
                            }
                        }
                        // 작성 내용이 empty인 경우 초기화
                        if ($(form).find('textarea').val().trim() === '') {
                            $(form).find('textarea').val('');
                        }

                        // 서버 오류는 모달창 표시
                        if (errorCode === 5) {
                            $('#errorModal').find('h5.modal-title').text('댓글 수정 실패');
                            $('#errorModal').find('.modal-body > div').text('오류가 발생했습니다. 다시 시도해 주세요.');
                            errorModal.show();
                        }
                    }
                });
            });

            // 댓글 삭제 버튼 -> 확인 모달
            $(document).on('click', 'button[id^="commentDeleteBtnOf"]', function (e) {
                const button = $(e.currentTarget);

                // 버튼 고유 id 추가
                const commentId = button.attr('id').replace(/^commentDeleteBtnOf/, '');
                $('#commentDeleteModal').find('button[data-role="delete"]').attr('id', 'commentDeleteOf' + commentId);
                // 대댓글일 경우 rootCommentId 추가
                if (button.attr('data-comment') !== 'root') {
                    const rootCommentId = button.attr('data-root');
                    $('#commentDeleteModal').find('button[data-role="delete"]').attr('data-root', rootCommentId);
                }

                commentDeleteModal.show();
            });
            // 댓글 삭제 ajax 요청
            $(document).on('click', 'button[id^="commentDeleteOf"]', function (e) {
                const button = $(e.currentTarget);
                const commentId = button.attr('id').replace(/^commentDeleteOf/, '');
                const rootCommentId = button.attr('data-root');

                $.ajax({
                    url: '/articles/comments/' + commentId,
                    type: 'DELETE',
                    success: function (xhr) {
                        // 기존 모달 닫기
                        commentDeleteModal.hide();

                        // 댓글 리스트 갱신
                        const html = makeCommentsHTML(xhr);
                        $('#commentList').html(html);
                        $('#commentList li:first').removeClass('border-top');
                        $('#commentTotal').text(xhr.comments.length);
                        // content 내용 초기화
                        putContentsIntoHTML(xhr);

                        //작성한 글이 대댓글인 경우 대댓글 목록 토글 열기
                        if (rootCommentId) {
                            $('#toggleBranchesOf' + rootCommentId).trigger('click');
                        }

                    },
                    error: function (xhr) {
                        const errorCode = parseInt(xhr.status / 100);

                        // 클라이언트 오류 -> 안내 오류메세지 표시
                        if (errorCode === 4) {
                            const response = JSON.parse(xhr.responseText);
                            const exMessage = response.exMessage;
                            const exDescription = response.exDescription;

                            $('#errorModal').find('h5.modal-title').text(exMessage);
                            $('#errorModal').find('.modal-body > div').text(exDescription);
                            errorModal.show();
                            commentDeleteModal.hide();
                        }

                        // 서버 오류 -> 기본 오류메세지 표시
                        if (errorCode === 5) {
                            $('#errorModal').find('h5.modal-title').text('댓글 삭제 실패');
                            $('#errorModal').find('.modal-body > div').text('오류가 발생했습니다. 다시 시도해 주세요.');
                            errorModal.show();
                            commentDeleteModal.hide();
                        }
                    }
                });
            });
        })
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
                        <a href="/members/${post.author.userNo}">
                            <img src="/images/profile/${not empty post.author.imageName? post.author.imageName: 'temporary.gif'}"
                                 style="width: 40px; height: 40px;"
                                 alt="프로필사진">
                        </a>
                    </div>
                    <div class="ms-2 d-flex flex-column">
                        <a href="/members/${post.author.userNo}">${not empty post.author.nickname? post.author.nickname: '(알 수 없음)'}</a>
                        <div class="x-text-sm x-text-gray-700" style="line-height: 1.2rem">
                            <c:if test="${not empty post.author.nickname}">
                                <span>${post.author.grade.description} / ${post.author.region.description}</span>
                                <span>·</span>
                            </c:if>
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
                                <button id="postDeleteBtn" type="button" class="dropdown-item">
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
                    <span id="commentTotal">${comments.size()}</span>개의 댓글
                </div>
                <%--    댓글 작성 폼    --%>
                <div class="mt-4 mb-5 p-3 d-flex border rounded">
                    <div class="me-3">
                        <img class="x-comment-profile-img x-border-thin rounded-circle"
                             src="/images/profile/${loginMember.imageName ne null? loginMember.imageName: 'temporary.gif'}"
                             style="border:1px solid #f8f9fa">
                    </div>
                    <form id="commentAddForm" action="/articles/comments" method="post" class="w-100">
                        <c:if test="${!empty loginMember}">
                            <input type="hidden" name="postId" id="postId" value="${post.id}">
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
                            <div class="mt-1 me-2 x-field-error"></div>
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
                                    <%--    Root 댓글    --%>
                                <div id="commentOf${vo.id}">
                                    <div class="d-flex justify-content-between">
                                            <%--    댓글 작성자 정보    --%>
                                        <div class="d-flex">
                                            <div class="me-2">
                                                <a href="/members/${vo.writer.userNo}"><img
                                                        src="/images/profile/${vo.writer.imageName ne null? vo.writer.imageName: 'temporary.gif'}"
                                                        class="x-comment-profile-img x-border-thin rounded-circle"
                                                        alt="프로필사진"></a>
                                            </div>
                                            <div class="d-flex flex-column my-auto">
                                                <a class="x-text-sm"
                                                   href="/members/${vo.writer.userNo}">${not empty vo.writer.nickname? vo.writer.nickname: '(알 수 없음)'}</a>
                                                <div class="x-text-xs x-text-gray-600 x-font-light"
                                                     style="line-height: 1.2rem">
                                                    <c:if test="${not empty vo.writer.nickname}">
                                                    <span>${vo.writer.grade.description} / ${vo.writer.region.description}</span>
                                                    <span>·</span>
                                                    </c:if>
                                                    <span class="">${customFn.getElapsedTime(vo.createdDate)}</span>
                                                </div>
                                            </div>
                                        </div>
                                            <%--    부가 메뉴    --%>
                                        <c:if test="${vo.writer.userNo eq loginMember.userNo}">
                                            <div class="dropdown d-flex align-items-center">
                                                <button class="dropdown-toggle" style="background: none; border: none;"
                                                        type="button"
                                                        id="dropdownMenuButtonOf${vo.id}" data-bs-toggle="dropdown"
                                                        aria-expanded="false">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                         fill="#6c757d"
                                                         class="bi bi-three-dots x-text-gray-700" viewBox="0 0 16 16">
                                                        <path d="M3 9.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3"/>
                                                    </svg>
                                                </button>
                                                <ul class="dropdown-menu dropdown-menu-end x-text-sm x-text-gray-700"
                                                    aria-labelledby="dropdownMenuButton${vo.id}">
                                                    <li>
                                                        <button id="commentEditFormBtnOf${vo.id}" data-comment="root"
                                                                type="button" class="dropdown-item" href="#"><i
                                                                class="me-1 bi bi-pencil-square"></i>수정하기
                                                        </button>
                                                    </li>
                                                    <li>
                                                        <button id="commentDeleteBtnOf${vo.id}" data-comment="root"
                                                                type="button"
                                                                class="dropdown-item">
                                                            <i class="me-1 bi bi-trash3"></i>삭제하기</a>
                                                        </button>
                                                    </li>
                                                </ul>
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="my-2 x-text-sm x-text-gray-800">
                                        <div id="contentOf${vo.id}" style="white-space: pre"><c:out
                                                value="${vo.content}"></c:out></div>
                                    </div>
                                    <div class="mb-2 d-flex">
                                        <c:if test="${vo.branchComments.size() > 0}">
                                            <button id="toggleBranchesOf${vo.id}"
                                                    class="ps-0 pe-2 btn x-btn-comments x-text-xs d-flex"
                                                    type="button">
                                                <span style="display: block"><i
                                                        class="me-1 bi bi-chevron-down"></i>댓글 ${vo.branchComments.size()}개 보기</span>
                                                <span style="display: none"><i class="me-1 bi bi-chevron-up"></i>댓글 모두 숨기기</span>
                                            </button>
                                        </c:if>
                                        <c:if test="${not empty loginMember}">
                                            <button id="commentAddFormBtnOf${vo.id}" data-comment="root"
                                                    data-root="${vo.id}" type="button"
                                                    class="px-0 btn x-btn-comment x-text-xs">
                                                댓글 쓰기
                                            </button>
                                        </c:if>
                                        <c:if test="${empty loginMember}">
                                            <button type="button" data-bs-toggle="modal"
                                                    class="px-0 btn x-btn-comment x-text-xs"
                                                    data-bs-target="#loginModal">
                                                댓글 쓰기
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                                    <%--    Branch 댓글    --%>
                                <div id="branchesOf${vo.id}" style="display:none;">
                                    <div>
                                        <ul class="ms-2 ps-3 list-unstyled" style="border-left: 2px solid #dee2e6">
                                            <c:forEach var="bvo" varStatus="status" items="${vo.branchComments}">
                                                <li class="py-3 ${status.index ne 0?'x-border-top-dashed':''}">
                                                    <div id="commentOf${bvo.id}">
                                                        <div class="d-flex justify-content-between">
                                                            <div class="d-flex">
                                                                <div class="me-2">
                                                                    <a href="/members/${bvo.writer.userNo}"><img
                                                                            src="/images/profile/${bvo.writer.imageName ne null? bvo.writer.imageName: 'temporary.gif'}"
                                                                            class="x-comment-profile-img x-border-thin rounded-circle"
                                                                            alt="프로필사진"></a>
                                                                </div>
                                                                <div class="d-flex flex-column my-auto">
                                                                    <a class="x-text-sm"
                                                                       href="/members/${bvo.writer.userNo}">${not empty bvo.writer.nickname? bvo.writer.nickname: '(알 수 없음)'}</a>
                                                                    <div class="x-text-xs x-text-gray-600 x-font-light"
                                                                         style="line-height: 1.2rem">
                                                                        <c:if test="${not empty bvo.writer.nickname}">
                                                                        <span>${bvo.writer.grade.description} / ${bvo.writer.region.description}</span>
                                                                        <span>·</span>
                                                                        </c:if>
                                                                        <span class="">${customFn.getElapsedTime(bvo.createdDate)}</span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                                <%--    부가 메뉴    --%>
                                                            <c:if test="${vo.writer.userNo eq loginMember.userNo}">
                                                                <div class="dropdown d-flex align-items-center">
                                                                    <button class="dropdown-toggle"
                                                                            style="background: none; border: none;"
                                                                            type="button"
                                                                            id="dropdownMenuButtonOf${bvo.id}"
                                                                            data-bs-toggle="dropdown"
                                                                            aria-expanded="false">
                                                                        <svg xmlns="http://www.w3.org/2000/svg"
                                                                             width="20" height="20"
                                                                             fill="#6c757d"
                                                                             class="bi bi-three-dots x-text-gray-700"
                                                                             viewBox="0 0 16 16">
                                                                            <path d="M3 9.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3m5 0a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3"/>
                                                                        </svg>
                                                                    </button>
                                                                    <ul class="dropdown-menu dropdown-menu-end x-text-sm x-text-gray-700"
                                                                        aria-labelledby="dropdownMenuButton${bvo.id}">
                                                                        <li>
                                                                            <button id="commentEditFormBtnOf${bvo.id}"
                                                                                    data-comment="${bvo.depthNo > 1? 'branch2': 'branch'}"
                                                                                    data-root="${vo.id}"
                                                                                    data-mentioned="${bvo.parentCommentInfo.mentionedName}"
                                                                                    class="dropdown-item" href="#"><i
                                                                                    class="me-1 bi bi-pencil-square"></i>수정하기
                                                                            </button>
                                                                        </li>
                                                                        <li>
                                                                            <button id="commentDeleteBtnOf${bvo.id}"
                                                                                    data-root="${vo.id}" type="button"
                                                                                    class="dropdown-item">
                                                                                <i class="me-1 bi bi-trash3"></i>삭제하기</a>
                                                                            </button>
                                                                        </li>
                                                                    </ul>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        <div class="${bvo.depthNo > 1? 'mt-0': 'mt-2'} mb-2 x-text-sm x-text-gray-800">
                                                            <c:if test="${bvo.depthNo > 1}">
                                                                <div>
                                                                    <span class="x-mention rounded-pill">@${not empty bvo.parentCommentInfo.mentionedName? bvo.parentCommentInfo.mentionedName: '(알 수 없음)'}</span>
                                                                </div>
                                                            </c:if>
                                                            <div id="contentOf${bvo.id}" style="white-space: pre"><c:out
                                                                    value="${bvo.content}"></c:out></div>
                                                        </div>
                                                        <div class="mb-2">
                                                            <c:if test="${not empty loginMember}">
                                                                <button id="commentAddFormBtnOf${bvo.id}"
                                                                        data-root="${vo.id}"
                                                                        data-mentioned="${bvo.parentCommentInfo.mentionedName}"
                                                                        type="button"
                                                                        class="px-0 btn x-btn-comment x-text-xs">
                                                                    댓글 쓰기
                                                                </button>
                                                            </c:if>
                                                            <c:if test="${empty loginMember}">
                                                                <button type="button" data-bs-toggle="modal"
                                                                        class="px-0 btn x-btn-comment x-text-xs"
                                                                        data-bs-target="#loginModal">
                                                                    댓글 쓰기
                                                                </button>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
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

    <%--    모달 (게시글 삭제 확인)   --%>
    <div class="modal" id="postDeleteModal" tabindex="-1" aria-labelledby="postDeleteModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title x-font-medium" id="postDeleteModalLabel">게시글 삭제</h5>
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

    <%--    모달 (댓글 삭제 확인)   --%>
    <div class="modal" id="commentDeleteModal" tabindex="-1" aria-labelledby="commentDeleteModalLabel"
         aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title x-font-medium" id="commentDeleteModalLabel">댓글 삭제</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body x-text-sm x-text-gray-700">
                    <p>댓글을 삭제하시겠습니까?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="px-3 py-1 btn btn-outline-secondary" data-bs-dismiss="modal">취소
                    </button>
                    <button id="commentDeleteBtn" type="button" data-role="delete" class="px-3 py-1 btn btn-primary">삭제
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%--    모달 (댓글 쓰기 로그인 확인)   --%>
    <div class="modal" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="p-4 pb-0 modal-body x-text-sm x-text-gray-700">
                    <h5 class="modal-title mb-1 x-font-medium">로그인이 필요한 기능</h5>
                    <p class="x-text-sm x-font-light x-text-gray-600">로그인 페이지로 이동하시겠습니까?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="px-3 py-1 btn btn-outline-secondary" data-bs-dismiss="modal">취소
                    </button>
                    <button type="button" class="px-3 py-1 btn btn-primary"
                            onclick="location.href='/login'">확인
                    </button>
                </div>
            </div>
        </div>
    </div>

    <%-- 오류 Modal --%>
    <div id="errorModal" class="modal modal-sm fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body p-4 text-center">
                    <h5 class="modal-title mb-1 x-font-medium" style="font-size: 1.1rem">
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

    <%--    대댓글 작성 폼(뼈대)    --%>
    <c:if test="${!empty loginMember}">
        <div id="addBranch" style="display: none">
            <div class="d-flex">
                <div class="me-3">
                    <img class="x-comment-profile-img x-border-thin rounded-circle"
                         src="/images/profile/${loginMember.imageName ne null? loginMember.imageName: 'temporary.gif'}"
                         style="border:1px solid #f8f9fa">
                </div>
                <form method="post" class="w-100">
                    <input type="hidden" name="postId" value="${post.id}">
                    <input type="hidden" name="parentId">
                    <div class="form-control p-0 pt-2">
                                    <textarea class="pt-0 border-0 form-control" name="content" placeholder="댓글을 남겨주세요."
                                              rows="3"></textarea>
                    </div>
                    <div class="mt-3 d-flex justify-content-end">
                        <div class="mt-1 me-2 x-field-error"></div>
                        <button data-role="cancel" class="me-1 px-3 py-1 btn btn-outline-secondary" type="button">취소
                        </button>
                        <button data-role="submit" class="px-3 py-1 btn btn-primary"
                                type="button">댓글 쓰기
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>
</main>

<!-- Bootstrap JS Bundle with Popper -->
<%@ include file="fragment/script.jsp" %>
</body>
</html>