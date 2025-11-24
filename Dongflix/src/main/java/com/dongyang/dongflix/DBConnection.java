package com.dongyang.dongflix;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
	public static Connection getConnection() {
		Connection conn = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			String url = "jdbc:mysql://localhost:3307/memberdb?characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
			String user = "team03";
			String pw = "3team";
			
			conn =  DriverManager.getConnection(url, user, pw);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}

}
