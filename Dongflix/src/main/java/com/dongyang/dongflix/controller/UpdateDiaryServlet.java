package com.dongyang.dongflix.controller;

import java.io.IOException;
import com.dongyang.dongflix.dao.DiaryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateDiary")
public class UpdateDiaryServlet extends HttpServlet {

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
            resp.sendRedirect(req.getContextPath() + "/diaryDetail?id=" + id);
        } else {
            resp.sendRedirect(req.getContextPath() + "/editDiary?id=" + id);
        }
    }
}