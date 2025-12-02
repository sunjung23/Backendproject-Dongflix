package com.dongyang.dongflix.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dto.MemberDTO;

public class MemberDAO {

    // ====================== 회원가입 ======================
    public int join(MemberDTO dto) {
        String sql = "INSERT INTO member(userid, userpw, name, grade) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dto.getUserid());
            ps.setString(2, dto.getPassword());
            ps.setString(3, dto.getUsername());
            ps.setString(4, "bronze"); // 기본 등급

            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


    // ====================== 로그인 ======================
    public MemberDTO login(String userid, String password) {
        String sql = "SELECT * FROM member WHERE userid=? AND userpw=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                MemberDTO dto = new MemberDTO(
                        rs.getString("userid"),
                        rs.getString("userpw"),
                        rs.getString("name")
                );

                // 프로필 관련 필드 셋팅
                dto.setNickname(rs.getString("nickname"));
                dto.setPhone(rs.getString("phone"));
                dto.setBirth(rs.getString("birth"));
                dto.setProfileImg(rs.getString("profile_img"));
                dto.setGrade(rs.getString("grade"));

                return dto;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    // ====================== 회원정보 수정 ======================
    public int updateMemberInfo(String userid,
                                String username,
                                String nickname,
                                String phone,
                                String birth,
                                String profileImg) {

        String sql = "UPDATE member " +
                "SET name = ?, nickname = ?, phone = ?, birth = ?, profile_img = ? " +
                "WHERE userid = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, nickname);
            ps.setString(3, phone);
            ps.setString(4, birth);
            ps.setString(5, profileImg);
            ps.setString(6, userid);

            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


    // ====================== 전체 회원 목록 조회 (관리자) ======================
    public List<MemberDTO> getAllMembers() {
        List<MemberDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM member ORDER BY userid";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MemberDTO dto = new MemberDTO(
                        rs.getString("userid"),
                        rs.getString("userpw"),
                        rs.getString("name")
                );

                dto.setNickname(rs.getString("nickname"));
                dto.setPhone(rs.getString("phone"));
                dto.setBirth(rs.getString("birth"));
                dto.setProfileImg(rs.getString("profile_img"));

                String grade = rs.getString("grade");
                if (grade == null || grade.isEmpty()) grade = "bronze";
                dto.setGrade(grade);

                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println(">>> 회원 목록 조회 실패");
            e.printStackTrace();
        }
        return list;
    }


    // ====================== 회원 등급 변경 ======================
    public int updateGrade(String userid, String grade) {
        String sql = "UPDATE member SET grade=? WHERE userid=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, grade);
            ps.setString(2, userid);

            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


    // ====================== 특정 회원 정보 조회 ======================
    public MemberDTO getMember(String userid) {
        String sql = "SELECT * FROM member WHERE userid=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                MemberDTO dto = new MemberDTO(
                        rs.getString("userid"),
                        rs.getString("userpw"),
                        rs.getString("name")
                );

                dto.setNickname(rs.getString("nickname"));
                dto.setPhone(rs.getString("phone"));
                dto.setBirth(rs.getString("birth"));
                dto.setProfileImg(rs.getString("profile_img"));
                dto.setGrade(rs.getString("grade"));

                return dto;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    // ====================== 비밀번호 확인 ======================
    public boolean checkPassword(String userid, String password) {
        String sql = "SELECT userid FROM member WHERE userid=? AND userpw=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            return rs.next(); // 비밀번호 일치 = true

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    // ====================== 비밀번호 업데이트 ======================
    public int updatePassword(String userid, String newPassword) {
        String sql = "UPDATE member SET userpw=? WHERE userid=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, userid);

            return ps.executeUpdate(); // 1이면 성공

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    
 // 닉네임이 null이면 자동 생성해서 저장하는 기능
    public String getOrCreateNickname(String userid) {

        String sql = "SELECT nickname FROM member WHERE userid=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userid);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String nickname = rs.getString("nickname");

                if (nickname != null && !nickname.trim().isEmpty()) {
                    return nickname;
                }
            }

            // 닉네임이 없는 경우 → 자동 생성
            String newNick = "사용자" + (int)(Math.random() * 90000 + 10000);

            String updateSql = "UPDATE member SET nickname=? WHERE userid=?";
            PreparedStatement ps2 = conn.prepareStatement(updateSql);
            ps2.setString(1, newNick);
            ps2.setString(2, userid);
            ps2.executeUpdate();

            return newNick;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "사용자" + (int)(Math.random() * 90000 + 10000);
    }


}
