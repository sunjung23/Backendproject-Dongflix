<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.dongyang.dongflix.dto.MemberDTO" %>

<%
    MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정 - DONGFLIX</title>

<style>
body {
    margin:0;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont,"Segoe UI",sans-serif;
}

.bg-overlay {
    min-height:100vh;
    padding:90px 20px;
    display:flex;
    align-items:center;
    justify-content:center;
    background:
        radial-gradient(circle at 20% 10%, rgba(40,70,160,0.25) 0%, transparent 55%),
        radial-gradient(circle at 80% 90%, rgba(90,130,255,0.22) 0%, transparent 55%),
        #000;
}

/* 메인 컨테이너 */
.edit-container {
    width:100%;
    max-width:540px; /* 🔥 기존 520 → 540으로 넓힘 */
    padding:38px 32px 34px;
    background:rgba(12,14,30,0.94);
    border:1px solid rgba(120,150,255,0.18);
    border-radius:24px;
    box-shadow:0 24px 60px rgba(0,0,40,0.85);
    backdrop-filter:blur(8px);
}

/* 제목 */
.edit-title {
    font-size:26px;
    font-weight:800;
    margin-bottom:6px;
}

.edit-sub {
    font-size:13px;
    color:#c0c6ea;
    margin-bottom:24px;
}

/* 입력 그룹 */
.form-group {
    margin-bottom:18px;
}
label {
    font-size:13px;
    margin-bottom:6px;
    display:block;
    color:#e9ecff;
}

input {
    width:100%;
    padding:12px 14px;
    border-radius:12px;
    background:#0f1325;
    border:1px solid rgba(100,120,210,0.35);
    color:#e8ebff;
    font-size:14px;
    transition:.22s;
    box-sizing:border-box;
}

input:focus {
    background:#131a34;
    border-color:#3f6fff;
    box-shadow:0 0 0 2px rgba(80,120,255,0.45);
    outline:none;
}

input[disabled] {
    opacity:.55;
    cursor:not-allowed;
}

/* 이름+닉네임 두 칸 */
.input-row {
    display:flex;
    gap:12px; /* 🔥 기존 gap 14 → 12 */
}

.input-row .form-group {
    flex:1 1 0; /* 🔥 두 칸 비율 균등하게 */
    margin-bottom:0;
}

/* 버튼 */
.btn-save {
    width:100%;
    padding:14px 0;
    border:none;
    border-radius:999px;
    background:#3f6fff;
    font-size:15px;
    font-weight:700;
    color:#fff;
    cursor:pointer;
    margin-top:10px;
    transition:.22s;
}
.btn-save:hover {
    background:#5d84ff;
    box-shadow:0 6px 18px rgba(80,120,255,0.45);
    transform:translateY(-1px);
}

/* 뒤로가기 */
.btn-back {
    display:block;
    margin-top:15px;
    text-align:center;
    font-size:13px;
    color:#a5aedc;
    text-decoration:none;
}
.btn-back:hover { color:#fff; }

/* 힌트 */
.hint {
    font-size:12px;
    color:#8e96c8;
    margin-top:4px;
}

/* 반응형 */
@media(max-width:620px){
    .edit-container{
        padding:28px 22px;
        border-radius:20px;
    }
}

@media(max-width:540px){
    .input-row{
        flex-direction:column; /* 🔥 모바일에서 자동으로 정렬 문제 해결 */
        gap:14px;
    }
}
</style>

</head>

<body>

<div class="bg-overlay">
    <div class="edit-container">

        <div class="edit-title">회원정보 수정</div>
        <div class="edit-sub">
            프로필 정보를 최신으로 유지하면 추천 기능이 더 정확해져요.
        </div>

        <form action="editProfile.do" method="post">

            <div class="form-group">
                <label>아이디</label>
                <input type="text" value="<%= user.getUserid() %>" disabled>
            </div>

            <div class="input-row">
                <div class="form-group">
                    <label>이름</label>
                    <input type="text" name="username" required value="<%= user.getUsername() %>">
                </div>

                <div class="form-group">
                    <label>닉네임</label>
                    <input type="text" name="nickname"
                           value="<%= user.getNickname() != null ? user.getNickname() : "" %>">
                    <div class="hint">게시판/리뷰에서 보여지는 이름이에요.</div>
                </div>
            </div>

            <div class="form-group">
                <label>연락처</label>
                <input type="text" name="phone"
                       value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
            </div>

            <div class="form-group">
                <label>생일</label>
                <input type="date" name="birth"
                       value="<%= user.getBirth() != null ? user.getBirth() : "" %>">
            </div>

            <div class="form-group">
                <label>프로필 이미지 URL</label>
                <input type="text" name="profileImg"
                       value="<%= user.getProfileImg() != null ? user.getProfileImg() : "" %>">
                <div class="hint">비워두면 기본 이미지가 사용됩니다.</div>
            </div>

            <button type="submit" class="btn-save">저장하기</button>

            <a href="mypage.do" class="btn-back">← 마이페이지로 돌아가기</a>

        </form>
    </div>
</div>

</body>
<%@ include file="/common/alert.jsp" %>
</html>
