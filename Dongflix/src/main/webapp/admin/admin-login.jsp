<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 로그인 - DONGFLIX</title>
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
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .logo {
            text-align: center;
            margin-bottom: 40px;
        }
        .logo img {
            height: 60px;
        }
        .login-container {
            background-color: #000;
            padding: 60px 68px 40px;
            border-radius: 4px;
            width: 450px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
        }
        h2 {
            margin-bottom: 28px;
            font-size: 32px;
            font-weight: 700;
            text-align: center;
            color: #fff;
        }
        .form-group {
            margin-bottom: 16px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            color: #b3b3b3;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 16px;
            background-color: #333;
            border: 1px solid #555;
            border-radius: 4px;
            color: white;
            font-size: 16px;
        }
        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #2036CA;
            background-color: #454545;
        }
        .error-message {
            background-color: #e87c03;
            color: white;
            padding: 12px 20px;
            border-radius: 4px;
            margin-bottom: 16px;
            font-size: 14px;
            text-align: center;
        }
        .btn-login {
            width: 100%;
            padding: 16px;
            background-color: #2036CA;
            border: none;
            border-radius: 4px;
            color: white;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            margin-top: 24px;
            transition: background-color 0.3s;
        }
        .btn-login:hover {
            background-color: #1a2ba3;
        }
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        .back-link a {
            color: #737373;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link a:hover {
            text-decoration: underline;
            color: #fff;
        }
    </style>
</head>
<body>

<div class="logo">
    <img src="<%= request.getContextPath() %>/img/logo.png" alt="DONGFLIX">
</div>

<div class="login-container">
    <h2>관리자 로그인</h2>
    
    <% 
        String error = request.getParameter("error");
        if ("1".equals(error)) {
    %>
        <div class="error-message">
            ⚠️ 아이디 또는 비밀번호가 틀렸거나 관리자 권한이 없습니다.
        </div>
    <% } %>
    
    <form action="<%= request.getContextPath() %>/admin/admin-login.do" method="post">
        <div class="form-group">
            <label for="userid">아이디</label>
            <input type="text" id="userid" name="userid" required autofocus>
        </div>
        
        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password" id="password" name="password" required>
        </div>
        
        <button type="submit" class="btn-login">로그인</button>
    </form>
    
    <div class="back-link">
        <a href="<%= request.getContextPath() %>/index.jsp">← 메인 페이지로 돌아가기</a>
    </div>
</div>

</body>
</html>