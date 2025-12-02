<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>

<%
    BoardDTO b = (BoardDTO) request.getAttribute("dto");
%>

<h2><%= b.getTitle() %></h2>
<p>작성자 : <%= b.getUserid() %></p>
<p>작성일 : <%= b.getCreatedAt() %></p>
<p><%= b.getContent() %></p>


<div class="post-actions">
    <a class="btn-edit" href="updateForm.jsp?id=<%=b.getBoardId() %>">✏ 수정</a>
    <a class="btn-delete" href="delete?id=<%= b.getBoardId() %>" 
       onclick="return confirm('정말 삭제할까요?')">🗑 삭제</a>
</div>

