<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">KNOU CS</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link<c:if test="${topicGroup == 'QUESTIONS'}"> active</c:if>" <c:if test="${topicGroup == 'QUESTIONS'}"> aria-current="page"</c:if> href="/questions">Q&A</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link<c:if test="${topicGroup == 'INFO'}"> active</c:if>" <c:if test="${topicGroup == 'INFO'}"> aria-current="page"</c:if> href="/info">정보</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link<c:if test="${topicGroup == 'COMMUNITY'}"> active</c:if>" <c:if test="${topicGroup == 'COMMUNITY'}"> aria-current="page"</c:if> href="/community">커뮤니티</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link<c:if test="${topicGroup == 'NOTICE'}"> active</c:if>" <c:if test="${topicGroup == 'NOTICE'}"> aria-current="page"</c:if> href="/notice">공지사항</a>
                </li>
            </ul>
        </div>
    </div>
</nav>