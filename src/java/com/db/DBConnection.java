package com.db;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static Connection conn = null;

    public static Connection getConnection() {
        try {
            // Only create a new one if the connection isn't already made or has been lost.
            if (conn == null || conn.isClosed()) {
                
                
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                
                String url = "jdbc:mysql://localhost:3306/college_events_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8";
                
                
                String user = "root";
                String password = "#your mysql password"; 

                conn = DriverManager.getConnection(url, user, password);
                System.out.println("Database Connected Successfully with Driver 9.0.0!");
            }
        } catch (Exception e) {
            // if any error came then print in server console 
            System.out.println("DBConnection Class Error: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
}