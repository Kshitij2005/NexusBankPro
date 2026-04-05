package com.nexusbank.controller;

import com.nexusbank.dao.UserDAO;
import com.nexusbank.dao.AccountDAO;
import com.nexusbank.dao.TransactionDAO;
import com.nexusbank.model.User;
import com.nexusbank.model.Loan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/approveLoan")
public class ApproveLoanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User manager = (User) session.getAttribute("user");

        // 1. Security Check
        if (manager == null || !manager.getRole().startsWith("M")) {
            response.sendRedirect("login.jsp?error=Unauthorized");
            return;
        }

        int loanId = Integer.parseInt(request.getParameter("loanId"));
        String action = request.getParameter("action"); // "APPROVED" or "REJECTED"
        String role = manager.getRole();

        UserDAO userDAO = new UserDAO();
        boolean isFinalPayout = false;

        // 2. Handle Rejection (Instant for any manager)
        if ("REJECTED".equals(action)) {
            userDAO.updateLoanStatus(loanId, "REJECTED");
            response.sendRedirect("managerDashboard?message=Loan+Rejected");
            return;
        }

        // 3. Handle Sequential Multi-tier Approval
        if ("APPROVED".equals(action)) {
            if (role.equals("M1")) {
                userDAO.updateLoanM1(loanId, true);
            }
            else if (role.equals("M2")) {
                // Logic: M2 can only sign if M1 has already signed
                Loan currentLoan = userDAO.getLoanById(loanId);
                if (currentLoan != null && currentLoan.isM1Approved()) {
                    userDAO.updateLoanM2(loanId, true);
                } else {
                    response.sendRedirect("managerDashboard?error=Wait+for+M1+Signature");
                    return;
                }
            }
            else if (role.equals("M3")) {
                // Logic: M3 can only sign if M1 and M2 have already signed
                Loan currentLoan = userDAO.getLoanById(loanId);
                if (currentLoan != null && currentLoan.isM1Approved() && currentLoan.isM2Approved()) {
                    userDAO.updateLoanM3(loanId, true);
                    isFinalPayout = true; // M3 triggers the money!
                } else {
                    response.sendRedirect("managerDashboard?error=Wait+for+M1+and+M2+Signatures");
                    return;
                }
            }
        }

        // 4. Final Payout Logic (Only runs after M3 Approval)
        if (isFinalPayout) {
            userDAO.updateLoanStatus(loanId, "APPROVED");
            Loan loan = userDAO.getLoanById(loanId);

            if (loan != null) {
                AccountDAO accDAO = new AccountDAO();
                TransactionDAO txDAO = new TransactionDAO();

                // Inject Capital into User Account
                accDAO.updateBalanceByUserId(loan.getUserId(), loan.getAmount());

                // Create Audit Trail (Transaction Log)
                int accId = accDAO.getAccountIdByUserId(loan.getUserId());
                txDAO.addTransaction(accId, "LOAN DISBURSEMENT", loan.getAmount());
            }
        }

        response.sendRedirect("managerDashboard?message=Status+Updated+Successfully");
    }
}