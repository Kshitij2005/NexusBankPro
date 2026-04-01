package com.nexusbank.controller;

import com.nexusbank.dao.AccountDAO;
import com.nexusbank.dao.TransactionDAO;
import com.nexusbank.model.User;
import com.nexusbank.model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/transferMoney")
public class TransferServlet extends HttpServlet {
    private AccountDAO accountDAO = new AccountDAO();
    private TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User senderUser = (User) session.getAttribute("user");
        String path = request.getContextPath();

        if (senderUser == null) {
            response.sendRedirect(path + "/login.jsp");
            return;
        }

        String receiverAccNo = request.getParameter("receiverAccNo");
        String amountStr = request.getParameter("amount");

        try {
            double amount = Double.parseDouble(amountStr);
            Account senderAcc = accountDAO.getAccountByUserId(senderUser.getId());

            // 1. Validation
            if (amount <= 0) {
                response.sendRedirect(path + "/viewBalance?error=Invalid+amount");
                return;
            }

            // 2. Find Receiver
            int receiverId = accountDAO.getUserIdByAccountNumber(receiverAccNo);
            if (receiverId == -1) {
                response.sendRedirect(path + "/viewBalance?error=Receiver+account+not+found");
                return;
            }

            // 3. Prevent Self-Transfer
            if (receiverAccNo.equals(senderAcc.getAccountNumber())) {
                response.sendRedirect(path + "/viewBalance?error=Cannot+transfer+to+yourself");
                return;
            }

            // 4. Execute Transfer (Database balances)
            boolean success = accountDAO.transferFunds(senderUser.getId(), receiverId, amount);

            if (success) {
                // 5. LOGGING
                int senderAccId = senderAcc.getId();
                int receiverAccId = accountDAO.getAccountIdByUserId(receiverId);

                // Update SENDER'S Log (Debit)
                transactionDAO.addTransaction(senderAccId, "TRANSFER TO: " + receiverAccNo, amount);

                // Update RECEIVER'S Log (Credit)
                transactionDAO.addTransaction(receiverAccId, "TRANSFER FROM: " + senderAcc.getAccountNumber(), amount);

                // REDIRECT TO SERVLET (Crucial for refreshing logs)
                response.sendRedirect(path + "/viewBalance?message=Transfer+Successful");
            } else {
                response.sendRedirect(path + "/viewBalance?error=Insufficient+Balance");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(path + "/viewBalance?error=System+Error");
        }
    }
}