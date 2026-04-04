package com.nexusbank.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Cleaned URL - no spaces, simplified SSL parameters
    private static final String URL = "jdbc:mysql://mysql-3d69d530-kshitijshelake87-a833.e.aivencloud.com:25703/defaultdb?useSSL=true&trustServerCertificate=true&allowPublicKeyRetrieval=true";
    private static final String USER = "avnadmin";
    private static final String PASSWORD = "AVNS_er4pernAdjIsPxZ74qi";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Force the driver to load
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Attempt connection
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
            if (conn != null) {
                System.out.println("Cloud Database Connection Successful!");
            }
        } catch (Exception e) {
            System.err.println("Cloud Database Connection Failed!");
            e.printStackTrace();
        }
        return conn;
    }
}
