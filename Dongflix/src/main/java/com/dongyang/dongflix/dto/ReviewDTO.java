package com.dongyang.dongflix.dto;

public class ReviewDTO {

    private int id;
    private String userid;
    private int movieId;
    private String title;
    private String content;
    private int rating;
    private String createdAt;

    // 새로 추가된 필드
    private String movieTitle;
    private String movieImg;
    
    // 🔥 추천 기능 추가
    private int likeCount;      // 추천 수
    private boolean isLiked;    // 현재 사용자가 추천했는지 여부

    public ReviewDTO() {}

    // 조회용 전체 생성자
    public ReviewDTO(int id, String userid, int movieId, String title,
                     String content, int rating, String createdAt,
                     String movieTitle, String movieImg) {
        this.id = id;
        this.userid = userid;
        this.movieId = movieId;
        this.title = title;
        this.content = content;
        this.rating = rating;
        this.createdAt = createdAt;
        this.movieTitle = movieTitle;
        this.movieImg = movieImg;
    }

    // 기존 작성용 생성자
    public ReviewDTO(String userid, int movieId, String title, String content, int rating) {
        this.userid = userid;
        this.movieId = movieId;
        this.title = title;
        this.content = content;
        this.rating = rating;
    }

    // 새롭게 필요한 생성자
    public ReviewDTO(String userid, int movieId, String title, String content,
                     int rating, String movieTitle, String movieImg) {
        this.userid = userid;
        this.movieId = movieId;
        this.title = title;
        this.content = content;
        this.rating = rating;
        this.movieTitle = movieTitle;
        this.movieImg = movieImg;
    }

    // getter / setter
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

    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }

    public String getMovieImg() { return movieImg; }
    public void setMovieImg(String movieImg) { this.movieImg = movieImg; }

    // 🔥 추천 기능 getter/setter
    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public boolean isLiked() { return isLiked; }
    public void setIsLiked(boolean isLiked) { this.isLiked = isLiked; }
}