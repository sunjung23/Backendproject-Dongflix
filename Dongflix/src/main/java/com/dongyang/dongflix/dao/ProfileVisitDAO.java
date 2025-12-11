package com.dongyang.dongflix.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dto.MemberDTO;

public class ProfileVisitDAO {

    // 1) 방문 기록 추가
    public void addVisit(String ownerUserid, String visitorUserid) {
        String sql = "INSERT INTO profile_visit (owner_userid, visitor_userid) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ownerUserid);
            ps.setString(2, visitorUserid);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 2) 특정 사용자의 총 방문 수
    public int getVisitCount(String ownerUserid) {
        String sql = "SELECT COUNT(*) FROM profile_visit WHERE owner_userid = ?";
        int count = 0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ownerUserid);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // 3) 최근 방문자 목록 (닉네임/프로필 이미지까지)
    public List<MemberDTO> getRecentVisitors(String ownerUserid, int limit) {
        List<MemberDTO> list = new ArrayList<>();

        String sql =
            "SELECT m.userid, m.userpw, m.username, m.nickname, m.phone, m.birth, " +
            "       m.profile_img, m.grade, m.movie_style " +
            "FROM profile_visit v " +
            "JOIN member m ON v.visitor_userid = m.userid " +
            "WHERE v.owner_userid = ? " +
            "ORDER BY v.visited_at DESC " +
            "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ownerUserid);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    // 생성자 8개 필드 세팅
                    MemberDTO dto = new MemberDTO(
                        rs.getString("userid"),
                        rs.getString("userpw"),
                        rs.getString("username"),
                        rs.getString("nickname"),
                        rs.getString("phone"),
                        rs.getString("birth"),
                        rs.getString("profile_img"),
                        rs.getString("grade")
                    );

                    // movie_style 추가로 세터 처리
                    dto.setMovieStyle(rs.getString("movie_style"));

                    list.add(dto);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
