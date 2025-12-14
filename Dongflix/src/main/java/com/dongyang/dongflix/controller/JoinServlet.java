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

@WebServlet("/join.do")
public class JoinServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 폼 파라미터
        String userid   = request.getParameter("userid");
        String password = request.getParameter("password");
        String username = request.getParameter("username");
        String genres   = request.getParameter("genres"); // "액션,로맨스,코미디" or "" or null

        // null 방지 & trim
        userid   = (userid   == null) ? "" : userid.trim();
        password = (password == null) ? "" : password.trim();
        username = (username == null) ? "" : username.trim();
        genres   = (genres   == null) ? "" : genres.trim();

        // 유효성 검사
        if (userid.isEmpty() || password.isEmpty() || username.isEmpty()) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "아이디, 비밀번호, 이름을 모두 입력해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/join.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "비밀번호는 6자 이상으로 설정해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/join.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        MemberDAO dao = new MemberDAO();

        // 아이디 중복 체크
        if (dao.isUserIdExists(userid)) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "이미 사용 중인 아이디입니다. 다른 아이디를 사용해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/join.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // DTO 구성 
        MemberDTO dto = new MemberDTO(userid, password, username);
        dto.setGenres(genres);     

        int result = dao.join(dto);


        // 결과 처리
        if (result == 1) {
            HttpSession session = request.getSession();

            session.setAttribute("signupGenres", genres);

            //DB에서 다시 조회
            MemberDTO loginUser = dao.login(userid, password);
            session.setAttribute("loginUser", loginUser);

            response.sendRedirect(request.getContextPath() + "/intro.jsp");
            return;
        }
        	else {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "회원가입 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/join.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
        }
    }
}
