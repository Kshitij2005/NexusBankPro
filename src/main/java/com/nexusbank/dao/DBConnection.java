package com.nexusbank.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Simplified URL for Aiven-to-Render compatibility
    private static final String URL = "jdbc:mysql://mysql-3d69d530-kshitijshelake87-a833.e.aivencloud.com:25703/defaultdb?sslMode=VERIFY_IDENTITY&enabledTLSProtocols=TLSv1.2,TLSv1.3";
    private static final String USER = "avnadmin";
    private static final String PASSWORD = "AVNS_er4pernAdjIsPxZ74qi";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Setting a timeout so the app doesn't hang forever
            DriverManager.setLoginTimeout(10); 
            
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
            if (conn != null) {
                System.out.println(">>> CLOUD DATABASE CONNECTED SUCCESSFULLY! <<<");
            }
        } catch (Exception e) {
            System.err.println(">>> CLOUD DATABASE CONNECTION FAILED! <<<");
            e.printStackTrace();
        }
        return conn;
    }
}
