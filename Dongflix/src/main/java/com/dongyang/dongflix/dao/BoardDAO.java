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

    // 목록 조회
    public List<BoardDTO> getAll() {
        List<BoardDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM board ORDER BY board_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new BoardDTO(
                        rs.getInt("board_id"),
                        rs.getString("userid"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("created_at"),
                        rs.getString("category")
                ));
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
                return new BoardDTO(
                        rs.getInt("board_id"),
                        rs.getString("userid"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("created_at"),
                        rs.getString("category")
                );
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
    
    
    public List<BoardDTO> getByUser(String userid) {
        List<BoardDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM board WHERE userid=? ORDER BY board_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new BoardDTO(
                    rs.getInt("board_id"),
                    rs.getString("userid"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("created_at"),
                    rs.getString("category")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
 // 카테고리별 목록 조회
    public List<BoardDTO> getByCategory(String category) {
        List<BoardDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM board WHERE category=? ORDER BY board_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new BoardDTO(
                    rs.getInt("board_id"),
                    rs.getString("userid"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("created_at"),
                    rs.getString("category")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //날짜 순으로 조회
    public List<BoardDTO> getSortedList(String orderType) {
        List<BoardDTO> list = new ArrayList<>();

        String order = "DESC";  // 기본 최신순
        if ("old".equals(orderType)) order = "ASC";

        String sql = "SELECT * FROM board ORDER BY board_id " + order;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new BoardDTO(
                    rs.getInt("board_id"),
                    rs.getString("userid"),
                    rs.getString("title"),
                    rs.getString("content"),
                    rs.getString("created_at"),
                    rs.getString("category")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


}
