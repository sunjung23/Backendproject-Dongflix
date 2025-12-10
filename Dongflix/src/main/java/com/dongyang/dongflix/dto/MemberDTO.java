package com.dongyang.dongflix.dto;

import java.sql.Timestamp;

public class MemberDTO {
    private String userid;
    private String userpw;
    private String username;
    private String nickname;
    private String phone;
    private String birth;
    private String profileImg;
    private String grade;
    private String email;
    private Timestamp createdAt;
    private String movieStyle;  // 🔥 추가

    // 기본 생성자
    public MemberDTO() {}

    // 생성자 1 (로그인용)
    public MemberDTO(String userid, String password, String username) {
        this.userid = userid;
        this.userpw = password;
        this.username = username;
    }

    // 생성자 2 (전체 정보)
    public MemberDTO(String userid, String password, String username,
                     String nickname, String phone, String birth,
                     String profileImg, String grade) {
        this.userid = userid;
        this.userpw = password;
        this.username = username;
        this.nickname = nickname;
        this.phone = phone;
        this.birth = birth;
        this.profileImg = profileImg;
        this.grade = grade;
    }

    // Getter & Setter
    public String getUserid() {
        return userid;
    }
    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getPassword() {
        return userpw;
    }
    public void setPassword(String password) {
        this.userpw = password;
    }

    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }

    public String getNickname() {
        return nickname;
    }
    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getBirth() {
        return birth;
    }
    public void setBirth(String birth) {
        this.birth = birth;
    }

    public String getProfileImg() {
        return profileImg;
    }
    public void setProfileImg(String profileImg) {
        this.profileImg = profileImg;
    }

    public String getGrade() {
        return grade;
    }
    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // 🔥 추가
    public String getMovieStyle() {
        return movieStyle;
    }
    public void setMovieStyle(String movieStyle) {
        this.movieStyle = movieStyle;
    }
}