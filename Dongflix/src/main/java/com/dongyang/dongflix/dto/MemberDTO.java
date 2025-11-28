package com.dongyang.dongflix.dto;

public class MemberDTO {
    private String userid;
    private String userpw;
    private String username;  
    private String nickname;     
    private String phone;       
    private String birth;        
    private String profileImg;  
    private String grade;

    public MemberDTO() {}

    public MemberDTO(String userid, String password, String username) {
        this.userid = userid;
        this.userpw = password;
        this.username = username;
    }


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

    public String getUserid() { return userid; }
    public void setUserid(String userid) { this.userid = userid; }

    public String getPassword() { return userpw; }
    public void setPassword(String password) { this.userpw = password; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getBirth() { return birth; }
    public void setBirth(String birth) { this.birth = birth; }

    public String getProfileImg() { return profileImg; }
    public void setProfileImg(String profileImg) { this.profileImg = profileImg; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }
}
