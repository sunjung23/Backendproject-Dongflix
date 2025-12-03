<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>

<%
    MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
    if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
    	response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DONGFLIX 관리자 페이지</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background-color: #141414;
            color: white;
            font-family: Arial, sans-serif;
        }
        .header {
            background-color: #000;
            padding: 20px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #2036CA;
        }
        .header .logo img {
            height: 40px;
            cursor: pointer;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .logout-btn {
            background-color: #2036CA;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        .logout-btn:hover {
            background-color: #1a2ba3;
        }
        .container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }
        .welcome {
            margin-bottom: 40px;
        }
        .welcome h2 {
            font-size: 32px;
            margin-bottom: 10px;
        }
        .welcome p {
            color: #999;
            font-size: 16px;
        }
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 30px;
            margin-top: 30px;
        }
        .menu-card {
            background-color: #1f1f1f;
            padding: 40px;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: transform 0.3s, background-color 0.3s;
            text-decoration: none;
            color: white;
            display: block;
        }
        .menu-card:hover {
            transform: translateY(-5px);
            background-color: #2a2a2a;
        }
        .menu-card h3 {
            font-size: 24px;
            margin-bottom: 15px;
            color: #2036CA;
        }
        .menu-card p {
            color: #999;
            font-size: 14px;
            line-height: 1.6;
        }
        .icon {
            font-size: 48px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="header">
    <div class="logo">
        <img src="<%= request.getContextPath() %>/img/logo.png" alt="DONGFLIX">
    </div>
    <div class="user-info">
        <span><%= adminUser.getUsername() %> 님</span>
        <a href="<%= request.getContextPath() %>/admin/admin-logout.do" class="logout-btn">로그아웃</a>
    </div>
</div>

<div class="container">
    <div class="welcome">
        <h2>관리자 대시보드</h2>
        <p>DONGFLIX 시스템을 관리할 수 있습니다.</p>
    </div>

    <div class="menu-grid">
        <a href="<%= request.getContextPath() %>/admin/admin-member.do" class="menu-card">
            <div class="icon">👥</div>
            <h3>회원 관리</h3>
            <p>회원 목록 조회 및 등급 관리<br>(Bronze / Silver / Gold)</p>
        </a>

        <a href="<%= request.getContextPath() %>/admin/admin-board.do" class="menu-card">
            <div class="icon">📋</div>
            <h3>게시판 관리</h3>
            <p>자유/등업/비밀 게시판 관리</p>
        </a>

        <a href="<%= request.getContextPath() %>/admin/admin-review.do" class="menu-card">
            <div class="icon">⭐</div>
            <h3>리뷰 관리</h3>
            <p>영화 리뷰 관리 및 삭제</p>
        </a>
    </div>
</div>

</body>
</html>