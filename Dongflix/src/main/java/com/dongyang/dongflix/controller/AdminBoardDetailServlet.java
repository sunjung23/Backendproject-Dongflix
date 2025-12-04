package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dao.MemberDAO;
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
        BoardDAO boardDao = new BoardDAO();
        BoardDTO board = boardDao.getById(boardId);

        if (board == null) {
            response.sendRedirect("admin-board.do");
            return;
        }

        // 작성자 정보 조회
        MemberDAO memberDao = new MemberDAO();
        MemberDTO author = memberDao.getMember(board.getUserid());

        request.setAttribute("board", board);
        request.setAttribute("category", category);
        request.setAttribute("author", author);
        request.getRequestDispatcher("/admin/admin-board-detail.jsp").forward(request, response);
    }

    // 등급 변경 처리
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

        if ("changeGrade".equals(action)) {
            String userid = request.getParameter("userid");
            String newGrade = request.getParameter("grade");
            String boardId = request.getParameter("boardId");
            String category = request.getParameter("category");

            // 등급 변경
            MemberDAO memberDao = new MemberDAO();
            memberDao.updateGrade(userid, newGrade);

            // 같은 페이지로 리다이렉트 (등급 변경 완료 메시지 포함)
            String redirectUrl = "admin-board-detail.do?boardId=" + boardId;
            if (category != null && !category.isEmpty()) {
                redirectUrl += "&category=" + category;
            }
            redirectUrl += "&success=1";
            
            response.sendRedirect(redirectUrl);
        }
    }
}