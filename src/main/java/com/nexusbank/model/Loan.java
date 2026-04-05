package com.nexusbank.model;

import java.sql.Timestamp;

public class Loan {
    private int id;
    private int userId;
    private double amount;
    private String purpose;
    private int tenure;
    private String status;
    private Timestamp appliedAt;

    // Multi-tier Approval Fields
    private boolean m1Approved;
    private boolean m2Approved;
    private boolean m3Approved;

    // Constructors
    public Loan() {}

    public Loan(int userId, double amount, String purpose, int tenure) {
        this.userId = userId;
        this.amount = amount;
        this.purpose = purpose;
        this.tenure = tenure;
        this.status = "PENDING";
        this.m1Approved = false;
        this.m2Approved = false;
        this.m3Approved = false;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }

    public int getTenure() { return tenure; }
    public void setTenure(int tenure) { this.tenure = tenure; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getAppliedAt() { return appliedAt; }
    public void setAppliedAt(Timestamp appliedAt) { this.appliedAt = appliedAt; }

    // Multi-tier Approval Getters and Setters
    public boolean isM1Approved() { return m1Approved; }
    public void setM1Approved(boolean m1Approved) { this.m1Approved = m1Approved; }

    public boolean isM2Approved() { return m2Approved; }
    public void setM2Approved(boolean m2Approved) { this.m2Approved = m2Approved; }

    public boolean isM3Approved() { return m3Approved; }
    public void setM3Approved(boolean m3Approved) { this.m3Approved = m3Approved; }
}