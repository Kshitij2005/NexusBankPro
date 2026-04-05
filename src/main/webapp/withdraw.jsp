<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Withdraw Funds | NexusBank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --background: #f8fafc;
            --card: #ffffff;
            --dark: #0f172a;
            --secondary: #64748b;
            --warning: #f59e0b;
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: var(--background);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            padding: 20px;
        }

        .withdraw-card {
            background: var(--card);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
            border: 1px solid #e2e8f0;
        }

        h2 { margin-bottom: 10px; color: var(--dark); font-weight: 700; }
        p { color: var(--secondary); font-size: 0.9rem; margin-bottom: 30px; }

        .input-group {
            text-align: left;
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--secondary);
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        input[type="number"] {
            width: 100%;
            padding: 14px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            transition: all 0.2s;
            box-sizing: border-box;
        }

        input[type="number"]:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .btn-withdraw {
            width: 100%;
            background: var(--primary);
            color: white;
            padding: 14px;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 10px;
        }

        .btn-withdraw:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
        }

        .info-box {
            background: #fffbeb;
            border: 1px solid #fef3c7;
            padding: 12px;
            border-radius: 10px;
            margin-top: 25px;
            font-size: 0.8rem;
            color: #92400e;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: var(--secondary);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .back-link:hover { color: var(--dark); }
    </style>
</head>
<body>

    <div class="withdraw-card">
        <h2>Withdraw Funds</h2>
        <p>Request a secure withdrawal from your account.</p>

        <form action="withdraw" method="post">
            <div class="input-group">
                <label>Enter Amount (₹)</label>
                <input type="number" name="amount" required min="1" step="0.01" placeholder="0.00">
            </div>

            <button type="submit" class="btn-withdraw">Submit Request</button>
        </form>

        <div class="info-box">
            <span>ℹ️</span>
            <span>Requests over ₹6L require multi-level manager approval (M1, M2, M3).</span>
        </div>

        <a href="dashboard" class="back-link">← Cancel and Go Back</a>
    </div>

</body>
</html>