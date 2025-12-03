package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/admin-board-detail.do")
public class AdminBoardDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("/admin/admin-login.jsp");
            return;
        }

        // 게시글 ID 가져오기
        String boardIdStr = request.getParameter("boardId");
        if (boardIdStr == null || boardIdStr.trim().isEmpty()) {
            response.sendRedirect("admin-board.do");
            return;
        }

        int boardId = Integer.parseInt(boardIdStr);
        String category = request.getParameter("category");

        // 게시글 조회
        BoardDAO dao = new BoardDAO();
        BoardDTO board = dao.getById(boardId);

        if (board == null) {
            response.sendRedirect("admin-board.do");
            return;
        }

        request.setAttribute("board", board);
        request.setAttribute("category", category);
        request.getRequestDispatcher("/admin/admin-board-detail.jsp").forward(request, response);
    }
}