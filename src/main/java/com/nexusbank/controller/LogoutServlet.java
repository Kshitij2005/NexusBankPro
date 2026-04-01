package com.nexusbank.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the current session
        HttpSession session = request.getSession(false);

        // 2. If it exists, invalidate it (clear all user data)
        if (session != null) {
            session.invalidate();
        }

        // 3. Redirect the user back to the login page with a message
        response.sendRedirect("login.jsp?message=Logged out successfully");
    }
}