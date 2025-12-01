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
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>영화 취향 테스트 - DONGFLIX</title>
    <style>
        * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    background-color: #141414;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    color: white;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0;
}

.test-container {
    max-width: 700px;
    width: 100%;
    background-color: rgba(0, 0, 0, 0.75);
    border-radius: 20px;
    padding: 50px 40px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
    color: white;
    position: relative;
}

/* 메인으로 돌아가기 */
.back-to-main {
    position: absolute;
    top: 50px;
    left: 40px;
    color: #b3b3b3;
    text-decoration: none;
    font-size: 16px;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 5px;
    transition: color 0.2s ease;
}

.back-to-main:hover {
    color: #2036CA;
}

.test-header {
    text-align: center;
    margin-bottom: 40px;
}

.test-header h1 {
    font-size: 36px;
    margin-bottom: 10px;
    color: #2036CA;
    font-weight: 700;
}

.test-header p {
    font-size: 16px;
    color: #b3b3b3;
}

.progress-bar {
    width: 100%;
    height: 10px;
    background: #333;
    border-radius: 10px;
    margin-bottom: 40px;
    overflow: hidden;
}

.progress-fill {
    height: 100%;
    background: linear-gradient(90deg, #2036CA 0%, #4a69ff 100%);
    width: 10%;
    transition: width 0.3s ease;
    border-radius: 10px;
}

.question-box {
    display: none;
}

.question-box.active {
    display: block;
    animation: fadeIn 0.5s ease;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.question-number {
    font-size: 14px;
    color: #b3b3b3;
    font-weight: 600;
    margin-bottom: 10px;
}

.question-text {
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 30px;
    line-height: 1.5;
    color: white;
}

.answer-options {
    display: grid;
    gap: 12px;
    margin-bottom: 30px;
}

.answer-option {
    padding: 18px 20px;
    background: #2a2a2a;
    border: 2px solid #444;
    border-radius: 12px;
    color: white;
    font-size: 16px;
    cursor: pointer;
    transition: all 0.3s ease;
    text-align: left;
}

.answer-option:hover {
    background: #333;
    border-color: #2036CA;
    transform: translateX(5px);
}

.answer-option.selected {
    background: #2036CA;
    border-color: #2036CA;
    color: white;
    font-weight: 600;
}

.nav-buttons {
    display: flex;
    gap: 15px;
    justify-content: space-between;
    margin-top: 30px;
}

.nav-btn {
    padding: 15px 30px;
    background: transparent;
    border: 2px solid #2036CA;
    border-radius: 10px;
    color: #2036CA;
    font-size: 16px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-weight: 600;
}

.nav-btn:hover:not(:disabled) {
    background: #2036CA;
    color: white;
}

.nav-btn:disabled {
    opacity: 0.3;
    cursor: not-allowed;
    border-color: #666;
    color: #666;
}

.nav-btn.next {
    background: #2036CA;
    color: white;
}

.nav-btn.next:hover:not(:disabled) {
    background: #1a2ba3;
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(32, 54, 202, 0.5);
}

.result-container {
    display: none;
    text-align: center;
}

.result-container.show {
    display: block;
    animation: fadeIn 0.5s ease;
}

.result-type {
    font-size: 64px;
    margin-bottom: 20px;
}

.result-title {
    font-size: 32px;
    font-weight: 700;
    margin-bottom: 15px;
    color: #2036CA;
}

.result-description {
    font-size: 18px;
    line-height: 1.7;
    margin-bottom: 40px;
    color: #b3b3b3;
}

.recommended-movies {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 15px;
    padding: 30px;
    margin-top: 30px;
}

.recommended-movies h3 {
    font-size: 24px;
    margin-bottom: 20px;
    font-weight: 600;
    color: #2036CA;
}

.movie-list {
    display: grid;
    gap: 15px;
    text-align: left;
}

.movie-item {
    background: #2a2a2a;
    padding: 18px;
    border-radius: 10px;
    font-size: 16px;
    transition: all 0.3s ease;
    border-left: 4px solid #2036CA;
    box-shadow: 0 2px 8px rgba(0,0,0,0.3);
}

.movie-item:hover {
    background: #333;
    transform: translateX(8px);
    box-shadow: 0 4px 15px rgba(32, 54, 202, 0.3);
}

.back-btn {
    display: inline-block;
    margin-top: 30px;
    padding: 15px 40px;
    background: #2036CA;
    border: none;
    border-radius: 30px;
    color: white;
    text-decoration: none;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(32, 54, 202, 0.3);
}

.back-btn:hover {
    background: #1a2ba3;
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(32, 54, 202, 0.5);
}
    </style>
</head>
<body>

<div class="test-container">
    <div class="test-header">
        <h1>🎥 영화 취향 테스트</h1>
        <p>10개의 질문으로 알아보는 <%= user.getUsername() %>님의 영화 취향!</p>
    </div>

    <div class="progress-bar">
        <div class="progress-fill" id="progressBar"></div>
    </div>

    <!-- 질문들 -->
    <div id="questions">
        <!-- Question 1 -->
        <div class="question-box active" data-question="1">
            <div class="question-number">1️⃣ 질문 1/10</div>
            <div class="question-text">영화를 고를 때 가장 먼저 보는 요소는?</div>
            <div class="answer-options">
                <div class="answer-option" data-answer="A">A. 빠르고 재미있는 전개</div>
                <div class="answer-option" data-answer="B">B. 감정선이 깊고 여운 있는 스토리</div>
                <div class="answer-option" data-answer="C">C. 화려한 영상미·액션·세계관</div>
                <div class="answer-option" data-answer="D">D. 개성 있는 캐릭터와 배우 매력</div>
            </div>
        </div>

        <!-- Question 2 -->
        <div class="question-box" data-question="2">
            <div class="question-number">2️⃣ 질문 2/10</div>
            <div class="question-text">힘든 하루 끝에 영화를 볼 때는?</div>
            <div class="answer-options">
                <div class="answer-option" data-answer="A">A. 아무 생각 없이 웃고 즐길 수 있는 코미디</div>
                <div class="answer-option" data-answer="B">B. 감성적이고 힐링되는 드라마나 로맨스</div>
                <div class="answer-option" data-answer="C">C. 몰입감 최고인 스릴러나 미스터리</div>
                <div class="answer-option" data-answer="D">D. 판타지·SF 같은 현실 도피형 장르</div>
            </div>
        </div>

        <!-- Question 3 -->
        <div class="question-box" data-question="3">
            <div class="question-number">3️⃣ 질문 3/10</div>
            <div class="question-text">영화 속 등장인물의 '관계' 설정 중 가장 흥미로운 건?</div>
            <div class="answer-options">
                <div class="answer-option" data-answer="A">A. 정의감 넘치는 히어로 vs 빌런</div>
                <div class="answer-option" data-answer="B">B. 현실적인 연인, 가족, 친구 관계</div>
                <div class="answer-option" data-answer="C">C. 이상하고 기묘한 인간관계</div>
                <div class="answer-option" data-answer="D">D. 영화 전체를 이끌어가는 천재형 캐릭터</div>
            </div>
        </div>

        <!-- Question 4 -->
        <div class="question-box" data-question="4">
            <div class="question-number">4️⃣ 질문 4/10</div>
            <div class="question-text">영화 엔딩 스타일은?</div>
            <div class="answer-options">
                <div class="answer-option" data-answer="A">A. 깔끔하게 마무리되는 해피엔딩</div>
                <div class="answer-option" data-answer="B">B. 슬프지만 여운이 남는 감성 엔딩</div>
                <div class="answer-option" data-answer="C">C. 반전에 반전을 거듭하는 충격 엔딩</div>
                <div class="answer-option" data-answer="D">D. 열린 결말로 해석의 여지가 남는 엔딩</div>
            </div>
        </div>

        <!-- Question 5 -->
        <div class="question-box" data-question="5">
            <div class="question-number">5️⃣ 질문 5/10</div>
            <div class="question-text">영화 속 긴장감에 대한 생각은?</div>
            <div class="answer-options">
                <div class="answer-option" data-answer="A">A. 적당히 긴장감이 있어야 재미있다</div>
                <div class="answer-option" data-answer="B">B. 잔잔하고 편안한 분위기가 더 좋다</div>
                <div class="answer-option" data-answer="C">C. 절박한 상황에서 몰입하는 걸 좋아한다</div>
                <div class="answer-option" data-answer="D">D. 분위기보단 캐릭터 중심이면 OK</div>
            </div>
        </div>

        <!-- Question 6 -->
        <div class="question-box" data-question="6">
            <div class="question-number">6️⃣ 질문 6/10</div>
            <div class="question-text">긴 러닝타임 영화(150분 이상)가 있다면?</div>
            <div class="answer-options">
                <div class="answer-option" data-answer="A">A. 길어도 상관 없음! 스토리가 좋으면 관람</div>
                <div class="answer-option" data-answer="B">B. 길면 집중이 안 됨… 짧은 영화 선호</div>
                <div class="answer-option" data-answer="C">C. 액션·스릴러라면 길어도 재미있음</div>
                <div class="answer-option" data-answer="D">D. 영상미나 세계관이 좋으면 긴 영화도 환영</div>
            </div>
        </div>

        <!-- Question 7 -->
        <div class="question-box" data-question="7">
            <div class="question-number">7️⃣ 질문 7/10</div>
            <div class="question-text">혼자 영화 볼 때 가장 끌리는 장르?</div>
            <div class="answer-options">
                <div class="answer-option" data-answer="A">A. 코미디 / 로맨틱 코미디</div>
                <div class="answer-option" data-answer="B">B. 감성 드라마 / 휴먼 영화</div>
                <div class="answer-option" data-answer="C">C. 스릴러 / 범죄 / 미스터리</div>
                <div class="answer-option" data-answer="D">D. 판타지 / SF / 히어로물</div>
            </div>
        </div>

        <!-- Question 8 -->
        <div class="question-box" data-question="8">
            <div class="question-number">8️⃣ 질문 8/10</div>
            <div class="question-text">친구가 "이 영화 철학적이고 좀 어려운데 재밌어"라고 한다면?</div>
            <div class="answer-options">
                <div class="answer-option" data-answer="A">A. 패스… 가벼운 영화가 좋아</div>
                <div class="answer-option" data-answer="B">B. 의미 있는 영화면 도전 가능</div>
                <div class="answer-option" data-answer="C">C. 난해해도 새로운 경험 좋아함</div>
                <div class="answer-option" data-answer="D">D. 해석하는 재미가 있으면 OK</div>
            </div>
        </div>

        <!-- Question 9 -->
        <div class="question-box" data-question="9">
            <div class="question-number">9️⃣ 질문 9/10</div>
            <div class="question-text">영화 속 음악·OST는?</div>
            <div class="answer-options">
                <div class="answer-option" data-answer="A">A. 크게 신경 안 씀</div>
                <div class="answer-option" data-answer="B">B. 서정적인 장면 + OST 조합 좋아함</div>
                <div class="answer-option" data-answer="C">C. 박진감 넘치는 음악 선호</div>
                <div class="answer-option" data-answer="D">D. OST로 인물 감정선이나 세계관을 느끼는 편</div>
            </div>
        </div>

        <!-- Question 10 -->
        <div class="question-box" data-question="10">
            <div class="question-number">🔟 질문 10/10</div>
            <div class="question-text">주말에 영화 한 편 보려고 할 때 가장 먼저 떠오르는 건?</div>
            <div class="answer-options">
                <div class="answer-option" data-answer="A">A. 기분 좋아지는 가벼운 영화</div>
                <div class="answer-option" data-answer="B">B. 감성 터지는 로맨스·드라마</div>
                <div class="answer-option" data-answer="C">C. 긴장감 넘치는 스릴러나 범죄물</div>
                <div class="answer-option" data-answer="D">D. 뇌가 시원해지는 판타지·SF·히어로물</div>
            </div>
        </div>

        <!-- 네비게이션 버튼 -->
        <div class="nav-buttons">
            <button class="nav-btn prev" id="prevBtn" disabled>← 이전</button>
            <button class="nav-btn next" id="nextBtn" disabled>다음 →</button>
            <button class="nav-btn next" id="resultBtn" style="display: none;">결과 확인 🍿</button>
        </div>
    </div>

    <!-- 결과 화면 -->
    <div class="result-container" id="resultContainer">
        <div class="result-type" id="resultEmoji"></div>
        <div class="result-title" id="resultTitle"></div>
        <div class="result-description" id="resultDesc"></div>

        <div class="recommended-movies">
            <h3>🎞️ <%= user.getUsername() %>님을 위한 추천 영화</h3>
            <div class="movie-list" id="movieList"></div>
        </div>

        <a href="indexMovie" class="back-btn">메인으로 돌아가기</a>
    </div>
</div>

<script>
var currentQuestion = 1;
var answers = {};
var totalQuestions = 10;

// 페이지 로드 완료 후 실행
window.onload = function() {
    console.log('페이지 로드 완료');
    
    // 모든 답변 옵션에 클릭 이벤트 추가
    var options = document.querySelectorAll('.answer-option');
    console.log('답변 옵션 개수:', options.length);
    
    for (var i = 0; i < options.length; i++) {
        options[i].onclick = function() {
            console.log('답변 클릭됨');
            
            // 현재 활성화된 질문 찾기
            var activeBox = document.querySelector('.question-box.active');
            var questionNum = parseInt(activeBox.getAttribute('data-question'));
            var answer = this.getAttribute('data-answer');
            
            console.log('질문 번호:', questionNum, '답변:', answer);
            
            // 같은 질문의 다른 선택지 선택 해제
            var currentOptions = activeBox.querySelectorAll('.answer-option');
            for (var j = 0; j < currentOptions.length; j++) {
                currentOptions[j].classList.remove('selected');
            }
            
            // 현재 선택지 선택
            this.classList.add('selected');
            
            // 답변 저장
            answers[questionNum] = answer;
            console.log('저장된 답변:', answers);
            
            // 진행률 업데이트
            updateProgress();
            
            // 버튼 상태 업데이트
            updateButtons();
        };
    }
    
    // 이전 버튼
    document.getElementById('prevBtn').onclick = function() {
        console.log('이전 버튼 클릭, 현재 질문:', currentQuestion);
        prevQuestion();
    };
    
    // 다음 버튼
    document.getElementById('nextBtn').onclick = function() {
        console.log('다음 버튼 클릭, 현재 질문:', currentQuestion);
        nextQuestion();
    };
    
    // 결과 버튼
    document.getElementById('resultBtn').onclick = function() {
        console.log('결과 버튼 클릭');
        showResult();
    };
    
    // 초기 버튼 상태
    updateButtons();
};

function updateProgress() {
    var answeredCount = Object.keys(answers).length;
    var progress = (answeredCount / totalQuestions) * 100;
    document.getElementById('progressBar').style.width = progress + '%';
    console.log('진행률:', progress + '%');
}

function updateButtons() {
    var prevBtn = document.getElementById('prevBtn');
    var nextBtn = document.getElementById('nextBtn');
    var resultBtn = document.getElementById('resultBtn');
    
    console.log('버튼 업데이트 - 현재 질문:', currentQuestion, '답변:', answers[currentQuestion]);
    
    // 이전 버튼
    prevBtn.disabled = (currentQuestion === 1);
    
    // 마지막 질문인 경우
    if (currentQuestion === totalQuestions) {
        nextBtn.style.display = 'none';
        resultBtn.style.display = 'block';
        resultBtn.disabled = !answers[currentQuestion];
    } else {
        nextBtn.style.display = 'block';
        resultBtn.style.display = 'none';
        nextBtn.disabled = !answers[currentQuestion];
    }
    
    console.log('다음 버튼 disabled:', nextBtn.disabled);
}

function prevQuestion() {
    if (currentQuestion > 1) {
        console.log('이전 질문으로 이동:', currentQuestion, '->', currentQuestion - 1);
        
        // 현재 질문 숨기기
        var current = document.querySelector('[data-question="' + currentQuestion + '"]');
        current.classList.remove('active');
        
        // 이전 질문으로
        currentQuestion--;
        
        // 이전 질문 보이기
        var prev = document.querySelector('[data-question="' + currentQuestion + '"]');
        prev.classList.add('active');
        
        updateButtons();
    }
}

function nextQuestion() {
    console.log('다음 질문 시도 - 현재:', currentQuestion, '답변 여부:', !!answers[currentQuestion]);
    
    if (currentQuestion < totalQuestions && answers[currentQuestion]) {
        console.log('다음 질문으로 이동:', currentQuestion, '->', currentQuestion + 1);
        
        // 현재 질문 숨기기
        var current = document.querySelector('[data-question="' + currentQuestion + '"]');
        current.classList.remove('active');
        
        // 다음 질문으로
        currentQuestion++;
        
        // 다음 질문 보이기
        var next = document.querySelector('[data-question="' + currentQuestion + '"]');
        next.classList.add('active');
        
        updateButtons();
    } else {
        console.log('이동 실패 - 답변 없음 또는 마지막 질문');
    }
}

function showResult() {
    console.log('결과 표시, 전체 답변:', answers);
    
    if (Object.keys(answers).length < totalQuestions) {
        alert('모든 질문에 답변해주세요!');
        return;
    }
    
    document.getElementById('questions').style.display = 'none';
    document.querySelector('.progress-bar').style.display = 'none';
    
    var result = analyzeAnswers(answers);
    
    document.getElementById('resultEmoji').textContent = result.emoji;
    document.getElementById('resultTitle').textContent = result.title;
    document.getElementById('resultDesc').textContent = result.description;
    
    var movieHTML = '';
	for (var i = 0; i < result.movies.length; i++) {
	    var movie = result.movies[i];
	    movieHTML += '<div class="movie-item" onclick="location.href=\'movieDetail?movieId=' + movie.id + '\'" style="cursor: pointer;">';
	    movieHTML += '<div style="font-weight: 600; margin-bottom: 8px; color: #ffffff; font-size: 16px;">' + movie.title + '</div>';
	    movieHTML += '<div style="font-size: 14px; color: #b3b3b3; line-height: 1.5;">' + movie.desc + '</div>';
	    movieHTML += '</div>';
	}
    document.getElementById('movieList').innerHTML = movieHTML;
    
    document.getElementById('resultContainer').classList.add('show');
}

function analyzeAnswers(answers) {
    var counts = { A: 0, B: 0, C: 0, D: 0 };
    
    for (var key in answers) {
        counts[answers[key]]++;
    }
    
    console.log('답변 집계:', counts);

    var maxType = 'A';
    var maxCount = counts.A;
    
    if (counts.B > maxCount) {
        maxType = 'B';
        maxCount = counts.B;
    }
    if (counts.C > maxCount) {
        maxType = 'C';
        maxCount = counts.C;
    }
    if (counts.D > maxCount) {
        maxType = 'D';
        maxCount = counts.D;
    }

    console.log('최종 유형:', maxType);

    var results = {
        A: {
            emoji: '😂',
            title: '코미디·가벼운 재미 추구형',
            description: '당신은 부담 없이 웃고 즐길 수 있는 영화를 선호하는 타입입니다! 복잡한 스토리보다는 빠른 전개와 유쾌한 분위기를 좋아하며, 영화를 통해 스트레스를 날리고 기분 전환을 하는 것을 즐깁니다.',
            movies: [
                { title: '극한직업 (2019)', desc: '치킨집을 운영하는 마약반 형사들의 좌충우돌 코미디', id: 575264 },
                { title: '써니 (2011)', desc: '80년대 여고생들의 우정과 현재를 오가는 감동 코미디', id: 83666 },
                { title: '7번방의 선물 (2013)', desc: '억울하게 수감된 아버지와 딸의 따뜻한 이야기', id: 177572 },
                { title: '엑시트 (2019)', desc: '건물에 갇힌 두 사람의 스릴 넘치는 탈출극', id: 597230 },
                { title: '백 투 더 퓨처 (1985)', desc: '타임머신을 타고 과거로 간 10대 소년의 모험', id: 105 }
            ]
        },
        B: {
            emoji: '💕',
            title: '감성·힐링 드라마 추구형',
            description: '당신은 깊은 감정선과 여운이 있는 영화를 선호하는 타입입니다! 인간관계의 미묘한 감정과 따뜻한 이야기를 좋아하며, 영화를 보며 감동받고 위로받는 것을 소중하게 여깁니다.',
            movies: [
                { title: '어바웃 타임 (2013)', desc: '시간여행을 통해 깨닫는 일상의 소중함', id: 122906 },
                { title: '클래식 (2003)', desc: '두 세대에 걸친 애틋한 사랑 이야기', id: 35883 },
                { title: '건축학개론 (2012)', desc: '첫사랑의 기억과 현재를 오가는 로맨스', id: 126095 },
                { title: '러브 액츄얼리 (2003)', desc: '크리스마스를 배경으로 한 다양한 사랑 이야기', id: 508 },
                { title: '비긴 어게인 (2013)', desc: '음악으로 상처를 치유하는 사람들의 이야기', id: 222935 }
            ]
        },
        C: {
            emoji: '🔍',
            title: '스릴러·미스터리 몰입형',
            description: '당신은 긴장감과 반전, 몰입감을 중요하게 생각하는 타입입니다! 복잡한 플롯과 예상치 못한 전개를 좋아하며, 영화를 보며 추리하고 분석하는 과정을 즐깁니다.',
            movies: [
                { title: '기생충 (2019)', desc: '계층 간 갈등을 다룬 블랙 코미디 스릴러', id: 496243 },
                { title: '올드보이 (2003)', desc: '15년간 감금된 남자의 복수극', id: 670 },
                { title: '살인의 추억 (2003)', desc: '실제 사건을 바탕으로 한 범죄 스릴러', id: 11299 },
                { title: '샤터 아일랜드 (2010)', desc: '정신병원에서 벌어지는 미스터리', id: 11324 },
                { title: '인셉션 (2010)', desc: '꿈속의 꿈을 오가는 심리 스릴러', id: 27205 }
            ]
        },
        D: {
            emoji: '🚀',
            title: '판타지·SF·히어로 세계관형',
            description: '당신은 현실을 넘어서는 상상력과 화려한 세계관을 사랑하는 타입입니다! 독특한 캐릭터와 압도적인 영상미, 스케일 큰 이야기를 좋아하며, 영화를 통해 새로운 세계를 경험하는 것을 즐깁니다.',
            movies: [
                { title: '인터스텔라 (2014)', desc: '우주를 무대로 한 장대한 SF 서사', id: 157336 },
                { title: '반지의 제왕: 왕의 귀환 (2003)', desc: '중간계를 구하는 장대한 판타지 서사', id: 122 },
                { title: '어벤져스: 엔드게임 (2019)', desc: '마블 히어로들의 최후의 전투', id: 299534 },
                { title: '해리포터와 마법사의 돌 (2001)', desc: '마법 세계의 모험과 성장 이야기', id: 671 },
                { title: '매트릭스 (1999)', desc: '가상현실과 진실을 오가는 SF 액션', id: 603 }
            ]
        }
    };

    return results[maxType];
}
</script>

</body>
</html>