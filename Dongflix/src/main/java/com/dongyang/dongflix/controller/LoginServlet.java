package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.MemberDAO;
import com.dongyang.dongflix.dto.MemberDTO;

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
            
            session.setAttribute("userid", user.getUserid());

            response.sendRedirect("indexMovie");
        } else {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>");
            response.getWriter().println("alert('아이디 또는 비밀번호가 올바르지 않습니다.');");
            response.getWriter().println("history.back();");
            response.getWriter().println("</script>");
        }
    }
}