package com.nexusbank.dao;

import com.nexusbank.model.User;
import com.nexusbank.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    // =========================
    // REGISTER USER
    // =========================
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";

        // Note: No import needed for DBConnection because it's in the same package
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, PasswordUtil.hashPassword(user.getPassword()));
            stmt.setString(4, (user.getRole() != null) ? user.getRole() : "USER");

            stmt.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.err.println("Registration Failed: " + e.getMessage());
            return false;
        }
    }

    // =========================
    // LOGIN USER
    // =========================
    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, PasswordUtil.hashPassword(password));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    return user;
                }
            }

        } catch (SQLException e) {
            System.err.println("Login Failed: " + e.getMessage());
        }
        return null;
    }
}