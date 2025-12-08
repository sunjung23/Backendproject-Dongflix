package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.BoardCommentDAO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/board/comment/delete")
public class BoardCommentDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        // 로그인 체크
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String commentIdStr = request.getParameter("commentId");
        String boardIdStr = request.getParameter("boardId");

        if (commentIdStr == null || boardIdStr == null ||
            commentIdStr.trim().isEmpty() || boardIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/board/list");
            return;
        }

        int commentId;
        int boardId;

        try {
            commentId = Integer.parseInt(commentIdStr);
            boardId = Integer.parseInt(boardIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/board/list");
            return;
        }

        BoardCommentDAO dao = new BoardCommentDAO();
        // 본인 글만 삭제되도록 userid 조건 사용
        dao.delete(commentId, user.getUserid());

        response.sendRedirect(request.getContextPath() + "/board/detail?id=" + boardId);
    }
}
