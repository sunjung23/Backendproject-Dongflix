<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DONGFLIX</title>

   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">


    <!-- 메인 페이지 -->
    <style>

        body {
            margin:0;
            padding:0;
            background:#000;
            color:#fff;
            font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
            overflow-x:hidden;
            background:
                radial-gradient(circle at 20% 15%, rgba(80,120,255,0.22), transparent 55%),
                radial-gradient(circle at 80% 85%, rgba(140,170,255,0.18), transparent 55%),
                #000;
        }
        a { text-decoration:none; color:inherit; }


        .main-banner {
            width:100%;
            height:560px;
            background-size:cover;
            background-position:center;
            position:relative;
            display:flex;
            align-items:flex-end;
            padding:60px;
            box-shadow:0 0 80px rgba(0,0,0,0.9) inset;
        }
        .main-banner::after {
            content:"";
            position:absolute;
            inset:0;
            background:linear-gradient(to top, rgba(0,0,0,0.78), transparent 65%);
        }
        .banner-content {
            position:relative;
            z-index:10;
            max-width:640px;
        }
        .banner-title {
            font-size:40px;
            font-weight:800;
            letter-spacing:-0.5px;
            text-shadow:0 8px 22px rgba(0,0,0,0.85);
        }
        .banner-btn {
            display:inline-block;
            margin-top:16px;
            padding:14px 30px;
            background:#3f6fff;
            border-radius:999px;
            font-size:16px;
            font-weight:700;
            color:white;
            transition:.22s;
        }
        .banner-btn:hover {
            transform:translateY(-3px);
            background:#678aff;
            box-shadow:0 12px 28px rgba(80,120,255,0.55);
        }


        .section-title {
            font-size:22px;
            font-weight:700;
            margin:28px 0 14px 20px;
            color:#dce1ff;
        }


        .slider-wrap {
            position:relative;
        }
        .movie-row {
            display:flex;
            gap:18px;
            overflow-x:auto;
            padding:10px 20px 26px;
            scroll-behavior:smooth;
        }
        .movie-row::-webkit-scrollbar { height:7px; }
        .movie-row::-webkit-scrollbar-thumb {
            background:rgba(110,140,255,0.55);
            border-radius:999px;
        }

        .movie-card {
            width:185px;
            flex:0 0 auto;
            position:relative;
            border-radius:18px;
            overflow:hidden;
            background:#0f1428;
            border:1px solid rgba(120,150,255,0.2);
            transition:.28s ease;
            cursor:pointer;
        }
        .movie-card img {
            width:100%;
            height:265px;
            object-fit:cover;
        }
        .movie-card:hover {
            transform:translateY(-6px) scale(1.05);
            border-color:#3f6fff;
            box-shadow:
                0 0 20px rgba(63,111,255,0.65),
                0 0 48px rgba(63,111,255,0.35);
        }

        .movie-hover {
            position:absolute;
            inset:0;
            background:linear-gradient(to top, rgba(0,0,0,0.88), transparent 60%);
            opacity:0;
            display:flex;
            align-items:flex-end;
            padding:12px;
            transition:.28s;
        }
        .movie-card:hover .movie-hover { opacity:1; }
        .hover-text {
            font-size:12px;
            color:#cfd6ff;
            line-height:1.4;
            max-height:70px;
            overflow:hidden;
        }

     
        .slide-btn {
            position:absolute;
            top:50%;
            transform:translateY(-50%);
            width:44px;
            height:70px;
            border-radius:16px;
            border:none;
            background:rgba(12,18,45,0.75);
            color:white;
            font-size:22px;
            cursor:pointer;
            opacity:0;
            transition:.22s;
            z-index:20;
        }
        .slider-wrap:hover .slide-btn { opacity:1; }
        .slide-btn.left { left:10px; }
        .slide-btn.right { right:10px; }
        .slide-btn:hover {
            background:#3f6fff;
            transform:translateY(-50%) scale(1.1);
        }


.floating-test-btn {
    position: fixed;
    right: 26px;
    bottom: 26px;

    width: 50px;
    height: 50px;

    display: flex;
    align-items: center;
    justify-content: center;

    border-radius: 50%;

    /* 고급스러운 글래스 느낌 */
    background: linear-gradient(
        135deg,
        rgba(55, 80, 190, 0.75),
        rgba(35, 55, 140, 0.75)
    );
    backdrop-filter: blur(8px);

    font-size: 21px;
    line-height: 1;
    color: #eef1ff;

    border: 1px solid rgba(140, 165, 255, 0.45);

    box-shadow:
        0 6px 18px rgba(0, 0, 0, 0.55),
        0 0 0 rgba(255,255,255,0);

    transition:
        transform .18s ease,
        box-shadow .18s ease,
        background .18s ease;
}

/* hover는 “과하지 않게” */
.floating-test-btn:hover {
    transform: translateY(-2px) scale(1.06);

    background: linear-gradient(
        135deg,
        rgba(90, 120, 255, 0.95),
        rgba(60, 90, 210, 0.95)
    );

    box-shadow:
        0 10px 28px rgba(80, 120, 255, 0.55),
        0 0 0 1px rgba(255,255,255,0.25);
}

    </style>
</head>

<body>


<%@ include file="/common/header.jsp" %>

<%
    // 서블릿에서 온 요청인지 확인
    if (request.getAttribute("fromServlet") == null) {
        response.sendRedirect(request.getContextPath() + "/indexMovie");
        return;
    }

    Map<String, List<TMDBmovie>> movieLists =
            (Map<String, List<TMDBmovie>>) request.getAttribute("movieLists");

    TMDBmovie banner = (TMDBmovie) request.getAttribute("bannerMovie");

    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    List<TMDBmovie> recommendList =
            (List<TMDBmovie>) request.getAttribute("personalRecommend");

    boolean showPersonal =
            (loginUser != null && recommendList != null && !recommendList.isEmpty());

    // 배너 null 안전 처리
    String bannerBg = "";
    String bannerTitle = "영화 정보를 불러올 수 없습니다.";
    int bannerId = -1;

    if (banner != null) {
        if (banner.getBackdropUrl() != null && !"".equals(banner.getBackdropUrl())) {
            bannerBg = banner.getBackdropUrl();
        } else if (banner.getPosterUrl() != null && !"".equals(banner.getPosterUrl())) {
            bannerBg = banner.getPosterUrl();
        }
        bannerTitle = banner.getTitle();
        bannerId = banner.getId();
    }
%>

<!-- ============================
     MAIN BANNER
============================ -->
<div class="main-banner" style="background-image:url('<%= bannerBg %>');">
    <div class="banner-content">
        <div class="banner-title">
            오늘의 추천 영화: <%= bannerTitle %>
        </div>

        <% if (bannerId > 0) { %>
            <a href="movieDetail?movieId=<%= bannerId %>" class="banner-btn">
                자세히 보기 →
            </a>
        <% } %>
    </div>
</div>


<% if (showPersonal) { %>
    <div class="section-title">
        <%
            String displayName;
            if (loginUser.getNickname() != null && !loginUser.getNickname().trim().isEmpty()) {
                displayName = loginUser.getNickname();
            } else if (loginUser.getUsername() != null && !loginUser.getUsername().trim().isEmpty()) {
                displayName = loginUser.getUsername();
            } else {
                displayName = loginUser.getUserid();
            }
        %>
        <%= displayName %> 님을 위한 맞춤 추천 🎬
    </div>

    <div class="slider-wrap">
        <button class="slide-btn left" onclick="slideLeft('personal')">❮</button>

        <div class="movie-row" id="row-personal">
            <% for (TMDBmovie m : recommendList) { %>
                <div class="movie-card"
                     onclick="location.href='movieDetail?movieId=<%= m.getId() %>'">
                    <img src="<%= m.getPosterUrl() %>" alt="<%= m.getTitle() %>">
                    <div class="movie-hover">
                        <div class="hover-text"><%= m.getOverview() %></div>
                    </div>
                </div>
            <% } %>
        </div>

        <button class="slide-btn right" onclick="slideRight('personal')">❯</button>
    </div>
<% } %>


<%
    if (movieLists != null) {
        for (Map.Entry<String, List<TMDBmovie>> entry : movieLists.entrySet()) {
            String key = entry.getKey();
            List<TMDBmovie> movies = entry.getValue();

            String title;
            if ("animation".equals(key)) {
                title = "애니메이션";
            } else if ("romance".equals(key)) {
                title = "로맨스";
            } else if ("action".equals(key)) {
                title = "액션";
            } else if ("crime".equals(key)) {
                title = "범죄";
            } else if ("fantasy".equals(key)) {
                title = "판타지";
            } else {
                title = key;
            }
%>

    <div class="section-title"><%= title %></div>

    <div class="slider-wrap">
        <button class="slide-btn left" onclick="slideLeft('<%= key %>')">❮</button>

        <div class="movie-row" id="row-<%= key %>">
            <% if (movies != null) {
                   for (TMDBmovie m : movies) { %>
                <div class="movie-card"
                     onclick="location.href='movieDetail?movieId=<%= m.getId() %>'">
                    <img src="<%= m.getPosterUrl() %>" alt="<%= m.getTitle() %>">
                    <div class="movie-hover">
                        <div class="hover-text"><%= m.getOverview() %></div>
                    </div>
                </div>
            <%   }
               } %>
        </div>

        <button class="slide-btn right" onclick="slideRight('<%= key %>')">❯</button>
    </div>

<%
        } // for
    } // if movieLists
%>

<a href="${pageContext.request.contextPath}/movieTest.jsp"
   class="floating-test-btn">🎬</a>


<script>
    function slideLeft(key) {
        var row = document.getElementById("row-" + key);
        if (row) row.scrollBy({ left: -600, behavior: "smooth" });
    }
    function slideRight(key) {
        var row = document.getElementById("row-" + key);
        if (row) row.scrollBy({ left: 600, behavior: "smooth" });
    }
</script>

</body>
</html>
