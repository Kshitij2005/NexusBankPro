package com.nexusbank.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Updated URL: Changed ssl-mode to useSSL for better compatibility with Render
    private static final String URL = "jdbc:mysql://mysql-3d69d530-kshitijshelake87-a833.e.aivencloud.com:25703/defaultdb?useSSL=true&trustServerCertificate=true";

    // Your Aiven Username
    private static final String USER = "avnadmin";

    // Your Aiven Password
    private static final String PASSWORD = "AVNS_er4pernAdjIsPxZ74qi";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // FORCE LOAD MYSQL DRIVER
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connecting to Cloud Database
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
            if (conn != null) {
                System.out.println("Cloud Database Connection Successful!");
            }

        } catch (Exception e) {
            System.out.println("Cloud Database Connection Failed!");
            // This will show exactly WHY it failed in your Render logs
            e.printStackTrace();
        }
        return conn;
    }
}
