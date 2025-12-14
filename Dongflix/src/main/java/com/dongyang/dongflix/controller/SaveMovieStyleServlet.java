package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.MemberDAO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/saveMovieStyle")
public class SaveMovieStyleServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 로그인 체크
        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // 취향 타입 받기
        String movieStyle = request.getParameter("movieStyle");
        
        if (movieStyle != null && !movieStyle.trim().isEmpty()) {
            // DB에 저장
            MemberDAO dao = new MemberDAO();
            int result = dao.updateMovieStyle(user.getUserid(), movieStyle);
            
            if (result > 0) {
                // 세션 업데이트
                user.setMovieStyle(movieStyle);
                session.setAttribute("loginUser", user);
                
                // 마이페이지로 리다이렉트
                response.sendRedirect("mypage.do");
            } else {
                response.sendRedirect("user/movieTest.jsp?error=1");
            }
        } else {
            response.sendRedirect("user/movieTest.jsp");
        }
    }
}