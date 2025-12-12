package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.MemberDAO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/login.do")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String userid = request.getParameter("userid");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        MemberDAO dao = new MemberDAO();
        MemberDTO user = dao.login(userid, password);

        if (user != null) {

            HttpSession session = request.getSession();
            session.setAttribute("loginUser", user);
            session.setAttribute("userid", user.getUserid());

            if (redirect != null && !redirect.isEmpty()) {
                response.sendRedirect(redirect);
            } else {
                response.sendRedirect("indexMovie");
            }

        } else {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/login.jsp");

            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
        }
    }
}
