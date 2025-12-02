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
        font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }

    /* 배경 그라디언트 느낌 */
    .bg-overlay {
        min-height:100vh;
        background:
            radial-gradient(circle at top, rgba(229,9,20,0.25) 0, transparent 55%),
            #000;
        display:flex;
        align-items:center;
        justify-content:center;
        padding:80px 16px;
        box-sizing:border-box;
    }

    .edit-container {
        width:100%;
        max-width:520px;
        background:rgba(17,17,17,0.96);
        border-radius:18px;
        padding:30px 26px 28px;
        box-shadow:0 10px 35px rgba(0,0,0,0.7);
        border:1px solid #222;
    }

    .edit-title {
        font-size:24px;
        font-weight:700;
        margin-bottom:6px;
    }

    .edit-sub {
        font-size:13px;
        color:#bbb;
        margin-bottom:22px;
    }

    .form-group { 
        margin-bottom:16px;
    }

    label {
        display:block;
        font-size:13px;
        margin-bottom:6px;
        color:#ddd;
    }

    .input-row {
        display:flex;
        gap:10px;
    }

    .input-row .form-group {
        flex:1;
        margin-bottom:0;
    }

    input {
        width:100%;
        padding:11px 12px;
        border-radius:9px;
        border:1px solid #333;
        background:#1b1b1b;
        color:#fff;
        font-size:14px;
        box-sizing:border-box;
        transition:border-color .2s, background .2s, box-shadow .2s;
    }

    input:focus {
        outline:none;
        border-color:#e50914;
        background:#202020;
        box-shadow:0 0 0 1px rgba(229,9,20,0.6);
    }

    input[disabled] {
        opacity:0.6;
        cursor:not-allowed;
    }

    .btn-save {
        width:100%;
        margin-top:10px;
        padding:12px 16px;
        border:none;
        border-radius:9px;
        background:#e50914;
        color:#fff;
        font-size:15px;
        font-weight:600;
        cursor:pointer;
        transition:background .2s, transform .1s, box-shadow .2s;
    }

    .btn-save:hover {
        background:#b20710;
        box-shadow:0 6px 18px rgba(229,9,20,0.45);
        transform:translateY(-1px);
    }

    .btn-back {
        display:block;
        margin-top:14px;
        text-align:center;
        color:#aaa;
        font-size:13px;
        text-decoration:none;
        transition:color .2s;
    }

    .btn-back:hover {
        color:#fff;
    }

    /* 작은 안내 텍스트 */
    .hint {
        font-size:12px;
        color:#777;
        margin-top:2px;
    }

    /* 반응형 - 모바일에서 여백 조정 */
    @media (max-width: 600px) {
        .bg-overlay {
            padding:72px 14px;
        }
        .edit-container {
            padding:24px 18px 22px;
            border-radius:14px;
        }
        .edit-title {
            font-size:21px;
        }
        .input-row {
            flex-direction:column;
        }
    }
</style>

</head>
<body>

<div class="bg-overlay">
    <div class="edit-container">
        <div class="edit-title">회원정보 수정</div>
        <div class="edit-sub">프로필 정보를 최신으로 유지하면 추천과 서비스 이용이 더 편해져요.</div>

        <form action="editProfile.do" method="post">

            <!-- 아이디 (수정 불가) -->
            <div class="form-group">
                <label>아이디</label>
                <input type="text" value="<%= user.getUserid() %>" disabled>
            </div>

            <!-- 이름 + 닉네임 나란히 (PC일 때) -->
            <div class="input-row">
                <div class="form-group">
                    <label>이름</label>
                    <input type="text" name="username" required
                           value="<%= user.getUsername() %>">
                </div>

                <div class="form-group">
                    <label>닉네임</label>
                    <input type="text" name="nickname"
                           value="<%= user.getNickname() != null ? user.getNickname() : "" %>">
                    <div class="hint">리뷰, 게시판에서 보여지는 이름이에요.</div>
                </div>
            </div>

            <!-- 연락처 -->
            <div class="form-group">
                <label>연락처</label>
                <input type="text" name="phone"
                       placeholder="예: 010-1234-5678"
                       value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
            </div>

            <!-- 생일 -->
            <div class="form-group">
                <label>생일</label>
                <input type="date" name="birth"
                       value="<%= user.getBirth() != null ? user.getBirth() : "" %>">
            </div>

            <!-- 프로필 이미지 URL -->
            <div class="form-group">
                <label>프로필 이미지 URL</label>
                <input type="text" name="profileImg"
                       placeholder="프로필로 사용할 이미지 URL을 입력하세요"
                       value="<%= user.getProfileImg() != null ? user.getProfileImg() : "" %>">
                <div class="hint">공백일 경우 기본 프로필 이미지가 사용됩니다.</div>
            </div>

            <button type="submit" class="btn-save">저장하기</button>

            <a href="mypage.do" class="btn-back">← 마이페이지로 돌아가기</a>
        </form>
    </div>
</div>

</body>
</html>
