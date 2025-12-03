package com.dongyang.dongflix.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import org.json.JSONArray;
import org.json.JSONObject;

import com.dongyang.dongflix.model.TMDBmovie;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/searchMovie")
public class SearchMovieServlet extends HttpServlet {

    private static final String API_KEY = "5c22fcbe6d86e21ad75efef7d85e867d";
    private static final String BASE_URL = "https://api.themoviedb.org/3";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        String genre = req.getParameter("genre");
        String sort = req.getParameter("sort");
        String page = req.getParameter("page");

        if (page == null) page = "1";

        try {

            List<TMDBmovie> movieList =
                    fetchMovies(keyword, genre, sort, page);

            req.setAttribute("movies", movieList);
            req.setAttribute("keyword", keyword);
            req.setAttribute("genre", genre);
            req.setAttribute("sort", sort);
            req.setAttribute("page", page);

            req.getRequestDispatcher("/movie/searchMovie.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("search.jsp");
        }
    }

    private List<TMDBmovie> fetchMovies(String keyword, String genre,
                                        String sort, String page) throws Exception {

    	String apiUrl;
    	if (keyword != null && !keyword.isEmpty()) {
    	    apiUrl = BASE_URL + "/search/movie?query="
    	            + URLEncoder.encode(keyword, StandardCharsets.UTF_8);
    	} else {
    	    apiUrl = BASE_URL + "/discover/movie?with_genres=" + genre;
    	}

        apiUrl += "&language=ko-KR&api_key=" + API_KEY + "&page=" + page;

        // 정렬 
        if ("rating".equals(sort)) apiUrl += "&sort_by=vote_average.desc";
        else if ("latest".equals(sort)) apiUrl += "&sort_by=release_date.desc";
        else apiUrl += "&sort_by=popularity.desc";  // default

        // API 호출 
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
        return list;
    }
}
