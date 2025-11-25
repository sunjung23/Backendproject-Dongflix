package com.dongyang.dongflix;

public class MemberDTO {
	private String userid;
	private String userpw;
	private String username;
	

    public MemberDTO() {}

    public MemberDTO(String userid, String password, String username) {
        this.userid = userid;
        this.userpw = password;
        this.username = username;
    }

    public String getUserid() { return userid; }
    public void setUserid(String userid) { this.userid = userid; }

    public String getPassword() { return userpw; }
    public void setPassword(String password) { this.userpw = password; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
}