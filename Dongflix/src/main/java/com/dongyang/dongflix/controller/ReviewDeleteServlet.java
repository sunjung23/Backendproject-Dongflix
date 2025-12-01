package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.ReviewDAO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/deleteReview")
public class ReviewDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int reviewId = Integer.parseInt(request.getParameter("id"));
        int movieId = Integer.parseInt(request.getParameter("movieId"));

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        ReviewDAO dao = new ReviewDAO();
        dao.deleteReview(reviewId);

        response.sendRedirect("movieDetail?movieId=" + movieId);
    }
}