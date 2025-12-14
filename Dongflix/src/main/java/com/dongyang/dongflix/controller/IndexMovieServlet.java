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
import jakarta.servlet.http.*;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/indexMovie")
public class IndexMovieServlet extends HttpServlet {

    private static final String API_KEY = "5c22fcbe6d86e21ad75efef7d85e867d";
    private static final String BASE_URL = "https://api.themoviedb.org/3";

    private static final Map<String, String> GENRES = new HashMap<>();
    static {
        GENRES.put("animation", "16");
        GENRES.put("romance", "10749");
        GENRES.put("action", "28");
        GENRES.put("crime", "80");
        GENRES.put("fantasy", "14");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Map<String, List<TMDBmovie>> movieLists = new HashMap<>();

            for (Map.Entry<String, String> entry : GENRES.entrySet()) {
                List<TMDBmovie> list = fetchByGenre(entry.getValue());
                movieLists.put(entry.getKey(), list);
            }

            List<TMDBmovie> allMovies = new ArrayList<>();
            for (List<TMDBmovie> list : movieLists.values()) {
                allMovies.addAll(list);
            }

            TMDBmovie bannerMovie = null;
            if (!allMovies.isEmpty()) {
                Collections.shuffle(allMovies);
                bannerMovie = allMovies.get(0);
            }

            HttpSession session = request.getSession();
            MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

            List<TMDBmovie> personalRecommend = null;

            if (user != null) {

                String style = user.getMovieStyle(); // ex) "액션,코미디,로맨스"

                if (style != null && !style.trim().isEmpty()) {

                    // 장르 분리
                    String[] favGenres = style.split(",");

                    // 결과 리스트
                    personalRecommend = new ArrayList<>();

                    for (String g : favGenres) {
                        g = g.trim();

                        String tmdbId = genreToTMDB(g);
                        if (tmdbId != null) {
                            // 선호 장르 영화 fetch (하나당 10개)
                            List<TMDBmovie> temp = fetchByGenre(tmdbId);
                            Collections.shuffle(temp);
                            personalRecommend.addAll(temp.subList(0, Math.min(temp.size(), 10)));
                        }
                    }

                    // 추천 섞음
                    Collections.shuffle(personalRecommend);

                    // 최대 20개만
                    if (personalRecommend.size() > 20) {
                        personalRecommend = personalRecommend.subList(0, 20);
                    }
                }
            }

            if (personalRecommend == null || personalRecommend.isEmpty()) {
                // 전체 인기 영화에서 랜덤 12개 제공
                Collections.shuffle(allMovies);
                personalRecommend = allMovies.subList(0, Math.min(12, allMovies.size()));
            }

            /*  JSP 전달 */
            request.setAttribute("bannerMovie", bannerMovie);
            request.setAttribute("movieLists", movieLists);
            request.setAttribute("personalRecommend", personalRecommend);
            request.setAttribute("fromServlet", true);

            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }

    /* TMDB 장르 변환 */
    private String genreToTMDB(String genre) {

        switch (genre) {
            case "액션": return "28";
            case "로맨스": return "10749";
            case "스릴러": return "53";
            case "코미디": return "35";
            case "SF": return "878";
            case "판타지": return "14";
            case "애니메이션": return "16";
            case "공포": return "27";
            case "드라마": return "18";
            default: return null;
        }
    }

    /*  TMDB API로 장르별 영화 로드 */
    private List<TMDBmovie> fetchByGenre(String genreId) throws Exception {

        Random rnd = new Random();
        int randomPage = rnd.nextInt(8) + 1;

        String apiUrl = BASE_URL +
                "/discover/movie?api_key=" + API_KEY +
                "&with_genres=" + genreId +
                "&language=ko-KR" +
                "&sort_by=popularity.desc" +
                "&vote_average.gte=6.0" +
                "&vote_count.gte=200" +
                "&page=" + randomPage;

        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
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

        for (int i = 0; i < results.length(); i++) {
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

        Collections.shuffle(list);

        return list.subList(0, Math.min(list.size(), 18));
    }
}
