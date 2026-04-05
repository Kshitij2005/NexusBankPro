<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NexusBank | Create Account</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --background: #f8fafc;
            --card: #ffffff;
            --text: #1e293b;
            --danger: #ef4444;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--background);
            color: var(--text);
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh; /* Better for mobile overflow */
            padding: 20px;
            box-sizing: border-box;
        }

        .register-card {
            background: var(--card);
            padding: 30px;
            border-radius: 24px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 400px;
            border: 1px solid #e2e8f0;
        }

        .brand { text-align: center; margin-bottom: 25px; }
        .brand h1 { color: var(--primary); margin: 0; font-size: 1.8rem; font-weight: 800; letter-spacing: -0.5px; }
        .brand p { color: #64748b; margin-top: 8px; font-size: 0.9rem; }

        .alert {
            background: #fee2e2;
            color: var(--danger);
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 0.85rem;
            text-align: center;
            border: 1px solid #fecaca;
        }

        .form-group { margin-bottom: 18px; text-align: left; }
        label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.85rem; color: #475569; }

        input {
            width: 100%; padding: 12px 16px; border: 1px solid #cbd5e1; border-radius: 12px;
            font-size: 1rem; box-sizing: border-box; transition: 0.2s;
            background: #fcfdfe;
        }
        input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1); background: #fff; }

        .btn-register {
            width: 100%; padding: 14px; background-color: var(--primary); color: white;
            border: none; border-radius: 12px; font-size: 1rem; font-weight: 700;
            cursor: pointer; margin-top: 10px; transition: 0.2s;
        }
        .btn-register:hover { background-color: #1d4ed8; transform: translateY(-1px); }
        .btn-register:active { transform: translateY(0); }

        .footer-text { text-align: center; margin-top: 25px; font-size: 0.9rem; color: #64748b; }
        .footer-text a { color: var(--primary); text-decoration: none; font-weight: 600; }
        .footer-text a:hover { text-decoration: underline; }
    </style>
</head>
<body>

    <div class="register-card">
        <div class="brand">
            <h1>NexusBank</h1>
            <p>Join the future of digital banking.</p>
        </div>

        <%-- Error Alert --%>
        <c:if test="${not empty param.error}">
            <div class="alert">
                ⚠️ ${param.error}
            </div>
        </c:if>

        <form action="register" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="name" placeholder="John Doe" required autocomplete="name">
            </div>

            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="name@example.com" required autocomplete="email">
            </div>

            <div class="form-group">
                <label>Create Password</label>
                <input type="password" name="password" placeholder="••••••••" required autocomplete="new-password">
            </div>

            <button type="submit" class="btn-register">Get Started</button>
        </form>

        <div class="footer-text">
            Already have an account? <a href="login.jsp">Log in</a>
        </div>
    </div>

</body>
</html>