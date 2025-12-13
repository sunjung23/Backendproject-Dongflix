package com.dongyang.dongflix.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.JSONObject;

import com.dongyang.dongflix.model.TMDBmovie;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/writeDiary")
public class WriteDiaryServlet extends HttpServlet {

    private static final String API_KEY = "5c22fcbe6d86e21ad75efef7d85e867d";
    private static final String BASE_URL = "https://api.themoviedb.org/3/movie/";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /* ===============================
           🔒 로그인 가드 (이게 핵심)
        =============================== */
        HttpSession session = req.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        /* ===============================
           movieId 파라미터 검사
        =============================== */
        String movieId = req.getParameter("movieId");

        if (movieId == null || movieId.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/indexMovie");
            return;
        }

        TMDBmovie movie = null;

        try {
            int id = Integer.parseInt(movieId);
            movie = fetchMovieDetail(id);

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (movie == null) {
            resp.sendRedirect(req.getContextPath() + "/indexMovie");
            return;
        }

        req.setAttribute("movie", movie);
        req.getRequestDispatcher("/movie/writeDiary.jsp").forward(req, resp);
    }

    private TMDBmovie fetchMovieDetail(int movieId) {

        try {
            String apiUrl = BASE_URL + movieId + "?api_key=" + API_KEY + "&language=ko-KR";

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;

            while ((line = br.readLine()) != null)
                sb.append(line);
            br.close();

            JSONObject obj = new JSONObject(sb.toString());

            return new TMDBmovie(
                    obj.getInt("id"),
                    obj.optString("title", "제목 없음"),
                    obj.optString("overview", "줄거리 없음"),
                    obj.optString("poster_path", null),
                    obj.optString("backdrop_path", null),
                    obj.optDouble("vote_average", 0),
                    obj.optString("release_date", "정보 없음")
            );

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
