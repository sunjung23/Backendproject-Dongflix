package com.dongyang.dongflix;

import java.io.IOException;
import java.util.List;

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

        // 로그인 안 되어 있으면 로그인 페이지로
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 내가 쓴 리뷰 목록 가져오기
        ReviewDAO rdao = new ReviewDAO();
        List<ReviewDTO> reviews = rdao.getReviewsByUser(user.getUserid());

        request.setAttribute("user", user);
        request.setAttribute("reviews", reviews);

        request.getRequestDispatcher("mypage.jsp").forward(request, response);
        
        //좋아요 목록
        LikeMovieDAO likeDao = new LikeMovieDAO();
        List<LikeMovieDTO> likedMovies = likeDao.getLikedMovies(user.getUserid());

        request.setAttribute("likedMovies", likedMovies);

    }
}
