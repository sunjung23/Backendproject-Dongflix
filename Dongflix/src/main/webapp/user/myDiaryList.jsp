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



</head>
<body>

<div class="container">
    <h2>📘 내 영화 일기장</h2>

    <% if (diaryList == null || diaryList.isEmpty()) { %>
        <div class="empty">작성한 영화 일기가 없습니다.<br>영화 상세 페이지에서 일기를 작성해보세요!</div>
    <% } else { %>

        <div class="grid">
            <% for (DiaryDTO d : diaryList) { %>

                <div class="card">
                    <%
                        String posterPath = d.getPosterPath();
                        String posterUrl = (posterPath != null && !posterPath.isEmpty())
                                ? "https://image.tmdb.org/t/p/w500" + posterPath
                                : request.getContextPath() + "/img/no_poster.png"; // 대체 이미지
                    %>

                    <img class="poster" src="<%= posterUrl %>" alt="포스터">

                    <div class="card-content">
                        <div class="title"><%= d.getMovieTitle() %></div>
                        <div class="date">🗓 <%= d.getDiaryDate() %></div>

                        <div class="content-preview">
                            <%
                                String c = d.getContent();
                                if (c != null && c.length() > 60) {
                                    c = c.substring(0, 60) + "...";
                                }
                            %>
                            <%= c %>
                        </div>

                        <div class="actions">
                            <button class="btn-edit"
                                    onclick="location.href='<%= request.getContextPath() %>/editDiary?id=<%= d.getId() %>'">
                                수정
                            </button>

                            <button class="btn-delete"
                                    onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='<%= request.getContextPath() %>/deleteDiary?id=<%= d.getId() %>';">
                                삭제
                            </button>
                        </div>

                    </div>
                </div>

            <% } %>
        </div>

    <% } %>

</div>

</body>
</html>