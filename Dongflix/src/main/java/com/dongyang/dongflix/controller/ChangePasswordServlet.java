package com.dongyang.dongflix.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.dongyang.dongflix.dao.MemberDAO;
import com.dongyang.dongflix.dto.MemberDTO;

@WebServlet("/changePassword.do")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String currentPw = request.getParameter("currentPw");
        String newPw = request.getParameter("newPw");
        String newPw2 = request.getParameter("newPw2");

        // 새 비밀번호 2개 불일치
        if (!newPw.equals(newPw2)) {
            response.sendRedirect("changePassword.jsp?error=nomatch");
            return;
        }

        MemberDAO dao = new MemberDAO();

        // 현재 비밀번호 확인
        if (!dao.checkPassword(user.getUserid(), currentPw)) {
            response.sendRedirect("changePassword.jsp?error=wrongpw");
            return;
        }

        // 비밀번호 업데이트
        int result = dao.updatePassword(user.getUserid(), newPw);

        if (result == 1) {
            // 세션에도 반영
            user.setPassword(newPw);
            session.setAttribute("loginUser", user);

            response.sendRedirect("mypage.do?pw=success");
        } else {
            response.sendRedirect("changePassword.jsp?error=db");
        }
    }
}
