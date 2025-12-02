package com.dongyang.dongflix.controller;

import java.io.*;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/board/update")
public class BoardUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        BoardDTO dto = new BoardDTO();
        dto.setBoardId(id);
        dto.setTitle(title);
        dto.setContent(content);

        new BoardDAO().update(dto);

        response.sendRedirect("detail?id=" + id);
    }
}
