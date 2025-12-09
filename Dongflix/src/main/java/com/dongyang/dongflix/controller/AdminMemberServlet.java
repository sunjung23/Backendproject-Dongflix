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
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        // 검색어 받기
        String searchKeyword = request.getParameter("search");
        
        MemberDAO memberDao = new MemberDAO();
        List<MemberDTO> members;
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            // 검색어가 있으면 검색
            members = memberDao.searchByUserid(searchKeyword.trim());
        } else {
            // 검색어가 없으면 전체 조회
            members = memberDao.getAllMembers();
        }
        
        request.setAttribute("members", members);
        request.setAttribute("searchKeyword", searchKeyword);
        
        request.getRequestDispatcher("/admin/admin-members.jsp").forward(request, response);
    }
    
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
        
        // 등급 변경 처리
        String userid = request.getParameter("userid");
        String grade = request.getParameter("grade");
        
        if (userid != null && grade != null) {
            MemberDAO memberDao = new MemberDAO();
            memberDao.updateGrade(userid, grade);
        }
        
        response.sendRedirect("admin-member.do");
    }
}