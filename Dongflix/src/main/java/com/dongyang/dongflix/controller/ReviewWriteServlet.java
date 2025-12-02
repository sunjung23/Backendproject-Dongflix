package com.dongyang.dongflix.controller;

import java.io.IOException;

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

@WebServlet("/writeReview")
public class ReviewWriteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int movieId = Integer.parseInt(request.getParameter("movieId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String content = request.getParameter("content");

        // TMDB 정보 받아오기
        TMDBmovie movie = (TMDBmovie) request.getAttribute("movieData");

        String movieTitle = request.getParameter("movieTitle");
        String movieImg = request.getParameter("movieImg");

        ReviewDTO dto = new ReviewDTO(
                user.getUserid(),
                movieId,
                "리뷰",
                content,
                rating,
                movieTitle,
                movieImg
        );


        // DB 저장
        ReviewDAO dao = new ReviewDAO();
        dao.insertReview(dto);

        // 상세 페이지로 이동
        response.sendRedirect("movieDetail?movieId=" + movieId);
    }
}
