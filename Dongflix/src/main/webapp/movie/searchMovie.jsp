<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.dongyang.dongflix.model.TMDBmovie" %>

<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <title>Dongflix - 탐색</title>

    <style>

    body{
        margin:0;
        padding:0;
        color:#fff;
        font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
        overflow-x:hidden;

        background:
            radial-gradient(circle at 18% 12%, rgba(80,120,255,0.22), transparent 55%),
            radial-gradient(circle at 82% 88%, rgba(140,170,255,0.18), transparent 55%),
            linear-gradient(180deg, #050714 0%, #00020a 100%);
    }

    /* 검색 페이지 래퍼 */
    .search-container{
        max-width:1100px;
        margin:140px auto 40px;
        padding:0 24px;
    }


    .search-panel{
        background:
            linear-gradient(180deg, rgba(18,24,56,0.92), rgba(10,14,32,0.86));
        border:1px solid rgba(120,150,255,0.22);
        border-radius:24px;
        padding:22px;
        box-shadow:
            0 0 0 1px rgba(255,255,255,0.025) inset,
            0 24px 56px rgba(0,0,0,0.75);
    }


    .search-box{
        position:relative;
        display:flex;
        align-items:center;
    }

    .search-input{
        width:100%;
        height:44px;
        padding:0 68px 0 16px;
        border-radius:999px;
        border:1px solid rgba(120,150,255,0.32);
        background:#0b1026;
        color:#f3f5ff;
        font-size:14px;
    }

    .search-input::placeholder{
        color:#8e97c9;
        font-size:14px;
    }

    .search-input:focus{
        outline:none;
        border-color:#3f6fff;
        box-shadow:0 0 0 2px rgba(80,120,255,0.35);
    }


    #voiceBtn{
        position:absolute;
        right:8px;
        width:32px;
        height:32px;
        border-radius:50%;
        border:1px solid rgba(120,150,255,0.32);
        background:#121836;
        color:#fff;
        cursor:pointer;
        display:flex;
        align-items:center;
        justify-content:center;
        font-size:13px;
        transition:.18s ease;
    }

    #voiceBtn:hover{
        background:#3f6fff;
    }


    .suggest-box{
        position:absolute;
        top:52px;
        left:0;
        right:0;
        background:#0c122b;
        border:1px solid rgba(120,150,255,0.28);
        border-radius:16px;
        overflow:hidden;
        display:none;
        z-index:20;
    }

    .suggest-box div{
        padding:10px 14px;
        cursor:pointer;
        font-size:13px;
        color:#e6e9ff;
    }

    .suggest-box div:hover{
        background:#3f6fff;
    }


    .history-box{
        position:absolute;
        top:52px;
        left:0;
        right:0;
        background:#0c122b;
        border:1px solid rgba(120,150,255,0.28);
        border-radius:16px;
        padding:12px 12px 6px;
        z-index:15;
        box-shadow:0 18px 36px rgba(0,0,0,0.6);
    }

    .history-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        font-size:12px;
        color:#dbe1ff;
        margin-bottom:8px;
    }

    .history-header button{
        background:none;
        border:none;
        color:#9aa4ff;
        font-size:12px;
        cursor:pointer;
    }

    .history-header button:hover{
        color:#ff6b6b;
    }

    #historyList{
        list-style:none;
        padding:0;
        margin:0;
    }

    #historyList li{
        display:flex;
        justify-content:space-between;
        align-items:center;
        padding:7px 8px;
        border-radius:8px;
        font-size:12.5px;
        color:#e6e9ff;
        cursor:pointer;
    }

    #historyList li:hover{
        background:#3f6fff;
    }

    .history-delete{
        font-size:11px;
        color:#ff6b6b;
        cursor:pointer;
    }


    .search-options{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-top:14px;
        gap:14px;
        flex-wrap:wrap;
    }

    .option-left{
        font-size:13px;
        color:#d6dcff;
    }

    .select-box{
        padding:6px 14px;
        border-radius:999px;
        border:1px solid rgba(120,150,255,0.32);
        background:#0b1026;
        color:#fff;
        font-size:13px;
    }


    .search-btn{
        margin-top:16px;
        width:100%;
        height:44px;
        border:none;
        border-radius:999px;
        background:#3f6fff;
        color:#fff;
        font-size:15px;
        font-weight:800;
        cursor:pointer;
        transition:.18s ease;
    }

    .search-btn:hover{
        background:#678aff;
    }


    .movie-grid{
        max-width:1200px;
        margin:42px auto;
        padding:0 24px;
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(180px,1fr));
        gap:22px;
    }

    .movie-card img{
        width:100%;
        border-radius:16px;
    }

    .movie-title{
        margin-top:8px;
        font-size:14px;
        text-align:center;
    }
    </style>
</head>

<body>

<%@ include file="/common/header.jsp" %>

<div class="search-container">
    <form action="${pageContext.request.contextPath}/searchMovie" method="get">

        <div class="search-panel">

            <div class="search-box">

                <!-- 검색 기록 -->
                <div id="historyBox" class="history-box" style="display:none;">
                    <div class="history-header">
                        <span>최근 검색어</span>
                        <button type="button" id="clearHistoryBtn">전체 삭제</button>
                    </div>
                    <ul id="historyList"></ul>
                </div>

                <input type="text" name="keyword" id="searchInput"
                       placeholder="영화 제목 검색..."
                       autocomplete="off"
                       value="${keyword}" class="search-input">

                <button type="button" id="voiceBtn">🎤</button>
                <div id="suggestBox" class="suggest-box"></div>
            </div>

            <div class="search-options">
                <div class="option-left">
                    <label>
                        <input type="checkbox" id="historyToggle" checked> 검색 기록 저장
                    </label>
                </div>

               <select name="genre" class="select-box">
    <option value="">전체</option>

    <option value="28">💥 액션</option>
    <option value="10749">💖 로맨스</option>
    <option value="53">🕵 스릴러</option>
    <option value="35">😂 코미디</option>
    <option value="878">🚀 SF</option>
    <option value="14">🪄 판타지</option>
    <option value="16">🎨 애니메이션</option>
    <option value="27">👻 공포</option>
    <option value="18">🎭 드라마</option>
    <option value="80">🔫 범죄</option>
    <option value="9648">🧩 미스터리</option>
    <option value="10751">👨‍👩‍👧 가족</option>
    <option value="36">📜 역사</option>
</select>


            </div>

            <button class="search-btn">검색</button>

        </div>
    </form>
</div>

<!-- 영화 리스트 -->
<div class="movie-grid">
<%
    List<TMDBmovie> movieList = (List<TMDBmovie>) request.getAttribute("movies");
    if (movieList != null) {
        for (TMDBmovie m : movieList) {
%>
    <div class="movie-card">
        <a href="movieDetail?movieId=<%= m.getId() %>">
            <img src="<%= m.getPosterUrl() %>">
        </a>
        <div class="movie-title"><%= m.getTitle() %></div>
    </div>
<%
        }
    }
%>
</div>

<script>
const input = document.getElementById("searchInput");
const suggestBox = document.getElementById("suggestBox");
const form = document.querySelector("form");

const historyBox = document.getElementById("historyBox");
const historyList = document.getElementById("historyList");
const clearBtn = document.getElementById("clearHistoryBtn");

/* 자동완성 */
input.addEventListener("input", async () => {
    const q = input.value.trim();

    if (q.length < 1) {
        suggestBox.style.display = "none";
        return;
    }

    const res = await fetch(
        "${pageContext.request.contextPath}/searchSuggest?q=" + encodeURIComponent(q)
    );
    const list = await res.json();

    suggestBox.innerHTML = "";

    list.forEach(title => {
        const div = document.createElement("div");
        div.textContent = title;

        div.onclick = () => {
            input.value = title;
            suggestBox.style.display = "none";
            form.submit();
        };

        suggestBox.appendChild(div);
    });

    suggestBox.style.display = "block";
});

/* 음성 검색 */
const voiceBtn = document.getElementById("voiceBtn");

voiceBtn.onclick = () => {
    if (!("webkitSpeechRecognition" in window)) {
        alert("이 브라우저는 음성 검색을 지원하지 않습니다.");
        return;
    }

    const recog = new webkitSpeechRecognition();
    recog.lang = "ko-KR";

    recog.onresult = (e) => {
        input.value = e.results[0][0].transcript;
        form.submit();
    };

    recog.start();
};

/* 검색 기록 저장 */
form.addEventListener("submit", () => {
    if (!document.getElementById("historyToggle").checked) return;

    let history = JSON.parse(localStorage.getItem("searchHistory") || "[]");
    history.unshift(input.value);
    history = [...new Set(history)].slice(0, 5);
    localStorage.setItem("searchHistory", JSON.stringify(history));
});

/* 검색 기록 렌더링 */
function renderHistory() {
    const history = JSON.parse(localStorage.getItem("searchHistory") || "[]");
    historyList.innerHTML = "";

    if (history.length === 0) {
        historyBox.style.display = "none";
        return;
    }

    historyBox.style.display = "block";

    history.forEach((word, idx) => {
        const li = document.createElement("li");

        const text = document.createElement("span");
        text.textContent = word;
        text.onclick = () => {
            input.value = word;
            form.submit();
        };

        const del = document.createElement("span");
        del.textContent = "✕";
        del.className = "history-delete";

        del.onclick = (e) => {
            e.stopPropagation();
            history.splice(idx, 1);
            localStorage.setItem("searchHistory", JSON.stringify(history));
            renderHistory();
        };

        li.appendChild(text);
        li.appendChild(del);
        historyList.appendChild(li);
    });
}

/* 전체 삭제 */
clearBtn.onclick = () => {
    localStorage.removeItem("searchHistory");
    renderHistory();
};

/* 검색창 포커스 시 표시 */
input.addEventListener("focus", renderHistory);

/* 검색 영역 밖 클릭 시 모두 닫기 */
document.addEventListener("click", (e) => {
    if (!e.target.closest(".search-box")) {
        suggestBox.style.display = "none";
        historyBox.style.display = "none";
    }
});

/*  검색 영역 내부 클릭은 버블링 막기 */
document.querySelector(".search-box").addEventListener("click", (e) => {
    e.stopPropagation();
});
</script>

</body>
</html>
