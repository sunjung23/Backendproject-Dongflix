<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>
<%@ include file="/common/header.jsp" %>

<%
    Boolean fromServlet = (Boolean) request.getAttribute("fromRecommendServlet");
    if (fromServlet == null || !fromServlet) {
        response.sendRedirect(request.getContextPath() + "/indexMovie");
        return;
    }

    String name     = (String) request.getAttribute("displayName");
    String genreStr = (String) request.getAttribute("genres");

    List<TMDBmovie> primaryList   = (List<TMDBmovie>) request.getAttribute("primaryList");
    List<TMDBmovie> tasteMoreList = (List<TMDBmovie>) request.getAttribute("tasteMoreList");
    List<TMDBmovie> trendingList  = (List<TMDBmovie>) request.getAttribute("trendingList");

    if (name == null) name = "회원";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DONGFLIX - 맞춤 추천</title>

    <style>
        body {
            margin:0;
            padding:0;
            background:#000;
            color:#fff;
            font-family:-apple-system, BlinkMacSystemFont,"Segoe UI",sans-serif;
            overflow-x:hidden;
        }

        /* =============================
           전체 배경 & 레이아웃
        ============================== */
        .recommend-wrap {
            min-height:100vh;
            background:
                radial-gradient(circle at 20% 10%, rgba(80,120,255,0.27), transparent 55%),
                radial-gradient(circle at 80% 90%, rgba(140,170,255,0.23), transparent 55%),
                #000;
            padding:90px 20px 60px;
        }

        .inner {
            max-width:1200px;
            margin:0 auto;
        }

        /* =============================
           HERO SECTION
        ============================== */
        .hero {
            text-align:left;
            margin-bottom:40px;
            animation:fadeInHero .8s ease-out;
        }

        @keyframes fadeInHero {
            from { opacity:0; transform:translateY(20px); }
            to   { opacity:1; transform:translateY(0); }
        }

        .hero-title {
            font-size:30px;
            font-weight:800;
            margin-bottom:8px;
        }

        .hero-sub {
            font-size:14px;
            color:#b6bfea;
            margin-bottom:16px;
        }

        .hero-chip-row {
            display:flex;
            flex-wrap:wrap;
            gap:8px;
            margin-top:6px;
        }

        .hero-chip {
            padding:6px 12px;
            border-radius:999px;
            font-size:12px;
            border:1px solid rgba(120,150,255,0.45);
            background:rgba(12,15,40,0.9);
            color:#e0e6ff;
        }

        .hero-tagline {
            margin-top:18px;
            font-size:13px;
            color:#8e96c9;
        }

        /* =============================
           SECTION 제목
        ============================== */
        .section {
            margin-bottom:40px;
        }

        .section-header {
            display:flex;
            align-items:flex-end;
            justify-content:space-between;
            margin:0 4px 12px;
        }

        .section-title {
            font-size:20px;
            font-weight:700;
        }

        .section-sub {
            font-size:12px;
            color:#a9b2e3;
        }

        /* =============================
           MOVIE SLIDER
        ============================== */
        .movie-slider {
            position:relative;
        }

        .movie-row {
            display:flex;
            gap:16px;
            overflow-x:auto;
            padding:4px 0 12px;
            scroll-behavior:smooth;
        }

        .movie-row::-webkit-scrollbar {
            height:6px;
        }
        .movie-row::-webkit-scrollbar-track {
            background:rgba(10,14,30,0.9);
        }
        .movie-row::-webkit-scrollbar-thumb {
            background:rgba(120,150,255,0.6);
            border-radius:999px;
        }

        .movie-card {
            flex:0 0 auto;
            width:190px;
            border-radius:16px;
            overflow:hidden;
            position:relative;
            background:#0f1325;
            cursor:pointer;
            transition:.25s;
            border:1px solid rgba(120,150,255,0.25);
        }

        .movie-card:hover {
            transform:translateY(-6px) scale(1.03);
            border-color:#3f6fff;
            box-shadow:
                0 0 16px rgba(63,111,255,0.6),
                0 0 40px rgba(63,111,255,0.35);
        }

        .movie-poster {
            width:100%;
            height:270px;
            object-fit:cover;
            display:block;
        }

        .movie-info {
            padding:10px 10px 12px;
        }

        .movie-title {
            font-size:14px;
            font-weight:600;
            margin-bottom:4px;
            white-space:nowrap;
            overflow:hidden;
            text-overflow:ellipsis;
        }

        .movie-meta {
            font-size:12px;
            color:#c7d2ff;
            display:flex;
            justify-content:space-between;
            align-items:center;
        }

        .movie-rating {
            font-size:12px;
        }

        .movie-year {
            font-size:11px;
            opacity:0.85;
        }

        .movie-hover {
            position:absolute;
            inset:0;
            background:linear-gradient(to top, rgba(0,0,0,0.9), transparent 60%);
            opacity:0;
            transition:.25s;
            display:flex;
            align-items:flex-end;
            padding:12px;
        }

        .movie-card:hover .movie-hover {
            opacity:1;
        }

        .movie-hover-text {
            font-size:11px;
            color:#dfe4ff;
            max-height:60px;
            overflow:hidden;
        }

        /* =============================
           슬라이더 좌우 버튼 (옵션)
        ============================== */
        .slide-btn {
            position:absolute;
            top:40%;
            transform:translateY(-50%);
            width:32px;
            height:48px;
            border-radius:999px;
            border:none;
            background:rgba(5,8,25,0.9);
            color:#fff;
            cursor:pointer;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:20px;
            opacity:0.0;
            transition:.2s;
            box-shadow:0 0 12px rgba(0,0,0,0.6);
        }

        .movie-slider:hover .slide-btn {
            opacity:0.9;
        }

        .slide-btn.left  { left:-8px; }
        .slide-btn.right { right:-8px; }

        .slide-btn:hover {
            background:#3f6fff;
        }

        /* =============================
           하단 버튼
        ============================== */
        .btn-area {
            text-align:center;
            margin:40px 0 10px;
        }

        .btn-home {
            padding:12px 22px;
            background:#3f6fff;
            border:none;
            border-radius:999px;
            color:#fff;
            font-size:15px;
            font-weight:700;
            cursor:pointer;
            transition:.22s;
        }

        .btn-home:hover {
            background:#678aff;
            transform:translateY(-2px);
            box-shadow:0 10px 20px rgba(80,120,255,0.45);
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size:24px;
            }
        }
    </style>
</head>
<body>

<div class="recommend-wrap">
    <div class="inner">

        <!-- ================= HERO ================= -->
        <div class="hero">
            <div class="hero-title"><%= name %>님을 위한 맞춤 추천</div>

            <% if (genreStr != null && !genreStr.trim().isEmpty()) { %>
                <div class="hero-sub">
                    회원님이 선택한 취향을 바탕으로 오늘의 추천을 준비했어요.
                </div>

                <div class="hero-chip-row">
                <%
                    String[] chips = genreStr.split("\\s*,\\s*");
                    for (String g : chips) {
                        if (g != null && !g.trim().isEmpty()) {
                %>
                    <span class="hero-chip">💎 <%= g.trim() %></span>
                <%
                        }
                    }
                %>
                </div>
            <% } else { %>
                <div class="hero-sub">
                    아직 선호 장르 정보가 없어, 인기 영화 위주로 추천해 드릴게요.
                </div>
            <% } %>

            <div class="hero-tagline">
                * 추천 결과는 TMDB 인기 데이터 + 회원님의 선호 장르를 하이브리드로 반영한 결과입니다.
            </div>
        </div>

        <!-- ============ SECTION 1: 핵심 추천 ============ -->
        <div class="section">
            <div class="section-header">
                <div class="section-title">나를 위한 핵심 추천</div>
                <div class="section-sub">선호 장르를 최우선으로 반영한 상위 추천 콘텐츠</div>
            </div>

            <div class="movie-slider" data-row-id="primary">
                <button class="slide-btn left"  onclick="slideRow('primary', -600)">❮</button>
                <div class="movie-row" id="row-primary">
                    <%
                        if (primaryList != null && !primaryList.isEmpty()) {
                            for (TMDBmovie m : primaryList) {
                                String year = (m.getReleaseDate() != null && m.getReleaseDate().length() >= 4)
                                        ? m.getReleaseDate().substring(0,4) : "";
                    %>
                    <div class="movie-card" onclick="location.href='movieDetail?movieId=<%= m.getId() %>'">
                        <img class="movie-poster" src="<%= m.getPosterUrl() %>" alt="<%= m.getTitle() %>">
                        <div class="movie-hover">
                            <div class="movie-hover-text"><%= m.getOverview() %></div>
                        </div>
                        <div class="movie-info">
                            <div class="movie-title"><%= m.getTitle() %></div>
                            <div class="movie-meta">
                                <span class="movie-rating">★ <%= String.format("%.1f", m.getRating()) %></span>
                                <span class="movie-year"><%= year %></span>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div style="padding:10px 4px; font-size:14px; color:#cfd4ff;">
                        추천 데이터를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.
                    </div>
                    <%
                        }
                    %>
                </div>
                <button class="slide-btn right" onclick="slideRow('primary', 600)">❯</button>
            </div>
        </div>

        <!-- ============ SECTION 2: 내 취향 더 보기 ============ -->
        <div class="section">
            <div class="section-header">
                <div class="section-title">내 취향 더 보기</div>
                <div class="section-sub">선호 장르 범위를 조금 넓혀서 찾아본 비슷한 스타일의 작품들</div>
            </div>

            <div class="movie-slider" data-row-id="taste">
                <button class="slide-btn left"  onclick="slideRow('taste', -600)">❮</button>
                <div class="movie-row" id="row-taste">
                    <%
                        if (tasteMoreList != null && !tasteMoreList.isEmpty()) {
                            for (TMDBmovie m : tasteMoreList) {
                                String year = (m.getReleaseDate() != null && m.getReleaseDate().length() >= 4)
                                        ? m.getReleaseDate().substring(0,4) : "";
                    %>
                    <div class="movie-card" onclick="location.href='movieDetail?movieId=<%= m.getId() %>'">
                        <img class="movie-poster" src="<%= m.getPosterUrl() %>" alt="<%= m.getTitle() %>">
                        <div class="movie-hover">
                            <div class="movie-hover-text"><%= m.getOverview() %></div>
                        </div>
                        <div class="movie-info">
                            <div class="movie-title"><%= m.getTitle() %></div>
                            <div class="movie-meta">
                                <span class="movie-rating">★ <%= String.format("%.1f", m.getRating()) %></span>
                                <span class="movie-year"><%= year %></span>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div style="padding:10px 4px; font-size:14px; color:#cfd4ff;">
                        선호 장르 기반 추천이 부족하여, 상단 추천과 인기작을 통해 채워집니다.
                    </div>
                    <%
                        }
                    %>
                </div>
                <button class="slide-btn right" onclick="slideRow('taste', 600)">❯</button>
            </div>
        </div>

        <!-- ============ SECTION 3: 전체 인기 영화 ============ -->
        <div class="section">
            <div class="section-header">
                <div class="section-title">지금 가장 인기 있는 영화</div>
                <div class="section-sub">전 세계 이용자들이 지금 가장 많이 보는 작품들</div>
            </div>

            <div class="movie-slider" data-row-id="trend">
                <button class="slide-btn left"  onclick="slideRow('trend', -600)">❮</button>
                <div class="movie-row" id="row-trend">
                    <%
                        if (trendingList != null && !trendingList.isEmpty()) {
                            for (TMDBmovie m : trendingList) {
                                String year = (m.getReleaseDate() != null && m.getReleaseDate().length() >= 4)
                                        ? m.getReleaseDate().substring(0,4) : "";
                    %>
                    <div class="movie-card" onclick="location.href='movieDetail?movieId=<%= m.getId() %>'">
                        <img class="movie-poster" src="<%= m.getPosterUrl() %>" alt="<%= m.getTitle() %>">
                        <div class="movie-hover">
                            <div class="movie-hover-text"><%= m.getOverview() %></div>
                        </div>
                        <div class="movie-info">
                            <div class="movie-title"><%= m.getTitle() %></div>
                            <div class="movie-meta">
                                <span class="movie-rating">★ <%= String.format("%.1f", m.getRating()) %></span>
                                <span class="movie-year"><%= year %></span>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div style="padding:10px 4px; font-size:14px; color:#cfd4ff;">
                        인기 영화 정보를 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.
                    </div>
                    <%
                        }
                    %>
                </div>
                <button class="slide-btn right" onclick="slideRow('trend', 600)">❯</button>
            </div>
        </div>

        <!-- 홈으로 버튼 -->
        <div class="btn-area">
            <button onclick="location.href='<%= request.getContextPath() %>/indexMovie'" class="btn-home">
                홈으로 돌아가기
            </button>
        </div>
    </div>
</div>

<script>
function slideRow(key, delta) {
    const row = document.getElementById("row-" + key);
    if (!row) return;
    row.scrollBy({ left: delta, behavior: "smooth" });
}
</script>

</body>
</html>
