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
        String genres   = request.getParameter("genres");   // "액션,로맨스,코미디" 이런 식으로 넘어옴 (선택 안 하면 null 또는 "")

        // null 방지 & trim
        userid   = (userid   == null) ? "" : userid.trim();
        password = (password == null) ? "" : password.trim();
        username = (username == null) ? "" : username.trim();
        genres   = (genres   == null) ? "" : genres.trim();

        // ===== 1) 기본 서버측 유효성 검사 =====
        if (userid.isEmpty() || password.isEmpty() || username.isEmpty()) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "아이디, 비밀번호, 이름을 모두 입력해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/join.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // (선택) 비밀번호 아주 기초적인 길이 검사 정도만 — UI에서 강도 안내는 이미 하고 있음
        if (password.length() < 6) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "비밀번호는 6자 이상으로 설정해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/join.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        MemberDAO dao = new MemberDAO();

        // ===== 2) 아이디 중복 체크 (서버 측에서도 한 번 더) =====
        if (dao.isUserIdExists(userid)) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "이미 사용 중인 아이디입니다. 다른 아이디를 사용해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/join.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // ===== 3) 회원 정보 DTO 구성 (지금은 userid/password/username만) =====
        MemberDTO dto = new MemberDTO(userid, password, username);

        // (⭐ 앞으로 6/7, 7/7에서 MemberDTO/DAO 수정하면 여기서 genres도 같이 DTO에 넣거나 별도 테이블에 Insert하면 됨)
        // 예를 들어 나중에는:
        // dto.setPreferredGenres(genres);
        // 같은 식으로 확장할 수 있음.

        int result = dao.join(dto);

        // ===== 4) 결과 처리 =====
        if (result == 1) {
            
            HttpSession session = request.getSession();
            session.setAttribute("signupGenres", genres);

            // 회원가입 성공 → 고급 alert.jsp 팝업 후 로그인 페이지로 이동
            request.setAttribute("alertType", "success");
            request.setAttribute("alertMsg", "회원가입이 완료되었습니다. 로그인 후 이용해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/login.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);

        } else {
            // DB 오류 등
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "회원가입 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            request.setAttribute("redirectUrl", request.getContextPath() + "/join.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
        }
    }
}
