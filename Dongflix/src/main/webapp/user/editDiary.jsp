<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dongyang.dongflix.dto.DiaryDTO" %>

<%@ include file="/common/header.jsp" %>

<%
    DiaryDTO d = (DiaryDTO) request.getAttribute("diary");
    if (d == null) {
        response.sendRedirect("myDiaryList");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link rel="stylesheet" type="text/css"
      href="<%= request.getContextPath() %>/css/editDiary.css?v=<%= System.currentTimeMillis() %>">
<title><%= d.getMovieTitle() %> - 일기 수정</title>


</head>
<body>

<div class="edit-container">

    <%
        String poster = (d.getPosterPath() != null && !d.getPosterPath().isEmpty())
                ? "https://image.tmdb.org/t/p/w500" + d.getPosterPath()
                : request.getContextPath() + "/img/no_poster.png";
    %>

    <img class="poster" src="<%= poster %>" alt="포스터">

    <div class="form-box">

        <div class="title"><%= d.getMovieTitle() %></div>

        <form action="<%= request.getContextPath() %>/updateDiary" method="post">

            <input type="hidden" name="id" value="<%= d.getId() %>">

            <div class="label">🗓 날짜</div>
            <input type="date" name="date" value="<%= d.getDiaryDate() %>" required>

            <div class="label">📘 일기 내용</div>
            <textarea name="content" required><%= d.getContent() %></textarea>

            <div class="actions">
                <button type="submit" class="btn btn-save">저장하기</button>
                <button type="button" class="btn btn-cancel"
                        onclick="location.href='<%= request.getContextPath() %>/diaryDetail?id=<%= d.getId() %>'">
                    취소
                </button>
            </div>

        </form>
    </div>

</div>

</body>
</html>