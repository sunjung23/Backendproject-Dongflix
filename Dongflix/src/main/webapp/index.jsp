<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/common/header.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>

<%
    if (request.getAttribute("fromServlet") == null) {
        response.sendRedirect(request.getContextPath() + "/indexMovie");
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

<!-- ======================== 배너 ======================== -->
<%
    String bannerBg = "";
    String bannerTitle = "영화 정보를 불러올 수 없습니다.";

    if (banner != null) {
        bannerBg = (banner.getBackdropUrl() != null && !banner.getBackdropUrl().isEmpty())
                    ? banner.getBackdropUrl()
                    : banner.getPosterUrl();
        bannerTitle = banner.getTitle();
    }
%>

<div class="main-banner" style="background-image: url('<%= bannerBg %>');">
    <div class="banner-content">
        <h1>오늘의 추천 영화: <%= bannerTitle %></h1>

        <a href="movieDetail?movieId=<%= banner.getId() %>" class="banner-detail-btn">
            자세히 보러 가기 &raquo;
        </a>
    </div>
</div>

<!-- ======================== 카테고리별 영화 ======================== -->
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

<div class="movie-slider-wrapper">

    <!-- ← 왼쪽 화살표 -->
    <button class="slide-btn left" onclick="slideLeft('<%= genreKey %>')">❮</button>

    <!-- 영화 목록 -->
    <div class="movie-row" id="row-<%= genreKey %>">
        <%
            if (movies != null) {
                for (TMDBmovie m : movies) {
        %>
        <div class="movie">
            <a href="movieDetail?movieId=<%= m.getId() %>">
                <img src="<%= m.getPosterUrl() %>" alt="<%= m.getTitle() %>">
            </a>
			<div class="hover-info">
			    <div class="hover-text"><%= m.getOverview() %></div>
			</div>
        </div>
        <%
                }
            }
        %>
    </div>

    <!-- → 오른쪽 화살표 -->
    <button class="slide-btn right" onclick="slideRight('<%= genreKey %>')">❯</button>
</div>

<%
    }
%>

<!-- ======================== 슬라이더 JS ======================== -->
<script>
function slideLeft(key) {
    const row = document.getElementById("row-" + key);
    row.scrollBy({ left: -600, behavior: "smooth" });
}

function slideRight(key) {
    const row = document.getElementById("row-" + key);
    row.scrollBy({ left: 600, behavior: "smooth" });
}
</script>

<!-- 🎬 영화 취향 테스트 버튼 -->
<a href="${pageContext.request.contextPath}/movieTest.jsp"
   class="floating-test-btn">
    🎬
</a>

</body>
</html>