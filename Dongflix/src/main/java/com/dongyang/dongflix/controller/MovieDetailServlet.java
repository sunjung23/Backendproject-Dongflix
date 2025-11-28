package com.dongyang.dongflix.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import com.dongyang.dongflix.model.TMDBmovie;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONObject;

@WebServlet("/movieDetail")
public class MovieDetailServlet extends HttpServlet {

    private static final String API_KEY = "5c22fcbe6d86e21ad75efef7d85e867d";
    private static final String BASE_URL = "https://api.themoviedb.org/3/movie/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String movieId = request.getParameter("movieId");

        if (movieId == null) {
            response.sendRedirect("indexMovie");
            return;
        }

        try {
            TMDBmovie movie = fetchMovieDetail(movieId);

            request.setAttribute("movie", movie);
            request.getRequestDispatcher("/movie/movieDetail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("indexMovie");
        }
    }

    private TMDBmovie fetchMovieDetail(String movieId) throws Exception {

        String apiUrl = BASE_URL + movieId + "?api_key=" + API_KEY + "&language=ko-KR";

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = br.readLine()) != null) sb.append(line);
        br.close();

        JSONObject obj = new JSONObject(sb.toString());

        TMDBmovie movie = new TMDBmovie(
                obj.getInt("id"),
                obj.optString("title", "제목 없음"),
                obj.optString("overview", "줄거리 없음"),
                obj.optString("poster_path", null),
                obj.optString("backdrop_path", null),
                obj.optDouble("vote_average", 0),
                obj.optString("release_date", "정보 없음")
        );

        return movie;
    }
}