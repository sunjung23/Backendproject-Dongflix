package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.LikeMovieDAO;
import com.dongyang.dongflix.dao.ReviewDAO;
import com.dongyang.dongflix.dto.LikeMovieDTO;
import com.dongyang.dongflix.dto.MemberDTO;
import com.dongyang.dongflix.dto.ReviewDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/mypage.do")
public class MyPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 리뷰 목록 가져오기
        ReviewDAO rdao = new ReviewDAO();
        List<ReviewDTO> reviews = rdao.getReviewsByUser(user.getUserid());
        request.setAttribute("reviews", reviews);

        // 좋아요 목록 가져오기
        LikeMovieDAO likeDao = new LikeMovieDAO();
        List<LikeMovieDTO> likedMovies = likeDao.getLikedMovies(user.getUserid());
        request.setAttribute("likedMovies", likedMovies);

        // 유저 정보
        request.setAttribute("user", user);

        request.getRequestDispatcher("/user/mypage.jsp").forward(request, response);
    }
}