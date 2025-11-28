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

        String sql = "SELECT id, user_id, movie_id, movie_title, poster_path, reg_dt " +
                     "FROM wish WHERE user_id=? ORDER BY reg_dt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new LikeMovieDTO(
                        rs.getInt("id"),
                        rs.getString("user_id"),
                        rs.getInt("movie_id"),
                        rs.getString("movie_title"),
                        rs.getString("poster_path"),
                        rs.getString("reg_dt")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}