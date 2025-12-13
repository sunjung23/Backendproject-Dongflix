package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.LinkedHashSet;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/searchSuggest")
public class SearchSuggestServlet extends HttpServlet {

    private static final String API_KEY = "5c22fcbe6d86e21ad75efef7d85e867d";
    private static final String BASE_URL = "https://api.themoviedb.org/3/search/movie";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String q = req.getParameter("q");
        if (q == null || q.trim().isEmpty()) {
            resp.getWriter().write("[]");
            return;
        }

        String apiUrl = BASE_URL +
                "?query=" + URLEncoder.encode(q, "UTF-8") +
                "&language=ko-KR" +
                "&api_key=" + API_KEY;

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        StringBuilder sb = new StringBuilder();
        try (var br = new java.io.BufferedReader(
                new java.io.InputStreamReader(conn.getInputStream(), "UTF-8"))) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }

        JSONObject obj = new JSONObject(sb.toString());
        JSONArray results = obj.getJSONArray("results");

        Set<String> titles = new LinkedHashSet<>();

        for (int i = 0; i < results.length() && titles.size() < 8; i++) {
            JSONObject m = results.getJSONObject(i);
            titles.add(m.optString("title"));
        }

        JSONArray out = new JSONArray(titles);

        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write(out.toString());
    }
}
