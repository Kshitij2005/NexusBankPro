package com.nexusbank.service;

import com.nexusbank.dao.AccountDAO;
import com.nexusbank.dao.TransactionDAO;
import com.nexusbank.dao.WithdrawalRequestDAO;
import com.nexusbank.model.Account;

public class AccountService {
    private final AccountDAO accountDAO = new AccountDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();
    private final WithdrawalRequestDAO requestDAO = new WithdrawalRequestDAO();

    public boolean deposit(int userId, double amount) {
        try {
            Account account = accountDAO.getAccountByUserId(userId);
            if (account == null) {
                accountDAO.createAccount(userId);
            }

            // FIXED: Using updateBalanceByUserId to ADD the amount to existing balance
            accountDAO.updateBalanceByUserId(userId, amount);

            // Record transaction
            int accountId = accountDAO.getAccountIdByUserId(userId);
            transactionDAO.addTransaction(accountId, "DEPOSIT", amount);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String withdraw(int userId, double amount) {
        try {
            Account account = accountDAO.getAccountByUserId(userId);
            if (account == null || account.getBalance() < amount) {
                return "Insufficient Balance";
            }

            boolean requestCreated = requestDAO.createRequest(userId, amount);

            if (requestCreated) {
                if (amount < 1000000) {
                    return "Pending: Needs M1 Manager Approval";
                } else if (amount >= 1100000 && amount <= 2400000) {
                    return "Pending: Needs M2 Manager Approval";
                } else if (amount >= 2500000) {
                    return "Pending: High Value - Needs M1, M2, and M3 Approval";
                }
                return "Withdrawal Request Submitted for Approval";
            } else {
                return "Error: Could not submit request";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "System Error: " + e.getMessage();
        }
    }

    public Account getAccountDetails(int userId) {
        return accountDAO.getAccountByUserId(userId);
    }
}