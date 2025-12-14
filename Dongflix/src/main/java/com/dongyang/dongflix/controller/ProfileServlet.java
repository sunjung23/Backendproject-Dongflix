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
        
        // 쿼리 파라미터에서 userid 받기 (프로필 주인)
        String userid = request.getParameter("userid");
        if (userid == null || userid.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/indexMovie");
            return;
        }
        
        // 프로필 주인 정보 조회 
        MemberDAO mdao = new MemberDAO();
        MemberDTO owner = mdao.getMember(userid);
        
        if (owner == null) {
            response.sendRedirect(request.getContextPath() + "/indexMovie");
            return;
        }
        
        // 현재 로그인한 사람(방문자) 조회
        HttpSession session = request.getSession();
        MemberDTO viewer = (MemberDTO) session.getAttribute("loginUser");
        
        // 자기 자신이 아닌 경우에만 방문 기록 남기기
        if (viewer != null && !viewer.getUserid().equals(owner.getUserid())) {
            ProfileVisitDAO vdao = new ProfileVisitDAO();
            vdao.addVisit(owner.getUserid(), viewer.getUserid());
        }
        
        // 그 사람의 게시글 / 리뷰 목록
        BoardDAO bdao = new BoardDAO();
        List<BoardDTO> boards = bdao.getByUser(owner.getUserid());
        
        ReviewDAO rdao = new ReviewDAO();
        List<ReviewDTO> reviews = rdao.getReviewsByUser(owner.getUserid());
        
        // 프로필 방문 통계
        ProfileVisitDAO vdao = new ProfileVisitDAO();
        int visitCount = vdao.getVisitCount(owner.getUserid());
        List<MemberDTO> recentVisitors = vdao.getRecentVisitors(owner.getUserid(), 10);
        
        // JSP로 전달
        request.setAttribute("owner", owner);
        request.setAttribute("boards", boards);
        request.setAttribute("reviews", reviews);
        request.setAttribute("visitCount", visitCount);
        request.setAttribute("recentVisitors", recentVisitors);
        
     // ===== 평균 평점 계산 =====
        double avgRating = 0.0;
        int reviewCount = (reviews != null) ? reviews.size() : 0;

        if (reviewCount > 0) {
            double sum = 0.0;
            for (ReviewDTO r : reviews) {
                sum += r.getRating();
            }
            avgRating = sum / reviewCount;
        }

        // ===== 성향 분석 =====
        String ratingType = "";
        String ratingClass = "";

        if (reviewCount == 0) {
            ratingType = "📝 아직 평가 중";
            ratingClass = "rating-wait";
        } else if (avgRating < 2.0) {
            ratingType = "🧊 혹독한 비평가형";
            ratingClass = "rating-cold";
        } else if (avgRating < 3.0) {
            ratingType = "🧐 현실적인 비평가형";
            ratingClass = "rating-real";
        } else if (avgRating < 3.7) {
            ratingType = "🎯 균형 잡힌 관객형";
            ratingClass = "rating-balance";
        } else if (avgRating < 4.4) {
            ratingType = "😊 호의적인 감상자형";
            ratingClass = "rating-warm";
        } else {
            ratingType = "🌈 뭐든 재밌는 낙관자형";
            ratingClass = "rating-happy";
        }

        // JSP 전달
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("reviewCount", reviewCount);
        request.setAttribute("ratingType", ratingType);
        request.setAttribute("ratingClass", ratingClass);

        // 기존 것들
        request.setAttribute("owner", owner);
        request.setAttribute("boards", boards);
        request.setAttribute("reviews", reviews);
        request.setAttribute("visitCount", visitCount);
        request.setAttribute("recentVisitors", recentVisitors);

        request.getRequestDispatcher("/user/profile.jsp").forward(request, response);

    }
}
