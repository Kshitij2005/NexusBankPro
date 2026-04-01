<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NexusBank | Create Account</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        /* Shared Styles from Login for consistency */
        :root { --primary: #2563eb; --background: #f8fafc; --card: #ffffff; --text: #1e293b; }
        body { font-family: 'Inter', sans-serif; background-color: var(--background); color: var(--text); margin: 0; display: flex; justify-content: center; align-items: center; height: 100vh; }

        .register-card {
            background: var(--card);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            border: 1px solid #e2e8f0;
        }

        .brand { text-align: center; margin-bottom: 30px; }
        .brand h1 { color: var(--primary); margin: 0; font-size: 1.8rem; font-weight: 800; }
        .brand p { color: #64748b; margin-top: 5px; font-size: 0.9rem; }

        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.875rem; }

        input {
            width: 100%; padding: 12px; border: 1px solid #cbd5e1; border-radius: 10px;
            font-size: 1rem; box-sizing: border-box; transition: 0.2s;
        }
        input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1); }

        .btn-register {
            width: 100%; padding: 14px; background-color: var(--primary); color: white;
            border: none; border-radius: 10px; font-size: 1rem; font-weight: 700;
            cursor: pointer; margin-top: 15px;
        }
        .btn-register:hover { background-color: #1d4ed8; }

        .footer-text { text-align: center; margin-top: 20px; font-size: 0.9rem; color: #64748b; }
        .footer-text a { color: var(--primary); text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>

    <div class="register-card">
        <div class="brand">
            <h1>NexusBank</h1>
            <p>Join us today! It only takes a minute.</p>
        </div>

        <form action="register" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" placeholder="John Doe" required>
            </div>

            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="name@example.com" required>
            </div>

            <div class="form-group">
                <label>Create Password</label>
                <input type="password" name="password" placeholder="Min. 8 characters" required>
            </div>

            <button type="submit" class="btn-register">Create Account</button>
        </form>

        <div class="footer-text">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </div>

</body>
</html>