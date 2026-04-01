package com.nexusbank.controller;

import com.nexusbank.model.User;
import com.nexusbank.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        AuthService authService = new AuthService();
        User user = authService.loginWeb(email, password);

        // --- DEBUG START ---
        System.out.println("================================");
        System.out.println("LOGIN ATTEMPT: " + email);
        if (user == null) {
            System.out.println("RESULT: User NOT found in database. (Check Password Hash in XAMPP)");
        } else {
            System.out.println("RESULT: User found!");
            System.out.println("USER ID: " + user.getId());
            System.out.println("USER ROLE IN DB: [" + user.getRole() + "]");
        }
        System.out.println("================================");
        // --- DEBUG END ---

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            String role = user.getRole();

            // Use .equalsIgnoreCase to be safer with case sensitivity
            if (role != null && (role.equalsIgnoreCase("M1") ||
                    role.equalsIgnoreCase("M2") ||
                    role.equalsIgnoreCase("M3"))) {

                System.out.println("REDIRECTING TO: managerDashboard");
                response.sendRedirect("managerDashboard");
            } else {
                System.out.println("REDIRECTING TO: viewBalance (Customer Dashboard)");
                response.sendRedirect("viewBalance");
            }

        } else {
            // Send back to login with an error message
            response.sendRedirect("login.jsp?error=Invalid+Email+or+Password");
        }
    }
}