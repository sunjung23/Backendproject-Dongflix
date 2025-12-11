package com.dongyang.dongflix.controller;

import java.io.IOException;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/board/update")
public class BoardUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");
        String contextPath = request.getContextPath();

        // 1) 로그인 체크
        if (user == null) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "로그인 후 이용 가능합니다.");
            request.setAttribute("redirectUrl", contextPath + "/login.jsp");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // 2) 게시글 ID 파라미터 체크
        String idParam = request.getParameter("id");
        if (idParam == null) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "잘못된 요청입니다.");
            request.setAttribute("redirectUrl", contextPath + "/board/list");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        int id = Integer.parseInt(idParam);
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        BoardDAO dao = new BoardDAO();
        BoardDTO origin = dao.getById(id);  // 기존 게시글 조회

        // 3) 게시글 존재 여부 체크
        if (origin == null) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "존재하지 않는 게시글입니다.");
            request.setAttribute("redirectUrl", contextPath + "/board/list");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // 4) 작성자 != 로그인 사용자 → 수정 불가
        if (!origin.getUserid().equals(user.getUserid())) {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "본인이 작성한 글만 수정할 수 있습니다.");
            request.setAttribute("redirectUrl", contextPath + "/board/list");
            request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
            return;
        }

        // 5) 수정 데이터 반영
        BoardDTO dto = new BoardDTO();
        dto.setBoardId(id);
        dto.setTitle(title);
        dto.setContent(content);

        int result = dao.update(dto);

        // 6) 결과에 따라 팝업
        if (result > 0) {
            request.setAttribute("alertType", "success");
            request.setAttribute("alertMsg", "게시글이 수정되었습니다.");
            request.setAttribute("redirectUrl", contextPath + "/board/detail?id=" + id);
        } else {
            request.setAttribute("alertType", "error");
            request.setAttribute("alertMsg", "게시글 수정 중 오류가 발생했습니다.");
            request.setAttribute("redirectUrl", contextPath + "/board/list");
        }

        request.getRequestDispatcher("/common/alert.jsp").forward(request, response);
    }
}
