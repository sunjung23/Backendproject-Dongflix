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

@WebServlet("/board/delete")
public class BoardDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 로그인 확인
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
        if (user == null) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "로그인 후 이용 가능합니다.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/login.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // 게시글 ID 확인
        String idParam = request.getParameter("id");
        if (idParam == null) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "잘못된 접근입니다.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/board/list");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        int boardId = Integer.parseInt(idParam);

        BoardDAO dao = new BoardDAO();
        BoardDTO board = dao.getById(boardId);  // ★ getDetail → getById 로 수정

        // 게시글 없음
        if (board == null) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "존재하지 않는 게시글입니다.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/board/list");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // 작성자 체크 (writer → userid)
        if (!board.getUserid().equals(user.getUserid())) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "본인이 작성한 글만 삭제할 수 있습니다.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/board/list");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // 삭제 실행
        int result = dao.delete(boardId);

        if (result > 0) {
            request.setAttribute("alertType", "success");
            request.setAttribute("alertMsg", "게시글이 삭제되었습니다.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/board/list");
        } else {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "게시글 삭제 중 오류가 발생했습니다.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/board/list");
        }

        request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
    }
}
