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

        // 로그인 사용자 확인
        MemberDTO user = (MemberDTO) request.getSession().getAttribute("loginUser");

     // 비밀게시판 전체 목록 접근 제한 
        if ("secret".equals(category)) {

            if (user == null || user.getGrade() == null ||
                !user.getGrade().equalsIgnoreCase("gold")) {

                request.setAttribute("alertType", "error");
                request.setAttribute("alertMsg", "비밀게시판은 GOLD 회원만 접근 가능합니다.");

                // 다시 일반 게시판으로 돌아가도록 category 세팅
                request.setAttribute("redirectUrl", request.getContextPath() + "/board/list?category=all");

                request.getRequestDispatcher("/common/alert.jsp")
                       .forward(request, response);
                return;
            }
        }

        

        BoardDAO dao = new BoardDAO();
        List<BoardDTO> list;

        // 정렬
        if (sort != null) {
            list = dao.getSortedList(sort);
        }
        // 전체 카테고리
        else if (category == null || category.equals("all")) {
            list = dao.getAll();
        }
        // 특정 카테고리
        else {
            list = dao.getByCategory(category);
        }

        request.setAttribute("list", list);
        request.setAttribute("category", category);
        request.setAttribute("sort", sort);

        request.getRequestDispatcher("/board/boardList.jsp")
               .forward(request, response);
    }
}
