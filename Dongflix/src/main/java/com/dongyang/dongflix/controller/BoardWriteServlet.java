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

@WebServlet("/board/write")
public class BoardWriteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        // 로그인 체크
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");

        // ⭐ 비밀 게시판 작성 권한 체크 (GOLD만 작성 가능)
        if ("secret".equals(category)) {
            if (user.getGrade() == null || 
                !user.getGrade().equalsIgnoreCase("gold")) {

                // 경고창 띄우고 전체 게시판으로 이동
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().write(
                    "<script>alert('비밀 게시판 글 작성은 GOLD 회원만 가능합니다.');"
                    + "location.href='" + request.getContextPath() + "/board/list';"
                    + "</script>"
                );
                return;
            }
        }

        BoardDTO dto = new BoardDTO(user.getUserid(), title, content, category);

        int result = new BoardDAO().insert(dto);

        // 작성 성공 → 전체 게시판 이동
        if (result > 0) {
            response.sendRedirect(request.getContextPath() + "/board/list");
        } else {
        	request.setAttribute("alertType", "error");
        	request.setAttribute("alertMsg", "게시글 등록 중 오류가 발생했습니다.");
        	request.getRequestDispatcher("/board/writeForm.jsp").forward(request, response);
        }
    }
}
