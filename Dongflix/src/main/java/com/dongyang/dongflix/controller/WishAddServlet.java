package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/wish")
public class WishAddServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        MemberDTO user = (MemberDTO) session.getAttribute("loginUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // MemberDTO → user_id 가져오기
        String userid = user.getUserid();

        int movieId = Integer.parseInt(request.getParameter("movie_id"));
        String movieTitle = request.getParameter("movie_title");
        String poster = request.getParameter("poster_path");

        try (Connection conn = DBConnection.getConnection()) {

            String sql = "INSERT INTO wish (user_id, movie_id, movie_title, poster_path) VALUES (?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, userid);
            ps.setInt(2, movieId);
            ps.setString(3, movieTitle);
            ps.setString(4, poster);

            ps.executeUpdate();
            System.out.println(">>> Wish Insert Success!!");

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("movieDetail?movieId=" + movieId);
    }
}