package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dao.BoardLikeDAO;
import com.dongyang.dongflix.dao.BoardCommentDAO;
import com.dongyang.dongflix.dao.MemberDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import com.dongyang.dongflix.dto.BoardCommentDTO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/board/detail")
public class BoardDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) id 파라미터 검증
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/board/list");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/board/list");
            return;
        }

        BoardDAO dao = new BoardDAO();

        // 2) 조회수 증가
        dao.increaseViews(id);

        // 3) 게시글 조회
        BoardDTO dto = dao.getById(id);
        if (dto == null) {
            response.sendRedirect(request.getContextPath() + "/board/list");
            return;
        }

        // 4) 로그인 사용자 조회
        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        // 5) 비밀게시판 권한 제한
        if ("secret".equals(dto.getCategory())) {
            if (user == null || user.getGrade() == null
                    || !user.getGrade().equalsIgnoreCase("gold")) {

                request.setAttribute("msg", "비밀게시판은 GOLD 등급만 열람할 수 있습니다.");
                request.getRequestDispatcher("/error/permission.jsp")
                        .forward(request, response);
                return;
            }
        }

        // 6) 좋아요 정보
        BoardLikeDAO likeDao = new BoardLikeDAO();
        int likeCount = likeDao.getLikeCount(id);

        boolean likedByMe = false;
        if (user != null) {
            likedByMe = likeDao.hasUserLiked(id, user.getUserid());
        }

        // 7) 댓글 목록
        BoardCommentDAO cdao = new BoardCommentDAO();
        List<BoardCommentDTO> comments = cdao.getByBoard(id);

        // 댓글 작성자 profileImg, nickname 포함 MemberDTO 주입
        MemberDAO mdao = new MemberDAO();
        if (comments != null) {
            for (BoardCommentDTO c : comments) {
                MemberDTO writer = mdao.getByUserid(c.getUserid());
                c.setMember(writer);  
            }
        }

        int commentCount = (comments != null) ? comments.size() : 0;

        // 8) request에 세팅
        request.setAttribute("dto", dto);
        request.setAttribute("likeCount", likeCount);
        request.setAttribute("likedByMe", likedByMe);
        request.setAttribute("comments", comments);
        request.setAttribute("commentCount", commentCount);

        // 9) 상세 페이지로 이동
        request.getRequestDispatcher("/board/boardDetail.jsp")
                .forward(request, response);
    }
}
