package com.nexusbank.controller;

import com.nexusbank.dao.WithdrawalRequestDAO;
import com.nexusbank.dao.TransactionDAO;
import com.nexusbank.dao.AccountDAO;
import com.nexusbank.dao.UserDAO; // Added for Loans
import com.nexusbank.model.Account;
import com.nexusbank.model.User;
import com.nexusbank.model.WithdrawalRequest;
import com.nexusbank.model.Transaction;
import com.nexusbank.model.Loan; // Added for Loans
import com.nexusbank.service.AccountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewBalance")
public class ViewBalanceServlet extends HttpServlet {
    private AccountService accountService = new AccountService();
    private WithdrawalRequestDAO requestDAO = new WithdrawalRequestDAO();
    private TransactionDAO transactionDAO = new TransactionDAO();
    private UserDAO userDAO = new UserDAO(); // Added for Loans

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            // 1. Fetch fresh account balance
            Account account = accountService.getAccountDetails(user.getId());
            session.setAttribute("account", account);

            if (account != null) {
                // 2. Fetch withdrawal tracking (M1/M2/M3 status)
                List<WithdrawalRequest> userRequests = requestDAO.getRequestsByUserId(user.getId());
                request.setAttribute("userRequests", userRequests);

                // 3. Fetch ACTUAL Transaction History
                List<Transaction> transactions = transactionDAO.getTransactionsByAccountId(account.getId());
                request.setAttribute("transactions", transactions);

                // 4. NEW: Fetch Loan Applications for this user
                List<Loan> userLoans = userDAO.getLoansByUserId(user.getId());
                request.setAttribute("userLoans", userLoans);
            }

            // Forward to the dashboard
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}