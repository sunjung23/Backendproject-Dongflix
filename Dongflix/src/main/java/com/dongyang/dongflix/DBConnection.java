package com.dongyang.dongflix;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = "jdbc:mysql://caboose.proxy.rlwy.net:13848/railway?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";
            String user = "root";
            String pw = "peFGqfaJijwDqzkIgfgARzqtMEemSdtE";

            conn = DriverManager.getConnection(url, user, pw);

            System.out.println(">>> DB 연결 성공!");

        } catch (Exception e) {
            System.out.println(">>> DB 연결 실패");
            e.printStackTrace();
        }
        return conn;
    }
}