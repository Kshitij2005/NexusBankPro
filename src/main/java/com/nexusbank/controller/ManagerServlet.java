package com.nexusbank.controller;

import com.nexusbank.dao.WithdrawalRequestDAO;
import com.nexusbank.dao.TransactionDAO;
import com.nexusbank.dao.AccountDAO;
import com.nexusbank.dao.UserDAO;
import com.nexusbank.model.User;
import com.nexusbank.model.WithdrawalRequest;
import com.nexusbank.model.Loan;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/managerDashboard")
public class ManagerServlet extends HttpServlet {
    private WithdrawalRequestDAO requestDAO = new WithdrawalRequestDAO();
    private TransactionDAO transactionDAO = new TransactionDAO();
    private AccountDAO accountDAO = new AccountDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Security Check: Only Managers (M1, M2, M3) can enter
        if (user == null || (!user.getRole().equals("M1") && !user.getRole().equals("M2") && !user.getRole().equals("M3"))) {
            response.sendRedirect("login.jsp?error=Access+Denied");
            return;
        }

        // ==========================================
        // 2. LOAN DIRECTORY LOGIC (UPDATED)
        // ==========================================
        String viewLoanCustomerId = request.getParameter("viewLoanCustomer");

        if (viewLoanCustomerId != null) {
            try {
                int userId = Integer.parseInt(viewLoanCustomerId);
                // Fetch all loans (Pending, Approved, Rejected) for this specific user
                List<Loan> specificUserLoans = userDAO.getLoansByUserId(userId);
                request.setAttribute("specificUserLoans", specificUserLoans);
                request.setAttribute("viewingLoanDetails", true);
            } catch (NumberFormatException e) {
                response.sendRedirect("managerDashboard?error=Invalid+Customer+ID");
                return;
            }
        } else {
            // Fetch unique users who have at least one PENDING loan
            List<User> loanCustomers = userDAO.getUniqueLoanCustomers();
            request.setAttribute("loanCustomerList", loanCustomers);
            request.setAttribute("viewingLoanDetails", false);
        }

        // ==========================================
        // 3. WITHDRAWAL LOGIC (DIRECTORY STYLE)
        // ==========================================
        String viewCustomerId = request.getParameter("viewCustomer");

        if (viewCustomerId != null) {
            try {
                int userId = Integer.parseInt(viewCustomerId);
                List<WithdrawalRequest> customerRequests = requestDAO.getRequestsByUserId(userId);
                request.setAttribute("pendingRequests", customerRequests);
                request.setAttribute("viewingCustomer", true);
            } catch (NumberFormatException e) {
                response.sendRedirect("managerDashboard?error=Invalid+Customer+ID");
                return;
            }
        } else {
            List<User> customers = requestDAO.getUniqueCustomersWithRequests();
            request.setAttribute("customerList", customers);
            request.setAttribute("viewingCustomer", false);
        }

        // 4. Forward to the JSP
        request.getRequestDispatcher("manager_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User manager = (User) session.getAttribute("user");

        if (manager == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String requestIdStr = request.getParameter("requestId");
        String action = request.getParameter("action");
        String role = manager.getRole();

        // ==========================================
        // WITHDRAWAL APPROVAL PROCESSING
        // ==========================================
        if (requestIdStr != null && "approve".equals(action)) {
            int requestId = Integer.parseInt(requestIdStr);
            WithdrawalRequest wr = requestDAO.getRequestById(requestId);
            if (wr == null) return;

            double amount = wr.getAmount();
            double currentBalance = accountDAO.getLatestBalance(wr.getUserId());

            if (currentBalance < amount) {
                requestDAO.updateStatus(requestId, "FAILED (Insufficient Funds)");
                response.sendRedirect("managerDashboard?viewCustomer=" + wr.getUserId() + "&error=Insufficient+Balance");
                return;
            }

            if (requestDAO.hasActiveInProcessRequest(wr.getUserId(), requestId)) {
                response.sendRedirect("managerDashboard?viewCustomer=" + wr.getUserId() + "&error=Finish+active+request+first");
                return;
            }

            boolean isFinalStep = false;

            if (role.equals("M1") && !wr.isM1Approved()) {
                requestDAO.updateM1Status(requestId, "APPROVED (M1)");
                if (amount <= 500000) isFinalStep = true;
            }
            else if (role.equals("M2")) {
                if (wr.isM1Approved() && !wr.isM2Approved()) {
                    requestDAO.updateM2Status(requestId, "APPROVED (M2)");
                    if (amount >= 600000 && amount <= 2400000) isFinalStep = true;
                } else if (!wr.isM1Approved()) {
                    response.sendRedirect("managerDashboard?viewCustomer=" + wr.getUserId() + "&error=Wait+for+M1+Approval");
                    return;
                }
            }
            else if (role.equals("M3")) {
                if (wr.isM1Approved() && wr.isM2Approved() && !wr.isM3Approved()) {
                    requestDAO.updateM3Status(requestId, "APPROVED (M3)");
                    if (amount >= 2500000) isFinalStep = true;
                } else {
                    response.sendRedirect("managerDashboard?viewCustomer=" + wr.getUserId() + "&error=Wait+for+M1/M2+Approval");
                    return;
                }
            }

            if (isFinalStep) {
                double finalBalance = accountDAO.getLatestBalance(wr.getUserId());
                if (finalBalance >= amount) {
                    requestDAO.updateStatus(requestId, "COMPLETED");
                    accountDAO.updateBalanceByUserId(wr.getUserId(), -amount);
                    int accountId = accountDAO.getAccountIdByUserId(wr.getUserId());
                    transactionDAO.addTransaction(accountId, "WITHDRAWAL", amount);
                } else {
                    requestDAO.updateStatus(requestId, "FAILED (Insufficient Funds)");
                }
            }
            response.sendRedirect("managerDashboard?viewCustomer=" + wr.getUserId());
        } else {
            response.sendRedirect("managerDashboard");
        }
    }
}