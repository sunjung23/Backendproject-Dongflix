<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DONGFLIX - 회원가입</title>

<style>

body {
    margin:0;
    padding:40px 0;
    min-height:100vh;
    overflow-y:auto;
    background:#000;
    color:#fff;
    font-family:-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;

    background:
        radial-gradient(circle at 20% 15%, rgba(80,120,255,0.27), transparent 55%),
        radial-gradient(circle at 80% 85%, rgba(140,170,255,0.23), transparent 55%),
        #000;

    display:flex;
    justify-content:center;
}

/* 메인 박스 */
.join-wrapper {
    width:100%;
    max-width:580px;  
    margin:40px 0;
    background:rgba(12,15,35,0.92);
    border-radius:28px;
    padding:46px 36px 40px;
    border:1px solid rgba(120,150,255,0.18);
    box-shadow:0 28px 70px rgba(20,30,70,0.85);
}

/* 제목 */
h2 {
    text-align:center;
    font-size:27px;
    font-weight:800;
    margin-bottom:10px;
    letter-spacing:-0.4px;
    color:#f1f3ff;
}

.join-sub {
    text-align:center;
    font-size:13px;
    color:#b8bfeb;
    margin-bottom:26px;
}

/* 폼 공통 */
.form-group {
    margin-bottom:18px;
}

/* 아이디 + 버튼 가로 정렬 */
.id-row {
    display:flex;
    gap:8px;
    align-items:flex-start;
}

.id-row .form-input {
    flex:1;
}

/* 인풋 스타일 */
.form-input {
    width:100%;
    padding:13px 15px;
    border-radius:12px;
    border:1px solid rgba(100,120,210,0.32);
    background:#0f1325;
    color:#f3f4ff;
    font-size:15px;
    transition:.22s;
}

.form-input:focus {
    outline:none;
    background:#131a34;
    border-color:#3f6fff;
    box-shadow:0 0 0 2px rgba(80,120,255,0.45);
}

/* 유효성 상태 */
.form-input.valid {
    border-color:#34d399;
    box-shadow:0 0 0 2px rgba(52,211,153,0.5);
}

.form-input.invalid {
    border-color:#ff4d4d;
    box-shadow:0 0 0 2px rgba(255,77,77,0.55);
    animation:shake .18s ease-in 0s 2;
}

@keyframes shake {
    0%   { transform:translateX(0); }
    25%  { transform:translateX(-3px); }
    50%  { transform:translateX(3px); }
    75%  { transform:translateX(-2px); }
    100% { transform:translateX(0); }
}

/* 아이디 중복 확인 버튼 */
.btn-check-id {
    padding:11px 14px;
    border-radius:12px;
    border:1px solid rgba(120,150,255,0.6);
    background:rgba(18,24,60,0.95);
    color:#e4e7ff;
    font-size:13px;
    font-weight:600;
    cursor:pointer;
    transition:.22s;
}

.btn-check-id:hover {
    background:#3f6fff;
    border-color:#3f6fff;
    box-shadow:0 6px 18px rgba(80,120,255,0.55);
}

/* 상태 메시지 */
#id-status {
    font-size:12px;
    margin-top:6px;
    min-height:16px;
}

#id-status.ok { color:#34d399; }
#id-status.error { color:#ff6b6b; }

/* 비밀번호 강도 표시 */
.pw-strength-wrap { margin-top:8px; }

.pw-strength-label {
    font-size:11px;
    color:#a7b0e2;
    margin-bottom:4px;
}

.pw-strength-bar-bg {
    width:100%;
    height:6px;
    border-radius:999px;
    background:#151833;
    overflow:hidden;
}

.pw-strength-bar {
    height:100%;
    width:0%;
    border-radius:999px;
    transition:width .25s ease, background .25s ease;
}
.pw-weak   { background:#ff4d4d; }
.pw-medium { background:#facc15; }
.pw-strong { background:#22c55e; }

.pw-strength-text {
    font-size:11px;
    color:#8f98c9;
    margin-top:4px;
}

/* 장르 카드 영역 */
.genre-grid {
    display:grid;
    gap:12px;
    grid-template-columns: repeat(3, 1fr);
    margin-top:22px;
}

@media (max-width: 650px){
    .genre-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

.genre-card {
    padding:18px 12px;
    border-radius:16px;
    background:#0f1328;
    text-align:center;
    border:1px solid rgba(120,150,255,0.25);
    color:#dfe4ff;
    font-weight:600;
    cursor:pointer;
    transition:.22s;
    user-select:none;
    backdrop-filter:blur(4px);
}

.genre-card:hover {
    transform:translateY(-4px) scale(1.05);
    background:#151c3c;
    border-color:#678aff;
    box-shadow:0 10px 22px rgba(90,130,255,0.35);
}

.genre-card.selected {
    background:rgba(63,111,255,0.85);
    border-color:#3f6fff;
    color:#fff;
    box-shadow:
        0 0 12px rgba(63,111,255,0.85),
        0 0 28px rgba(63,111,255,0.55),
        inset 0 0 12px rgba(255,255,255,0.15);
    transform:scale(1.05);
}

/* 회원가입 버튼 */
.btn-join {
    width:100%;
    padding:14px 0;
    border:none;
    border-radius:999px;
    cursor:pointer;
    background:#3f6fff;
    color:#fff;
    font-size:16px;
    font-weight:700;
    transition:.22s;
    margin-top:16px;
}

.btn-join:hover {
    background:#678aff;
    transform:translateY(-2px);
    box-shadow:0 10px 20px rgba(80,120,255,0.45);
}

/* 하단 안내 */
.helper-text {
    margin-top:22px;
    text-align:center;
    color:#b7bee3;
    font-size:14px;
}

.helper-text a {
    color:#94acff;
    font-weight:600;
    text-decoration:none;
}

.helper-text a:hover {
    color:#c4d3ff;
}
</style>

</head>
<body>

<div class="join-wrapper">
    <h2>회원가입</h2>
    <div class="join-sub">
        DONGFLIX 계정을 만들고, 나만의 영화 취향에 맞는 추천을 받아보세요.
    </div>

    <form action="${pageContext.request.contextPath}/join.do" method="post" id="joinForm">

        <!-- ID + 중복 확인 -->
        <div class="form-group">
            <div class="id-row">
                <input type="text" id="userid" name="userid"
                       placeholder="아이디 (영문/숫자 조합 권장)" class="form-input" required>

                <button type="button" class="btn-check-id" id="btnCheckId">
                    중복 확인
                </button>
            </div>
            <div id="id-status"></div>
        </div>

        <!-- 비밀번호 -->
        <div class="form-group">
            <input type="password" id="password" name="password"
                   placeholder="비밀번호 (8자 이상 권장)" class="form-input" required>

            <div class="pw-strength-wrap">
                <div class="pw-strength-label">비밀번호 안전도</div>
                <div class="pw-strength-bar-bg">
                    <div class="pw-strength-bar" id="pwStrengthBar"></div>
                </div>
                <div class="pw-strength-text" id="pwStrengthText">아직 분석 전입니다.</div>
            </div>
        </div>

        <!-- 이름 -->
        <div class="form-group">
            <input type="text" id="username" name="username"
                   placeholder="이름" class="form-input" required>
        </div>

        <!-- 장르 선택 -->
        <div class="genre-section">
            <label style="font-size:14px; color:#b7c0f9; margin-bottom:8px; display:block;">
                선호 장르 (최대 3개 선택)
            </label>

            <div class="genre-grid" id="genreGrid">
                <div class="genre-card" data-genre="액션">💥 액션</div>
                <div class="genre-card" data-genre="로맨스">💖 로맨스</div>
                <div class="genre-card" data-genre="스릴러">🕵 스릴러</div>
                <div class="genre-card" data-genre="코미디">😂 코미디</div>
                <div class="genre-card" data-genre="SF">🚀 SF</div>
                <div class="genre-card" data-genre="판타지">🪄 판타지</div>
                <div class="genre-card" data-genre="애니메이션">🎨 애니메이션</div>
                <div class="genre-card" data-genre="공포">👻 공포</div>
                <div class="genre-card" data-genre="드라마">🎭 드라마</div>
            </div>
        </div>

        <!-- hidden inputs -->
        <input type="hidden" id="idChecked" value="false">
        <input type="hidden" name="genres" id="selectedGenres">

        <button type="submit" class="btn-join">회원가입</button>
    </form>

    <div class="helper-text">
        이미 계정이 있으신가요?
        <a href="login.jsp"> 로그인하기</a>
    </div>
</div>
<script>
(function(){
    const ctx = "<%= request.getContextPath() %>";

    /* -----------------------------
       요소 가져오기
    ------------------------------*/
    const useridInput = document.getElementById("userid");
    const btnCheckId = document.getElementById("btnCheckId");
    const statusEl = document.getElementById("id-status");
    const idCheckedHidden = document.getElementById("idChecked");
    const joinForm = document.getElementById("joinForm");

    const pwInput = document.getElementById("password");
    const pwBar = document.getElementById("pwStrengthBar");
    const pwText = document.getElementById("pwStrengthText");

    const selectedGenresInput = document.getElementById("selectedGenres");


    /* =========================
       1) 아이디 입력 시 상태 초기화
    ==========================*/
    useridInput.addEventListener("input", () => {
        useridInput.classList.remove("valid", "invalid");
        statusEl.className = "";
        statusEl.textContent = "";
        idCheckedHidden.value = "false";
    });


    /* =========================
       2) 아이디 중복 확인
    ==========================*/
    btnCheckId.addEventListener("click", () => {
        const id = useridInput.value.trim();

        if (id === "") {
            useridInput.classList.add("invalid");
            statusEl.className = "error";
            statusEl.textContent = "아이디를 입력해주세요.";
            return;
        }

        fetch(ctx + "/checkUserid.do?userid=" + encodeURIComponent(id))
            .then(res => res.text())
            .then(text => {
                if (text === "OK") {
                    useridInput.classList.add("valid");
                    useridInput.classList.remove("invalid");
                    statusEl.className = "ok";
                    statusEl.textContent = "사용 가능한 아이디입니다.";
                    idCheckedHidden.value = "true";
                }
                else if (text === "DUP") {
                    useridInput.classList.add("invalid");
                    useridInput.classList.remove("valid");
                    statusEl.className = "error";
                    statusEl.textContent = "이미 사용 중인 아이디입니다.";
                    idCheckedHidden.value = "false";
                }
                else {
                    useridInput.classList.add("invalid");
                    statusEl.className = "error";
                    statusEl.textContent = "서버 오류가 발생했습니다.";
                    idCheckedHidden.value = "false";
                }
            })
            .catch(err => {
                console.error(err);
                useridInput.classList.add("invalid");
                statusEl.className = "error";
                statusEl.textContent = "네트워크 오류입니다.";
                idCheckedHidden.value = "false";
            });
    });


    /* =========================
       3) 비밀번호 강도 측정
    ==========================*/
    function calcStrength(pw){
        let score = 0;
        if (pw.length >= 8) score++;
        if (/[0-9]/.test(pw)) score++;
        if (/[a-zA-Z]/.test(pw)) score++;
        if (/[^0-9a-zA-Z]/.test(pw)) score++;
        return score;
    }

    pwInput.addEventListener("input", () => {
        const pw = pwInput.value;
        const score = calcStrength(pw);

        let width = 0;
        let cls = "";
        let text = "비밀번호를 입력하면 분석됩니다.";

        if (!pw) {
            width = 0;
            cls = "";
        }
        else if (score <= 1) {
            width = 33;
            cls = "pw-weak";
            text = "위험: 너무 쉬운 비밀번호입니다.";
        }
        else if (score <= 3) {
            width = 66;
            cls = "pw-medium";
            text = "보통: 조금 더 복잡하게 만들어볼까요?";
        }
        else {
            width = 100;
            cls = "pw-strong";
            text = "안전: 매우 강력한 비밀번호입니다!";
        }

        pwBar.className = "pw-strength-bar " + cls;
        pwBar.style.width = width + "%";
        pwText.textContent = text;
    });



    /* =========================
       4) 장르 선택 (최대 3개)
    ==========================*/
    const genreCards = document.querySelectorAll(".genre-card");

    genreCards.forEach(card => {
        card.addEventListener("click", () => {

            // 이미 선택된 경우 → 해제
            if (card.classList.contains("selected")) {
                card.classList.remove("selected");
            }
            else {
                // 3개 이상 선택 방지
                const selectedCount = document.querySelectorAll(".genre-card.selected").length;
                if (selectedCount >= 3) {
                    // 흔들림 애니메이션
                    card.classList.add("shake-limit");
                    setTimeout(() => card.classList.remove("shake-limit"), 400);
                    return;
                }
                card.classList.add("selected");
            }

            // 선택된 장르 목록 업데이트
            const selected = [...document.querySelectorAll(".genre-card.selected")]
                .map(c => c.dataset.genre);

            selectedGenresInput.value = selected.join(",");
        });
    });

    // shake animation 추가
    const styleShake = document.createElement("style");
    styleShake.innerHTML = `
        .shake-limit {
            animation:shakeCard .18s ease-in-out 2;
        }
        @keyframes shakeCard {
            0% { transform:translateX(0); }
            25% { transform:translateX(-4px); }
            50% { transform:translateX(4px); }
            75% { transform:translateX(-2px); }
            100% { transform:translateX(0); }
        }
    `;
    document.head.appendChild(styleShake);



    /* =========================
       5) 회원가입 제출 전 검증
    ==========================*/
    joinForm.addEventListener("submit", (e) => {

        if (useridInput.value.trim() === "") {
            e.preventDefault();
            useridInput.classList.add("invalid");
            statusEl.className = "error";
            statusEl.textContent = "아이디를 입력해주세요.";
            return;
        }

        if (idCheckedHidden.value !== "true") {
            e.preventDefault();
            statusEl.className = "error";
            statusEl.textContent = "아이디 중복 확인을 완료해주세요.";
            useridInput.classList.add("invalid");
        }
    });

})();
</script>

</body>
</html>
