package com.dongyang.dongflix.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dto.ReviewDTO;

public class ReviewDAO {

    // 리뷰 등록
    public int insertReview(ReviewDTO dto) {
        String sql = "INSERT INTO review (userid, movie_id, title, content, rating, movie_title, movie_img) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dto.getUserid());
            ps.setInt(2, dto.getMovieId());
            ps.setString(3, dto.getTitle());
            ps.setString(4, dto.getContent());
            ps.setInt(5, dto.getRating());
            ps.setString(6, dto.getMovieTitle());
            ps.setString(7, dto.getMovieImg());

            return ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(">>> 리뷰 등록 실패");
            e.printStackTrace();
        }
        return 0;
    }

    // 특정 영화 리뷰 조회
    public List<ReviewDTO> getReviewsByMovie(int movieId) {
        List<ReviewDTO> list = new ArrayList<>();

        String sql = "SELECT * FROM review WHERE movie_id=? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ReviewDTO dto = new ReviewDTO(
                        rs.getInt("review_id"),
                        rs.getString("userid"),
                        rs.getInt("movie_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getInt("rating"),
                        rs.getString("created_at"),
                        rs.getString("movie_title"),
                        rs.getString("movie_img")
                );
                list.add(dto);
            }

        } catch (Exception e) {
            System.out.println(">>> 영화 리뷰 조회 실패");
            e.printStackTrace();
        }
        return list;
    }


    // 특정 유저 리뷰 조회
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
                        rs.getInt("movie_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getInt("rating"),
                        rs.getString("created_at"),
                        rs.getString("movie_title"),
                        rs.getString("movie_img")
                );
                list.add(dto);
            }

        } catch (Exception e) {
            System.out.println(">>> 유저 리뷰 조회 실패");
            e.printStackTrace();
        }
        return list;
    }


    // 리뷰 1개 조회
    public ReviewDTO getReviewById(int id) {
        String sql = "SELECT * FROM review WHERE review_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new ReviewDTO(
                        rs.getInt("review_id"),
                        rs.getString("userid"),
                        rs.getInt("movie_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getInt("rating"),
                        rs.getString("created_at"),
                        rs.getString("movie_title"),
                        rs.getString("movie_img")
                );
            }

        } catch (Exception e) {
            System.out.println(">>> 리뷰 조회 실패");
            e.printStackTrace();
        }
        return null;
    }


    // 리뷰 수정
    public int updateReview(ReviewDTO dto) {
        String sql = "UPDATE review SET title=?, content=?, rating=? WHERE review_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dto.getTitle());
            ps.setString(2, dto.getContent());
            ps.setInt(3, dto.getRating());
            ps.setInt(4, dto.getId());

            return ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(">>> 리뷰 수정 실패");
            e.printStackTrace();
        }
        return 0;
    }

    // 리뷰 삭제
    public int deleteReview(int id) {
        String sql = "DELETE FROM review WHERE review_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(">>> 리뷰 삭제 실패");
            e.printStackTrace();
        }
        return 0;
    }

    // 평균 별점
    public double getAverageRating(String userid) {
        String sql = "SELECT AVG(rating) FROM review WHERE userid=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
