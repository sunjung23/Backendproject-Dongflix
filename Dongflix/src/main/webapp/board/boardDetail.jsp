<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>
<%@ page import="com.dongyang.dongflix.dto.BoardCommentDTO" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="java.util.List" %>
<%@ include file="/common/header.jsp" %>

<%
    BoardDTO b = (BoardDTO) request.getAttribute("dto");
    if (b == null) {
        response.sendRedirect("list");
        return;
    }

    // 좋아요 관련
    int likeCount = 0;
    Object likeObj = request.getAttribute("likeCount");
    if (likeObj != null) {
        likeCount = (Integer) likeObj;
    }

    boolean likedByMe = false;
    Object likedByMeObj = request.getAttribute("likedByMe");
    if (likedByMeObj instanceof Boolean) {
        likedByMe = (Boolean) likedByMeObj;
    }

    // 댓글 관련
    List<BoardCommentDTO> comments =
        (List<BoardCommentDTO>) request.getAttribute("comments");

    int commentCount = 0;
    Object ccObj = request.getAttribute("commentCount");
    if (ccObj != null) {
        commentCount = (Integer) ccObj;
    } else if (comments != null) {
        commentCount = comments.size();
    }

    MemberDTO loginUser =
        (MemberDTO) session.getAttribute("loginUser");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= b.getTitle() %> - DONGFLIX</title>

<style>
/* ===========================================
   GLOBAL Premium Style
   =========================================== */
body {
    margin:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

/* ===========================================
   배경 (Glow + Deep Black)
   =========================================== */
.detail-bg {
    min-height:100vh;
    padding:100px 16px;
    background:
        radial-gradient(circle at 20% 15%, rgba(229,9,20,0.35) 0%, transparent 60%),
        radial-gradient(circle at 85% 85%, rgba(255,60,60,0.28) 0%, transparent 60%),
        #000;
    display:flex;
    justify-content:center;
    align-items:flex-start;
}

/* ===========================================
   콘텐츠 박스 (Glassmorphism)
   =========================================== */
.detail-container {
    max-width:900px;
    width:100%;
    background:rgba(17,17,17,0.95);
    padding:38px 32px 30px;
    border-radius:20px;
    border:1px solid rgba(255,255,255,0.08);
    box-shadow:0 20px 60px rgba(0,0,0,0.7);
    backdrop-filter:blur(5px);
}

/* ===========================================
   제목
   =========================================== */
.post-title {
    font-size:30px;
    font-weight:800;
    background:linear-gradient(90deg,#ff3d3d,#e50914);
    -webkit-background-clip:text;
    color:transparent;
    margin-bottom:20px;
}

/* ===========================================
   작성 정보
   =========================================== */
.post-meta {
    font-size:14px;
    color:#c9c9c9;
    line-height:1.8;
    margin-bottom:24px;
    padding-left:14px;
    border-left:3px solid #e50914;
}

/* ===========================================
   본문
   =========================================== */
.post-content {
    background:#1a1a1a;
    padding:20px 22px;
    border-radius:16px;
    font-size:16px;
    border:1px solid #2e2e2e;
    line-height:1.75;
    color:#ececec;
}

/* ===========================================
   좋아요 버튼
   =========================================== */
.like-area {
    margin-top:14px;
    margin-bottom:18px;
}

.like-btn {
    padding:7px 14px;
    border-radius:999px;
    border:1px solid transparent;
    cursor:pointer;
    font-size:13px;
    font-weight:600;
    background:#333;
    color:#fff;
    transition:.2s;
}

.like-btn.like-on {
    background:#e50914;
    border-color:#e50914;
    box-shadow:0 0 10px rgba(229,9,20,0.5);
}

.like-btn.like-off:hover {
    background:#444;
}

/* ===========================================
   버튼 영역
   =========================================== */
.post-actions {
    margin-top:10px;
    display:flex;
    flex-wrap:wrap;
    gap:10px;
}

/* 버튼 공통 */
.post-actions a {
    padding:10px 18px;
    border-radius:10px;
    text-decoration:none;
    color:white;
    font-size:14px;
    font-weight:600;
    transition:.22s;
}

/* 목록 버튼 */
.btn-back {
    background:#222;
}
.btn-back:hover {
    background:#333;
}

/* 수정 버튼 */
.btn-edit {
    background:#e50914;
}
.btn-edit:hover {
    background:#b20710;
    box-shadow:0 8px 18px rgba(229,9,20,0.45);
}

/* 삭제 버튼 */
.btn-delete {
    background:#444;
}
.btn-delete:hover {
    background:#222;
}

/* ===========================================
   댓글 영역 (컴팩트 UI)
   =========================================== */
.comment-title {
    margin-top:26px;
    font-size:17px;
    font-weight:600;
    border-bottom:1px solid #2b2b2b;
    padding-bottom:8px;
}

/* 댓글 작성 폼 */
.comment-box {
    margin-top:10px;
    display:flex;
    gap:8px;
}

.comment-box textarea {
    flex:1;
    resize:vertical;
    min-height:60px;
    max-height:140px;
    border-radius:10px;
    border:1px solid #333;
    background:#141414;
    color:#fff;
    padding:8px 10px;
    font-size:13px;
    line-height:1.5;
    box-sizing:border-box;
}

.comment-box textarea:focus {
    outline:none;
    border-color:#e50914;
    background:#171717;
}

.comment-submit {
    padding:0 14px;
    border-radius:10px;
    border:none;
    background:#e50914;
    color:#fff;
    font-size:13px;
    font-weight:600;
    cursor:pointer;
    white-space:nowrap;
    transition:.2s;
}

.comment-submit:hover {
    background:#b20710;
}

/* 댓글 리스트 */
.comment-list {
    margin-top:14px;
    display:flex;
    flex-direction:column;
    gap:8px;
}

.comment-item {
    padding:10px 12px;
    border-radius:10px;
    background:#151515;
    border:1px solid #242424;
    font-size:13px;
}

/* 한 줄 상단 정보 */
.comment-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:4px;
}

.comment-author {
    font-weight:600;
    color:#f0f0f0;
}

.comment-date {
    font-size:11px;
    color:#909090;
}

/* 댓글 내용 */
.comment-body {
    color:#dddddd;
    line-height:1.5;
}

/* 댓글 삭제 버튼 */
.comment-delete-form {
    margin-top:4px;
    text-align:right;
}

.comment-delete-btn {
    background:transparent;
    border:none;
    color:#999;
    font-size:11px;
    cursor:pointer;
    padding:0;
}

.comment-delete-btn:hover {
    color:#ff6666;
}

/* ===========================================
   반응형
   =========================================== */
@media (max-width:700px) {
    .detail-container { padding:24px 18px 22px; }
    .post-title { font-size:24px; }
    .post-content { padding:18px; }
    .comment-box {
        flex-direction:column;
    }
    .comment-submit {
        align-self:flex-end;
        height:32px;
        margin-top:2px;
    }
}
</style>
</head>

<body>

<div class="detail-bg">
<div class="detail-container">

    <!-- 🔥 제목 -->
    <div class="post-title"><%= b.getTitle() %></div>

    <!-- 🔥 작성 정보 -->
   <div class="post-meta">
   
    <div style="display:flex; align-items:center; gap:10px;">
        
        <a href="<%= request.getContextPath() %>/user/profile?userid=<%= b.getUserid() %>"
           style="display:flex; align-items:center; text-decoration:none; color:#fff; gap:10px;">

            <img src="<%= (request.getContextPath() + "/upload/profile/" + b.getProfileImg()) %>"
                 onerror="this.src='<%= request.getContextPath()%>/assets/default_profile.png';"
                 style="width:38px; height:38px; border-radius:50%; object-fit:cover; border:1px solid #333;">
            
            <span style="font-weight:600;">
                <%= b.getUserid() %>
            </span>
        </a>
    </div>
   <div style="margin-top:6px;">
    작성자 :
    <a href="<%= request.getContextPath() %>/user/profile?userid=<%= b.getUserid() %>"
       style="color:#e50914; text-decoration:none;">
        <%= b.getUserid() %>
    </a><br>
    작성일 : <%= b.getCreatedAt() %><br>
    분류 : <%= b.getCategory() %>
     </div>
</div>


    <!-- 🔥 본문 -->
    <div class="post-content">
        <%= b.getContent().replaceAll("\n", "<br>") %>
    </div>

    <!-- ❤️ 좋아요 영역 -->
    <div class="like-area">
        <form action="<%= request.getContextPath() %>/board/like"
              method="post"
              style="display:inline;">
            <input type="hidden" name="boardId" value="<%= b.getBoardId() %>">
            <button type="submit"
                    class="like-btn <%= likedByMe ? "like-on" : "like-off" %>">
                ♡ 좋아요 (<%= likeCount %>)
            </button>
        </form>
    </div>

    <!-- 🔘 기본 버튼들 -->
    <div class="post-actions">
        <a class="btn-back"
           href="list?category=<%= b.getCategory() %>">← 목록으로</a>

        <a class="btn-edit"
           href="<%= request.getContextPath() %>/board/updateForm?id=<%= b.getBoardId() %>">
           ✏ 수정
        </a>

        <a class="btn-delete"
           href="delete?id=<%= b.getBoardId() %>"
           onclick="return confirm('정말 삭제할까요?')">
           🗑 삭제
        </a>
    </div>

    <!-- 💬 댓글 영역 -->
    <div class="comment-title">
        💬 댓글 (<%= commentCount %>)
    </div>

    <% if (loginUser != null) { %>
        <!-- 댓글 작성 폼 -->
        <form action="<%= request.getContextPath() %>/board/comment/write"
              method="post">
            <input type="hidden" name="boardId" value="<%= b.getBoardId() %>">

            <div class="comment-box">
                <textarea name="content"
                          placeholder="댓글을 입력하세요."
                          required></textarea>
                <button type="submit" class="comment-submit">등록</button>
            </div>
        </form>
    <% } else { %>
        <p style="color:#bbb; margin-top:10px; font-size:13px;">
            댓글 작성은 로그인 후 가능합니다.
        </p>
    <% } %>

    <!-- 댓글 리스트 -->
    <div class="comment-list">
        <% if (comments != null) {
               for (BoardCommentDTO c : comments) {

            	   String displayName = c.getUserid();


                   boolean myComment = (loginUser != null &&
                       loginUser.getUserid().equals(c.getUserid()));
        %>
          <div class="comment-item">
    <div class="comment-header">

        <div style="display:flex; align-items:center; gap:8px;">
            <a href="<%= request.getContextPath() %>/user/profile?userid=<%= c.getUserid() %>"
               style="display:flex; align-items:center; text-decoration:none; color:#fff; gap:8px;">
                
                <img src="<%= request.getContextPath() %>/upload/profile/<%= 
                        (c.getMember() != null && c.getMember().getProfileImg() != null
                         ? c.getMember().getProfileImg()
                         : "default_profile.png") %>"
                     onerror="this.src='<%= request.getContextPath() %>/assets/default_profile.png';"
                     style="width:32px; height:32px; border-radius:50%; object-fit:cover; border:1px solid #333;">

                <span class="comment-author">
                    <%= c.getMember() != null ? 
                            (c.getMember().getNickname() != null && !c.getMember().getNickname().isEmpty()
                            ? c.getMember().getNickname()
                            : c.getUserid())
                        : c.getUserid() %>
                </span>
            </a>
        </div>

        <span class="comment-date"><%= c.getCreatedAt() %></span>
    </div>

    <div class="comment-body">
        <%= c.getContent().replaceAll("\n", "<br>") %>
    </div>

    <% if (myComment) { %>
        <div class="comment-delete-form">
            <form action="<%= request.getContextPath() %>/board/comment/delete" method="post">
                <input type="hidden" name="commentId" value="<%= c.getCommentId() %>">
                <input type="hidden" name="boardId" value="<%= b.getBoardId() %>">
                <button type="submit" class="comment-delete-btn">삭제</button>
            </form>
        </div>
    <% } %>
</div>
        <%   }
           } %>
    </div>

</div>
</div>

</body>
</html>
