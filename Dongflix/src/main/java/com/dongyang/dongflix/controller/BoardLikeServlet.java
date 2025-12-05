package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.BoardLikeDAO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/board/like")
public class BoardLikeServlet extends HttpServlet {

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

        // boardId 파라미터 검증
        String boardIdStr = request.getParameter("boardId");
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

        BoardLikeDAO dao = new BoardLikeDAO();

        // 이미 좋아요 눌렀는지 확인
        boolean liked = dao.hasUserLiked(boardId, user.getUserid());

        if (liked) {
            // 이미 눌렀으면 취소
            dao.removeLike(boardId, user.getUserid());
        } else {
            // 안 눌렀으면 좋아요 추가
            dao.addLike(boardId, user.getUserid());
        }

        // 다시 게시글 상세로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/board/detail?id=" + boardId);
    }
}
