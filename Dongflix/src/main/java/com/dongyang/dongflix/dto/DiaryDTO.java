package com.dongyang.dongflix.dto;

public class DiaryDTO {

    private int diary_id;
    private String userid;
    private int movieId;
    private String movieTitle;
    private String diaryDate;
    private String content;
    private String regDate; 
    private String posterPath; 

    public DiaryDTO() {}

    public int getId() {
        return diary_id;
    }
    public void setId(int id) {
        this.diary_id = diary_id;
    }

    public String getUserid() {
        return userid;
    }
    public void setUserid(String userid) {
        this.userid = userid;
    }

    public int getMovieId() {
        return movieId;
    }
    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public String getMovieTitle() {
        return movieTitle;
    }
    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public String getDiaryDate() {
        return diaryDate;
    }
    public void setDiaryDate(String diaryDate) {
        this.diaryDate = diaryDate;
    }

    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    public String getRegDate() {
        return regDate;
    }
    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }

    public String getPosterPath() {
        return posterPath;
    }
    public void setPosterPath(String posterPath) {
        this.posterPath = posterPath;
    }
}