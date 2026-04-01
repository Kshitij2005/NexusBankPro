package com.nexusbank.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Updated URL with your Aiven Cloud Host, Port, and defaultdb name
    private static final String URL = "jdbc:mysql://mysql-3d69d530-kshitijshelake87-a833.e.aivencloud.com:25703/defaultdb?ssl-mode=REQUIRED";

    // Updated Username from your Aiven screenshot
    private static final String USER = "avnadmin";

    // Updated Password from your Aiven screenshot
    private static final String PASSWORD = "AVNS_er4pernAdjIsPxZ74qi";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // LOAD MYSQL DRIVER
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connecting to Cloud Database
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Cloud Database Connection Successful!");

        } catch (Exception e) {
            System.out.println("Cloud Database Connection Failed!");
            e.printStackTrace();
        }
        return conn;
    }
}