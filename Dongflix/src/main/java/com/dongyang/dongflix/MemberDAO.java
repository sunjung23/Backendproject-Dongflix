package com.dongyang.dongflix;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {

    // 회원가입
	public int join(MemberDTO dto) {
	    String sql = "INSERT INTO member(userid, userpw, name, grade) VALUES (?, ?, ?, ?)";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setString(1, dto.getUserid());
	        ps.setString(2, dto.getPassword());
	        ps.setString(3, dto.getUsername());
	        ps.setString(4, "bronze");  // 기본 등급을 bronze로
	        
	        int result = ps.executeUpdate();
	        System.out.println(">>> 회원가입 결과: " + result);
	        return result;
	    } catch (Exception e) {
	        System.out.println(">>> 회원가입 실패");
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
                MemberDTO dto = new MemberDTO(
                        rs.getString("userid"),
                        rs.getString("userpw"),
                        rs.getString("name")
                );
                // grade를 꼭 설정해야 함!
                dto.setGrade(rs.getString("grade"));
                return dto;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
 // ========== 관리자 기능 (기존 코드 아래에 추가) ==========

 // 전체 회원 목록 조회
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
                // grade 설정 - 이게 핵심!
                String grade = rs.getString("grade");
                if (grade == null || grade.isEmpty()) {
                    grade = "bronze"; // 기본값
                }
                dto.setGrade(grade);
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println(">>> 회원 목록 조회 실패");
            e.printStackTrace();
        }
        return list;
    }

 // 회원 등급 변경
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

 // 회원 정보 조회 (grade 포함)
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
             return dto;
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return null;
 }
}