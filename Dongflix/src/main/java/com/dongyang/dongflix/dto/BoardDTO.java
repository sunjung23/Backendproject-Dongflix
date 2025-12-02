package com.dongyang.dongflix.dto;

public class BoardDTO {
    private int boardId;
    private String userid;
    private String title;
    private String content;
    private String createdAt;
    private String category;


    public BoardDTO() {}

    public BoardDTO(int boardId, String userid, String title, String content, String createdAt, String category) {
        this.boardId = boardId;
        this.userid = userid;
        this.title = title;
        this.content = content;
        this.createdAt = createdAt;
        this.category = category;
    }

   
    public BoardDTO(String userid, String title, String content, String category) {
        this.userid = userid;
        this.title = title;
        this.content = content;
        this.category = category;
    }


    // getter & setter
    public int getBoardId() { return boardId; }
    public void setBoardId(int boardId) { this.boardId = boardId; }

    public String getUserid() { return userid; }
    public void setUserid(String userid) { this.userid = userid; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
}
