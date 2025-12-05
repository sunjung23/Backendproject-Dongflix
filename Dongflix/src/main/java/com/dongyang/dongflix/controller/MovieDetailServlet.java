package com.dongyang.dongflix.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.dongyang.dongflix.dao.LikeMovieDAO;
import com.dongyang.dongflix.dao.ReviewDAO;
import com.dongyang.dongflix.dto.MemberDTO;
import com.dongyang.dongflix.dto.ReviewDTO;
import com.dongyang.dongflix.model.TMDBmovie;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/movieDetail")
public class MovieDetailServlet extends HttpServlet {

    private static final String API_KEY = "5c22fcbe6d86e21ad75efef7d85e867d";
    private static final String BASE_URL = "https://api.themoviedb.org/3/movie/";

    private static final Map<Integer, TMDBmovie> cache = new HashMap<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String movieId = request.getParameter("movieId");

        if (movieId == null) {
            response.sendRedirect("indexMovie");
            return;
        }

        try {
            int id = Integer.parseInt(movieId);

            TMDBmovie movie;

            if (cache.containsKey(id)) {
                movie = cache.get(id);
                System.out.println("TMDB 캐시 HIT: " + id);

            } else {
                movie = fetchMovieDetail(id);
                cache.put(id, movie);
                System.out.println("TMDB API 호출 & 캐싱: " + id);
            }

            request.setAttribute("movie", movie);

            ReviewDAO reviewDAO = new ReviewDAO();
            List<ReviewDTO> reviewList = reviewDAO.getReviewsByMovie(movie.getId());
            request.setAttribute("reviewList", reviewList);

            double avgRating = 0;
            if (reviewList != null && !reviewList.isEmpty()) {
                double sum = 0;
                for (ReviewDTO r : reviewList) sum += r.getRating();
                avgRating = sum / reviewList.size();
            }

            request.setAttribute("avgRating", avgRating);
            request.setAttribute("reviewCount", reviewList.size());

            HttpSession session = request.getSession();
            MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

            boolean isWished = false;
            if (loginUser != null) {
                LikeMovieDAO dao = new LikeMovieDAO();
                isWished = dao.isWished(loginUser.getUserid(), movie.getId());
            }
            request.setAttribute("isWished", isWished);

            request.getRequestDispatcher("/movie/movieDetail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("indexMovie");
        }
    }

    private TMDBmovie fetchMovieDetail(int movieId) throws Exception {

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

        return new TMDBmovie(
                obj.getInt("id"),
                obj.optString("title", "제목 없음"),
                obj.optString("overview", "줄거리 없음"),
                obj.optString("poster_path", null),
                obj.optString("backdrop_path", null),
                obj.optDouble("vote_average", 0),
                obj.optString("release_date", "정보 없음")
        );
    }
}