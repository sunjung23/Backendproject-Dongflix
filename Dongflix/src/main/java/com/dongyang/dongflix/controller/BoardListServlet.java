package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dto.BoardDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/board/list")
public class BoardListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        String sort = request.getParameter("sort");

        BoardDAO dao = new BoardDAO();
        List<BoardDTO> list;

        // 정렬 존재 시 → 정렬 우선
        if (sort != null) {
            list = dao.getSortedList(sort);
        }
        else if (category == null || category.equals("all")) {
            list = dao.getAll();
        } else {
            list = dao.getByCategory(category);
        }

        request.setAttribute("list", list);
        request.setAttribute("category", category);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("/board/boardList.jsp")
               .forward(request, response);
    }
}
