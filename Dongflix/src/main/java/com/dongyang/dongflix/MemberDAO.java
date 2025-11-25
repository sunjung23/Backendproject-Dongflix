package com.dongyang.dongflix;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MemberDAO {

    // 회원가입
    public int join(MemberDTO dto) {
        String sql = "INSERT INTO member(userid, userpw, name, grade) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dto.getUserid());
            ps.setString(2, dto.getPassword());   // userpw
            ps.setString(3, dto.getUsername());  // name
            ps.setString(4, "basic");            // grade 기본값 (원하면 변경)

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 로그인
    public MemberDTO login(String userid, String password) {
        String sql = "SELECT * FROM member WHERE userid=? AND userpw=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new MemberDTO(
                        rs.getString("userid"),
                        rs.getString("userpw"),
                        rs.getString("name")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}