package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dao.LikeMovieDAO;
import com.dongyang.dongflix.dao.MemberDAO;
import com.dongyang.dongflix.dao.ReviewDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import com.dongyang.dongflix.dto.LikeMovieDTO;
import com.dongyang.dongflix.dto.MemberDTO;
import com.dongyang.dongflix.dto.ReviewDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/admin-member-detail.do")
public class AdminMemberDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("/admin/admin-login.jsp");
            return;
        }

        // 조회할 회원 아이디
        String userid = request.getParameter("userid");
        if (userid == null || userid.trim().isEmpty()) {
            response.sendRedirect("admin-member.do");
            return;
        }

        // 회원 정보 조회
        MemberDAO memberDao = new MemberDAO();
        MemberDTO user = memberDao.getMember(userid);

        if (user == null) {
            response.sendRedirect("admin-member.do");
            return;
        }

        // 리뷰 목록 가져오기
        ReviewDAO reviewDao = new ReviewDAO();
        List<ReviewDTO> reviews = reviewDao.getReviewsByUser(userid);
        double avgRating = reviewDao.getAverageRating(userid);

        // 찜한 영화 목록 가져오기
        LikeMovieDAO likeDao = new LikeMovieDAO();
        List<LikeMovieDTO> likedMovies = likeDao.getLikedMovies(userid);

        // 작성한 게시글 목록
        BoardDAO boardDao = new BoardDAO();
        List<BoardDTO> myBoards = boardDao.getByUser(userid);

        // 데이터 전달
        request.setAttribute("user", user);
        request.setAttribute("reviews", reviews);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("likedMovies", likedMovies);
        request.setAttribute("myBoards", myBoards);

        request.getRequestDispatcher("/admin/admin-member-detail.jsp").forward(request, response);
    }
}