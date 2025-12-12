package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.MemberDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/checkUserid.do")
public class CheckUseridServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String userid = request.getParameter("userid");

        response.setContentType("text/plain; charset=UTF-8");

        if (userid == null || userid.trim().isEmpty()) {
            response.getWriter().write("EMPTY");
            return;
        }

        MemberDAO dao = new MemberDAO();
        boolean exists = dao.isUserIdExists(userid);

        if (exists) {
            response.getWriter().write("DUP");   // 이미 존재
        } else {
            response.getWriter().write("OK");    // 사용 가능
        }
    }
}
