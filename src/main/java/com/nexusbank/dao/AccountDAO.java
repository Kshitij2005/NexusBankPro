package com.nexusbank.dao;

import com.nexusbank.model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDAO {

    public Account getAccountByUserId(int userId) {
        String query = "SELECT * FROM accounts WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account account = new Account();
                    account.setId(rs.getInt("id"));
                    account.setUserId(rs.getInt("user_id"));
                    account.setAccountNumber(rs.getString("account_number"));
                    account.setBalance(rs.getDouble("balance"));
                    return account;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Helper to get ONLY the latest balance specifically for the Safety Wall
    public double getLatestBalance(int userId) {
        String query = "SELECT balance FROM accounts WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("balance");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0.0;
    }

    // NEW: Find a User ID by an Account Number (Crucial for Transfers)
    public int getUserIdByAccountNumber(String accountNo) {
        String sql = "SELECT user_id FROM accounts WHERE account_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, accountNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("user_id");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1; // Not found
    }

    // NEW: Atomic Fund Transfer (Debit one, Credit other)
    public boolean transferFunds(int senderId, int receiverId, double amount) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // 1. Debit Sender (only if they have enough money)
            String debitSql = "UPDATE accounts SET balance = balance - ? WHERE user_id = ? AND balance >= ?";
            try (PreparedStatement psDebit = conn.prepareStatement(debitSql)) {
                psDebit.setDouble(1, amount);
                psDebit.setInt(2, senderId);
                psDebit.setDouble(3, amount);
                int rows = psDebit.executeUpdate();
                if (rows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // 2. Credit Receiver
            String creditSql = "UPDATE accounts SET balance = balance + ? WHERE user_id = ?";
            try (PreparedStatement psCredit = conn.prepareStatement(creditSql)) {
                psCredit.setDouble(1, amount);
                psCredit.setInt(2, receiverId);
                int rows = psCredit.executeUpdate();
                if (rows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit(); // Success: Save both changes
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException e) {}
        }
    }

    // Updates balance relative to current (e.g., +500 or -500)
    public void updateBalanceByUserId(int userId, double amountChange) {
        String query = "UPDATE accounts SET balance = balance + ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDouble(1, amountChange);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // Sets an absolute balance (Used for administrative overrides)
    public void updateBalance(int accountId, double newBalance) {
        String query = "UPDATE accounts SET balance = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDouble(1, newBalance);
            ps.setInt(2, accountId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public int getAccountIdByUserId(int userId) {
        String query = "SELECT id FROM accounts WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public void createAccount(int userId) {
        String dummyAccNo = "NEX" + (int)(Math.random() * 1000000);
        String query = "INSERT INTO accounts (user_id, account_number, balance) VALUES (?, ?, 0.0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, dummyAccNo);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}