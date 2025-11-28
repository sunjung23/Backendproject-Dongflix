package com.dongyang.dongflix.dto;

public class LikeMovieDTO {
    private int id;
    private String userid;
    private int movieId;        
    private String movieTitle;
    private String movieImg;
    private String createdAt;

    public LikeMovieDTO(int id, String userid, int movieId, String movieTitle, String movieImg, String createdAt) {
        this.id = id;
        this.userid = userid;
        this.movieId = movieId;
        this.movieTitle = movieTitle;
        this.movieImg = movieImg;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public String getUserid() { return userid; }
    public int getMovieId() { return movieId; }  
    public String getMovieTitle() { return movieTitle; }
    public String getMovieImg() { return movieImg; }
    public String getCreatedAt() { return createdAt; }
}