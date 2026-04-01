package com.nexusbank.controller;

import com.nexusbank.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        AuthService authService = new AuthService();

        boolean success = authService.registerUser(name, email, password);

        if (success) {
            response.sendRedirect("login.jsp");
        } else {
            response.getWriter().println("Registration Failed");
        }
    }
}