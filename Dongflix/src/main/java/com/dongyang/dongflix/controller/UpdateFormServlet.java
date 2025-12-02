package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dto.BoardDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/board/updateForm")

public class UpdateFormServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        BoardDTO dto = new BoardDAO().getById(id);

        if (dto == null) {
            response.sendRedirect("list");
            return;
        }

        request.setAttribute("dto", dto);

        request.getRequestDispatcher("/board/updateForm.jsp").forward(request, response);
    }
}
