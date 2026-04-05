package com.nexusbank.dao;

import com.nexusbank.model.User;
import com.nexusbank.model.Loan;
import com.nexusbank.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // =========================
    // REGISTER USER
    // =========================
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
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

    // =========================
    // APPLY FOR LOAN (With Duplicate Check)
    // =========================
    public boolean hasActiveLoanRequest(int userId) {
        String sql = "SELECT COUNT(*) FROM loans WHERE user_id = ? AND status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean applyForLoan(Loan loan) {
        String sql = "INSERT INTO loans (user_id, amount, purpose, tenure_months, status) VALUES (?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, loan.getUserId());
            ps.setDouble(2, loan.getAmount());
            ps.setString(3, loan.getPurpose());
            ps.setInt(4, loan.getTenure());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Loan Application Failed: " + e.getMessage());
            return false;
        }
    }

    // ===================================
    // MANAGER MODULE: FETCH LOANS
    // ===================================
    public List<Loan> getAllPendingLoans() {
        List<Loan> loans = new ArrayList<>();
        String sql = "SELECT * FROM loans WHERE status = 'PENDING' ORDER BY applied_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Loan loan = new Loan();
                loan.setId(rs.getInt("id"));
                loan.setUserId(rs.getInt("user_id"));
                loan.setAmount(rs.getDouble("amount"));
                loan.setPurpose(rs.getString("purpose"));
                loan.setTenure(rs.getInt("tenure_months"));
                loan.setStatus(rs.getString("status"));
                loan.setAppliedAt(rs.getTimestamp("applied_at"));
                loan.setM1Approved(rs.getBoolean("m1_approved"));
                loan.setM2Approved(rs.getBoolean("m2_approved"));
                loan.setM3Approved(rs.getBoolean("m3_approved"));
                loans.add(loan);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return loans;
    }

    public List<User> getUniqueLoanCustomers() {
        List<User> users = new ArrayList<>();
        // Fetches users who have at least one PENDING loan
        String sql = "SELECT DISTINCT u.id, u.name FROM users u JOIN loans l ON u.id = l.user_id WHERE l.status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                users.add(u);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return users;
    }

    // ===================================
    // MANAGER MODULE: MULTI-TIER UPDATES
    // ===================================
    public boolean updateLoanM1(int loanId, boolean status) {
        String sql = "UPDATE loans SET m1_approved = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status); ps.setInt(2, loanId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateLoanM2(int loanId, boolean status) {
        String sql = "UPDATE loans SET m2_approved = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status); ps.setInt(2, loanId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateLoanM3(int loanId, boolean status) {
        String sql = "UPDATE loans SET m3_approved = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status); ps.setInt(2, loanId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateLoanStatus(int loanId, String status) {
        String sql = "UPDATE loans SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, loanId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ===================================
    // FETCH LOANS BY ID / USER ID
    // ===================================
    public Loan getLoanById(int loanId) {
        String sql = "SELECT * FROM loans WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, loanId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Loan l = new Loan();
                    l.setId(rs.getInt("id"));
                    l.setUserId(rs.getInt("user_id"));
                    l.setAmount(rs.getDouble("amount"));
                    l.setPurpose(rs.getString("purpose"));
                    l.setTenure(rs.getInt("tenure_months"));
                    l.setStatus(rs.getString("status"));
                    l.setM1Approved(rs.getBoolean("m1_approved"));
                    l.setM2Approved(rs.getBoolean("m2_approved"));
                    l.setM3Approved(rs.getBoolean("m3_approved"));
                    return l;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Loan> getLoansByUserId(int userId) {
        List<Loan> list = new ArrayList<>();
        String sql = "SELECT * FROM loans WHERE user_id = ? ORDER BY applied_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Loan l = new Loan();
                    l.setId(rs.getInt("id"));
                    l.setAmount(rs.getDouble("amount"));
                    l.setPurpose(rs.getString("purpose"));
                    l.setTenure(rs.getInt("tenure_months"));
                    l.setStatus(rs.getString("status"));
                    l.setAppliedAt(rs.getTimestamp("applied_at"));
                    l.setM1Approved(rs.getBoolean("m1_approved"));
                    l.setM2Approved(rs.getBoolean("m2_approved"));
                    l.setM3Approved(rs.getBoolean("m3_approved"));
                    list.add(l);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}