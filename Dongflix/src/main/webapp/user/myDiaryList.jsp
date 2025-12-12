<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.DiaryDTO" %>

<%@ include file="/common/header.jsp" %>

<%
    List<DiaryDTO> diaryList = (List<DiaryDTO>) request.getAttribute("diaryList");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 영화 일기장</title>

<link rel="stylesheet" type="text/css"
      href="<%= request.getContextPath() %>/css/myDiaryList.css?v=<%= System.currentTimeMillis() %>">

<style>
    .card-link {
        text-decoration: none;
        color: inherit;
    }
</style>

</head>
<body>

<div class="container">
    <h2>내 영화 일기장</h2>

    <% if (diaryList == null || diaryList.isEmpty()) { %>
        <div class="empty">작성한 영화 일기가 없습니다.<br>영화 상세 페이지에서 일기를 작성해보세요!</div>
    <% } else { %>

        <div class="grid">
            <% for (DiaryDTO d : diaryList) { 
                String poster = (d.getPosterPath() != null && !d.getPosterPath().isEmpty())
                        ? "https://image.tmdb.org/t/p/w500" + d.getPosterPath()
                        : request.getContextPath() + "/img/no_poster.png";
            %>

            <a href="<%= request.getContextPath() %>/diaryDetail?id=<%= d.getId() %>" class="card-link">
                <div class="card">
                    <img class="poster" src="<%= poster %>" alt="포스터">

                    <div class="card-content">
                        <div class="title"><%= d.getMovieTitle() %></div>
                        <div class="date">🗓 <%= d.getDiaryDate() %></div>

                        <div class="content-preview">
                            <%
                                String preview = d.getContent();
                                if (preview != null && preview.length() > 60) {
                                    preview = preview.substring(0, 60) + "...";
                                }
                            %>
                            <%= preview %>
                        </div>
                    </div>
                </div>
            </a>

            <% } %>
        </div>

    <% } %>

</div>

</body>
</html>