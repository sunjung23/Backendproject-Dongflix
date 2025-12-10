package com.dongyang.dongflix.controller;

import java.io.*;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/board/update")
public class BoardUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        // 로그인 체크
        if (user == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('로그인 후 이용 가능합니다.'); location.href='"
                + request.getContextPath() + "/login.jsp';</script>");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        BoardDAO dao = new BoardDAO();
        BoardDTO origin = dao.getById(id);  // 기존 게시글 조회

        // 게시글 존재 여부 체크
        if (origin == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('존재하지 않는 게시글입니다.'); location.href='"
                + request.getContextPath() + "/board/list';</script>");
            return;
        }

        // 작성자 != 로그인 사용자 → 수정 불가
        if (!origin.getUserid().equals(user.getUserid())) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('본인 글만 수정할 수 있습니다.'); location.href='"
                + request.getContextPath() + "/board/list';</script>");
            return;
        }

        // 수정 데이터 반영
        BoardDTO dto = new BoardDTO();
        dto.setBoardId(id);
        dto.setTitle(title);
        dto.setContent(content);

        dao.update(dto);

        response.sendRedirect("detail?id=" + id);
    }
}
