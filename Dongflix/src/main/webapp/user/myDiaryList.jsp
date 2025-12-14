<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dongyang.dongflix.dto.DiaryDTO" %>

<%@ include file="/common/header.jsp" %>

<%
    List<DiaryDTO> diaryList = (List<DiaryDTO>) request.getAttribute("diaryList");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>내 영화 일기장</title>

<style>
:root{
    --bg:#000;
    --panel:#0f1325;
    --panel2:#0b0f1f;

    --line:rgba(120,150,255,0.18);
    --line2:rgba(120,150,255,0.32);

    --txt:#fff;
    --muted:#b6bfea;
    --muted2:#9aa4d9;

    --glow:rgba(63,111,255,0.50);
    --glow2:rgba(63,111,255,0.22);

    --radius:18px;

    /* timeline sizing (thin + premium) */
    --railH:6px;
    --knobS:12px;
}

*{ box-sizing:border-box; }

body {
    margin:0;
    background:var(--bg);
    color:var(--txt);
    font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
}

/* 배경 */
.page-wrap {
    min-height:100vh;
    padding:110px 24px 60px;
    background:
        radial-gradient(circle at 20% 10%, rgba(80,120,255,0.27), transparent 55%),
        radial-gradient(circle at 80% 90%, rgba(140,170,255,0.23), transparent 55%),
        #000;
}

.inner {
    max-width:1280px;
    margin:0 auto;
}

/* 헤더 */
.page-header {
    margin-bottom:18px;
    display:flex;
    align-items:flex-end;
    justify-content:space-between;
    gap:16px;
}

.page-header-left{ min-width:0; }

.page-title {
    font-size:28px;
    font-weight:800;
    letter-spacing:0.2px;
}
.page-sub {
    font-size:14px;
    color:var(--muted);
    margin-top:6px;
}

/* 상단 컨트롤 */
.toolbar{
    display:flex;
    align-items:center;
    gap:10px;
    flex:0 0 auto;
}

.sort-toggle{
    appearance:none;
    border:1px solid var(--line2);
    background:
      linear-gradient(180deg, rgba(18,22,45,0.88), rgba(10,12,28,0.72));
    color:#e9eeff;
    border-radius:999px;
    padding:10px 12px;
    cursor:pointer;
    display:inline-flex;
    align-items:center;
    gap:8px;
    font-weight:800;
    font-size:13px;
    letter-spacing:0.2px;
    box-shadow:
      0 0 0 1px rgba(255,255,255,0.03) inset,
      0 10px 26px rgba(0,0,0,0.55);
    transition:transform .18s ease, border-color .18s ease, box-shadow .18s ease;
}
.sort-toggle:hover{
    border-color:rgba(120,150,255,0.55);
    box-shadow:
      0 0 14px rgba(63,111,255,0.18),
      0 10px 26px rgba(0,0,0,0.55);
    transform:translateY(-1px);
}
.sort-toggle:active{ transform:translateY(0); }

.sort-pill{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    padding:4px 8px;
    border-radius:999px;
    border:1px solid rgba(120,150,255,0.22);
    background:rgba(120,150,255,0.10);
    font-size:12px;
    color:#d9e0ff;
    font-weight:800;
}

/* ===== EMPTY ===== */
.empty {
    margin-top:120px;
    text-align:center;
    font-size:18px;
    color:var(--muted2);
}

/* ===== TIMELINE BAR (THIN, SEGMENTED BY YEAR) ===== */
.timeline-wrap{
    margin:12px 0 14px;
    padding:14px 14px 12px;
    border-radius:16px;
    border:1px solid var(--line);
    background:
      radial-gradient(circle at 15% 20%, rgba(63,111,255,0.16), transparent 55%),
      radial-gradient(circle at 85% 80%, rgba(140,170,255,0.10), transparent 60%),
      linear-gradient(180deg, rgba(12,16,35,0.86), rgba(6,8,18,0.76));
    box-shadow:
      0 0 0 1px rgba(255,255,255,0.03) inset,
      0 18px 40px rgba(0,0,0,0.55);
}

.timeline-top{
    display:flex;
    align-items:flex-end;
    justify-content:space-between;
    gap:12px;
    margin-bottom:10px;
    flex-wrap:wrap;
}

.timeline-left{
    display:flex;
    align-items:baseline;
    gap:10px;
    min-width:0;
}

.timeline-title{
    font-size:13px;
    font-weight:900;
    color:#e7ecff;
    letter-spacing:0.25px;
    display:flex;
    align-items:center;
    gap:8px;
}

.timeline-meta{
    font-size:12px;
    color:var(--muted);
    font-weight:800;
    opacity:0.95;
    white-space:nowrap;
}

.timeline-now{
    font-size:12px;
    color:#eef2ff;
    font-weight:900;
    letter-spacing:0.2px;
    padding:6px 10px;
    border-radius:999px;
    border:1px solid rgba(120,150,255,0.22);
    background:rgba(120,150,255,0.08);
    box-shadow:0 0 0 1px rgba(255,255,255,0.03) inset;
    white-space:nowrap;
}

/* rail container */
.timeline-rail{
    position:relative;
    height:var(--railH);
    border-radius:999px;
    background:rgba(120,150,255,0.10);
    border:1px solid rgba(120,150,255,0.16);
    overflow:hidden;
    cursor:pointer;
    user-select:none;
}

/* year segments underlay */
.timeline-segments{
    position:absolute;
    inset:0;
    display:flex;
    gap:6px;
    padding:1px;
    pointer-events:none;
}
.year-seg{
    height:calc(var(--railH) - 2px);
    border-radius:999px;
    background:rgba(120,150,255,0.10);
    border:1px solid rgba(120,150,255,0.14);
    box-shadow:0 0 0 1px rgba(0,0,0,0.25) inset;
    overflow:hidden;
    position:relative;
}
.year-seg::after{
    content:"";
    position:absolute;
    inset:0;
    background:linear-gradient(90deg, rgba(255,255,255,0.06), transparent 45%, rgba(255,255,255,0.04));
    opacity:.65;
}

/* fill + knob */
.timeline-fill{
    position:absolute;
    left:0; top:0; bottom:0;
    width:0%;
    border-radius:999px;

    /* 🌌 몽환적 오로라 그라데이션 */
    background:linear-gradient(
        90deg,
        rgba(170,120,255,0.85),
        rgba(120,180,255,0.9),
        rgba(120,255,240,0.9)
    );

    box-shadow:
        0 0 12px rgba(160,140,255,0.55),
        0 0 28px rgba(120,220,255,0.45);

    pointer-events:none;
}

.timeline-knob{
    position:absolute;
    top:50%;
    transform:translate(-50%,-50%);
    left:0%;
    width:var(--knobS);
    height:var(--knobS);
    border-radius:999px;
    background:rgba(235,242,255,0.94);
    box-shadow:
      0 0 0 4px rgba(63,111,255,0.18),
      0 0 18px rgba(63,111,255,0.48);
    border:1px solid rgba(20,30,60,0.60);
    cursor:grab;
}
.timeline-knob:active{ cursor:grabbing; }

/* labels row */
.timeline-labels{
    position:relative;
    display:flex;
    justify-content:space-between;
    gap:10px;
    margin-top:10px;
    flex-wrap:wrap;
}
.year-label{
    font-size:11px;
    color:rgba(220,230,255,0.78);
    font-weight:900;
    letter-spacing:0.2px;
    padding:4px 8px;
    border-radius:999px;
    border:1px solid rgba(120,150,255,0.18);
    background:rgba(120,150,255,0.06);
}
.range-label{
    margin-left:auto;
    font-size:11px;
    color:rgba(182,191,234,0.92);
    font-weight:800;
    letter-spacing:0.15px;
    white-space:nowrap;
}

/* ===== SLIDER ===== */
.diary-slider { position:relative; }

.diary-row {
    display:flex;
    gap:18px;
    overflow-x:auto;
    padding:8px 4px 16px;
    scroll-behavior:smooth;
    overscroll-behavior-x:contain;
}

.diary-row::-webkit-scrollbar { height:6px; }
.diary-row::-webkit-scrollbar-thumb {
    background:rgba(120,150,255,0.6);
    border-radius:999px;
}
.diary-row::-webkit-scrollbar-track {
    background:rgba(10,14,30,0.9);
}

/* 카드 */
.card {
    flex:0 0 auto;
    width:190px;
    border-radius:var(--radius);
    overflow:hidden;
    background:var(--panel);
    border:1px solid rgba(120,150,255,0.25);
    transition:transform .22s ease, border-color .22s ease, box-shadow .22s ease;
    position:relative;
    box-shadow:0 14px 32px rgba(0,0,0,0.45);
}
.card:hover {
    transform:translateY(-5px);
    border-color:rgba(120,150,255,0.55);
    box-shadow:
        0 0 16px rgba(63,111,255,0.18),
        0 18px 44px rgba(0,0,0,0.55);
}

/* 포스터 */
.poster {
    width:100%;
    height:270px;
    object-fit:cover;
    filter:saturate(1.03) contrast(1.03);
}

/* 카드 정보 */
.card-content { padding:12px 12px 14px; }
.title {
    font-size:14px;
    font-weight:900;
    margin-bottom:4px;
    white-space:nowrap;
    overflow:hidden;
    text-overflow:ellipsis;
}
.date {
    font-size:12px;
    color:var(--muted);
    margin-bottom:8px;
}
.content-preview {
    font-size:12px;
    color:#d7dcff;
    line-height:1.45;
    height:52px;
    overflow:hidden;
}

/* 호버 텍스트 */
.card-hover {
    position:absolute;
    inset:0;
    background:linear-gradient(to top, rgba(0,0,0,0.88), transparent 68%);
    opacity:0;
    transition:.22s ease;
    display:flex;
    align-items:flex-end;
    padding:12px;
}
.card:hover .card-hover { opacity:1; }
.hover-text {
    font-size:12px;
    color:#e6ebff;
    font-weight:900;
}

/* 링크 */
.card-link { text-decoration:none; color:inherit; }
.card-link:focus-visible .card{
    outline:2px solid rgba(140,170,255,0.8);
    outline-offset:3px;
}

/* 드래그 중에는 선택 방지 (깔끔한 UX) */
.dragging, .dragging *{
    user-select:none !important;
    cursor:grabbing !important;
}
</style>

</head>
<body>

<div class="page-wrap">
    <div class="inner">

        <div class="page-header">
            <div class="page-header-left">
                <div class="page-title">🎞 내 영화 일기장</div>
                <div class="page-sub">내가 기록한 영화 감상 노트 · 개인 아카이브</div>
            </div>

            <div class="toolbar">
                <!-- 정렬 토글 (클라에서 정렬) -->
                <button type="button" class="sort-toggle" id="sortToggleBtn" aria-label="작성일 정렬 토글">
                    <span>⏱ 작성일</span>
                    <span class="sort-pill" id="sortStatePill">최신순</span>
                </button>
            </div>
        </div>

        <% if (diaryList == null || diaryList.isEmpty()) { %>

            <div class="empty">
                아직 작성한 영화 일기가 없어요.<br>
                영화 상세 페이지에서 나만의 기록을 남겨보세요 🎬
            </div>

        <% } else { %>

            <!-- TIMELINE (FINAL) -->
            <div class="timeline-wrap" id="timelineWrap">
                <div class="timeline-top">
                    <div class="timeline-left">
                        <div class="timeline-title">📍 MY TIMELINE</div>
                        <div class="timeline-meta" id="timelineCount">—</div>
                    </div>
                    <div class="timeline-now" id="timelineNow">NOW · —</div>
                </div>

                <div class="timeline-rail" id="timelineRail" aria-label="타임라인 스크러버(클릭/드래그 가능)">
                    <div class="timeline-segments" id="timelineSegments" aria-hidden="true"></div>
                    <div class="timeline-fill" id="timelineFill" aria-hidden="true"></div>
                    <div class="timeline-knob" id="timelineKnob" aria-label="타임라인 노브" role="slider"
                         aria-valuemin="0" aria-valuemax="100" aria-valuenow="0" tabindex="0"></div>
                </div>

                <div class="timeline-labels" id="timelineLabels" aria-hidden="true">
                    <!-- year labels injected -->
                    <div class="range-label" id="timelineRange">—</div>
                </div>
            </div>

            <div class="diary-slider">
                <div class="diary-row" id="diaryRow">

                    <% for (DiaryDTO d : diaryList) {
                        String poster = (d.getPosterPath() != null && !d.getPosterPath().isEmpty())
                                ? "https://image.tmdb.org/t/p/w500" + d.getPosterPath()
                                : request.getContextPath() + "/img/no_poster.png";

                        // diaryDate null 방어 (data-date에도 안전하게 들어가게)
                        String safeDiaryDate = (d.getDiaryDate() != null) ? String.valueOf(d.getDiaryDate()) : "";
                    %>

                    <a
                        href="<%= request.getContextPath() %>/diaryDetail?id=<%= d.getId() %>"
                        class="card-link"
                        data-diary-id="<%= d.getId() %>"
                        data-diary-date="<%= safeDiaryDate %>"
                    >
                        <div class="card">
                            <img class="poster" src="<%= poster %>" alt="포스터">

                            <div class="card-content">
                                <div class="title"><%= d.getMovieTitle() %></div>
                                <div class="date">🗓 <%= safeDiaryDate %></div>

                                <div class="content-preview">
                                    <%
                                        String preview = d.getContent();
                                        if (preview != null && preview.length() > 60) {
                                            preview = preview.substring(0, 60) + "...";
                                        }
                                    %>
                                    <%= preview %>
                                </div>
                            </div>

                            <div class="card-hover">
                                <div class="hover-text">📘 일기 자세히 보기</div>
                            </div>
                        </div>
                    </a>

                    <% } %>

                </div>
            </div>

           <script>
(function(){
    "use strict";

    const diaryRow = document.getElementById("diaryRow");
    const sortToggleBtn = document.getElementById("sortToggleBtn");
    const sortStatePill = document.getElementById("sortStatePill");

    const timelineRail = document.getElementById("timelineRail");
    const timelineSegments = document.getElementById("timelineSegments");
    const timelineFill = document.getElementById("timelineFill");
    const timelineKnob = document.getElementById("timelineKnob");
    const timelineLabels = document.getElementById("timelineLabels");
    const timelineRange = document.getElementById("timelineRange");
    const timelineCount = document.getElementById("timelineCount");
    const timelineNow = document.getElementById("timelineNow");

    if (!diaryRow || !timelineRail || !timelineKnob) return;

    const STORAGE_KEY = "dongflix_diary_sort_order";
    let isDragging = false;
    let rafId = null;
    let selectedDateText = null; 
    let sortOrder = "desc"; // 기본: 최신순


    function clamp(n,min,max){ return Math.max(min, Math.min(max, n)); }

    function parseDateSafe(dateStr){
        if (!dateStr) return null;
        const s = String(dateStr).trim();
        if (!s) return null;

        let cleaned = s.replace(/\./g, "-").replace(/\//g, "-");
        cleaned = cleaned.replace(" ", "T");

        let dt = new Date(cleaned);
        if (!isNaN(dt.getTime())) return dt;

        const m = cleaned.match(/^(\d{4})-(\d{1,2})-(\d{1,2})/);
        if (m){
            return new Date(+m[1], +m[2]-1, +m[3]);
        }
        return null;
    }

    function formatDateK(dt){
        if (!dt) return "—";
        return dt.getFullYear() + "." +
            String(dt.getMonth()+1).padStart(2,"0") + "." +
            String(dt.getDate()).padStart(2,"0");
    }

    function getCards(){
        return Array.from(diaryRow.querySelectorAll(".card-link"));
    }

    function setTimelineNow(mode, dateText){
        timelineNow.textContent = mode + " · " + (dateText || "—");
    }

    function getCurrentVisibleCard(){
        const cards = getCards();
        if (!cards.length) return null;

        const rowRect = diaryRow.getBoundingClientRect();
        let best = null, bestDist = Infinity;

        cards.forEach(a => {
            const rect = a.getBoundingClientRect();
            const dist = Math.abs(rect.left - rowRect.left);
            if (dist < bestDist){
                bestDist = dist;
                best = a;
            }
        });
        return best;
    }

    function updateTimelineUI(){
        const maxScroll = diaryRow.scrollWidth - diaryRow.clientWidth;
        const ratio = maxScroll > 0 ? diaryRow.scrollLeft / maxScroll : 0;
        const pct = clamp(ratio * 100, 0, 100);

        timelineFill.style.width = pct + "%";
        timelineKnob.style.left = pct + "%";

        if (selectedDateText) {
            setTimelineNow("SELECTED", selectedDateText);
            return;
        }

        const cur = getCurrentVisibleCard();
        if (cur){
            const dt = parseDateSafe(cur.dataset.diaryDate);
            setTimelineNow("VIEWING", dt ? formatDateK(dt) : "—");
        } else {
            setTimelineNow("VIEWING", "—");
        }
    }

    function requestUpdate(){
        if (rafId) return;
        rafId = requestAnimationFrame(()=>{
            rafId = null;
            updateTimelineUI();
        });
    }

    function bindCardHover(){
        getCards().forEach(a=>{
            function cardDate(){
                const dt = parseDateSafe(a.dataset.diaryDate);
                return dt ? formatDateK(dt) : "—";
            }

            a.addEventListener("mouseenter", ()=>{
                setTimelineNow("HOVER", cardDate());
            });

            a.addEventListener("mouseleave", ()=>{
                if (selectedDateText) {
                    setTimelineNow("SELECTED", selectedDateText);
                } else {
                    requestUpdate();
                }
            });

            a.addEventListener("click", ()=>{
                selectedDateText = cardDate();
                setTimelineNow("SELECTED", selectedDateText);
            });
        });
    }

    diaryRow.addEventListener("scroll", requestUpdate, { passive:true });
 // ===== 작성일 정렬 토글 =====
    sortToggleBtn.addEventListener("click", function(){
        sortOrder = (sortOrder === "desc") ? "asc" : "desc";
        sortStatePill.textContent = (sortOrder === "desc") ? "최신순" : "오래된순";

        const cards = getCards();

        cards.sort(function(a,b){
            const da = parseDateSafe(a.dataset.diaryDate);
            const db = parseDateSafe(b.dataset.diaryDate);

            if (!da && db) return 1;
            if (!db && da) return -1;
            if (!da && !db) return 0;

            return (sortOrder === "desc") ? db - da : da - db;
        });

        // DOM 재배치
        const frag = document.createDocumentFragment();
        cards.forEach(a => frag.appendChild(a));
        diaryRow.appendChild(frag);

        // 정렬 후 상태 동기화
        selectedDateText = null;
        diaryRow.scrollLeft = 0;
        requestUpdate();
    });

    bindCardHover();
    requestUpdate();

})();
</script>

        <% } %>

    </div>
</div>

</body>
</html>
