<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dongyang.dongflix.dto.BoardDTO" %>
<%@ page import="com.dongyang.dongflix.dto.BoardCommentDTO" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>
<%@ page import="com.dongyang.dongflix.dao.MemberDAO" %>
<%@ page import="java.util.List" %>
<%@ include file="/common/header.jsp" %>

<%
    BoardDTO b = (BoardDTO) request.getAttribute("dto");
    if (b == null) {
        response.sendRedirect("list");
        return;
    }

    int likeCount = 0;
    Object likeObj = request.getAttribute("likeCount");
    if (likeObj != null) likeCount = (Integer) likeObj;

    boolean likedByMe = false;
    Object likedByMeObj = request.getAttribute("likedByMe");
    if (likedByMeObj instanceof Boolean) likedByMe = (Boolean) likedByMeObj;

    List<BoardCommentDTO> comments = 
        (List<BoardCommentDTO>) request.getAttribute("comments");

    int commentCount = 0;
    Object ccObj = request.getAttribute("commentCount");
    if (ccObj != null) commentCount = (Integer) ccObj;
    else if (comments != null) commentCount = comments.size();

    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

    MemberDAO memberDao = new MemberDAO();
    String writerNickname = memberDao.getOrCreateNickname(b.getUserid());
    MemberDTO writer = memberDao.getByUserid(b.getUserid());
    String writerProfileImg = (writer != null) ? writer.getProfileImg() : null;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= b.getTitle() %> - DONGFLIX</title>

<style>
/* ===========================================
   GLOBAL Premium Blue Style
=========================================== */
* { box-sizing:border-box; }

body {
    margin:0;
    background:#040611;
    color:#e6e9ff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", system-ui, sans-serif;
}

/* ===========================================
   BACKGROUND (Deep Navy + Blue Glow)
=========================================== */
.detail-bg {
    min-height:100vh;
    padding:100px 16px 60px;
    background:
        radial-gradient(circle at 15% 0%, rgba(63,111,255,0.32) 0%, transparent 55%),
        radial-gradient(circle at 85% 100%, rgba(0,212,255,0.20) 0%, transparent 55%),
        linear-gradient(180deg, #040611 0%, #070b12 45%, #040611 100%);
    display:flex;
    justify-content:center;
}

/* ===========================================
   MAIN CONTENT BOX (Glass Navy)
=========================================== */
.detail-container {
    width:100%;
    max-width:900px;
    background:rgba(8,13,28,0.92);
    padding:38px 32px 30px;
    border-radius:22px;
    border:1px solid rgba(120,150,255,0.18);
    backdrop-filter:blur(12px);
    box-shadow:0 26px 70px rgba(0,0,0,0.85);
    position:relative;
    overflow:hidden;
}

.detail-container::before {
    content:"";
    position:absolute;
    inset:0;
    border-radius:22px;
    pointer-events:none;
    background:
        linear-gradient(135deg, rgba(63,111,255,0.20), transparent 50%, rgba(0,212,255,0.12));
    opacity:0.55;
    mix-blend-mode:screen;
}

.detail-container > * { position:relative; z-index:2; }

/* ===========================================
   TITLE
=========================================== */
.post-title {
    font-size:30px;
    font-weight:800;
    margin-bottom:18px;
    background:linear-gradient(90deg,#3F6FFF,#00C8FF,#9bd3ff);
    -webkit-background-clip:text;
    color:transparent;
}

/* ===========================================
   POST META
=========================================== */
.post-meta {
    padding:14px 18px;
    border-left:3px solid #3F6FFF;
    background:rgba(15,20,40,0.65);
    border-radius:12px;
    font-size:14px;
    color:#cdd6ff;
    line-height:1.75;
    margin-bottom:26px;
}

/* ===========================================
   CONTENT BOX
=========================================== */
.post-content {
    background:#0b1328;
    border:1px solid rgba(120,150,255,0.28);
    padding:22px 24px;
    border-radius:16px;
    font-size:16px;
    line-height:1.75;
    color:#e6ecff;
    box-shadow:0 16px 40px rgba(0,0,0,0.7);
}

/* ===========================================
   LIKE AREA
=========================================== */
.like-area {
    margin-top:18px;
    margin-bottom:18px;
}

.like-btn {
    padding:8px 16px;
    border-radius:999px;
    border:1px solid rgba(120,150,255,0.55);
    background:#0c1329;
    color:#ced7ff;
    font-size:13px;
    font-weight:600;
    cursor:pointer;
    transition:.22s;
}

.like-btn.like-on {
    background:linear-gradient(135deg,#2036CA,#3F6FFF);
    color:#fff;
    border-color:#3F6FFF;
    box-shadow:0 0 12px rgba(63,111,255,0.65);
}

.like-btn.like-off:hover {
    background:#15204a;
    border-color:#3F6FFF;
    color:#fff;
}

/* ===========================================
   ACTION BUTTONS
=========================================== */
.post-actions {
    margin-top:12px;
    display:flex;
    gap:12px;
}

.post-actions a {
    padding:10px 20px;
    border-radius:999px;
    font-size:13px;
    font-weight:600;
    text-decoration:none;
    color:white;
    border:1px solid transparent;
    transition:.2s;
}

/* BACK */
.btn-back {
    background:#0d142b;
    border-color:rgba(120,150,255,0.35);
    color:#d3dbff;
}
.btn-back:hover {
    background:#18245a;
    border-color:#3F6FFF;
}

/* EDIT */
.btn-edit {
    background:linear-gradient(135deg,#2036CA,#3F6FFF);
}
.btn-edit:hover {
    background:linear-gradient(135deg,#3250ff,#00d4ff);
    box-shadow:0 10px 26px rgba(63,111,255,0.6);
}

/* DELETE */
.btn-delete {
    background:rgba(60,15,25,0.9);
    border-color:rgba(229,9,20,0.5);
}
.btn-delete:hover {
    background:#d9081a;
    box-shadow:0 10px 24px rgba(229,9,20,0.6);
}

/* ===========================================
   COMMENT SECTION
=========================================== */
.comment-title {
    margin-top:28px;
    font-size:18px;
    font-weight:700;
    border-bottom:1px solid rgba(120,150,255,0.4);
    padding-bottom:8px;
    color:#dbe3ff;
}

.comment-box {
    margin-top:12px;
    display:flex;
    gap:10px;
}

.comment-box textarea {
    flex:1;
    background:#060b1a;
    border:1px solid rgba(120,150,255,0.55);
    border-radius:10px;
    padding:10px;
    color:#e6ecff;
    resize:vertical;
    min-height:70px;
    max-height:160px;
}

.comment-box textarea:focus {
    outline:none;
    border-color:#3F6FFF;
    background:#081024;
    box-shadow:0 0 10px rgba(63,111,255,0.7);
}

.comment-submit {
    background:linear-gradient(135deg,#2036CA,#3F6FFF);
    padding:0 16px;
    border-radius:10px;
    color:white;
    font-weight:600;
    border:1px solid transparent;
    cursor:pointer;
    transition:.22s;
}

.comment-submit:hover {
    background:linear-gradient(135deg,#3250ff,#00d4ff);
}

/* ===========================================
   COMMENT LIST
=========================================== */
.comment-list {
    margin-top:16px;
    display:flex;
    flex-direction:column;
    gap:12px;
}

.comment-item {
    background:#0b1328;
    padding:12px 14px;
    border-radius:12px;
    border:1px solid rgba(120,150,255,0.35);
    box-shadow:0 10px 24px rgba(0,0,0,0.6);
    font-size:13px;
}

.comment-header {
    display:flex;
    justify-content:space-between;
    margin-bottom:4px;
}

.comment-author {
    font-weight:600;
    color:#e8edff;
}

.comment-date {
    font-size:11px;
    color:#9aa6d8;
}

.comment-body {
    color:#dbe3ff;
    line-height:1.55;
}

/* DELETE BTN */
.comment-delete-btn {
    background:none;
    border:none;
    color:#bb4646;
    font-size:12px;
    cursor:pointer;
    margin-top:4px;
}
.comment-delete-btn:hover {
    color:#ff6b6b;
}

/* ===== COMMENT PROFILE AVATAR (CHARCOAL BLACK / SOLID) ===== */
.profile-avatar {
    width:32px;
    height:32px;
    border-radius:50%;

    /* ✅ 단색 차콜 블랙 */
    background: #14161b;

    border:1px solid rgba(120,150,255,0.35);
    box-shadow:
        inset 0 0 0 1px rgba(255,255,255,0.03),
        0 0 10px rgba(30,60,255,0.25);

    display:flex;
    align-items:center;
    justify-content:center;
    overflow:hidden;
    flex-shrink:0;
}

.profile-avatar img {
    width:100%;
    height:100%;
    object-fit:cover;
}




</style>
</head>

<body>

<div class="detail-bg">
<div class="detail-container">

    <!-- Title -->
    <div class="post-title"><%= b.getTitle() %></div>

    <!-- Author Info -->
    <div class="post-meta">
        <a href="<%= request.getContextPath() %>/user/profile?userid=<%= b.getUserid() %>"
           style="display:flex; align-items:center; gap:10px; text-decoration:none; color:#fff;">

            <%
                // ✅ 기본 이미지 (img 폴더 기준)
                String defaultImg = request.getContextPath() + "/img/default_profile.png";

                String profile = writerProfileImg;

                String imgSrc = defaultImg;

                if (profile != null) {
                    String p = profile.trim();

                    // ✅ "이미지 없음" 취급: null/빈값/"null"/기본파일명
                    if (p.isEmpty()
                            || "null".equalsIgnoreCase(p)
                            || "default_profile.png".equalsIgnoreCase(p)
                            || "default_profile_blue.png".equalsIgnoreCase(p)) {
                        imgSrc = defaultImg;

                    } else if (p.startsWith("http")) {
                        imgSrc = p;

                    } else if (p.startsWith("/")) {
                        // DB에 "/upload/profile/xxx" 또는 "/img/xxx"처럼 저장된 경우
                        imgSrc = request.getContextPath() + p;

                    } else {
                        imgSrc = request.getContextPath() + "/upload/profile/" + p;
                    }
                }
            %>

            <div class="profile-avatar" style="width:40px; height:40px;">
    <img src="<%= imgSrc %>"
         onerror="this.style.display='none';">
</div>

            <span style="font-size:15px; font-weight:600;">
                <%= writerNickname %>
            </span>
        </a>

        <div style="margin-top:10px;">
            작성자 :
            <a href="<%= request.getContextPath() %>/user/profile?userid=<%= b.getUserid() %>"
               style="color:#3F6FFF; text-decoration:none;">
               <%= writerNickname %>
            </a><br>

            작성일 : <%= b.getCreatedAt() %><br>
            분류 : <%= b.getCategory() %>
        </div>
    </div>

    <!-- Content -->
    <div class="post-content">
        <%= b.getContent().replaceAll("\n", "<br>") %>
    </div>

    <!-- Like -->
    <div class="like-area">
        <form action="<%= request.getContextPath() %>/board/like" method="post" style="display:inline;">
            <input type="hidden" name="boardId" value="<%= b.getBoardId() %>">
            <button type="submit" class="like-btn <%= likedByMe ? "like-on":"like-off"%>">
                ♡ 좋아요 (<%= likeCount %>)
            </button>
        </form>
    </div>

    <!-- Buttons -->
    <div class="post-actions">
        <a class="btn-back" href="list?category=<%= b.getCategory() %>">← 목록으로</a>

        <a class="btn-edit"
           href="<%= request.getContextPath() %>/board/updateForm?id=<%= b.getBoardId() %>">
           ✏ 수정
        </a>

        <a class="btn-delete"
           href="delete?id=<%= b.getBoardId() %>"
           onclick="return confirm('정말 삭제할까요?');">
           🗑 삭제
        </a>
    </div>

    <!-- Comments -->
    <div class="comment-title">
        💬 댓글 (<%= commentCount %>)
    </div>

    <% if (loginUser != null) { %>
        <form action="<%= request.getContextPath() %>/board/comment/write" method="post">
            <input type="hidden" name="boardId" value="<%= b.getBoardId() %>">

            <div class="comment-box">
                <textarea name="content" placeholder="댓글을 입력하세요." required></textarea>
                <button type="submit" class="comment-submit">등록</button>
            </div>
        </form>
    <% } else { %>
        <p style="color:#9aa6d8; margin-top:10px; font-size:13px;">댓글 작성은 로그인 후 가능합니다.</p>
    <% } %>

    <!-- Comment List -->
    <div class="comment-list">
        <% if (comments != null) {
            for (BoardCommentDTO c : comments) {

                boolean myComment = (loginUser != null &&
                       loginUser.getUserid().equals(c.getUserid()));
        %>

        <div class="comment-item">

            <div class="comment-header">

                <div style="display:flex; align-items:center; gap:8px;">
                  <%
                      // ✅ 기본 이미지 (img 폴더 기준)
                      String cDefaultImg = request.getContextPath() + "/img/default_profile.png";

                      String cProfile = null;
                      if (c.getMember() != null) {
                          cProfile = c.getMember().getProfileImg();
                      }

                      String cImgSrc = cDefaultImg;

                      if (cProfile != null) {
                          String p = cProfile.trim();

                          // ✅ "이미지 없음" 취급: null/빈값/"null"/기본파일명
                          if (p.isEmpty()
                                  || "null".equalsIgnoreCase(p)
                                  || "default_profile.png".equalsIgnoreCase(p)
                                  || "default_profile_blue.png".equalsIgnoreCase(p)) {
                              cImgSrc = cDefaultImg;

                          } else if (p.startsWith("http")) {
                              cImgSrc = p;

                          } else if (p.startsWith("/")) {
                              cImgSrc = request.getContextPath() + p;

                          } else {
                              cImgSrc = request.getContextPath() + "/upload/profile/" + p;
                          }
                      }
                  %>

                  <div class="profile-avatar">
    <img src="<%= cImgSrc %>"
         onerror="this.style.display='none';">
</div>

                    <span class="comment-author">
                        <%= (c.getMember()!=null && c.getMember().getNickname()!=null && !c.getMember().getNickname().isEmpty())
                                ? c.getMember().getNickname()
                                : c.getUserid() %>
                    </span>
                </div>

                <span class="comment-date"><%= c.getCreatedAt() %></span>
            </div>

            <div class="comment-body">
                <%= c.getContent().replaceAll("\n","<br>") %>
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

        <% } } %>

    </div>

</div>
</div>

</body>

<%@ include file="/common/alert.jsp" %>
</html>
