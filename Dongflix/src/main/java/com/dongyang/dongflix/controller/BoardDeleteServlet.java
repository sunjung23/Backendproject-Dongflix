package com.dongyang.dongflix.controller;

import java.io.*;
import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/board/delete")
public class BoardDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        BoardDAO dao = new BoardDAO();
        BoardDTO dto = dao.getById(id); // 게시글 조회

        // 게시글이 없을 때
        if (dto == null) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('존재하지 않는 게시글입니다.'); location.href='"
                + request.getContextPath() + "/board/list';</script>");
            return;
        }

        // 본인 글이 아니면 삭제 불가
        if (!dto.getUserid().equals(user.getUserid())) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println(
                "<script>alert('본인 글만 삭제할 수 있습니다.'); location.href='"
                + request.getContextPath() + "/board/list';</script>");
            return;
        }

        dao.delete(id);

        response.sendRedirect("list");
    }
}
