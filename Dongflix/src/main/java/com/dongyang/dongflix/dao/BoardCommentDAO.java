package com.dongyang.dongflix.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dongyang.dongflix.DBConnection;
import com.dongyang.dongflix.dto.BoardCommentDTO;
import com.dongyang.dongflix.dto.MemberDTO;

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
            System.out.println(">>> getByBoard 에러");
            e.printStackTrace();
        }
        return list;
    }
    
    // 관리자용: 댓글 목록 조회 (작성자 정보 포함)
    public List<BoardCommentDTO> getByBoardWithMember(int boardId) {
        List<BoardCommentDTO> list = new ArrayList<>();
        
        // 1단계: 댓글 목록 먼저 조회
        String sql = "SELECT comment_id, board_id, userid, content, created_at " +
                     "FROM board_comment WHERE board_id = ? ORDER BY comment_id ASC";
        
        System.out.println(">>> getByBoardWithMember 호출 - boardId: " + boardId);
        
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
                    
                    // 2단계: 각 댓글의 작성자 정보 조회
                    String userid = rs.getString("userid");
                    MemberDTO member = getMemberInfo(userid);
                    dto.setMember(member);
                    
                    list.add(dto);
                    System.out.println(">>> 댓글 추가: " + dto.getCommentId() + " - " + dto.getContent());
                }
            }
            
            System.out.println(">>> 총 댓글 개수: " + list.size());
            
        } catch (Exception e) {
            System.out.println(">>> getByBoardWithMember 에러");
            e.printStackTrace();
        }
        return list;
    }

    // 회원 정보 조회 (헬퍼 메서드)
    private MemberDTO getMemberInfo(String userid) {
        String sql = "SELECT userid, username, nickname, grade, profile_img FROM member WHERE userid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userid);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MemberDTO member = new MemberDTO();
                    member.setUserid(rs.getString("userid"));
                    member.setUsername(rs.getString("username"));
                    member.setNickname(rs.getString("nickname"));
                    member.setGrade(rs.getString("grade"));
                    member.setProfileImg(rs.getString("profile_img"));
                    return member;
                }
            }
            
        } catch (Exception e) {
            System.out.println(">>> getMemberInfo 에러: " + userid);
            e.printStackTrace();
        }
        
        // 회원 정보가 없으면 기본값 반환
        MemberDTO member = new MemberDTO();
        member.setUserid(userid);
        member.setGrade("bronze");
        return member;
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
    
    // 관리자용: 댓글 강제 삭제 (userid 체크 없음)
    public int deleteByAdmin(int commentId) {
        String sql = "DELETE FROM board_comment WHERE comment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // 댓글 개수 조회
    public int getCommentCount(int boardId) {
        String sql = "SELECT COUNT(*) FROM board_comment WHERE board_id = ?";
        
        System.out.println(">>> getCommentCount 호출 - boardId: " + boardId);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, boardId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println(">>> 댓글 개수 결과: " + count);
                    return count;
                }
            }
        } catch (Exception e) {
            System.out.println(">>> getCommentCount 에러");
            e.printStackTrace();
        }
        return 0;
    }
}