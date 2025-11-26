package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.MemberDAO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/join.do")
public class JoinServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String userid = request.getParameter("userid");
        String password = request.getParameter("password");
        String username = request.getParameter("username");

        MemberDTO dto = new MemberDTO(userid, password, username);
        MemberDAO dao = new MemberDAO();

        int result = dao.join(dto);

        if (result == 1) {
            response.sendRedirect("login.jsp");
        } else {
            response.sendRedirect("join.jsp");
        }
    }
}