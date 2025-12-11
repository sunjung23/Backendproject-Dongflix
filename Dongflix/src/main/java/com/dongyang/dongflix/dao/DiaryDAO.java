package com.dongyang.dongflix.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dto.DiaryDTO;

public class DiaryDAO {

    /** 일기 저장 */
    public int saveDiary(String userid, int movieId, String movieTitle,
                         String date, String content, String posterPath) {

        String sql = "INSERT INTO movie_diary(userid, movie_id, movie_title, diary_date, content, poster_path) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ps.setInt(2, movieId);
            ps.setString(3, movieTitle);
            ps.setString(4, date);
            ps.setString(5, content);
            ps.setString(6, posterPath);

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 내 일기 목록 */
    public List<DiaryDTO> getMyDiaryList(String userid) {
        List<DiaryDTO> list = new ArrayList<>();

        String sql = "SELECT diary_id, userid, movie_id, movie_title, diary_date, content, reg_date, poster_path "
                   + "FROM movie_diary WHERE userid = ? ORDER BY diary_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DiaryDTO dto = new DiaryDTO();
                dto.setId(rs.getInt("diary_id")); // DTO의 id에 diary_id 저장
                dto.setUserid(rs.getString("userid"));
                dto.setMovieId(rs.getInt("movie_id"));
                dto.setMovieTitle(rs.getString("movie_title"));
                dto.setDiaryDate(rs.getString("diary_date"));
                dto.setContent(rs.getString("content"));
                dto.setRegDate(rs.getString("reg_date"));
                dto.setPosterPath(rs.getString("poster_path"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 일기 삭제 */
    public int deleteDiary(int id) {

        String sql = "DELETE FROM movie_diary WHERE diary_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 일기 상세 조회 (수정용) */
    public DiaryDTO getDiaryById(int id) {
        DiaryDTO dto = null;

        String sql = "SELECT diary_id, userid, movie_id, movie_title, diary_date, content, reg_date, poster_path "
                   + "FROM movie_diary WHERE diary_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                dto = new DiaryDTO();
                dto.setId(rs.getInt("diary_id"));
                dto.setUserid(rs.getString("userid"));
                dto.setMovieId(rs.getInt("movie_id"));
                dto.setMovieTitle(rs.getString("movie_title"));
                dto.setDiaryDate(rs.getString("diary_date"));
                dto.setContent(rs.getString("content"));
                dto.setRegDate(rs.getString("reg_date"));
                dto.setPosterPath(rs.getString("poster_path"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }

    /** 일기 수정 */
    public int updateDiary(int id, String diaryDate, String content) {

        String sql = "UPDATE movie_diary "
                   + "SET diary_date = ?, content = ? "
                   + "WHERE diary_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, diaryDate);
            ps.setString(2, content);
            ps.setInt(3, id);

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}