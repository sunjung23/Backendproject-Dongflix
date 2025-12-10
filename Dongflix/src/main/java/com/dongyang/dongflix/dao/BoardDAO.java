package com.dongyang.dongflix.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dto.BoardDTO;

public class BoardDAO {

    // 글 작성
    public int insert(BoardDTO dto) {
        String sql = "INSERT INTO board (userid, title, content, category) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dto.getUserid());
            ps.setString(2, dto.getTitle());
            ps.setString(3, dto.getContent());
            ps.setString(4, dto.getCategory());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /* ------------------------------------------------------------
       목록 조회 (JOIN member → profile_img 가져오기)
       ------------------------------------------------------------ */
    public List<BoardDTO> getAll() {
        List<BoardDTO> list = new ArrayList<>();

        String sql =
            "SELECT b.*, m.profile_img " +
            "FROM board b " +
            "JOIN member m ON b.userid = m.userid " +
            "ORDER BY b.board_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BoardDTO dto = new BoardDTO(
                        rs.getInt("board_id"),
                        rs.getString("userid"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("created_at"),
                        rs.getString("category")
                );
                dto.setViews(rs.getInt("views"));
                dto.setProfileImg(rs.getString("profile_img")); // ⭐ 추가
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ------------------------------------------------------------
       상세 조회 (JOIN member → profile_img 포함)
       ------------------------------------------------------------ */
    public BoardDTO getById(int id) {
        String sql =
            "SELECT b.*, m.profile_img " +
            "FROM board b " +
            "JOIN member m ON b.userid = m.userid " +
            "WHERE b.board_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                BoardDTO dto = new BoardDTO(
                        rs.getInt("board_id"),
                        rs.getString("userid"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("created_at"),
                        rs.getString("category")
                );

                dto.setViews(rs.getInt("views"));
                dto.setProfileImg(rs.getString("profile_img")); // ⭐ 추가

                return dto;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 수정
    public int update(BoardDTO dto) {
        String sql = "UPDATE board SET title=?, content=? WHERE board_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dto.getTitle());
            ps.setString(2, dto.getContent());
            ps.setInt(3, dto.getBoardId());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 삭제
    public int delete(int id) {
        String sql = "DELETE FROM board WHERE board_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /* ------------------------------------------------------------
       사용자별 게시글 (JOIN member)
       ------------------------------------------------------------ */
    public List<BoardDTO> getByUser(String userid) {
        List<BoardDTO> list = new ArrayList<>();
        String sql =
            "SELECT b.*, m.profile_img " +
            "FROM board b " +
            "JOIN member m ON b.userid = m.userid " +
            "WHERE b.userid=? ORDER BY b.board_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BoardDTO dto = new BoardDTO(
                        rs.getInt("board_id"),
                        rs.getString("userid"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("created_at"),
                        rs.getString("category")
                );
                dto.setViews(rs.getInt("views"));
                dto.setProfileImg(rs.getString("profile_img")); // ⭐ 추가

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* ------------------------------------------------------------
       정렬 (JOIN member)
       ------------------------------------------------------------ */
    public List<BoardDTO> getSortedList(String sort) {
        List<BoardDTO> list = new ArrayList<>();

        String orderSql = switch (sort) {
            case "old" -> "ORDER BY b.board_id ASC";
            case "views" -> "ORDER BY b.views DESC";
            default -> "ORDER BY b.board_id DESC";
        };

        String sql =
            "SELECT b.*, m.profile_img " +
            "FROM board b " +
            "JOIN member m ON b.userid = m.userid " +
            orderSql;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BoardDTO dto = new BoardDTO(
                        rs.getInt("board_id"),
                        rs.getString("userid"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("created_at"),
                        rs.getString("category")
                );
                dto.setViews(rs.getInt("views"));
                dto.setProfileImg(rs.getString("profile_img")); // ⭐ 추가

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /* ------------------------------------------------------------
       카테고리 목록 (JOIN member)
       ------------------------------------------------------------ */
    public List<BoardDTO> getByCategory(String category) {
        List<BoardDTO> list = new ArrayList<>();

        String sql =
            "SELECT b.*, m.profile_img " +
            "FROM board b " +
            "JOIN member m ON b.userid = m.userid " +
            "WHERE b.category=? ORDER BY b.board_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BoardDTO dto = new BoardDTO(
                        rs.getInt("board_id"),
                        rs.getString("userid"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("created_at"),
                        rs.getString("category")
                );

                dto.setViews(rs.getInt("views"));
                dto.setProfileImg(rs.getString("profile_img")); // ⭐ 추가

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 조회수 증가
    public void increaseViews(int boardId) {
        String sql = "UPDATE board SET views = views + 1 WHERE board_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, boardId);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
