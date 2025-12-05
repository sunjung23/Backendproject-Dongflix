package com.dongyang.dongflix.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.dongyang.dongflix.DBConnection;

public class BoardLikeDAO {

    /**
     * 특정 게시글에 대해 해당 사용자가 이미 좋아요를 눌렀는지 확인
     * @param boardId 게시글 ID
     * @param userid  사용자 ID
     * @return true = 이미 좋아요 함, false = 아직 안 함
     */
    public boolean hasUserLiked(int boardId, String userid) {
        String sql = "SELECT COUNT(*) FROM board_like WHERE board_id = ? AND userid = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, boardId);
            ps.setString(2, userid);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    return count > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * 좋아요 추가
     * @param boardId 게시글 ID
     * @param userid  사용자 ID
     */
    public void addLike(int boardId, String userid) {
        String sql = "INSERT INTO board_like (board_id, userid) VALUES (?, ?)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, boardId);
            ps.setString(2, userid);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 좋아요 취소
     * @param boardId 게시글 ID
     * @param userid  사용자 ID
     */
    public void removeLike(int boardId, String userid) {
        String sql = "DELETE FROM board_like WHERE board_id = ? AND userid = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, boardId);
            ps.setString(2, userid);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 해당 게시글의 총 좋아요 개수
     * @param boardId 게시글 ID
     * @return 좋아요 개수
     */
    public int getLikeCount(int boardId) {
        String sql = "SELECT COUNT(*) FROM board_like WHERE board_id = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, boardId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}
