package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.MemberDAO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/admin-member.do")
public class AdminMemberServlet extends HttpServlet {
    
    // 회원 목록 조회
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("/admin/admin-login.jsp");
            return;
        }
        
        MemberDAO dao = new MemberDAO();
        List<MemberDTO> members = dao.getAllMembers();
        
        request.setAttribute("members", members);
        request.getRequestDispatcher("/admin/admin-members.jsp").forward(request, response);
    }
    
    // 회원 등급 변경
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("/admin/admin-login.jsp");
            return;
        }
        
        String userid = request.getParameter("userid");
        String grade = request.getParameter("grade");
        
        MemberDAO dao = new MemberDAO();
        dao.updateGrade(userid, grade);
        
        response.sendRedirect("admin-member.do");
    }
}