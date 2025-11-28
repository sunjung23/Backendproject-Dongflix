<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/common/header.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>

<%
    if (request.getAttribute("fromServlet") == null) {
        response.sendRedirect("indexMovie");
        return;
    }

    // 서블릿에서 넘어온 데이터
    Map<String, List<TMDBmovie>> movieLists =
            (Map<String, List<TMDBmovie>>) request.getAttribute("movieLists");

    TMDBmovie banner = (TMDBmovie) request.getAttribute("bannerMovie");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DONGFLIX</title>

    <!-- CSS 적용 -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<!-- ================== 메인 배너 ================== -->

<%
    // 배너 null 체크 → 예외 방지
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


<!-- ================== 카테고리 ================== -->

<%
    for (Map.Entry<String, List<TMDBmovie>> entry : movieLists.entrySet()) {

        String genreKey = entry.getKey();
        List<TMDBmovie> movies = entry.getValue();

        // 한글 장르명 매핑
        String displayName = genreKey;
        if ("animation".equals(genreKey)) displayName = "애니메이션";
        else if ("romance".equals(genreKey)) displayName = "로맨스";
        else if ("action".equals(genreKey)) displayName = "액션 / 스릴러";
        else if ("crime".equals(genreKey)) displayName = "범죄";
        else if ("fantasy".equals(genreKey)) displayName = "판타지";
%>

<!-- 카테고리 타이틀 -->
<div class="category"><%= displayName %></div>

<!-- 카테고리 영화 목록 -->
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
    } // end for
%>

</body>
</html>