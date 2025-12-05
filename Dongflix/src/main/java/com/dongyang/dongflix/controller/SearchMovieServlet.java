package com.dongyang.dongflix.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;

import com.dongyang.dongflix.model.TMDBmovie;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/searchMovie")
public class SearchMovieServlet extends HttpServlet {

    private static final String API_KEY = "5c22fcbe6d86e21ad75efef7d85e867d";
    private static final String BASE_URL = "https://api.themoviedb.org/3";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        String genre = req.getParameter("genre");

        try {
            List<TMDBmovie> movieList = fetchMovies(keyword, genre, 6);

            // 포스터 없는 영화 제외
            movieList.removeIf(m -> m.getPosterUrl() == null || m.getPosterUrl().isEmpty());

            req.setAttribute("movies", movieList);
            req.setAttribute("keyword", keyword);
            req.setAttribute("genre", genre);

            req.getRequestDispatcher("/movie/searchMovie.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("search.jsp");
        }
    }

    /** 여러 페이지에서 영화 수집 */
    private List<TMDBmovie> fetchMovies(String keyword, String genre, int pages) throws Exception {
        List<TMDBmovie> collected = new ArrayList<>();

        for (int p = 1; p <= pages; p++) {

            String apiUrl = buildApiUrl(keyword, genre, p);

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            br.close();

            JSONObject obj = new JSONObject(sb.toString());
            JSONArray results = obj.getJSONArray("results");

            for (int i = 0; i < results.length(); i++) {
                JSONObject m = results.getJSONObject(i);

                if (m.isNull("poster_path")) continue;

                collected.add(new TMDBmovie(
                        m.getInt("id"),
                        m.optString("title", "제목 없음"),
                        m.optString("overview", "줄거리 없음"),
                        m.optString("poster_path", null),
                        m.optString("backdrop_path", null),
                        m.optDouble("vote_average", 0),
                        m.optString("release_date", "정보 없음")
                ));
            }
        }

        return collected;
    }

    private String buildApiUrl(String keyword, String genre, int page) throws Exception {
        StringBuilder apiUrl = new StringBuilder(BASE_URL);

        if (keyword != null && !keyword.isEmpty()) {
            apiUrl.append("/search/movie?query=")
                    .append(URLEncoder.encode(keyword, "UTF-8"));
        } else {
            apiUrl.append("/discover/movie?with_genres=")
                    .append(genre == null ? "" : genre);
        }

        apiUrl.append("&language=ko-KR&api_key=").append(API_KEY);
        apiUrl.append("&page=").append(page);


        return apiUrl.toString();
    }
}