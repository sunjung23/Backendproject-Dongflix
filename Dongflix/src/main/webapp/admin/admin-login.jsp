<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>DONGFLIX 관리자 로그인</title>
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
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            flex-direction: column;
        }
        .logo-header {
            margin-bottom: 30px;
        }
        .logo-header img {
            height: 60px;
        }
        .login-container {
            background-color: rgba(0, 0, 0, 0.75);
            padding: 60px;
            border-radius: 4px;
            width: 450px;
        }
        h2 {
            margin-bottom: 28px;
            font-size: 32px;
        }
        .form-group {
            margin-bottom: 16px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 16px;
            background-color: #333;
            border: none;
            border-radius: 4px;
            color: white;
            font-size: 16px;
        }
        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            background-color: #454545;
        }
        .btn-login {
            width: 100%;
            padding: 16px;
            background-color: #2036CA;
            border: none;
            border-radius: 4px;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 24px;
        }
        .btn-login:hover {
            background-color: #1a2ba3;
        }
        .error-message {
            background-color: #e87c03;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 16px;
            font-size: 14px;
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
        }
    </style>
</head>
<body>

<div class="logo-header">
   <img src="<%= request.getContextPath() %>/img/logo.png">

<div class="login-container">
    <h2>관리자 로그인</h2>

    <%
        String error = request.getParameter("error");
        if ("1".equals(error)) {
    %>
        <div class="error-message">
            ⚠ 관리자 권한이 없거나 로그인 정보가 올바르지 않습니다.
        </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/admin-login.do" method="post">
        <div class="form-group">
            <label>아이디</label>
            <input type="text" name="userid" required>
        </div>

        <div class="form-group">
            <label>비밀번호</label>
            <input type="password" name="password" required>
        </div>

        <button type="submit" class="btn-login">로그인</button>
    </form>

    <div class="back-link">
        <a href="${pageContext.request.contextPath}/indexMovie">← 메인으로 돌아가기</a>
    </div>
</div>

</body>
</html>