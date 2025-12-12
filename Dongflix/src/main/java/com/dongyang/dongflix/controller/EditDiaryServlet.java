package com.dongyang.dongflix.controller;

import java.io.IOException;


import com.dongyang.dongflix.dao.DiaryDAO;
import com.dongyang.dongflix.dto.DiaryDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/editDiary")
public class EditDiaryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = req.getParameter("id");

        DiaryDAO dao = new DiaryDAO();
        DiaryDTO diary = dao.getDiaryById(Integer.parseInt(id));

        if (diary == null) {
            resp.sendRedirect(req.getContextPath() + "/myDiaryList");
            return;
        }

        req.setAttribute("diary", diary);
        req.getRequestDispatcher("/user/editDiary.jsp").forward(req, resp);  // ★ 수정됨
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(req.getParameter("id"));
        String date = req.getParameter("date");
        String content = req.getParameter("content");

        DiaryDAO dao = new DiaryDAO();
        int result = dao.updateDiary(id, date, content);

        if (result > 0) {
            resp.sendRedirect(req.getContextPath() + "/myDiaryList");
        } else {
            resp.sendRedirect(req.getContextPath() + "/editDiary?id=" + id);
        }
    }
}