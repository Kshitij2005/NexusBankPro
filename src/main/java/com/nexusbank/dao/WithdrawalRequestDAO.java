package com.nexusbank.dao;

import com.nexusbank.model.WithdrawalRequest;
import com.nexusbank.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WithdrawalRequestDAO {

    public boolean createRequest(int userId, double amount) {
        String sql = "INSERT INTO withdrawal_requests (user_id, amount, status, m1_approved, m2_approved, m3_approved) VALUES (?, ?, 'PENDING', 0, 0, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDouble(2, amount);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public WithdrawalRequest getRequestById(int id) {
        String sql = "SELECT * FROM withdrawal_requests WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToRequest(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /**
     * Gets a list of unique users who have pending withdrawal requests.
     * Includes Name and Account Number for the Manager Directory.
     */
    public List<User> getUniqueCustomersWithRequests() {
        List<User> customers = new ArrayList<>();
        // Using 'account_number' to match your database exactly
        String sql = "SELECT DISTINCT u.id, u.name, a.account_number " +
                "FROM users u " +
                "JOIN accounts a ON u.id = a.user_id " +
                "JOIN withdrawal_requests wr ON u.id = wr.user_id " +
                "WHERE wr.status NOT IN ('COMPLETED') AND wr.status NOT LIKE 'FAILED%' " +
                "ORDER BY u.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setAccountNumber(rs.getString("account_number")); // Matches User.java field
                customers.add(u);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return customers;
    }

    /**
     * Gets all withdrawal requests for a specific customer.
     * Includes the auto-fail balance check logic.
     */
    public List<WithdrawalRequest> getRequestsByUserId(int userId) {
        List<WithdrawalRequest> requests = new ArrayList<>();
        String sql = "SELECT * FROM withdrawal_requests WHERE user_id = ? ORDER BY id DESC";
        AccountDAO accountDAO = new AccountDAO();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WithdrawalRequest req = mapResultSetToRequest(rs);
                    // Live balance check: Auto-fail if user spent money elsewhere
                    if (!req.getStatus().equals("COMPLETED") && !req.getStatus().contains("FAILED")) {
                        double currentBal = accountDAO.getLatestBalance(req.getUserId());
                        if (currentBal < req.getAmount()) {
                            updateStatus(req.getId(), "FAILED (Insufficient Funds)");
                            req.setStatus("FAILED (Insufficient Funds)");
                        }
                    }
                    requests.add(req);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return requests;
    }

    public boolean hasActiveInProcessRequest(int userId, int currentRequestId) {
        String sql = "SELECT COUNT(*) FROM withdrawal_requests WHERE user_id = ? " +
                "AND status NOT IN ('PENDING', 'COMPLETED') " +
                "AND status NOT LIKE 'REJECTED%' " +
                "AND status NOT LIKE 'FAILED%' " +
                "AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, currentRequestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public void updateM1Status(int requestId, String status) {
        String sql = "UPDATE withdrawal_requests SET m1_approved = 1, status = ? WHERE id = ?";
        executeUpdate(sql, status, requestId);
    }

    public void updateM2Status(int requestId, String status) {
        String sql = "UPDATE withdrawal_requests SET m2_approved = 1, status = ? WHERE id = ?";
        executeUpdate(sql, status, requestId);
    }

    public void updateM3Status(int requestId, String status) {
        String sql = "UPDATE withdrawal_requests SET m3_approved = 1, status = ? WHERE id = ?";
        executeUpdate(sql, status, requestId);
    }

    public void updateStatus(int requestId, String status) {
        String sql = "UPDATE withdrawal_requests SET status = ? WHERE id = ?";
        executeUpdate(sql, status, requestId);
    }

    private void executeUpdate(String sql, String status, int requestId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, requestId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    private WithdrawalRequest mapResultSetToRequest(ResultSet rs) throws SQLException {
        WithdrawalRequest req = new WithdrawalRequest();
        req.setId(rs.getInt("id"));
        req.setUserId(rs.getInt("user_id"));
        req.setAmount(rs.getDouble("amount"));
        req.setStatus(rs.getString("status"));
        req.setM1Approved(rs.getBoolean("m1_approved"));
        req.setM2Approved(rs.getBoolean("m2_approved"));
        req.setM3Approved(rs.getBoolean("m3_approved"));
        return req;
    }
}