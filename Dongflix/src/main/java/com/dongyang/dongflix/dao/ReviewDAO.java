package com.dongyang.dongflix.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dto.ReviewDTO;

public class ReviewDAO {

    // 특정 유저의 리뷰 목록 조회
    public List<ReviewDTO> getReviewsByUser(String userid) {
        List<ReviewDTO> list = new ArrayList<>();

        String sql = "SELECT * FROM review WHERE userid=? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ReviewDTO dto = new ReviewDTO(
                        rs.getInt("review_id"),
                        rs.getString("userid"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getInt("rating"),
                        rs.getString("created_at")
                );
                list.add(dto);
            }

        } catch (Exception e) {
            System.out.println(">>> 리뷰 목록 조회 실패");
            e.printStackTrace();
        }
        return list;
    }
}
