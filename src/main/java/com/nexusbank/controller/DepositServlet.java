package com.nexusbank.controller;

import com.nexusbank.model.User;
import com.nexusbank.service.AccountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deposit")
public class DepositServlet extends HttpServlet {
    private AccountService accountService = new AccountService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            double amount = Double.parseDouble(request.getParameter("amount"));
            boolean success = accountService.deposit(user.getId(), amount);

            if (success) {
                // REDIRECT to /viewBalance to force a fresh data refresh from DB
                response.sendRedirect("viewBalance?message=Deposit+Successful");
            } else {
                response.sendRedirect("viewBalance?error=Deposit+Failed");
            }
        } catch (Exception e) {
            response.sendRedirect("viewBalance?error=Invalid+Amount");
        }
    }
}