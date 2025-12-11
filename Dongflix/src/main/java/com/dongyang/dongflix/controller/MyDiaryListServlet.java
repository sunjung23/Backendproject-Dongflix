package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.DiaryDAO;
import com.dongyang.dongflix.dto.DiaryDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/myDiaryList")
public class MyDiaryListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String userid = (String) session.getAttribute("userid");

        if (userid == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        DiaryDAO dao = new DiaryDAO();
        List<DiaryDTO> diaryList = dao.getMyDiaryList(userid);

        req.setAttribute("diaryList", diaryList);
        req.getRequestDispatcher("/user/myDiaryList.jsp").forward(req, resp);
    }
}