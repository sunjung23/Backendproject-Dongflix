package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.DiaryDAO;
import com.dongyang.dongflix.dto.DiaryDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/diaryDetail")
public class DiaryDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = req.getParameter("id");

        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/myDiaryList");
            return;
        }

        DiaryDAO dao = new DiaryDAO();
        DiaryDTO diary = dao.getDiaryById(Integer.parseInt(id));

        if (diary == null) {
            resp.sendRedirect(req.getContextPath() + "/myDiaryList");
            return;
        }

        req.setAttribute("diary", diary);
        req.getRequestDispatcher("/user/diaryDetail.jsp").forward(req, resp);
    }
}