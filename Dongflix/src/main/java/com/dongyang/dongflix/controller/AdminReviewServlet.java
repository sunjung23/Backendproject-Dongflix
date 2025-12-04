package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.ReviewDAO;
import com.dongyang.dongflix.dto.MemberDTO;
import com.dongyang.dongflix.dto.ReviewDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/admin-review.do")
public class AdminReviewServlet extends HttpServlet {

    // 리뷰 목록 조회
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("/admin/admin-login.jsp");
            return;
        }

        ReviewDAO dao = new ReviewDAO();
        List<ReviewDTO> reviews = dao.getAllReviews();

        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/admin/admin-review.jsp").forward(request, response);
    }

    // 리뷰 삭제
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String reviewIdStr = request.getParameter("reviewId");
            
            // 프로필에서 온 경우 확인
            String fromProfile = request.getParameter("fromProfile");
            String profileUserid = request.getParameter("profileUserid");
            String fromBoard = request.getParameter("fromBoard");
            String boardId = request.getParameter("boardId");
            String fromReview = request.getParameter("fromReview");
            String originalReviewId = request.getParameter("originalReviewId");

            if (reviewIdStr != null) {
                int reviewId = Integer.parseInt(reviewIdStr);
                ReviewDAO reviewDao = new ReviewDAO();
                reviewDao.deleteReview(reviewId);
            }

            // 리다이렉트 URL 결정
            String redirectUrl = "admin-review.do";
            
            if ("true".equals(fromProfile) && profileUserid != null) {
                // 프로필에서 온 경우 프로필로 복귀
                redirectUrl = "admin-member-detail.do?userid=" + profileUserid;
                
                if ("true".equals(fromBoard) && boardId != null) {
                    redirectUrl += "&fromBoard=true&boardId=" + boardId;
                } else if ("true".equals(fromReview) && originalReviewId != null) {
                    redirectUrl += "&fromReview=true&reviewId=" + originalReviewId;
                }
            }
            
            response.sendRedirect(redirectUrl);
        }
    }
}