package com.dongyang.dongflix.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

import com.dongyang.dongflix.dto.MemberDTO;
import com.dongyang.dongflix.model.TMDBmovie;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/recommend")
public class RecommendServlet extends HttpServlet {

    private static final String API_KEY  = "5c22fcbe6d86e21ad75efef7d85e867d";
    private static final String BASE_URL = "https://api.themoviedb.org/3";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 로그인 사용자 확인
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
        if (user == null) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "로그인 후 추천 서비스를 이용할 수 있습니다.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/login.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // 회원 가입 시 저장해둔 선호 장르 (예: "액션,로맨스,코미디")
        String signupGenres = (String) session.getAttribute("signupGenres");
        if (signupGenres == null) signupGenres = "";

        // 화면에 보여줄 이름 (닉네임 > 이름 > 아이디)
        String displayName;
        if (user.getNickname() != null && !user.getNickname().trim().isEmpty()) {
            displayName = user.getNickname();
        } else if (user.getUsername() != null && !user.getUsername().trim().isEmpty()) {
            displayName = user.getUsername();
        } else {
            displayName = user.getUserid();
        }

        //  선호 장르 문자열 → 리스트
        List<String> genreTokens = new ArrayList<>();
        if (!signupGenres.trim().isEmpty()) {
            genreTokens = Arrays.asList(signupGenres.split("\\s*,\\s*"));
        }

        // 선호 장르 목록을 TMDB 장르 ID CSV로 매핑 (예: "28,10749,16")
        String tmdbGenreCsv = mapGenresToTmdbIds(genreTokens);

        List<TMDBmovie> tasteMovies   = new ArrayList<>();
        List<TMDBmovie> popularMovies = new ArrayList<>();

        try {
            // 선호 장르 기반 추천 (최대 30편 정도)
            if (tmdbGenreCsv != null && !tmdbGenreCsv.isEmpty()) {
                tasteMovies = fetchByGenres(tmdbGenreCsv, 30);
            }

            // 전체 인기 영화 (최대 30편 정도)
            popularMovies = fetchPopular(30);

        } catch (Exception e) {
            e.printStackTrace();
            // 오류 등 발생 시 기본 인기 영화만이라도 추천
            try {
                popularMovies = fetchPopular(30);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        // 리스트 셔플
        Collections.shuffle(tasteMovies);
        Collections.shuffle(popularMovies);

        List<TMDBmovie> primaryList   = new ArrayList<>();
        List<TMDBmovie> tasteMoreList = new ArrayList<>();
        List<TMDBmovie> trendingList  = new ArrayList<>();


        for (int i = 0; i < tasteMovies.size(); i++) {
            TMDBmovie m = tasteMovies.get(i);
            if (i < 12) {
                primaryList.add(m);
            } else if (i < 24) {
                tasteMoreList.add(m);
            } else {
                break;
            }
        }

        int needForPrimary = 12 - primaryList.size();
        int needForTasteMore = 12 - tasteMoreList.size();

        int popIndex = 0;
        while ((needForPrimary > 0 || needForTasteMore > 0) && popIndex < popularMovies.size()) {
            TMDBmovie m = popularMovies.get(popIndex++);
            if (!containsMovie(primaryList, m) && !containsMovie(tasteMoreList, m)) {
                if (needForPrimary > 0) {
                    primaryList.add(m);
                    needForPrimary--;
                } else if (needForTasteMore > 0) {
                    tasteMoreList.add(m);
                    needForTasteMore--;
                }
            }
        }

        Set<Integer> usedIds = new HashSet<>();
        for (TMDBmovie m : primaryList)   usedIds.add(m.getId());
        for (TMDBmovie m : tasteMoreList) usedIds.add(m.getId());

        for (TMDBmovie m : popularMovies) {
            if (trendingList.size() >= 12) break;
            if (!usedIds.contains(m.getId())) {
                trendingList.add(m);
                usedIds.add(m.getId());
            }
        }

        request.setAttribute("fromRecommendServlet", true);
        request.setAttribute("displayName", displayName);
        request.setAttribute("genres", signupGenres);
        request.setAttribute("primaryList", primaryList);
        request.setAttribute("tasteMoreList", tasteMoreList);
        request.setAttribute("trendingList", trendingList);

        request.getRequestDispatcher("/recommend.jsp").forward(request, response);
    }

    private String mapGenresToTmdbIds(List<String> genres) {
        if (genres == null || genres.isEmpty()) return null;

        List<String> ids = new ArrayList<>();

        for (String g : genres) {
            if (g == null) continue;
            String trimmed = g.trim();

            switch (trimmed) {
                case "액션"     -> ids.add("28");
                case "로맨스"   -> ids.add("10749");
                case "스릴러"   -> ids.add("53");
                case "코미디"   -> ids.add("35");
                case "SF"       -> ids.add("878");
                case "판타지"   -> ids.add("14");
                case "애니메이션" -> ids.add("16");
                case "공포"     -> ids.add("27");
                case "드라마"   -> ids.add("18");
                // 필요하면 더 추가 가능
            }
        }

        if (ids.isEmpty()) return null;
        // 중복 제거
        Set<String> set = new LinkedHashSet<>(ids);
        return String.join(",", set);
    }

    private List<TMDBmovie> fetchByGenres(String genreCsv, int maxCount) throws Exception {


        Random rnd = new Random();
        int randomPage = rnd.nextInt(3) + 1;  // 1~3

        String apiUrl = BASE_URL +
                "/discover/movie?api_key=" + API_KEY +
                "&with_genres=" + genreCsv +
                "&language=ko-KR" +
                "&sort_by=popularity.desc" +
                "&vote_count.gte=200" +
                "&page=" + randomPage;

        return fetchMovieList(apiUrl, maxCount);
    }


    private List<TMDBmovie> fetchPopular(int maxCount) throws Exception {
        String apiUrl = BASE_URL +
                "/movie/popular?api_key=" + API_KEY +
                "&language=ko-KR" +
                "&page=1";

        return fetchMovieList(apiUrl, maxCount);
    }


    private List<TMDBmovie> fetchMovieList(String apiUrl, int maxCount) throws Exception {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8")
        );

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);
        br.close();

        JSONObject obj = new JSONObject(sb.toString());
        JSONArray results = obj.getJSONArray("results");

        List<TMDBmovie> list = new ArrayList<>();

        for (int i = 0; i < results.length() && list.size() < maxCount; i++) {
            JSONObject m = results.getJSONObject(i);

            list.add(new TMDBmovie(
                    m.getInt("id"),
                    m.optString("title", "제목 없음"),
                    m.optString("overview", "줄거리 없음"),
                    m.optString("poster_path", null),
                    m.optString("backdrop_path", null),
                    m.optDouble("vote_average", 0),
                    m.optString("release_date", "정보 없음")
            ));
        }

        return list;
    }


    private boolean containsMovie(List<TMDBmovie> list, TMDBmovie target) {
        if (list == null || target == null) return false;
        for (TMDBmovie m : list) {
            if (m.getId() == target.getId()) return true;
        }
        return false;
    }
}
