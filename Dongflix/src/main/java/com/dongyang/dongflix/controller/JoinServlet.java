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

        // 1) 폼 파라미터
        String userid   = request.getParameter("userid");
        String password = request.getParameter("password");
        String username = request.getParameter("username");
        String genres   = request.getParameter("genres"); // "액션,로맨스,코미디" or "" or null

        // null 방지 & trim
        userid   = (userid   == null) ? "" : userid.trim();
        password = (password == null) ? "" : password.trim();
        username = (username == null) ? "" : username.trim();
        genres   = (genres   == null) ? "" : genres.trim();

        // 2) 서버측 유효성 검사
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

        // 3) 아이디 중복 체크
        if (dao.isUserIdExists(userid)) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "이미 사용 중인 아이디입니다. 다른 아이디를 사용해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/join.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // 4) DTO 구성 (+ movie_style 저장용)
        MemberDTO dto = new MemberDTO(userid, password, username);
        dto.setMovieStyle(genres); // ✅ movie_style 컬럼에 저장될 값

        int result = dao.join(dto);

        // 5) 결과 처리
        if (result == 1) {
            HttpSession session = request.getSession();

            // ✅ 회원가입 때 선택한 장르 기록 (intro / recommend에서 사용 가능)
            session.setAttribute("signupGenres", genres);

            // ✅ (선택) 자동 로그인: recommend에서 로그인 검사 통과시키려면 필요
            // recommend 서블릿이 "로그인 필수"면 이 줄이 사실상 필수다.
            session.setAttribute("loginUser", dto);

            // ✅ intro로 이동 → intro가 /recommend로 자동 이동
            response.sendRedirect(request.getContextPath() + "/intro.jsp");
            return;

        } else {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "회원가입 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/join.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
        }
    }
}
