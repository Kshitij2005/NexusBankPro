package com.nexusbank.controller;

import com.nexusbank.dao.WithdrawalRequestDAO;
import com.nexusbank.dao.AccountDAO;
import com.nexusbank.dao.TransactionDAO;
import com.nexusbank.model.Account;
import com.nexusbank.model.User;
import com.nexusbank.model.WithdrawalRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/approveRequest")
public class ApproveServlet extends HttpServlet {
    private WithdrawalRequestDAO requestDAO = new WithdrawalRequestDAO();
    private AccountDAO accountDAO = new AccountDAO();
    private TransactionDAO transactionDAO = new TransactionDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User manager = (User) session.getAttribute("user");

        if (manager == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            WithdrawalRequest wr = requestDAO.getRequestById(requestId);

            if (wr == null) {
                response.sendRedirect("managerDashboard?error=Request+Not+Found");
                return;
            }

            String role = manager.getRole();
            double amount = wr.getAmount();
            boolean isFinalStep = false;

            // 1. TIERED APPROVAL LOGIC (Matching your 5L / 24L / 25L rules)
            if (role.equals("M1")) {
                requestDAO.updateM1Status(requestId, "APPROVED (M1)");
                if (amount <= 500000) isFinalStep = true;
            }
            else if (role.equals("M2")) {
                requestDAO.updateM2Status(requestId, "APPROVED (M2)");
                if (amount > 500000 && amount <= 2400000) isFinalStep = true;
            }
            else if (role.equals("M3")) {
                requestDAO.updateM3Status(requestId, "APPROVED (M3)");
                if (amount >= 2500000) isFinalStep = true;
            }

            // 2. FINAL DEDUCTION LOGIC
            if (isFinalStep) {
                // Safety check: Fetch latest balance from DB
                double currentBalance = accountDAO.getLatestBalance(wr.getUserId());

                if (currentBalance >= amount) {
                    // Update Status to COMPLETED
                    requestDAO.updateStatus(requestId, "COMPLETED");

                    // Deduct money
                    accountDAO.updateBalanceByUserId(wr.getUserId(), -amount);

                    // Log to Transaction History
                    int accountId = accountDAO.getAccountIdByUserId(wr.getUserId());
                    transactionDAO.addTransaction(accountId, "WITHDRAWAL", amount);

                    response.sendRedirect("managerDashboard?message=Withdrawal+Completed+Successfully");
                } else {
                    // Safety Wall: Reject if balance is now too low
                    requestDAO.updateStatus(requestId, "REJECTED (Insufficient Funds)");
                    response.sendRedirect("managerDashboard?error=Insufficient+User+Funds");
                }
            } else {
                response.sendRedirect("managerDashboard?message=Approval+Recorded+Waiting+for+next+tier");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("managerDashboard?error=Processing+Error");
        }
    }
}