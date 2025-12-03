package com.dongyang.dongflix.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/getRecommendedMovies")
public class MovieTestServlet extends HttpServlet {
    
    private static final String API_KEY = "5c22fcbe6d86e21ad75efef7d85e867d";
    private static final String BASE_URL = "https://api.themoviedb.org/3";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String type = request.getParameter("type"); // A, B, C, D
        
        try {
            // 유형별로 다른 장르 ID 사용
            String genreId = getGenreIdByType(type);
            
            // TMDB에서 영화 가져오기
            List<MovieData> movies = fetchMoviesByGenre(genreId);
            
            // 랜덤하게 섞기
            Collections.shuffle(movies);
            
            // 상위 5개만 선택
            int count = Math.min(5, movies.size());
            
            // JSON 응답 생성
            out.print("[");
            for (int i = 0; i < count; i++) {
                MovieData movie = movies.get(i);
                out.print("{");
                out.print("\"id\":" + movie.id + ",");
                out.print("\"title\":\"" + escapeJson(movie.title) + "\",");
                out.print("\"year\":\"" + movie.releaseYear + "\",");
                out.print("\"rating\":" + movie.rating + ",");
                out.print("\"poster\":\"" + escapeJson(movie.posterPath) + "\",");
                out.print("\"genres\":\"" + escapeJson(movie.genres) + "\"");
                out.print("}");
                if (i < count - 1) out.print(",");
            }
            out.print("]");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("[{\"error\": \"영화 정보를 가져올 수 없습니다.\"}]");
        }
    }
    
    // TMDB API로 장르별 영화 가져오기
    private List<MovieData> fetchMoviesByGenre(String genreId) throws Exception {
        Random rnd = new Random();
        int randomPage = rnd.nextInt(3) + 1;
        
        String apiUrl = BASE_URL +
                "/discover/movie?api_key=" + API_KEY +
                "&with_genres=" + genreId +
                "&language=ko-KR" +
                "&sort_by=popularity.desc" +
                "&vote_average.gte=7.0" +
                "&vote_count.gte=200" +
                "&page=" + randomPage;
        
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        
        BufferedReader br = new BufferedReader(
            new InputStreamReader(conn.getInputStream(), "UTF-8")
        );
        
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();
        
        JSONObject obj = new JSONObject(sb.toString());
        JSONArray results = obj.getJSONArray("results");
        
        List<MovieData> list = new ArrayList<>();
        for (int i = 0; i < results.length(); i++) {
            JSONObject m = results.getJSONObject(i);
            
            MovieData movie = new MovieData();
            movie.id = m.getInt("id");
            movie.title = m.optString("title", "제목 없음");
            movie.rating = m.optDouble("vote_average", 0.0);
            
            // 포스터 경로
            String poster = m.optString("poster_path", "");
            if (!poster.isEmpty()) {
                movie.posterPath = "https://image.tmdb.org/t/p/w200" + poster;
            } else {
                movie.posterPath = "";
            }
            
            // 장르 ID 배열을 텍스트로 변환
            JSONArray genreIds = m.optJSONArray("genre_ids");
            movie.genres = convertGenreIdsToText(genreIds);
            
            // 개봉년도 추출
            String releaseDate = m.optString("release_date", "");
            if (releaseDate.length() >= 4) {
                movie.releaseYear = releaseDate.substring(0, 4);
            } else {
                movie.releaseYear = "미정";
            }
            
            // 평점 7.0 미만 제외
            if (movie.rating >= 7.0) {
                list.add(movie);
            }
        }
        
        return list;
    }

    // 장르 ID를 한글 텍스트로 변환
    private String convertGenreIdsToText(JSONArray genreIds) {
        if (genreIds == null || genreIds.length() == 0) {
            return "";
        }
        
        // TMDB 장르 ID 매핑
        Map<Integer, String> genreMap = new HashMap<>();
        genreMap.put(28, "액션");
        genreMap.put(12, "모험");
        genreMap.put(16, "애니메이션");
        genreMap.put(35, "코미디");
        genreMap.put(80, "범죄");
        genreMap.put(99, "다큐멘터리");
        genreMap.put(18, "드라마");
        genreMap.put(10751, "가족");
        genreMap.put(14, "판타지");
        genreMap.put(36, "역사");
        genreMap.put(27, "공포");
        genreMap.put(10402, "음악");
        genreMap.put(9648, "미스터리");
        genreMap.put(10749, "로맨스");
        genreMap.put(878, "SF");
        genreMap.put(10770, "TV영화");
        genreMap.put(53, "스릴러");
        genreMap.put(10752, "전쟁");
        genreMap.put(37, "서부");
        
        List<String> genreNames = new ArrayList<>();
        for (int i = 0; i < genreIds.length() && i < 2; i++) { // 최대 2개만
            int genreId = genreIds.optInt(i);
            String genreName = genreMap.get(genreId);
            if (genreName != null) {
                genreNames.add(genreName);
            }
        }
        
        return String.join(" · ", genreNames);
    }
    
    // 유형별 장르 ID 반환 (여러 장르 조합)
    private String getGenreIdByType(String type) {
        if (type == null) return "28";
        
        switch (type) {
            case "A": // 코미디·가벼운 재미
                return "35,12,10751"; // Comedy, Adventure, Family
            case "B": // 로맨스·드라마·감성
                return "10749,18,10402"; // Romance, Drama, Music
            case "C": // 스릴러·범죄·미스터리
                return "53,80,9648"; // Thriller, Crime, Mystery
            case "D": // 판타지·SF·히어로
                return "14,878,28,12"; // Fantasy, SF, Action, Adventure
            default:
                return "28";
        }
    }
    
    // JSON 특수문자 이스케이프
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", " ")
                  .replace("\r", " ")
                  .replace("\t", " ");
    }
    
    // 내부 클래스
    private static class MovieData {
        int id;
        String title;
        String releaseYear;
        double rating;
        String posterPath;  
        String genres;    
    }
}