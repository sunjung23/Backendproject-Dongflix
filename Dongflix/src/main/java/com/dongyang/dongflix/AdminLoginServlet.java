package com.dongyang.dongflix;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-login.do")
public class AdminLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String userid = request.getParameter("userid");
        String password = request.getParameter("password");
        
        MemberDAO dao = new MemberDAO();
        MemberDTO user = dao.login(userid, password);
        
        // 로그인 성공 && 관리자 권한 확인
        if (user != null && "admin".equals(user.getGrade())) {
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", user);
            response.sendRedirect("admin-dashboard.jsp");
        } else {
            response.sendRedirect("admin-login.jsp?error=1");
        }
    }
}