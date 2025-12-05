package com.dongyang.dongflix.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.dongyang.dongflix.DBConnection;

public class ReviewLikeDAO {

    // 추천 추가
    public boolean addLike(int reviewId, String userid) {
        String sql = "INSERT INTO review_like (review_id, userid) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reviewId);
            ps.setString(2, userid);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.out.println(">>> 추천 추가 실패 (이미 추천했을 수 있음)");
            e.printStackTrace();
        }
        return false;
    }

    // 추천 취소
    public boolean removeLike(int reviewId, String userid) {
        String sql = "DELETE FROM review_like WHERE review_id=? AND userid=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reviewId);
            ps.setString(2, userid);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.out.println(">>> 추천 취소 실패");
            e.printStackTrace();
        }
        return false;
    }

    // 특정 리뷰의 추천 수 조회
    public int getLikeCount(int reviewId) {
        String sql = "SELECT COUNT(*) FROM review_like WHERE review_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reviewId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.out.println(">>> 추천 수 조회 실패");
            e.printStackTrace();
        }
        return 0;
    }

    // 사용자가 해당 리뷰를 추천했는지 확인
    public boolean isLiked(int reviewId, String userid) {
        String sql = "SELECT COUNT(*) FROM review_like WHERE review_id=? AND userid=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reviewId);
            ps.setString(2, userid);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (Exception e) {
            System.out.println(">>> 추천 여부 확인 실패");
            e.printStackTrace();
        }
        return false;
    }
}