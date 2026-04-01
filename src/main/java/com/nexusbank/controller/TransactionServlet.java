package com.nexusbank.controller;

import com.nexusbank.dao.AccountDAO;
import com.nexusbank.dao.TransactionDAO;
import com.nexusbank.model.Account;
import com.nexusbank.model.Transaction;
import com.nexusbank.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/transactions")
public class TransactionServlet extends HttpServlet {
    private TransactionDAO transactionDAO = new TransactionDAO();
    private AccountDAO accountDAO = new AccountDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            Account acc = accountDAO.getAccountByUserId(user.getId());
            if (acc != null) {
                List<Transaction> list = transactionDAO.getTransactionsByAccountId(acc.getId());
                request.setAttribute("transactionList", list);
                request.getRequestDispatcher("transactions.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}