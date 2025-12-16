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

    // 목록 조회 (전체)
    public List<BoardDTO> getAll() {
        List<BoardDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM board ORDER BY board_id DESC";

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
                dto.setViews(rs.getInt("views"));  // 조회수
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 상세 조회
    public BoardDTO getById(int id) {
        String sql = "SELECT * FROM board WHERE board_id=?";

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
                dto.setViews(rs.getInt("views"));  // 조회수
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

        String deleteComments = "DELETE FROM board_comment WHERE board_id=?";
        String deleteLikes = "DELETE FROM board_like WHERE board_id=?";
        String deleteBoard = "DELETE FROM board WHERE board_id=?";

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false); 

            try (
                PreparedStatement ps1 = conn.prepareStatement(deleteComments);
                PreparedStatement ps2 = conn.prepareStatement(deleteLikes);
                PreparedStatement ps3 = conn.prepareStatement(deleteBoard)
            ) {
                // 댓글 삭제
                ps1.setInt(1, id);
                ps1.executeUpdate();

                //  좋아요 삭제
                ps2.setInt(1, id);
                ps2.executeUpdate();

                // 게시글 삭제
                ps3.setInt(1, id);
                int result = ps3.executeUpdate();

                conn.commit(); // 성공 시 커밋
                return result;

            } catch (Exception e) {
                conn.rollback(); // 실패 롤백
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // 사용자별 게시글
    public List<BoardDTO> getByUser(String userid) {
        List<BoardDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM board WHERE userid=? ORDER BY board_id DESC";

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
                dto.setViews(rs.getInt("views"));  // 조회수
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 날짜 순 + 조회수 순 정렬
    public List<BoardDTO> getSortedList(String sort) {
        List<BoardDTO> list = new ArrayList<>();

        String sql;
        if ("old".equals(sort)) {
            sql = "SELECT * FROM board ORDER BY board_id ASC";      // 오래된순
        } else if ("views".equals(sort)) {
            sql = "SELECT * FROM board ORDER BY views DESC";        // 조회수순
        } else {
            sql = "SELECT * FROM board ORDER BY board_id DESC";     // 최신순(new, default)
        }

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
                dto.setViews(rs.getInt("views"));  // 조회수
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 카테고리별 목록
    public List<BoardDTO> getByCategory(String category) {
        List<BoardDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM board WHERE category=? ORDER BY board_id DESC";

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
                dto.setViews(rs.getInt("views"));  // 조회수
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
