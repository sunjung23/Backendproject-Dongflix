<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dongyang.dongflix.dto.DiaryDTO" %>

<%@ include file="/common/header.jsp" %>

<%
    DiaryDTO d = (DiaryDTO) request.getAttribute("diary");
    if (d == null) {
        response.sendRedirect(request.getContextPath() + "/myDiaryList");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link rel="stylesheet" type="text/css"
      href="<%= request.getContextPath() %>/css/diaryDetail.css?v=<%= System.currentTimeMillis() %>">
<title><%= d.getMovieTitle() %> - 일기 상세보기</title>


</head>
<body>

<div class="detail-container">

    <%
        String poster = (d.getPosterPath() != null && !d.getPosterPath().isEmpty())
                ? "https://image.tmdb.org/t/p/w500" + d.getPosterPath()
                : request.getContextPath() + "/img/no_poster.png";
    %>

    <img class="poster" src="<%= poster %>" alt="포스터">

    <div class="info">
        <div class="title"><%= d.getMovieTitle() %></div>
        <div class="date">작성일: <%= d.getDiaryDate() %></div>

        <div class="content-box"><%= d.getContent() %></div>

        <div class="actions">
            <button class="btn btn-edit"
                onclick="location.href='<%= request.getContextPath() %>/editDiary?id=<%= d.getId() %>'">
                수정
            </button>

            <button class="btn btn-delete"
                onclick="if(confirm('삭제하시겠습니까?')) location.href='<%= request.getContextPath() %>/deleteDiary?id=<%= d.getId() %>'">
                삭제
            </button>
        </div>
    </div>

</div>

</body>
</html>