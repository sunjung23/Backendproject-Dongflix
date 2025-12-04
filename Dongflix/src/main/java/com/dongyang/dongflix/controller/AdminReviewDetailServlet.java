package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.MemberDAO;
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
            response.sendRedirect("admin-login.jsp");
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
        ReviewDAO reviewDao = new ReviewDAO();
        ReviewDTO review = reviewDao.getReviewById(reviewId);  // 메서드 이름 수정

        if (review == null) {
            response.sendRedirect("admin-review.do");
            return;
        }

        // 작성자 정보 조회
        MemberDAO memberDao = new MemberDAO();
        MemberDTO author = memberDao.getMember(review.getUserid());

        request.setAttribute("review", review);
        request.setAttribute("author", author);
        request.getRequestDispatcher("/admin/admin-review-detail.jsp").forward(request, response);
    }
}