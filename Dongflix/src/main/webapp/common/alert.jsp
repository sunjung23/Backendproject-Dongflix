<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String alertType = (String) request.getAttribute("alertType");
    String alertMsg  = (String) request.getAttribute("alertMsg");
    String redirect  = (String) request.getAttribute("redirectUrl");

    // alertMsg 없으면 렌더링 안 함
    if (alertMsg == null || alertType == null) return;
%>

<style>

.alert-overlay {
    position:fixed;
    top:0; left:0;
    width:100%; height:100%;
    background:rgba(0,0,0,0.55);
    backdrop-filter:blur(3px);
    display:flex;
    align-items:center;
    justify-content:center;
    z-index:9999;
    animation:fadeIn .25s ease-out;
}

@keyframes fadeIn {
    from { opacity:0; }
    to   { opacity:1; }
}

.alert-box {
    background:rgba(15,18,40,0.95);
    padding:30px 28px;
    border-radius:22px;
    width:90%;
    max-width:360px;
    text-align:center;
    border:1px solid rgba(120,150,255,0.28);
    box-shadow:0 18px 55px rgba(40,60,150,0.55);
    animation:pop .22s ease-out;
}

@keyframes pop {
    from { transform:scale(.85); opacity:.6; }
    to   { transform:scale(1); opacity:1; }
}

.alert-title {
    font-size:19px;
    font-weight:700;
    margin-bottom:12px;
}

.alert-msg {
    font-size:14px;
    color:#ccd5ff;
    line-height:1.5;
    margin-bottom:22px;
}

/* 버튼 */
.alert-btn {
    display:inline-block;
    padding:10px 26px;
    border-radius:12px;
    border:none;
    cursor:pointer;
    font-size:14px;
    font-weight:600;
    transition:.22s;
}

/* 성공 */
.alert-success .alert-title { color:#7ab8ff; }
.alert-success .alert-btn {
    background:#3f6fff; color:#fff;
}
.alert-success .alert-btn:hover {
    background:#5e87ff;
}

/* 실패 */
.alert-error .alert-title { color:#ff6b6b; }
.alert-error .alert-btn {
    background:#ff4d4d; color:#fff;
}
.alert-error .alert-btn:hover {
    background:#ff6b6b;
}
</style>

<div class="alert-overlay">
    <div class="alert-box <%= "alert-" + alertType %>">
        <div class="alert-title">
            <%= "success".equals(alertType) ? "✔ 성공" : "⚠ 오류" %>
        </div>

        <div class="alert-msg"><%= alertMsg %></div>

        <button class="alert-btn"
            onclick="<%= (redirect != null)
                ? "location.href='" + redirect + "'"
                : "document.querySelector('.alert-overlay').remove()" %>">
            닫기
        </button>
    </div>
</div>
