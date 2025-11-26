<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>

<%
    MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
    if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 관리 - DONGFLIX</title>
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
            border-bottom: 1px solid #333;
        }
        .header .logo img {
            height: 35px;
        }
        .header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .back-btn {
            background-color: #333;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        .back-btn:hover {
            background-color: #555;
        }
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        h2 {
            margin-bottom: 20px;
            font-size: 28px;
        }
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            border-bottom: 2px solid #333;
        }
        .tab {
            padding: 12px 24px;
            background-color: transparent;
            color: #999;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }
        .tab:hover {
            color: white;
        }
        .tab.active {
            color: #2036CA;
            border-bottom-color: #2036CA;
        }
        .content-area {
            background-color: #1f1f1f;
            border-radius: 8px;
            padding: 40px;
            text-align: center;
        }
        .placeholder {
            color: #666;
            font-size: 18px;
            padding: 60px 20px;
        }
        .placeholder-icon {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        .info-box {
            background-color: #2a2a2a;
            border-left: 4px solid #2036CA;
            padding: 20px;
            margin-top: 20px;
            text-align: left;
        }
        .info-box h3 {
            color: #2036CA;
            margin-bottom: 10px;
            font-size: 18px;
        }
        .info-box ul {
            color: #999;
            margin-left: 20px;
            line-height: 1.8;
        }
    </style>
    <script>
        function showTab(tabName) {
            // 모든 탭 비활성화
            var tabs = document.getElementsByClassName('tab');
            for (var i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove('active');
            }
            // 클릭한 탭 활성화
            event.target.classList.add('active');
            
            // 내용 변경 (추후 구현)
            alert(tabName + ' 탭 - 추후 구현 예정');
        }
    </script>
</head>
<body>

<div class="header">
    <div class="logo">
        <img src="img/logo.png" alt="DONGFLIX">
    </div>
    <div class="header-right">
        <span>📝 게시글 관리</span>
        <a href="admin-dashboard.jsp" class="back-btn">← 대시보드로</a>
    </div>
</div>

<div class="container">
    <h2>게시글 및 댓글 관리</h2>
    
    <div class="tabs">
        <button class="tab active" onclick="showTab('posts')">게시글 관리</button>
        <button class="tab" onclick="showTab('comments')">댓글 관리</button>
    </div>
    
    <div class="content-area">
        <div class="placeholder-icon">📋</div>
        <div class="placeholder">
            게시글 관리 기능은 추후 구현 예정입니다.<br>
            팀원이 게시글 DB를 완성하면 연동됩니다.
        </div>
        
        <div class="info-box">
            <h3>📌 구현 예정 기능</h3>
            <ul>
                <li><strong>게시글 관리:</strong> 전체 게시글 목록 조회, 부적절한 게시글 숨김 처리</li>
                <li><strong>댓글 관리:</strong> 전체 댓글 목록 조회, 부적절한 댓글 숨김 처리</li>
                <li><strong>상태 관리:</strong> 숨김/표시 상태 전환, 신고 내역 확인</li>
            </ul>
        </div>
        
        <div class="info-box" style="margin-top: 20px;">
            <h3>🔧 연동 필요 사항</h3>
            <ul>
                <li>PostDTO.java - 게시글 데이터 객체</li>
                <li>PostDAO.java - 게시글 DB 처리</li>
                <li>CommentDTO.java - 댓글 데이터 객체</li>
                <li>CommentDAO.java - 댓글 DB 처리</li>
            </ul>
        </div>
    </div>
</div>

</body>
</html>