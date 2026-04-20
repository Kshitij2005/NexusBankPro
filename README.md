# NexusBank Pro: Multi-tier Sequential Banking System

**NexusBank Pro** is a secure, web-based banking management application built using the **MVC (Model-View-Controller)** architecture. It features a unique **3-tier sequential loan approval workflow** (M1, M2, and M3) and is designed for high-stakes financial data integrity.

## 🚀 Features
* **Hierarchical Approvals:** Sequential sign-off from Branch (M1), Regional (M2), and Corporate (M3) managers.
* **Core Banking:** Real-time Deposits, Withdrawals, and Balance tracking.
* **Security:** SQL Injection prevention via Prepared Statements and hashed credentials.
* **Cloud Native:** Fully deployed using **Render** (Application) and **Aiven** (PostgreSQL).

## 🛠️ Tech Stack
* **Backend:** Java JDK 17, Jakarta Servlet API, JSP.
* **Database:** PostgreSQL (Cloud-hosted on Aiven).
* **Server:** Apache Tomcat (via Render).
* **Build Tool:** Maven.

## ⚙️ Installation & Setup

### 1. Prerequisites
* Install **Java JDK 17** or higher.
* Install **Apache Maven**.
* A PostgreSQL database (Local or Cloud).

### 2. Database Setup
1. Create a database named `nexusbank`.
2. Execute the SQL scripts located in the resources folder to create tables for `users`, `accounts`, and `loans`.

### 3. Environment Variables
To keep the project secure, do not hardcode credentials. Set the following environment variables in your system or Render dashboard:
* `DB_URL`: your_database_jdbc_url
* `DB_USER`: your_database_username
* `DB_PASSWORD`: your_database_password

### 4. Running Locally
1. Clone the repository:
   ```bash
   git clone [https://github.com/Kshitij2005/NexusBankPro.git](https://github.com/Kshitij2005/NexusBankPro.git)