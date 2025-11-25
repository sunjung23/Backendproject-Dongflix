<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.ReviewDTO" %>

<%
    // 세션에서 로그인 유저 가져오기
    MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // MyPageServlet에서 넘긴 리뷰 목록
    @SuppressWarnings("unchecked")
    List<ReviewDTO> reviews = (List<ReviewDTO>) request.getAttribute("reviews");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - DONGFLIX</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">

    <style>
        body {
            background:#000;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            color:#fff;
        }
        header {
            display:flex;
            align-items:center;
            justify-content:space-between;
            padding:16px 40px;
            background:rgba(0,0,0,0.9);
        }
        header .logo img { height:32px; }
        header nav ul { display:flex; list-style:none; gap:20px; margin:0; padding:0; }
        header nav a { color:#fff; text-decoration:none; font-size:14px; }
        header .mypage a { color:#fff; text-decoration:none; font-weight:600; }

        .mypage-container {
            max-width: 1000px;
            margin: 40px auto 60px;
            background:#111;
            border-radius: 16px;
            padding: 24px 28px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.6);
        }

        .mypage-top {
            display:flex;
            justify-content:space-between;
            align-items:flex-start;
            margin-bottom:24px;
        }

        .user-info {
            display:flex;
            flex-direction:column;
            gap:8px;
        }
        .user-name {
            font-size:24px;
            font-weight:700;
        }
        .user-meta {
            font-size:14px;
            color:#bbb;
        }

        .grade-badge {
            padding:6px 14px;
            border-radius:999px;
            font-size:13px;
            font-weight:600;
            background:rgba(255,255,255,0.08);
            color:#eee;
        }

        .grade-bronze { background:rgba(205, 127, 50, 0.18); color:#f1c27d; }
        .grade-silver { background:rgba(192,192,192,0.2); color:#e0e0e0; }
        .grade-gold   { background:rgba(255,215,0,0.22); color:#ffdd55; }

        .mypage-actions {
            display:flex;
            flex-direction:column;
            gap:8px;
        }

        .mp-btn {
            display:inline-block;
            padding:8px 14px;
            border-radius:8px;
            border:1px solid rgba(255,255,255,0.25);
            background:transparent;
            color:#fff;
            font-size:13px;
            text-decoration:none;
            text-align:center;
        }
        .mp-btn:hover {
            background:rgba(255,255,255,0.12);
        }

        .section-title {
            font-size:18px;
            font-weight:600;
            margin:24px 0 12px;
        }

        .user-detail-table {
            width:100%;
            border-collapse:collapse;
            margin-bottom:20px;
            background:#151515;
            border-radius:12px;
            overflow:hidden;
        }
        .user-detail-table th,
        .user-detail-table td {
            padding:10px 14px;
            font-size:14px;
        }
        .user-detail-table th {
            width:120px;
            text-align:left;
            background:#191919;
            color:#bbb;
        }
        .user-detail-table tr:nth-child(even) td {
            background:#141414;
        }

        .review-list {
            margin-top:8px;
        }
        .review-item {
            border-bottom:1px solid #222;
            padding:12px 0;
        }
        .review-title {
            font-weight:600;
            margin-bottom:4px;
        }
        .review-meta {
            font-size:12px;
            color:#aaa;
            margin-bottom:6px;
        }
        .review-content {
            font-size:14px;
            color:#ddd;
        }
        .no-reviews {
            padding:24px 0;
            text-align:center;
            color:#888;
            font-size:14px;
        }

        a.review-link {
            color:#66b3ff;
            text-decoration:none;
            font-size:13px;
        }
        a.review-link:hover {
            text-decoration:underline;
        }
    </style>
</head>
<body>

<header>
    <div class="logo"><img src="img/logo.png" alt="DONGFLIX"></div>
    <nav>
        <ul>
            <li><a href="index.jsp">홈</a></li>
            <li><a href="#">영화</a></li>
            <li><a href="#">시리즈</a></li>
        </ul>
    </nav>
    <div class="mypage"><a href="mypage.do">마이페이지</a></div>
</header>

<div class="mypage-container">
    <div class="mypage-top">
        <div class="user-info">
            <div class="user-name"><%= user.getUsername() %> 님</div>
            <div class="user-meta">
                아이디 : <%= user.getUserid() %>
            </div>
        </div>

        <div class="mypage-actions">
            <span class="grade-badge 
                <%
                    String grade = user.getGrade();
                    if (grade == null) grade = "bronze";
                    String g = grade.toLowerCase();
                    if (g.equals("bronze")) { out.print("grade-bronze"); }
                    else if (g.equals("silver")) { out.print("grade-silver"); }
                    else if (g.equals("gold")) { out.print("grade-gold"); }
                %>">
                등급 : <%= grade %>
            </span>

            <a href="editProfile.jsp" class="mp-btn">회원정보 수정</a>
            <a href="changePassword.jsp" class="mp-btn">비밀번호 변경</a>
            <a href="logout.do" class="mp-btn">로그아웃</a>
        </div>
    </div>

    <h3 class="section-title">내 정보</h3>
    <table class="user-detail-table">
        <tr>
            <th>아이디</th>
            <td><%= user.getUserid() %></td>
        </tr>
        <tr>
            <th>이름</th>
            <td><%= user.getUsername() %></td>
        </tr>
        <tr>
            <th>등급</th>
            <td><%= grade %></td>
        </tr>
    </table>

    <h3 class="section-title">내가 쓴 리뷰</h3>

    <div class="review-list">
        <%
            if (reviews == null || reviews.isEmpty()) {
        %>
            <div class="no-reviews">아직 작성한 리뷰가 없습니다.</div>
        <%
            } else {
                for (ReviewDTO r : reviews) {
        %>
            <div class="review-item">
                <div class="review-title"><%= r.getTitle() %></div>
                <div class="review-meta">
                    평점: <%= r.getRating() %>/10
                    &nbsp; | &nbsp;
                    작성일: <%= r.getCreatedAt() %>
                </div>
                <div class="review-content"><%= r.getContent() %></div>
                <!-- 추후 상세/수정/삭제 기능 만들면 여기에 링크 추가 -->
                <!-- 예: <a class="review-link" href="reviewView.do?id=<%= r.getId() %>">자세히 보기</a> -->
            </div>
        <%
                }
            }
        %>
    </div>
</div>

</body>
</html>
