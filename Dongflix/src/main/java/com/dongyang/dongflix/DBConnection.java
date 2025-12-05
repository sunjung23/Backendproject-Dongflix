package com.dongyang.dongflix;

import java.sql.Connection;
import java.sql.SQLException;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class DBConnection {

    private static HikariDataSource ds;

    // HikariCP 초기화 
    static {
        try {
            HikariConfig config = new HikariConfig();

            config.setJdbcUrl("jdbc:mysql://caboose.proxy.rlwy.net:13848/railway?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8");
            config.setUsername("root");
            config.setPassword("peFGqfaJijwDqzkIgfgARzqtMEemSdtE");

            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

            config.setMaximumPoolSize(10);     
            config.setMinimumIdle(2);         
            config.setConnectionTimeout(3000);    
            config.setIdleTimeout(600000);        
            config.setMaxLifetime(1800000);       
            
            ds = new HikariDataSource(config);

            System.out.println(" HikariCP Connection Pool 초기화 완료");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }
}