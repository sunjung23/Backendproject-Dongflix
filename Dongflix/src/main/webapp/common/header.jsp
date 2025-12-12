<%@ page contentType="text/html; charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">

<header class="df-header" role="banner">
  <div class="df-header-inner">

    <!-- 로고 (왼쪽) -->
    <a href="${pageContext.request.contextPath}/indexMovie" class="df-logo" aria-label="DONGFLIX 홈">
      <img src="${pageContext.request.contextPath}/img/logo.png" alt="DONGFLIX">
    </a>

    <!-- 메뉴 (가운데) -->
    <nav class="df-nav" aria-label="주 메뉴">
      <ul class="df-nav-list">
        <li><a class="df-nav-link" href="${pageContext.request.contextPath}/indexMovie">홈</a></li>
        <li><a class="df-nav-link" href="${pageContext.request.contextPath}/searchMovie">탐색</a></li>
        <li><a class="df-nav-link" href="${pageContext.request.contextPath}/board/list">게시판</a></li>
      </ul>
    </nav>

    <!-- 유저 (오른쪽) -->
    <div class="df-user-area">
      <%
        Object loginUserObj = session.getAttribute("loginUser");
        boolean isLoggedIn = (loginUserObj != null);
      %>

      <% if (isLoggedIn) { %>
        <a class="df-user-link" href="${pageContext.request.contextPath}/mypage.do">마이페이지</a>
        <span class="df-divider">|</span>
        <a class="df-user-link" href="${pageContext.request.contextPath}/logout.do">로그아웃</a>
      <% } else { %>
        <a class="df-user-link" href="${pageContext.request.contextPath}/login.jsp">로그인</a>
      <% } %>
    </div>

  </div>
</header>
