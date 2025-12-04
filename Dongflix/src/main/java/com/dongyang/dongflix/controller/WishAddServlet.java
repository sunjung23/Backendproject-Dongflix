package com.dongyang.dongflix.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dao.LikeMovieDAO;
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

        String userId = user.getUserid();

        int movieId = Integer.parseInt(request.getParameter("movie_id"));
        String movieTitle = request.getParameter("movie_title");
        String poster = request.getParameter("poster_path");

        try (Connection conn = DBConnection.getConnection()) {

            // 1️⃣ 이미 찜한 영화인지 확인
            String checkSql = "SELECT COUNT(*) FROM wish WHERE user_id = ? AND movie_id = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, userId);
            checkPs.setInt(2, movieId);

            ResultSet rs = checkPs.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            if (count > 0) {
                // 2️⃣ 이미 존재 → DELETE(찜 취소)
                String deleteSql = "DELETE FROM wish WHERE user_id = ? AND movie_id = ?";
                PreparedStatement del = conn.prepareStatement(deleteSql);
                del.setString(1, userId);
                del.setInt(2, movieId);
                del.executeUpdate();

                System.out.println(">>> Wish Removed!");

            } else {
                // 3️⃣ 존재하지 않음 → INSERT(찜 추가)
                String insertSql =
                    "INSERT INTO wish (user_id, movie_id, movie_title, poster_path) VALUES (?, ?, ?, ?)";

                PreparedStatement ins = conn.prepareStatement(insertSql);
                ins.setString(1, userId);
                ins.setInt(2, movieId);
                ins.setString(3, movieTitle);
                ins.setString(4, poster);
                ins.executeUpdate();

                System.out.println(">>> Wish Added!");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 원래 페이지로 리다이렉트
        response.sendRedirect("movieDetail?movieId=" + movieId);
    }
}