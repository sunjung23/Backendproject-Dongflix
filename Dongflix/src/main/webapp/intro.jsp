<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 회원가입 직후 세션에 저장한 장르 (없을 수도 있음)
    String genres = (String) session.getAttribute("signupGenres");
    if (genres == null) genres = "";  

    String username = "";
    Object userObj = session.getAttribute("loginUser");
    if (userObj != null) {
        username = ((com.dongyang.dongflix.dto.MemberDTO) userObj).getUsername();
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DONGFLIX 취향 분석</title>

    <style>
        /* ===============================
           GLOBAL THEME
        =============================== */
        body {
            margin:0;
            height:100vh;
            overflow:hidden;
            background:#000;
            font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            display:flex;
            align-items:center;
            justify-content:center;

            background:
                radial-gradient(circle at 20% 15%, rgba(80,120,255,0.27), transparent 55%),
                radial-gradient(circle at 80% 85%, rgba(140,170,255,0.23), transparent 55%),
                #000;
        }

        /* 중앙 컨테이너 */
        .intro-box {
            text-align:center;
            color:#dfe5ff;
            animation:fadeIn 1.6s ease-out forwards;
            opacity:0;
        }

        @keyframes fadeIn {
            from { opacity:0; transform:translateY(25px); }
            to   { opacity:1; transform:translateY(0); }
        }

        /* 큰 타이틀 */
        .intro-title {
            font-size:32px;
            font-weight:800;
            margin-bottom:20px;
            color:#f2f4ff;
            text-shadow:0 0 12px rgba(90,130,255,0.9);
            animation:titleGlow 3s infinite alternate ease-in-out;
        }

        @keyframes titleGlow {
            0%   { text-shadow:0 0 12px rgba(90,130,255,0.6); }
            100% { text-shadow:0 0 24px rgba(90,130,255,1); }
        }

        .intro-sub {
            font-size:16px;
            color:#b8c2ff;
            margin-bottom:28px;
            animation:fadeSub 2.2s ease-out forwards;
            opacity:0;
        }

        @keyframes fadeSub {
            from { opacity:0; }
            to   { opacity:1; }
        }

        /* 로딩바 */
        .loading-bar {
            width:260px;
            height:8px;
            border-radius:999px;
            background:#1b1f35;
            margin:0 auto;
            overflow:hidden;
            position:relative;
        }

        .loading-inner {
            height:100%;
            width:0%;
            background:linear-gradient(90deg, #3f6fff, #8bb3ff);
            border-radius:999px;
            animation:loadingMove 3.2s forwards ease-out;
        }

        @keyframes loadingMove {
            0%   { width:0%; }
            40%  { width:45%; }
            70%  { width:70%; }
            100% { width:100%; }
        }

        /* 하단 문구 */
        .loading-text {
            margin-top:16px;
            font-size:14px;
            color:#9aa4d9;
            animation:fadeIn 2.4s ease-in forwards;
            opacity:0;
        }
    </style>
</head>

<body>

<div class="intro-box">

    <div class="intro-title">
        <% if (!username.isEmpty()) { %>
            <%= username %>님의 취향 분석 중...
        <% } else { %>
            취향을 분석하고 있어요...
        <% } %>
    </div>

    <div class="intro-sub">
        <% if (!genres.isEmpty()) { %>
            선택한 장르 기반으로 더 정확한 추천을 준비하고 있습니다.<br>
            ( <%= genres %> )
        <% } else { %>
            회원님의 시청 취향을 분석하는 중입니다.
        <% } %>
    </div>

    <div class="loading-bar">
        <div class="loading-inner"></div>
    </div>

    <div class="loading-text">
        나만을 위한 영화 추천 리스트 생성 중...
    </div>

</div>

<script>
    // 3초 후 추천 페이지로 자동 이동
    setTimeout(function(){
        window.location.href = "<%= request.getContextPath() %>/recommend";
    }, 3300);
</script>

</body>
</html>
