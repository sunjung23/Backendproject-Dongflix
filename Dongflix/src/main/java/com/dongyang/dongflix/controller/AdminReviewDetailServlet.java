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

@WebServlet("/admin/admin-review-detail.do")
public class AdminReviewDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("/admin/admin-login.jsp");
            return;
        }

        // 리뷰 ID 가져오기
        String reviewIdStr = request.getParameter("reviewId");
        if (reviewIdStr == null || reviewIdStr.trim().isEmpty()) {
            response.sendRedirect("admin-review.do");
            return;
        }

        int reviewId = Integer.parseInt(reviewIdStr);

        // 리뷰 조회
        ReviewDAO dao = new ReviewDAO();
        ReviewDTO review = dao.getReviewById(reviewId);

        if (review == null) {
            response.sendRedirect("admin-review.do");
            return;
        }

        request.setAttribute("review", review);
        request.getRequestDispatcher("/admin/admin-review-detail.jsp").forward(request, response);
    }
}