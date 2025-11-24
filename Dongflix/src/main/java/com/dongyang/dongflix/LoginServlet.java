package com.dongyang.dongflix;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login.do")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String userid = request.getParameter("userid");
        String password = request.getParameter("password");

        MemberDAO dao = new MemberDAO();
        MemberDTO user = dao.login(userid, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", user);

            response.sendRedirect("loginsuccess.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}