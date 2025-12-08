package com.dongyang.dongflix.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dto.BoardCommentDTO;

public class BoardCommentDAO {

    // 특정 게시글의 댓글 목록
    public List<BoardCommentDTO> getByBoard(int boardId) {
        List<BoardCommentDTO> list = new ArrayList<>();

        String sql = "SELECT comment_id, board_id, userid, content, created_at " +
                     "FROM board_comment WHERE board_id = ? ORDER BY comment_id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, boardId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BoardCommentDTO dto = new BoardCommentDTO(
                        rs.getInt("comment_id"),
                        rs.getInt("board_id"),
                        rs.getString("userid"),
                        rs.getString("content"),
                        rs.getString("created_at")
                    );
                    list.add(dto);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 댓글 작성
    public int insert(BoardCommentDTO dto) {
        String sql = "INSERT INTO board_comment (board_id, userid, content) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, dto.getBoardId());
            ps.setString(2, dto.getUserid());
            ps.setString(3, dto.getContent());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // 댓글 삭제 (본인 글만 삭제: comment_id + userid)
    public int delete(int commentId, String userid) {
        String sql = "DELETE FROM board_comment WHERE comment_id = ? AND userid = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, commentId);
            ps.setString(2, userid);

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}
