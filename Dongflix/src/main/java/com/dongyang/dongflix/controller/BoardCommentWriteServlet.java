package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.BoardCommentDAO;
import com.dongyang.dongflix.dto.BoardCommentDTO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/board/comment/write")
public class BoardCommentWriteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        // 로그인 체크
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String boardIdStr = request.getParameter("boardId");
        String content = request.getParameter("content");

        if (boardIdStr == null || boardIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/board/list");
            return;
        }

        int boardId;
        try {
            boardId = Integer.parseInt(boardIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/board/list");
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            // 내용이 비어 있으면 그냥 상세로 돌려보내기
            response.sendRedirect(request.getContextPath() + "/board/detail?id=" + boardId);
            return;
        }

        BoardCommentDTO dto = new BoardCommentDTO();
        dto.setBoardId(boardId);
        dto.setUserid(user.getUserid());
        dto.setContent(content.trim());

        BoardCommentDAO dao = new BoardCommentDAO();
        dao.insert(dto);

        response.sendRedirect(request.getContextPath() + "/board/detail?id=" + boardId);
    }
}
