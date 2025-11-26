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

@WebServlet("/editProfile.do")
public class EditProfileServlet extends HttpServlet {

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

        String username   = request.getParameter("username");
        String nickname   = request.getParameter("nickname");
        String phone      = request.getParameter("phone");
        String birth      = request.getParameter("birth");
        String profileImg = request.getParameter("profileImg");

        MemberDAO dao = new MemberDAO();
        int result = dao.updateMemberInfo(
                user.getUserid(),
                username,
                nickname,
                phone,
                birth,
                profileImg
        );

        if (result > 0) {
            // 세션 업데이트
            user.setUsername(username);
            user.setNickname(nickname);
            user.setPhone(phone);
            user.setBirth(birth);
            user.setProfileImg(profileImg);

            session.setAttribute("loginUser", user);
            response.sendRedirect("mypage.do");
        } else {
            response.sendRedirect("editProfile.jsp");
        }
    }
}
