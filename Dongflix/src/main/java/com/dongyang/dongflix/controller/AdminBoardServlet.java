package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/admin-board.do")
public class AdminBoardServlet extends HttpServlet {

    // 게시판 목록 조회
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("/admin/admin-login.jsp");
            return;
        }

        BoardDAO dao = new BoardDAO();
        
        // 카테고리별 게시글 조회
        String category = request.getParameter("category");
        List<BoardDTO> boards;
        
        if (category != null && !category.isEmpty()) {
            boards = dao.getByCategory(category);
        } else {
            boards = dao.getAll();
        }

        request.setAttribute("boards", boards);
        request.setAttribute("currentCategory", category);
        request.getRequestDispatcher("/admin/admin-board.jsp").forward(request, response);
    }

    // 게시글 삭제
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

        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            int boardId = Integer.parseInt(request.getParameter("boardId"));
            BoardDAO dao = new BoardDAO();
            dao.delete(boardId);
        }

        // 삭제 후 목록으로 리다이렉트
        String category = request.getParameter("category");
        if (category != null && !category.isEmpty()) {
            response.sendRedirect("admin-board.do?category=" + category);
        } else {
            response.sendRedirect("admin-board.do");
        }
    }
}