package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.BoardCommentDAO;
import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dao.MemberDAO;
import com.dongyang.dongflix.dto.BoardCommentDTO;
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
        
        System.out.println("========== AdminBoardDetailServlet doGet 시작 ==========");
        
        // 관리자 권한 체크
        HttpSession session = request.getSession();
        MemberDTO adminUser = (MemberDTO) session.getAttribute("adminUser");
        if (adminUser == null || !"admin".equals(adminUser.getGrade())) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        // 게시글 ID 가져오기
        String boardIdStr = request.getParameter("boardId");
        System.out.println(">>> boardId 파라미터: " + boardIdStr);
        
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
            System.out.println(">>> 게시글 없음!");
            response.sendRedirect("admin-board.do");
            return;
        }
        
        System.out.println(">>> 게시글 조회 성공: " + board.getTitle());
        
        // 작성자 정보 조회
        MemberDAO memberDao = new MemberDAO();
        MemberDTO author = memberDao.getMember(board.getUserid());
        
        // 댓글 목록 조회 (작성자 정보 포함)
        BoardCommentDAO commentDao = new BoardCommentDAO();
        List<BoardCommentDTO> comments = commentDao.getByBoardWithMember(boardId);
        int commentCount = commentDao.getCommentCount(boardId);
        
        System.out.println(">>> 댓글 개수: " + commentCount);
        System.out.println(">>> 댓글 리스트: " + (comments != null ? comments.size() + "개" : "null"));
        
        if (comments != null) {
            for (BoardCommentDTO c : comments) {
                System.out.println("  - 댓글 ID: " + c.getCommentId() + ", 내용: " + c.getContent());
            }
        }
        
        request.setAttribute("board", board);
        request.setAttribute("category", category);
        request.setAttribute("author", author);
        request.setAttribute("comments", comments);
        request.setAttribute("commentCount", commentCount);
        
        System.out.println("========== JSP로 forward ==========");
        
        request.getRequestDispatcher("/admin/admin-board-detail.jsp").forward(request, response);
    }
    
    // 등급 변경 및 댓글 삭제 처리
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
        
        if ("changeGrade".equals(action)) {
            // 등급 변경
            String userid = request.getParameter("userid");
            String newGrade = request.getParameter("grade");
            String boardId = request.getParameter("boardId");
            String category = request.getParameter("category");
            
            MemberDAO memberDao = new MemberDAO();
            memberDao.updateGrade(userid, newGrade);
            
            String redirectUrl = "admin-board-detail.do?boardId=" + boardId;
            if (category != null && !category.isEmpty()) {
                redirectUrl += "&category=" + category;
            }
            redirectUrl += "&success=1";
            
            response.sendRedirect(redirectUrl);
            
        } else if ("deleteComment".equals(action)) {
            // 댓글 삭제
            String commentIdStr = request.getParameter("commentId");
            String boardIdStr = request.getParameter("boardId");
            String category = request.getParameter("category");
            
            if (commentIdStr != null && boardIdStr != null) {
                int commentId = Integer.parseInt(commentIdStr);
                
                BoardCommentDAO commentDao = new BoardCommentDAO();
                commentDao.deleteByAdmin(commentId);
            }
            
            // 같은 페이지로 리다이렉트
            String redirectUrl = "admin-board-detail.do?boardId=" + boardIdStr;
            if (category != null && !category.isEmpty()) {
                redirectUrl += "&category=" + category;
            }
            redirectUrl += "&commentDeleted=1";
            
            response.sendRedirect(redirectUrl);
        }
    }
}