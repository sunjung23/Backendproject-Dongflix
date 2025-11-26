package com.dongyang.dongflix.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import com.dongyang.dongflix.model.TMDBmovie;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/indexMovie")
public class IndexMovieServlet extends HttpServlet {

    private static final String API_KEY = "5c22fcbe6d86e21ad75efef7d85e867d";
    private static final String BASE_URL = "https://api.themoviedb.org/3";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 영화 목록 가져오기
            List<TMDBmovie> animationList = fetchByGenre("16");
            List<TMDBmovie> romanceList   = fetchByGenre("10749");
            List<TMDBmovie> actionList    = fetchByGenre("28");

            request.setAttribute("fromServlet", true);

            //데이터 저장
            request.setAttribute("animationList", animationList);
            request.setAttribute("romanceList", romanceList);
            request.setAttribute("actionList", actionList);

            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }

    private List<TMDBmovie> fetchByGenre(String genreId) throws Exception {
        String apiUrl = BASE_URL +
                "/discover/movie?api_key=" + API_KEY +
                "&with_genres=" + genreId +
                "&language=ko-KR&page=1";

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();

        String jsonStr = sb.toString();
        JSONObject obj = new JSONObject(jsonStr);
        JSONArray results = obj.getJSONArray("results");

        List<TMDBmovie> list = new ArrayList<>();

        int limit = Math.min(results.length(), 6);
        for (int i = 0; i < limit; i++) {
            JSONObject m = results.getJSONObject(i);

            int id = m.getInt("id");
            String title = m.optString("title", "제목 없음");
            String overview = m.optString("overview", "줄거리 없음");
            String posterPath = m.optString("poster_path", null);

            list.add(new TMDBmovie(id, title, overview, posterPath));
        }

        return list;
    }
}