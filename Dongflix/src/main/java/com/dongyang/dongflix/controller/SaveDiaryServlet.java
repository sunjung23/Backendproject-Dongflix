package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.DiaryDAO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/saveDiary")
public class SaveDiaryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
    	MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

    	if (loginUser == null) {
    	    resp.sendRedirect(req.getContextPath() + "/login.jsp");
    	    return;
    	}

    	String userid = loginUser.getUserid();


        int movieId = Integer.parseInt(req.getParameter("movieId"));
        String movieTitle = req.getParameter("movieTitle");
        String date = req.getParameter("date");
        String content = req.getParameter("content");
        String posterPath = req.getParameter("posterPath");

        DiaryDAO dao = new DiaryDAO();
        int result = dao.saveDiary(userid, movieId, movieTitle, date, content, posterPath);

        if (result > 0) {
            resp.sendRedirect(req.getContextPath() + "/myDiaryList");
        } else {
            resp.sendRedirect(req.getContextPath() + "/writeDiary?movieId=" + movieId);
        }
    }
}