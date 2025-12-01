package com.dongyang.dongflix.dto;

public class ReviewDTO {

    private int id;
    private String userid;
    private int movieId;
    private String title;
    private String content;
    private int rating;
    private String createdAt;

    public ReviewDTO() {}

    // 조회용 전체 생성자
    public ReviewDTO(int id, String userid, int movieId, String title,
                     String content, int rating, String createdAt) {
        this.id = id;
        this.userid = userid;
        this.movieId = movieId;
        this.title = title;
        this.content = content;
        this.rating = rating;
        this.createdAt = createdAt;
    }

    // 작성용 생성자
    public ReviewDTO(String userid, int movieId, String title, String content, int rating) {
        this.userid = userid;
        this.movieId = movieId;
        this.title = title;
        this.content = content;
        this.rating = rating;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUserid() { return userid; }
    public void setUserid(String userid) { this.userid = userid; }

    public int getMovieId() { return movieId; }
    public void setMovieId(int movieId) { this.movieId = movieId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}