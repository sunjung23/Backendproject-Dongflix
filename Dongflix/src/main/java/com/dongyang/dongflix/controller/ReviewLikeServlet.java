package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.io.PrintWriter;

import org.json.JSONObject;

import com.dongyang.dongflix.dao.ReviewLikeDAO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/reviewLike")
public class ReviewLikeServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // 로그인 체크
        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
        
        JSONObject json = new JSONObject();
        
        if (user == null) {
            json.put("success", false);
            json.put("message", "로그인이 필요합니다.");
            out.print(json.toString());
            return;
        }
        
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            String action = request.getParameter("action"); // "like" or "unlike"
            
            ReviewLikeDAO dao = new ReviewLikeDAO();
            boolean success = false;
            
            if ("like".equals(action)) {
                success = dao.addLike(reviewId, user.getUserid());
            } else if ("unlike".equals(action)) {
                success = dao.removeLike(reviewId, user.getUserid());
            }
            
            // 추천 수 조회
            int likeCount = dao.getLikeCount(reviewId);
            
            json.put("success", success);
            json.put("likeCount", likeCount);
            
        } catch (Exception e) {
            json.put("success", false);
            json.put("message", "오류가 발생했습니다.");
            e.printStackTrace();
        }
        
        out.print(json.toString());
    }
}