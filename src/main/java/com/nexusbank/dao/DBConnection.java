package com.nexusbank.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Using direct IP and trustServerCertificate to bypass DNS and SSL handshake issues
    private static final String URL = "jdbc:mysql://159.89.160.106:25703/defaultdb?useSSL=true&trustServerCertificate=true&allowPublicKeyRetrieval=true";
    private static final String USER = "avnadmin";
    private static final String PASSWORD = "AVNS_er4pernAdjIsPxZ74qi";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Explicitly load the driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect using the direct IP URL
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
