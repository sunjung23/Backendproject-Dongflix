<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/common/header.jsp" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>

<%
    BoardDTO b = (BoardDTO) request.getAttribute("dto");
    if (b == null) {
        response.sendRedirect(request.getContextPath() + "/board/list");
        return;
    }
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>

<style>
body {
    background: #000;
    color: #fff;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    margin: 0;
    padding: 0;
}

/* 메인 박스 */
.update-container {
    max-width: 750px;
    margin: 120px auto;
    background: #111;
    padding: 32px;
    border-radius: 16px;
    box-shadow: 0 10px 35px rgba(0,0,0,0.6);
}

/* 제목 */
.update-container h2 {
    font-size: 26px;
    font-weight: 700;
    margin-bottom: 28px;
    border-left: 4px solid #e50914;
    padding-left: 12px;
}

/* input, textarea 스타일 */
.update-container input,
.update-container textarea {
    width: 100%;
    padding: 14px;
    background: #1c1c1c;
    border: 1px solid #333;
    border-radius: 10px;
    color: #fff;
    font-size: 15px;
    margin-bottom: 18px;
    resize: none;
}

.update-container textarea {
    height: 220px;
}

/* 버튼 영역 */
.btn-area {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-top: 10px;
}

/* 수정 버튼 */
.btn-update {
    background: #e50914;
    padding: 10px 20px;
    border-radius: 8px;
    text-decoration: none;
    color: #fff;
    border: none;
    cursor: pointer;
    font-size: 15px;
    transition: 0.2s;
}

.btn-update:hover {
    background: #b20710;
}

/* 취소 버튼 */
.btn-cancel {
    background: #444;
    padding: 10px 18px;
    border-radius: 8px;
    color: #fff;
    text-decoration: none;
    font-size: 15px;
}

.btn-cancel:hover {
    background: #555;
}

</style>
</head>

<body>

<div class="update-container">

    <h2>게시글 수정</h2>

   <form action="<%=request.getContextPath()%>/board/update" method="post">

        <!-- 게시글 ID -->
        <input type="hidden" name="id" value="<%= b.getBoardId() %>">

        <label>제목</label>
        <input type="text" name="title" value="<%= b.getTitle() %>" required>

        <label>내용</label>
        <textarea name="content" required><%= b.getContent() %></textarea>

        <div class="btn-area">
            <button type="submit" class="btn-update">✔ 수정하기</button>
            <a href="detail?id=<%= b.getBoardId() %>" class="btn-cancel">취소</a>
        </div>

    </form>

</div>

</body>
</html>
