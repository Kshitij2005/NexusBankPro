package com.nexusbank.controller;

import com.nexusbank.dao.UserDAO;
import com.nexusbank.model.Loan;
import com.nexusbank.model.User;
import com.nexusbank.model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/applyLoan")
public class LoanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Account account = (Account) session.getAttribute("account");

        // 1. Security Check: Ensure user is logged in
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserDAO dao = new UserDAO();

        // 2. CONCURRENCY CHECK: Prevent duplicate active applications
        if (dao.hasActiveLoanRequest(user.getId())) {
            // FIX: Redirect to viewBalance so the existing loan actually shows up in the table
            response.sendRedirect("viewBalance?error=You+already+have+a+pending+application.+Please+wait.");
            return;
        }

        try {
            // 3. Parse form data
            double amount = Double.parseDouble(request.getParameter("amount"));
            String purpose = request.getParameter("purpose");
            int tenure = Integer.parseInt(request.getParameter("tenure"));

            // 4. RISK ASSESSMENT: Check eligibility (Minimum Balance Rule)
            double currentBalance = (account != null) ? account.getBalance() : 0.0;

            if (currentBalance < 10000) {
                response.sendRedirect("viewBalance?error=Loan+Rejected:+Min+₹10,000+balance+required+for+credit+eligibility.");
                return;
            }

            // 5. PROCESS: Save Loan to Database
            Loan loan = new Loan(user.getId(), amount, purpose, tenure);

            if (dao.applyForLoan(loan)) {
                // FIX: Redirect to viewBalance so the table refreshes automatically!
                response.sendRedirect("viewBalance?message=Loan+Application+Submitted+Successfully!");
            } else {
                response.sendRedirect("viewBalance?error=Database+Error:+Failed+to+submit+application.");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("viewBalance?error=Invalid+amount+or+tenure+format.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewBalance?error=An+unexpected+error+occurred.");
        }
    }
}