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
            response.sendRedirect("admin-login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String boardIdStr = request.getParameter("boardId");
            String category = request.getParameter("category");
            
            // 프로필에서 온 경우 확인
            String fromProfile = request.getParameter("fromProfile");
            String profileUserid = request.getParameter("profileUserid");
            String fromBoard = request.getParameter("fromBoard");
            String originalBoardId = request.getParameter("originalBoardId");
            String fromReview = request.getParameter("fromReview");
            String reviewId = request.getParameter("reviewId");

            if (boardIdStr != null) {
                int boardId = Integer.parseInt(boardIdStr);
                BoardDAO boardDao = new BoardDAO();
                boardDao.delete(boardId);
            }

            // 리다이렉트 URL 결정
            String redirectUrl = "admin-board.do";
            
            if ("true".equals(fromProfile) && profileUserid != null) {
                // 프로필에서 온 경우 프로필로 복귀
                redirectUrl = "admin-member-detail.do?userid=" + profileUserid;
                
                if ("true".equals(fromBoard) && originalBoardId != null) {
                    redirectUrl += "&fromBoard=true&boardId=" + originalBoardId;
                } else if ("true".equals(fromReview) && reviewId != null) {
                    redirectUrl += "&fromReview=true&reviewId=" + reviewId;
                }
            } else {
                // 게시판 목록으로
                if (category != null && !category.isEmpty() && !"all".equals(category)) {
                    redirectUrl += "?category=" + category;
                }
            }
            
            response.sendRedirect(redirectUrl);
        }
    }
}