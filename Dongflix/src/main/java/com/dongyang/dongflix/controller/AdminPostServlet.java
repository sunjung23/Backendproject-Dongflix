package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-post.do")
public class AdminPostServlet extends HttpServlet {
    
    // 게시글/댓글 목록 조회 (틀만)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        // TODO: 나중에 PostDAO에서 게시글/댓글 목록 가져오기
        // List<PostDTO> posts = postDAO.getAllPosts();
        // request.setAttribute("posts", posts);
        
        request.getRequestDispatcher("admin-posts.jsp").forward(request, response);
    }
    
    // 게시글/댓글 숨김 처리 (틀만)
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
        
        String postId = request.getParameter("postId");
        String action = request.getParameter("action"); // hide, show 등
        
        // TODO: 나중에 PostDAO에서 게시글 숨김 처리
        // postDAO.updateStatus(postId, action);
        
        response.sendRedirect("admin-post.do");
    }
}