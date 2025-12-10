package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dao.MemberDAO;
import com.dongyang.dongflix.dao.ProfileVisitDAO;
import com.dongyang.dongflix.dao.ReviewDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import com.dongyang.dongflix.dto.MemberDTO;
import com.dongyang.dongflix.dto.ReviewDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user/profile")
public class ProfileServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1) 쿼리 파라미터에서 userid 받기 (프로필 주인)
        String userid = request.getParameter("userid");
        if (userid == null || userid.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/indexMovie");
            return;
        }
        
        // 2) 프로필 주인 정보 조회 (🔥 getMember 사용 - movie_style 포함)
        MemberDAO mdao = new MemberDAO();
        MemberDTO owner = mdao.getMember(userid);
        
        if (owner == null) {
            response.sendRedirect(request.getContextPath() + "/indexMovie");
            return;
        }
        
        // 3) 현재 로그인한 사람(방문자) 조회
        HttpSession session = request.getSession();
        MemberDTO viewer = (MemberDTO) session.getAttribute("loginUser");
        
        // 4) 자기 자신이 아닌 경우에만 방문 기록 남기기
        if (viewer != null && !viewer.getUserid().equals(owner.getUserid())) {
            ProfileVisitDAO vdao = new ProfileVisitDAO();
            vdao.addVisit(owner.getUserid(), viewer.getUserid());
        }
        
        // 5) 그 사람의 게시글 / 리뷰 목록
        BoardDAO bdao = new BoardDAO();
        List<BoardDTO> boards = bdao.getByUser(owner.getUserid());
        
        ReviewDAO rdao = new ReviewDAO();
        List<ReviewDTO> reviews = rdao.getReviewsByUser(owner.getUserid());
        
        // 6) 프로필 방문 통계
        ProfileVisitDAO vdao = new ProfileVisitDAO();
        int visitCount = vdao.getVisitCount(owner.getUserid());
        List<MemberDTO> recentVisitors = vdao.getRecentVisitors(owner.getUserid(), 10);
        
        // 7) JSP로 전달
        request.setAttribute("owner", owner);
        request.setAttribute("boards", boards);
        request.setAttribute("reviews", reviews);
        request.setAttribute("visitCount", visitCount);
        request.setAttribute("recentVisitors", recentVisitors);
        
        request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
    }
}