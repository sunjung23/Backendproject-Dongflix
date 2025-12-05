package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dao.BoardLikeDAO;
import com.dongyang.dongflix.dto.BoardDTO;
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

        // 2) 게시글 조회 + 조회수 증가 처리
        BoardDAO dao = new BoardDAO();

        // 🔥 조회수 증가
        dao.increaseViews(id);

        // 🔥 조회수 반영된 최신 데이터 다시 가져오기
        BoardDTO dto = dao.getById(id);

        // 3) 게시글 존재 여부 확인
        if (dto == null) {
            response.sendRedirect(request.getContextPath() + "/board/list");
            return;
        }

        // 4) 로그인 사용자 조회
        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        // 5) 비밀게시판 권한 제한
        if ("secret".equals(dto.getCategory())) {
            // user == null 이거나 grade 가 null 이거나 gold 가 아니면 차단
            if (user == null || user.getGrade() == null
                    || !user.getGrade().equalsIgnoreCase("gold")) {

                request.setAttribute("msg", "비밀게시판은 GOLD 등급만 열람할 수 있습니다.");
                request.getRequestDispatcher("/error/permission.jsp")
                       .forward(request, response);
                return;
            }
        }

        // 6) 좋아요 정보 세팅
        BoardLikeDAO likeDao = new BoardLikeDAO();
        int likeCount = likeDao.getLikeCount(id);

        boolean likedByMe = false;
        if (user != null) {
            likedByMe = likeDao.hasUserLiked(id, user.getUserid());
        }

        // 7) 데이터 전달 후 상세 페이지로 이동
        request.setAttribute("dto", dto);
        request.setAttribute("likeCount", likeCount);
        request.setAttribute("likedByMe", likedByMe);

        request.getRequestDispatcher("/board/boardDetail.jsp")
               .forward(request, response);
    }
}
