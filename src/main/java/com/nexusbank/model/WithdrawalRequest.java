package com.nexusbank.model;

public class WithdrawalRequest {
    private int id;
    private int userId;
    private double amount;
    private String status;
    private boolean m1Approved;
    private boolean m2Approved;
    private boolean m3Approved;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // IMPORTANT: Note the Capital 'M' here
    public boolean isM1Approved() { return m1Approved; }
    public void setM1Approved(boolean m1Approved) { this.m1Approved = m1Approved; }

    public boolean isM2Approved() { return m2Approved; }
    public void setM2Approved(boolean m2Approved) { this.m2Approved = m2Approved; }

    public boolean isM3Approved() { return m3Approved; }
    public void setM3Approved(boolean m3Approved) { this.m3Approved = m3Approved; }
}