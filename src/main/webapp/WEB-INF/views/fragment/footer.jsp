<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<script>
    $(document).ready(function () {

        // 모바일 하단 네비게이션 글쓰기 버튼 -> 카테고리 선택 메뉴
        $('#createBtn').click(function (e) {
            e.preventDefault();
            const menu = $('#createBtnDropdup');
            const menuDisplay = menu.css('display');

            if (menuDisplay == 'block') {
                menu.css('display', 'none');
            } else {
                menu.css('display', 'block');
            }
        });
    });
</script>

<div class="x-footer d-flex justify-content-center border-top" style="margin-top: 6rem; margin-bottom: 4.5rem">
    <div class="x-container-width x-width-full" style="min-width: 340px">
        <div class="py-3 d-flex justify-content-between">
            <div class="x-aside text-center">
                <a class="navbar-brand text-primary fst-italic x-font-bold" href="/">Bangcom</a>
                <p class="x-text-gray-600 x-font-light" style="line-height: 0.65rem; font-size: 0.6rem">Korea National
                    Open
                    University<br>CS Department Community</p>
            </div>
            <div class="x-main">
                <ul class="d-flex justify-content-start list-unstyled x-text-xs x-font-light">
                    <li><a href="#">포트폴리오 소개</a></li>
                    <span class="mx-2">|</span>
                    <li><a href="#">연락처</a></li>
                    <span class="mx-2">|</span>
                    <li><a href="#">버그 제보</a></li>
                    <span class="mx-2">|</span>
                    <li><a href="#">개인정보처리방침</a></li>
                </ul>
                <div class="x-text-sm x-font-light x-text-gray-700">
                    <p class="my-0"><span class="x-font-medium">이임시</span>의 포트폴리오</p>
                    <p>
                        <span>email: temporary12345@gmail.com</span>
                        <span class="mx-2">|</span>
                        <a href="#" style="color: inherit"><i class="me-1 bi bi-github"></i>Github</a>
                        <span class="mx-2">|</span>
                        <a href="#" style="color: inherit"><i class="me-1 bi bi-house-door-fill"></i>Blog</a>
                    </p>
                </div>
            </div>
            <div class="x-aside">
                <div class="text-center">
                    <a href="https://www.knou.ac.kr/">
                        <img src="/resources/img/knou-logo.jpg" alt="방송대 로고" width="150px">
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%--    모바일 하단 네비게이션    --%>
<div class="d-block d-sm-none position-relative">
    <nav class="x-mnav border-top fixed-bottom z-3" style="height: 4.5rem; background-color: white">
        <div class="d-flex justify-content-center align-items-center" style="padding: .55rem">
            <a class="d-flex flex-column align-items-center rounded-circle x-mnav-btn" href="/questions">
                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                     class="x-mnav-btn-icon bi bi-question-circle" viewBox="0 0 16 16">
                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                    <path d="M5.255 5.786a.237.237 0 0 0 .241.247h.825c.138 0 .248-.113.266-.25.09-.656.54-1.134 1.342-1.134.686 0 1.314.343 1.314 1.168 0 .635-.374.927-.965 1.371-.673.489-1.206 1.06-1.168 1.987l.003.217a.25.25 0 0 0 .25.246h.811a.25.25 0 0 0 .25-.25v-.105c0-.718.273-.927 1.01-1.486.609-.463 1.244-.977 1.244-2.056 0-1.511-1.276-2.241-2.673-2.241-1.267 0-2.655.59-2.75 2.286m1.557 5.763c0 .533.425.927 1.01.927.609 0 1.028-.394 1.028-.927 0-.552-.42-.94-1.029-.94-.584 0-1.009.388-1.009.94"/>
                </svg>
                <span class="x-mnav-btn-text">Q&A</span>
            </a>
            <a class="d-flex flex-column align-items-center rounded-circle x-mnav-btn" href="/info">
                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                     class="x-mnav-btn-icon bi bi-info-circle" viewBox="0 0 16 16">
                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                    <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/>
                </svg>
                <span class="x-mnav-btn-text">정보</span>
            </a>
            <div class="position-relative d-flex flex-column align-items-center x-mnav-btn">
                <a id="createBtn" class="d-flex align-items-center justify-content-center x-mnav-center-btn" href="#">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                         class="x-mnav-btn-icon-center bi bi-plus"
                         viewBox="0 0 16 16">
                        <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                    </svg>
                </a>
                <ul id="createBtnDropdup" class="p-3 pe-4 position-absolute dropdown-menu x-mnav-center-dropdown" style="display: none">
                    <li class="mb-2">
                        <a class="d-flex dropdown-item" href="${cpath}/questions/new">
                            <div class="me-3 d-flex align-items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                                     class="x-mnav-btn-icon bi bi-question-circle" viewBox="0 0 16 16">
                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                    <path d="M5.255 5.786a.237.237 0 0 0 .241.247h.825c.138 0 .248-.113.266-.25.09-.656.54-1.134 1.342-1.134.686 0 1.314.343 1.314 1.168 0 .635-.374.927-.965 1.371-.673.489-1.206 1.06-1.168 1.987l.003.217a.25.25 0 0 0 .25.246h.811a.25.25 0 0 0 .25-.25v-.105c0-.718.273-.927 1.01-1.486.609-.463 1.244-.977 1.244-2.056 0-1.511-1.276-2.241-2.673-2.241-1.267 0-2.655.59-2.75 2.286m1.557 5.763c0 .533.425.927 1.01.927.609 0 1.028-.394 1.028-.927 0-.552-.42-.94-1.029-.94-.584 0-1.009.388-1.009.94"/>
                                </svg>
                            </div>
                            <div class="row">
                                <div class="x-text-sm"><span class="x-font-semibold">Q&A</span>에 글쓰기</div>
                                <div class="x-font-light x-text-xs">학사, 학습, 기타</div>
                            </div>
                        </a>
                    </li>
                    <li class="mb-2">
                        <a class="d-flex dropdown-item" href="${cpath}/info/new">
                            <div class="me-3 d-flex align-items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                                     class="x-mnav-btn-icon bi bi-info-circle" viewBox="0 0 16 16">
                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                    <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/>
                                </svg>
                            </div>
                            <div class="row">
                                <div class="x-text-sm"><span class="x-font-semibold">정보</span>에 글쓰기</div>
                                <div class="x-font-light x-text-xs">멘토알림, 정보공유</div>
                            </div>
                        </a>
                    </li>
                    <li class="mb-2">
                        <a class="d-flex dropdown-item" href="${cpath}/community/new">
                            <div class="me-3 d-flex align-items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                                     class="x-mnav-btn-icon bi bi-people" viewBox="0 0 16 16">
                                    <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1zm-7.978-1L7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002-.014.002zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4m3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0M6.936 9.28a6 6 0 0 0-1.23-.247A7 7 0 0 0 5 9c-4 0-5 3-5 4q0 1 1 1h4.216A2.24 2.24 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816M4.92 10A5.5 5.5 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275ZM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0m3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4"/>
                                </svg>
                            </div>
                            <div class="row">
                                <div class="x-text-sm"><span class="x-font-semibold">커뮤니티</span>에 글쓰기</div>
                                <div class="x-font-light x-text-xs">학교생활, 사는얘기, 벼룩시장</div>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
            <a class="d-flex flex-column align-items-center rounded-circle x-mnav-btn" href="/community">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                     class="x-mnav-btn-icon bi bi-people" viewBox="0 0 16 16">
                    <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1zm-7.978-1L7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002-.014.002zM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4m3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0M6.936 9.28a6 6 0 0 0-1.23-.247A7 7 0 0 0 5 9c-4 0-5 3-5 4q0 1 1 1h4.216A2.24 2.24 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816M4.92 10A5.5 5.5 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275ZM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0m3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4"/>
                </svg>
                <span class="x-mnav-btn-text">커뮤니티</span>
            </a>
            <a class="d-flex flex-column align-items-center rounded-circle x-mnav-btn" href="/notice">
                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor"
                     class="x-mnav-btn-icon bi bi-exclamation-circle" viewBox="0 0 16 16">
                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                    <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0M7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0z"/>
                </svg>
                <span class="x-mnav-btn-text">공지사항</span>
            </a>
        </div>
    </nav>
</div>