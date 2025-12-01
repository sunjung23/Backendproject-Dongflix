package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.ReviewDAO;
import com.dongyang.dongflix.dto.MemberDTO;
import com.dongyang.dongflix.dto.ReviewDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateReview")
public class ReviewUpdateServlet extends HttpServlet {

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

        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        int movieId = Integer.parseInt(request.getParameter("movieId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String content = request.getParameter("content");

        ReviewDTO dto = new ReviewDTO();
        dto.setId(reviewId);
        dto.setRating(rating);
        dto.setContent(content);
        dto.setTitle("리뷰");

        ReviewDAO dao = new ReviewDAO();
        dao.updateReview(dto);

        response.sendRedirect("movieDetail?movieId=" + movieId);
    }
}