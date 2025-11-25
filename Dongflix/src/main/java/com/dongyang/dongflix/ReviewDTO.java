package com.dongyang.dongflix;

public class ReviewDTO {

    private int id;
    private String userid;
    private String title;
    private String content;
    private int rating;
    private String createdAt;

    public ReviewDTO() {}

    public ReviewDTO(int id, String userid, String title, String content, int rating, String createdAt) {
        this.id = id;
        this.userid = userid;
        this.title = title;
        this.content = content;
        this.rating = rating;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUserid() { return userid; }
    public void setUserid(String userid) { this.userid = userid; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
