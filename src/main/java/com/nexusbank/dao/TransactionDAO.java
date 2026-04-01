package com.nexusbank.dao;

import com.nexusbank.model.Transaction;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    // ==========================================
    // RECORD A NEW TRANSACTION (Deposit or Withdrawal)
    // ==========================================
    public void addTransaction(int accountId, String type, double amount) {
        String sql = "INSERT INTO transactions (account_id, type, amount, transaction_date) VALUES (?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, accountId);
            stmt.setString(2, type);
            stmt.setDouble(3, amount);

            int rowsAffected = stmt.executeUpdate();
            System.out.println("DEBUG: Transaction recorded! Type: " + type + " | Rows: " + rowsAffected);

        } catch (SQLException e) {
            System.err.println("CRITICAL ERROR: Transaction Recording Failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ==========================================
    // FETCH ALL TRANSACTIONS FOR THE DASHBOARD
    // ==========================================
    public List<Transaction> getTransactionsByAccountId(int accountId) {
        List<Transaction> transactions = new ArrayList<>();
        // Fetching specifically by account_id and ordering by newest first
        String sql = "SELECT id, account_id, type, amount, transaction_date FROM transactions WHERE account_id = ? ORDER BY transaction_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, accountId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Transaction t = new Transaction();
                    t.setId(rs.getInt("id"));
                    t.setAccountId(rs.getInt("account_id"));
                    t.setType(rs.getString("type"));
                    t.setAmount(rs.getDouble("amount"));
                    // Make sure Transaction model uses java.sql.Timestamp
                    t.setTimestamp(rs.getTimestamp("transaction_date"));
                    transactions.add(t);
                }
            }
            System.out.println("DEBUG: Found " + transactions.size() + " transactions for Account ID: " + accountId);

        } catch (SQLException e) {
            System.err.println("CRITICAL ERROR: Error Fetching Transactions: " + e.getMessage());
            e.printStackTrace();
        }
        return transactions;
    }
}