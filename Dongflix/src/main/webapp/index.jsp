<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/common/header.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>

<%
    if (request.getAttribute("fromServlet") == null) {
        response.sendRedirect("indexMovie");
        return;
    }

    Map<String, List<TMDBmovie>> movieLists =
            (Map<String, List<TMDBmovie>>) request.getAttribute("movieLists");

    TMDBmovie banner = (TMDBmovie) request.getAttribute("bannerMovie");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DONGFLIX</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<!-- 배너 -->
<%
    String bannerBg = "";
    String bannerTitle = "영화 정보를 불러올 수 없습니다.";
    String bannerOverview = "";

    if (banner != null) {
        bannerBg = (banner.getBackdropUrl() != null && !banner.getBackdropUrl().isEmpty())
                    ? banner.getBackdropUrl()
                    : banner.getPosterUrl();
        bannerTitle = banner.getTitle();
        bannerOverview = banner.getOverview();
    }
%>

<div class="main-banner" style="background-image: url('<%= bannerBg %>');">
    <div class="banner-content">
        <h1><%= bannerTitle %></h1>
        <p><%= bannerOverview %></p>
    </div>
</div>

<!-- 카테고리 영화들 -->
<%
    for (Map.Entry<String, List<TMDBmovie>> entry : movieLists.entrySet()) {
        String genreKey = entry.getKey();
        List<TMDBmovie> movies = entry.getValue();
        
        String displayName = genreKey;
        if ("animation".equals(genreKey)) displayName = "애니메이션";
        else if ("romance".equals(genreKey)) displayName = "로맨스";
        else if ("action".equals(genreKey)) displayName = "액션 / 스릴러";
        else if ("crime".equals(genreKey)) displayName = "범죄";
        else if ("fantasy".equals(genreKey)) displayName = "판타지";
%>

<div class="category"><%= displayName %></div>

<div class="movie-grid">
<%
        if (movies != null) {
            for (TMDBmovie m : movies) {
%>
    <div class="movie">
        <a href="movieDetail?movieId=<%= m.getId() %>">
            <img src="<%= m.getPosterUrl() %>" alt="<%= m.getTitle() %>">
        </a>
        <div class="hover-info"><%= m.getOverview() %></div>
    </div>
<%
            }
        }
%>
</div>

<%
    }
%>

<!-- 🎬 영화 취향 테스트 플로팅 버튼 -->
<%
    Object loginUserForTest = session.getAttribute("loginUser");
%>

<% if (loginUserForTest != null) { %>
    <a href="${pageContext.request.contextPath}/movieTest.jsp" 
       style="position: fixed; bottom: 30px; right: 30px; width: 65px; height: 65px; 
              background: linear-gradient(135deg, #2036CA 0%, #4a69ff 100%); 
              border-radius: 50%; z-index: 9999; font-size: 32px; 
              display: flex; align-items: center; justify-content: center; 
              cursor: pointer; text-decoration: none; 
              box-shadow: 0 8px 25px rgba(32, 54, 202, 0.5);
              border: none;
              transition: all 0.3s ease;"
       onmouseover="this.style.transform='translateY(-5px) scale(1.05)'; this.style.boxShadow='0 12px 35px rgba(32, 54, 202, 0.7)';"
       onmouseout="this.style.transform=''; this.style.boxShadow='0 8px 25px rgba(32, 54, 202, 0.5)';"
       title="영화 취향 테스트">
        🎬
    </a>
<% } else { %>
    <div onclick="if(confirm('로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?')) location.href='${pageContext.request.contextPath}/login.jsp';" 
         style="position: fixed; bottom: 30px; right: 30px; width: 65px; height: 65px; 
                background: linear-gradient(135deg, #2036CA 0%, #4a69ff 100%); 
                border-radius: 50%; z-index: 9999; font-size: 32px; 
                display: flex; align-items: center; justify-content: center; 
                cursor: pointer; 
                box-shadow: 0 8px 25px rgba(32, 54, 202, 0.5);
                border: none;
                transition: all 0.3s ease;"
         onmouseover="this.style.transform='translateY(-5px) scale(1.05)'; this.style.boxShadow='0 12px 35px rgba(32, 54, 202, 0.7)';"
         onmouseout="this.style.transform=''; this.style.boxShadow='0 8px 25px rgba(32, 54, 202, 0.5)';"
         title="영화 취향 테스트">
        🎬
    </div>
<% } %>

</body>
</html>