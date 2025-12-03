<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="java.util.List" %>

<%
    MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
    if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    List<MemberDTO> members = (List<MemberDTO>) request.getAttribute("members");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 관리 - DONGFLIX</title>
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
        .table-container {
            background-color: #1f1f1f;
            border-radius: 8px;
            padding: 20px;
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #333;
        }
        th {
            background-color: #2a2a2a;
            color: #2036CA;
            font-weight: bold;
        }
        tr:hover {
            background-color: #2a2a2a;
        }
        select {
            padding: 6px 12px;
            background-color: #333;
            color: white;
            border: 1px solid #555;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        select:focus {
            outline: none;
            border-color: #2036CA;
        }
        select:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        .btn-update {
            background-color: #2036CA;
            color: white;
            padding: 6px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-update:hover {
            background-color: #1a2ba3;
        }
        .grade-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        .grade-admin {
            background-color: #2036CA;
            color: white;
        }
        .grade-gold {
            background-color: #ffd700;
            color: #000;
        }
        .grade-silver {
            background-color: #c0c0c0;
            color: #000;
        }
        .grade-bronze {
            background-color: #cd7f32;
            color: white;
        }
        /* 상세보기 버튼 스타일 추가 */
        .btn-detail {
            padding: 6px 14px;
            background: #e50914;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            text-decoration: none;
            display: inline-block;
            transition: .2s;
        }
        
        .btn-detail:hover {
            background: #f40612;
            box-shadow: 0 4px 12px rgba(229, 9, 20, 0.4);
        }
        
        .no-change {
            color: #999;
            font-size: 16px;
        }
    </style>
    <script>
        function updateGrade(userid, selectElement) {
            var newGrade = selectElement.value;
            if (confirm(userid + ' 회원의 등급을 ' + newGrade.toUpperCase() + '(으)로 변경하시겠습니까?')) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/admin/admin-member.do';
                
                var useridInput = document.createElement('input');
                useridInput.type = 'hidden';
                useridInput.name = 'userid';
                useridInput.value = userid;
                
                var gradeInput = document.createElement('input');
                gradeInput.type = 'hidden';
                gradeInput.name = 'grade';
                gradeInput.value = newGrade;
                
                form.appendChild(useridInput);
                form.appendChild(gradeInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</head>
<body>

<div class="header">
    <div class="logo">
        <img src="<%= request.getContextPath() %>/img/logo.png" alt="DONGFLIX">
    </div>
    <div class="header-right">
        <span>👥 회원 관리</span>
        <a href="admin-dashboard.jsp" class="back-btn">← 대시보드로</a>
    </div>
</div>

<div class="container">
    <h2>전체 회원 목록</h2>
    
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>현재 등급</th>
                    <th>등급 변경</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <% for (MemberDTO m : members) { 
                    // 관리자 본인인지 체크
                    boolean isCurrentAdmin = m.getUserid().equals(adminUser.getUserid());
                    // admin 등급인지 체크
                    boolean isAdminGrade = "admin".equals(m.getGrade());
                %>
                <tr>
                    <td><%= m.getUserid() %></td>
                    <td><%= m.getUsername() %></td>
                    <td>
                        <span class="grade-badge grade-<%= m.getGrade().toLowerCase() %>">
                            <%= m.getGrade().toUpperCase() %>
                        </span>
                    </td>
                    <td>
                        <% if (isCurrentAdmin || isAdminGrade) { %>
                            <!-- 관리자 본인이거나 admin 등급인 경우 변경 불가 -->
                            <span class="no-change">변경 불가</span>
                        <% } else { %>
                            <!-- 일반 회원인 경우만 등급 변경 가능 -->
                            <select onchange="updateGrade('<%= m.getUserid() %>', this)">
                                <option value="">등급 선택</option>
                                <option value="bronze" <%= "bronze".equals(m.getGrade()) ? "selected" : "" %>>Bronze</option>
                                <option value="silver" <%= "silver".equals(m.getGrade()) ? "selected" : "" %>>Silver</option>
                                <option value="gold" <%= "gold".equals(m.getGrade()) ? "selected" : "" %>>Gold</option>
                            </select>
                        <% } %>
                    </td>
                    <td>
                        <a href="admin-member-detail.do?userid=<%= m.getUserid() %>" class="btn-detail">상세보기</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>