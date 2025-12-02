package com.dongyang.dongflix.controller;

import java.io.*;
import com.dongyang.dongflix.dao.BoardDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/board/delete")
public class BoardDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        new BoardDAO().delete(id);

        response.sendRedirect("list");
    }
}
