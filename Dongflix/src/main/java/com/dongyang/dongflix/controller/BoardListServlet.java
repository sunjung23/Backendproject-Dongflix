package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.util.List;

import com.dongyang.dongflix.dao.BoardDAO;
import com.dongyang.dongflix.dto.BoardDTO;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/board/list")
public class BoardListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        String sort = request.getParameter("sort");

        // ★ 로그인 사용자 확인
        MemberDTO user = (MemberDTO) request.getSession().getAttribute("loginUser");

        // ★ 비밀게시판 접근 제한 — GOLD만
        if ("secret".equals(category)) {
            if (user == null || !"gold".equalsIgnoreCase(user.getGrade())) {

                // ★ alert + redirect 방식
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println(
                    "<script>alert('비밀 게시판은 GOLD 회원만 접근 가능합니다.');" +
                    "location.href='" + request.getContextPath() + "/board/list?category=all';</script>"
                );
                return; // ★ 반드시 return
            }
        }

        BoardDAO dao = new BoardDAO();
        List<BoardDTO> list;

        // 정렬 우선
        if (sort != null) {
            list = dao.getSortedList(sort);
        }
        else if (category == null || category.equals("all")) {
            list = dao.getAll();
        } else {
            list = dao.getByCategory(category);
        }

        request.setAttribute("list", list);
        request.setAttribute("category", category);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("/board/boardList.jsp")
               .forward(request, response);
    }
}
