package com.nexusbank.service;

import com.nexusbank.dao.UserDAO;
import com.nexusbank.model.User;

import java.util.Scanner;

public class AuthService {

    private UserDAO userDAO = new UserDAO();
    private Scanner scanner = new Scanner(System.in);

    // =========================
    // REGISTER (CONSOLE VERSION)
    // =========================
    public void register() {

        System.out.println("\n===== USER REGISTRATION =====");

        System.out.print("Enter Name: ");
        String name = scanner.nextLine();

        System.out.print("Enter Email: ");
        String email = scanner.nextLine();

        System.out.print("Enter Password: ");
        String password = scanner.nextLine();

        User user = new User(name, email, password, "CUSTOMER");

        boolean success = userDAO.registerUser(user);

        if (success) {
            System.out.println("Registration Successful!");
        } else {
            System.out.println("Registration Failed!");
        }
    }

    // =========================
    // REGISTER (WEB VERSION)
    // =========================
    public boolean registerUser(String name, String email, String password) {

        User user = new User(name, email, password, "CUSTOMER");

        return userDAO.registerUser(user);
    }

    // =========================
    // LOGIN (CONSOLE VERSION)
    // =========================
    public User login() {

        System.out.println("\n===== USER LOGIN =====");

        System.out.print("Enter Email: ");
        String email = scanner.nextLine();

        System.out.print("Enter Password: ");
        String password = scanner.nextLine();

        User user = userDAO.loginUser(email, password);

        if (user != null) {
            System.out.println("Login Successful! Welcome " + user.getName());
            return user;
        } else {
            System.out.println("Invalid Email or Password!");
            return null;
        }
    }

    // =========================
    // LOGIN (WEB VERSION)
    // =========================
    public User loginWeb(String email, String password) {
        return userDAO.loginUser(email, password);
    }
}