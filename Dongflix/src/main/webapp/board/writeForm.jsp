<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="/common/header.jsp" %>

<%
    // 로그인 확인
    com.dongyang.dongflix.dto.MemberDTO user =
            (com.dongyang.dongflix.dto.MemberDTO) session.getAttribute("loginUser");

    if (user == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>

<style>
    .write-container {
        max-width: 700px;
        margin: 80px auto;
        padding: 20px;
        background: #111;
        color: #fff;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(255,255,255,0.1);
    }
    input, textarea {
        width: 100%;
        padding: 10px;
        background: #222;
        border: 1px solid #444;
        border-radius: 6px;
        color: #fff;
        margin-bottom: 15px;
    }
    button {
        padding: 10px 20px;
        background: #e50914;
        border: none;
        border-radius: 6px;
        color: #fff;
        cursor: pointer;
    }
    button:hover {
        background: #b20710;
    }
</style>

</head>
<body>

<div class="write-container">

    <h2>게시글 작성</h2>

    <form action="<%=request.getContextPath()%>/board/write" method="post">
    <label>카테고리</label>
    <p>
		<select name="category" required>
   		 <option value="free">📢 자유게시판</option>
   		 <option value="level">⬆️ 등업게시판</option>
   		 <option value="secret">🔒 비밀게시판</option>
		</select>
    	<p>
    	
        <label>제목</label>
        <input type="text" name="title" required>

        <label>내용</label>
        <textarea name="content" rows="8" required></textarea>

        <button type="submit">작성하기</button>
    </form>

</div>

</body>
</html>
