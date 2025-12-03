package com.dongyang.dongflix.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

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

            request.setAttribute("bannerMovie", bannerMovie);
            request.setAttribute("movieLists", movieLists);
            request.setAttribute("fromServlet", true);

            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }

    private List<TMDBmovie> fetchByGenre(String genreId) throws Exception {

        Random rnd = new Random();
        int randomPage = rnd.nextInt(8) + 1;

        String apiUrl = BASE_URL +
                "/discover/movie?api_key=" + API_KEY +
                "&with_genres=" + genreId +
                "&language=ko-KR" +
                "&sort_by=popularity.desc" +
                "&vote_average.gte=7.0" +
                "&vote_count.gte=300" +
                "&page=" + randomPage;

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

        Collections.shuffle(list);

        return list.subList(0, Math.min(list.size(), 18));
    }
}