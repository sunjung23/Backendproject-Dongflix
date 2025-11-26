package com.dongyang.dongflix;

public class MemberDTO {
    private String userid;
    private String userpw;
    private String username;     // DB의 name 컬럼
    private String nickname;     // 새 컬럼
    private String phone;        // 새 컬럼
    private String birth;        // 새 컬럼 (문자열로 처리)
    private String profileImg;   // 새 컬럼 (URL 또는 경로)
    private String grade;

    public MemberDTO() {}

    // 기존 코드에서 사용하는 기본 생성자 (userid, password, username)
    public MemberDTO(String userid, String password, String username) {
        this.userid = userid;
        this.userpw = password;
        this.username = username;
    }

    // 필요하면 전체 필드 사용하는 생성자
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
