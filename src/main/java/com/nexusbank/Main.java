package com.nexusbank;

import com.nexusbank.model.User;
import com.nexusbank.service.AuthService;
import com.nexusbank.service.BankingService;

import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);
        AuthService authService = new AuthService();
        BankingService bankingService = new BankingService();
        User loggedInUser = null;

        while (true) {

            System.out.println("\n===== NEXUS BANK PRO =====");
            System.out.println("1. Register");
            System.out.println("2. Login");
            System.out.println("3. Exit");
            System.out.print("Choose Option: ");

            int choice = scanner.nextInt();
            scanner.nextLine();  // Clear input buffer

            switch (choice) {

                case 1:
                    authService.register();
                    break;

                case 2:
                    loggedInUser = authService.login();

                    if (loggedInUser != null) {

                        while (true) {

                            System.out.println("\n===== BANKING MENU =====");
                            System.out.println("1. Create Account");
                            System.out.println("2. Deposit");
                            System.out.println("3. Withdraw");
                            System.out.println("4. View Balance");
                            System.out.println("5. View Transactions");
                            System.out.println("6. Logout");
                            System.out.print("Choose Option: ");

                            int bankChoice = scanner.nextInt();
                            scanner.nextLine();  // Clear input buffer

                            switch (bankChoice) {

                                case 1:
                                    bankingService.createAccount(loggedInUser.getId());
                                    break;

                                case 2:
                                    bankingService.deposit(loggedInUser.getId());
                                    break;

                                case 3:
                                    bankingService.withdraw(loggedInUser.getId());
                                    break;

                                case 4:
                                    bankingService.viewBalance(loggedInUser.getId());
                                    break;

                                case 5:
                                    bankingService.viewTransactionHistory(loggedInUser.getId());
                                    break;

                                case 6:
                                    System.out.println("Logging out...");
                                    loggedInUser = null;
                                    break;

                                default:
                                    System.out.println("Invalid Choice!");
                            }

                            if (loggedInUser == null) {
                                break;
                            }
                        }
                    }
                    break;

                case 3:
                    System.out.println("Thank you for using NexusBank!");
                    System.exit(0);
                    break;

                default:
                    System.out.println("Invalid Choice!");
            }
        }
    }
}