package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/board/detail")
public class BoardDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        BoardDTO dto = new BoardDAO().getById(id);

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        // 🔴 비밀게시판 접근 제한
        if ("secret".equals(dto.getCategory())) {
            if (user == null || !user.getGrade().equalsIgnoreCase("gold")) {
                request.setAttribute("msg", "비밀게시판은 GOLD 등급만 열람할 수 있습니다.");
                request.getRequestDispatcher("/error/permission.jsp").forward(request, response);
                return;
            }
        }

        request.setAttribute("dto", dto);
        request.getRequestDispatcher("/board/boardDetail.jsp").forward(request, response);
    }
}
