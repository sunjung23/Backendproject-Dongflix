package com.dongyang.dongflix.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dto.LikeMovieDTO;

public class LikeMovieDAO {

    public List<LikeMovieDTO> getLikedMovies(String userid) {
        List<LikeMovieDTO> list = new ArrayList<>();

        String sql = "SELECT * FROM liked_movies WHERE userid=? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new LikeMovieDTO(
                        rs.getInt("id"),
                        rs.getString("userid"),
                        rs.getString("movie_title"),
                        rs.getString("movie_img"),
                        rs.getString("created_at")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
