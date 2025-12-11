<%@ page contentType="text/html; charset=UTF-8" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">

<header class="df-header" id="topHeader">

    <div class="df-header-inner">

        <!-- 로고 -->
        <div class="df-logo-area">
            <a href="${pageContext.request.contextPath}/indexMovie" class="df-logo">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="DONGFLIX">
            </a>
        </div>

        <!-- 메뉴 -->
        <nav class="df-nav">
            <ul>
                <li><a href="${pageContext.request.contextPath}/indexMovie">홈</a></li>
                <li><a href="${pageContext.request.contextPath}/searchMovie">탐색</a></li>
                <li><a href="${pageContext.request.contextPath}/board/list">게시판</a></li>
            </ul>
        </nav>

        <!-- 검색창 -->
        <div class="df-search-area">
            <div class="df-search-wrapper">
                <span class="df-search-icon">🔍</span>
                <input type="text" id="searchInput"
                       placeholder="콘텐츠, 배우, 장르 검색…"
                       autocomplete="off">
                <button id="voiceBtn">🎤</button>
                <div class="search-dropdown" id="searchDropdown"></div>
            </div>
        </div>

        <!-- 마이페이지 / 로그인 -->
        <div class="df-user-area">
            <%
                Object loginUserObj = session.getAttribute("loginUser");
                boolean isLoggedIn = (loginUserObj != null);
            %>

            <% if (isLoggedIn) { %>
                <a href="${pageContext.request.contextPath}/mypage.do">마이페이지</a>
                <span class="df-divider">|</span>
                <a href="${pageContext.request.contextPath}/logout.do">로그아웃</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp">로그인</a>
            <% } %>
        </div>

    </div>

</header>

<div id="searchOverlay"></div>

<script>
// ---------------------------
// 기본 JS (검색창/음성/히스토리)
// ---------------------------
const ctx = "<%= request.getContextPath() %>";
const searchInput = document.getElementById("searchInput");
const dropdown = document.getElementById("searchDropdown");
const overlay = document.getElementById("searchOverlay");
const voiceBtn = document.getElementById("voiceBtn");

function loadHistory() {
    try { return JSON.parse(localStorage.getItem("df_history") || "[]"); }
    catch(e){ return []; }
}
function saveHistory(q){
    if(!q) return;
    let h = loadHistory().filter(x=>x!==q);
    h.unshift(q);
    if(h.length>10) h=h.slice(0,10);
    localStorage.setItem("df_history", JSON.stringify(h));
}

function renderDropdown(v){
    let html = "";
    const history = loadHistory();
    const suggestions = ["액션","판타지","로맨스","애니메이션","코미디","SF"];

    if(!v){
        if(history.length===0){
            html = "<div class='drop-empty'>최근 검색 기록 없음</div>";
        } else {
            html += "<div class='drop-title'>최근 검색</div>";
            html += history.map(h=>`<div class='drop-item'>📌 ${h}</div>`).join("");
        }
    } else {
        const filtered = suggestions.filter(s=>s.includes(v));
        html += "<div class='drop-title'>추천 키워드</div>";
        html += filtered.length
            ? filtered.map(s=>`<div class='drop-item'>🔎 ${s}</div>`).join("")
            : "<div class='drop-empty'>일치하는 추천 없음</div>";
    }

    dropdown.innerHTML = html;
    dropdown.style.display = "block";
    overlay.style.display = "block";

    dropdown.querySelectorAll(".drop-item").forEach(el=>{
        el.onclick = ()=>{
            const t = el.innerText.replace("📌","").replace("🔎","").trim();
            saveHistory(t);
            location.href = ctx + "/searchMovie?query=" + encodeURIComponent(t);
        };
    });
}

searchInput.addEventListener("focus",()=>renderDropdown(""));
searchInput.addEventListener("input",(e)=>renderDropdown(e.target.value));
overlay.addEventListener("click",()=>{
    dropdown.style.display="none";
    overlay.style.display="none";
});

voiceBtn.onclick = ()=>{
    if(!('webkitSpeechRecognition' in window)){
        alert("음성 검색 미지원 브라우저");
        return;
    }
    const r = new webkitSpeechRecognition();
    r.lang="ko-KR";
    r.start();
    r.onresult = e=>{
        let text = e.results[0][0].transcript;
        searchInput.value = text;
        saveHistory(text);
        location.href = ctx + "/searchMovie?query=" + encodeURIComponent(text);
    };
};
</script>
