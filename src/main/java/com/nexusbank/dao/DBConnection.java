package com.nexusbank.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Final Universal SSL String for Aiven-to-Render
    private static final String URL = "jdbc:mysql://mysql-3d69d530-kshitijshelake87-a833.e.aivencloud.com:25703/defaultdb?"
            + "useSSL=true&"
            + "trustServerCertificate=true&"
            + "allowPublicKeyRetrieval=true&"
            + "sslMode=DISABLED"; // Disables the strict path validation causing your error

    private static final String USER = "avnadmin";
    private static final String PASSWORD = "AVNS_er4pernAdjIsPxZ74qi";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 10 second timeout
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
