package com.dongyang.dongflix.dto;

public class BoardCommentDTO {

    private int commentId;
    private int boardId;
    private String userid;
    private String content;
    private String createdAt;
    private MemberDTO member; // 댓글 작성자 정보 포함


    public BoardCommentDTO() {
    }

    public BoardCommentDTO(int commentId, int boardId, String userid, String content, String createdAt) {
        this.commentId = commentId;
        this.boardId = boardId;
        this.userid = userid;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getCommentId() {
        return commentId;
    }

    public void setCommentId(int commentId) {
        this.commentId = commentId;
    }

    public int getBoardId() {
        return boardId;
    }

    public void setBoardId(int boardId) {
        this.boardId = boardId;
    }

    public String getUserid() {
        return userid;
    }

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
    public MemberDTO getMember() { return member; }
    public void setMember(MemberDTO member) { this.member = member; }

}
