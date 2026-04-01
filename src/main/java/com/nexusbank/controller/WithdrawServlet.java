package com.nexusbank.controller;

import com.nexusbank.model.User;
import com.nexusbank.model.Account;
import com.nexusbank.service.AccountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/withdraw")
public class WithdrawServlet extends HttpServlet {
    private AccountService accountService = new AccountService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Account account = (Account) session.getAttribute("account");

        if (user == null || account == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            double amount = Double.parseDouble(request.getParameter("amount"));

            // BUG FIX: Pre-check balance before sending to service
            if (amount > account.getBalance()) {
                response.sendRedirect("viewBalance?error=" + URLEncoder.encode("Insufficient balance for this request!", StandardCharsets.UTF_8));
                return;
            }

            String resultMessage = accountService.withdraw(user.getId(), amount);
            String encodedMsg = URLEncoder.encode(resultMessage, StandardCharsets.UTF_8);

            if (resultMessage.startsWith("Pending") || resultMessage.contains("Submitted")) {
                response.sendRedirect("viewBalance?message=" + encodedMsg);
            } else {
                response.sendRedirect("viewBalance?error=" + encodedMsg);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("viewBalance?error=Invalid+Amount+Entered");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewBalance?error=An+unexpected+error+occurred");
        }
    }
}