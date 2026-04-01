package com.nexusbank.service;

import com.nexusbank.dao.AccountDAO;
import com.nexusbank.dao.TransactionDAO;
import com.nexusbank.model.Account;
import com.nexusbank.model.Transaction; // Added this import
import java.util.List; // Added this import
import java.util.Scanner;

public class BankingService {

    private final AccountDAO accountDAO = new AccountDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();
    private final Scanner scanner = new Scanner(System.in);

    public void createAccount(int userId) {
        accountDAO.createAccount(userId);
        System.out.println("Account created successfully!");
    }

    public void deposit(int userId) {
        Account account = accountDAO.getAccountByUserId(userId);

        if (account == null) {
            System.out.println("No Account Found. Please create account first.");
            return;
        }

        System.out.print("Enter amount to deposit: ");
        double amount = scanner.nextDouble();

        double newBalance = account.getBalance() + amount;

        accountDAO.updateBalance(account.getId(), newBalance);
        transactionDAO.addTransaction(account.getId(), "DEPOSIT", amount);

        System.out.println("Deposit Successful!");
        System.out.println("Updated Balance: " + newBalance);
    }

    public void withdraw(int userId) {
        Account account = accountDAO.getAccountByUserId(userId);

        if (account == null) {
            System.out.println("No Account Found.");
            return;
        }

        System.out.print("Enter amount to withdraw: ");
        double amount = scanner.nextDouble();

        if (amount > account.getBalance()) {
            System.out.println("Insufficient Balance!");
            return;
        }

        double newBalance = account.getBalance() - amount;

        accountDAO.updateBalance(account.getId(), newBalance);
        transactionDAO.addTransaction(account.getId(), "WITHDRAW", amount);

        System.out.println("Withdrawal Successful!");
        System.out.println("Updated Balance: " + newBalance);
    }

    public void viewBalance(int userId) {
        Account account = accountDAO.getAccountByUserId(userId);

        if (account == null) {
            System.out.println("No Account Found.");
            return;
        }

        System.out.println("Current Balance: " + account.getBalance());
    }

    // FIXED: Updated to use the new TransactionDAO method name
    public void viewTransactionHistory(int userId) {
        Account account = accountDAO.getAccountByUserId(userId);

        if (account == null) {
            System.out.println("No Account Found.");
            return;
        }

        // Fetch the list of transactions
        List<Transaction> transactions = transactionDAO.getTransactionsByAccountId(account.getId());

        if (transactions.isEmpty()) {
            System.out.println("No Transactions Found.");
        } else {
            System.out.println("--- Transaction History ---");
            for (Transaction t : transactions) {
                System.out.println(t.getType() + ": $" + t.getAmount() + " on " + t.getTimestamp());
            }
        }
    }
}