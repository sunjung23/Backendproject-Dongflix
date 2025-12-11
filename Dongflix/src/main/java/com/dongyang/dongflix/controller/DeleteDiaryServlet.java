package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.DiaryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/deleteDiary")
public class DeleteDiaryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = req.getParameter("id");

        DiaryDAO dao = new DiaryDAO();
        dao.deleteDiary(Integer.parseInt(id));

        resp.sendRedirect("myDiaryList");
    }
}
