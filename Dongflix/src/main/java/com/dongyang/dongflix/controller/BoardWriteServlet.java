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

@WebServlet("/board/write")
public class BoardWriteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");

        BoardDTO dto = new BoardDTO(user.getUserid(), title, content, category);

        int result = new BoardDAO().insert(dto);

        // ⭐ 작성 성공 → 전체 게시판 목록으로 이동
        if (result > 0) {
            response.sendRedirect(request.getContextPath() + "/board/list");
        } else {
            request.setAttribute("msg", "게시글 작성 실패");
            request.getRequestDispatcher("/board/writeForm.jsp").forward(request, response);
        }
    }
}
