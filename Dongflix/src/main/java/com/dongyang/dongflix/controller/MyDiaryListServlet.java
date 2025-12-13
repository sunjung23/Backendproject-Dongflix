package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.DiaryDAO;
import com.dongyang.dongflix.dto.DiaryDTO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/myDiaryList")
public class MyDiaryListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

    	HttpSession session = req.getSession();
    	MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

    	if (loginUser == null) {
    	    resp.sendRedirect(req.getContextPath() + "/login.jsp");
    	    return;
    	}

    	String userid = loginUser.getUserid();


        DiaryDAO dao = new DiaryDAO();
        List<DiaryDTO> diaryList = dao.getMyDiaryList(userid);

        req.setAttribute("diaryList", diaryList);
        req.getRequestDispatcher("/user/myDiaryList.jsp").forward(req, resp);
    }
}