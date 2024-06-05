<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath" value="${pageContext.request.contextPath}"/>

<div class=" border-bottom">
    <nav class="x-container-width mx-auto navbar navbar-expand-sm navbar-light">
        <div class="container-fluid">
            <a class="navbar-brand text-primary fst-italic x-font-bold" style="flex-grow: 1" href="#">Bangcom</a>
            <div class="collapse navbar-collapse" style="flex-grow: 9" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto x-text-sm x-font-medium">
                    <li class="nav-item">
                        <a class="nav-link<c:if test="${topicGroup == 'QUESTIONS'}"> active</c:if>" <c:if
                                test="${topicGroup == 'QUESTIONS'}"> aria-current="page"</c:if>
                           href="/questions">Q&A</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link<c:if test="${topicGroup == 'INFO'}"> active</c:if>" <c:if
                                test="${topicGroup == 'INFO'}"> aria-current="page"</c:if> href="/info">정보</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link<c:if test="${topicGroup == 'COMMUNITY'}"> active</c:if>" <c:if
                                test="${topicGroup == 'COMMUNITY'}"> aria-current="page"</c:if>
                           href="/community">커뮤니티</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link<c:if test="${topicGroup == 'NOTICE'}"> active</c:if>" <c:if
                                test="${topicGroup == 'NOTICE'}"> aria-current="page"</c:if> href="/notice">공지사항</a>
                    </li>
                </ul>
            </div>
            <c:if test="${empty loginMember}">
                <div style="flex-grow: 0">
                    <div>
                        <a class="btn btn-outline-secondary rounded-pill px-3 py-1" href="/login"><span
                                class="x-text-sm">로그인</span></a>
                        <a class="btn btn-primary rounded-pill px-3 py-1" href="/signup"><span
                                class="x-text-sm">회원가입</span></a>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty loginMember}">
                <div style="flex-grow: 0">
                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarScrollingDropdown" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <img id="navProfileImg" src="/images/profile/${loginMember.imageName ne null? loginMember.imageName: 'temporary.gif'}" width="32px" height="32px" alt="프로필사진">
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end x-text-sm" aria-labelledby="navbarScrollingDropdown">
                            <li><a class="dropdown-item" href="${cpath}/settings/profile"><i class="me-1 bi bi-person-circle"></i>프로필</a></li>
                            <li><a class="dropdown-item" href="#"><i class="me-1 bi bi-gear"></i>계정관리</a></li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li><a class="dropdown-item" href="/logout"><i class="me-1 bi bi-power"></i>로그아웃</a></li>
                        </ul>
                    </div>
                </div>
            </c:if>
        </div>
</div>
</nav>