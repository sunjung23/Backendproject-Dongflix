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

        // 1) 새 비밀번호 일치 여부
        if (!newPw.equals(newPw2)) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "새 비밀번호가 서로 일치하지 않습니다.");
            request.getRequestDispatcher("/user/changePassword.jsp").forward(request, response);
            return;
        }

        MemberDAO dao = new MemberDAO();

        // 2) 현재 비밀번호 검증
        if (!dao.checkPassword(user.getUserid(), currentPw)) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "현재 비밀번호가 올바르지 않습니다.");
            request.getRequestDispatcher("/user/changePassword.jsp").forward(request, response);
            return;
        }

        // 3) 비밀번호 업데이트
        int result = dao.updatePassword(user.getUserid(), newPw);

        if (result == 1) {
            // 세션 비밀번호도 갱신
            user.setPassword(newPw);
            session.setAttribute("loginUser", user);

            request.setAttribute("alertType", "success");
            request.setAttribute("alertMsg", "비밀번호가 성공적으로 변경되었습니다!");

            request.getRequestDispatcher("/user/changePassword.jsp").forward(request, response);
        } else {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "비밀번호 변경에 실패했습니다. 다시 시도해주세요.");
            request.getRequestDispatcher("/user/changePassword.jsp").forward(request, response);
        }
    }
}
