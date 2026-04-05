<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Deposit Funds | NexusBank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --background: #f8fafc;
            --card: #ffffff;
            --dark: #0f172a;
            --secondary: #64748b;
            --success: #22c55e;
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

        .deposit-card {
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
            margin-bottom: 25px;
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
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--success);
            transition: all 0.2s;
            box-sizing: border-box;
        }

        input[type="number"]::placeholder { font-weight: 400; color: #cbd5e1; }

        input[type="number"]:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .btn-deposit {
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
        }

        .btn-deposit:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }

        .back-link {
            display: inline-block;
            margin-top: 25px;
            color: var(--secondary);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: color 0.2s;
        }

        .back-link:hover { color: var(--dark); text-decoration: underline; }

        /* Icon styling */
        .icon-circle {
            width: 60px;
            height: 60px;
            background: #dcfce7;
            color: #15803d;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>

    <div class="deposit-card">
        <div class="icon-circle">💰</div>
        <h2>Deposit Funds</h2>
        <p>Add money to your account instantly.</p>

        <form action="deposit" method="post">
            <div class="input-group">
                <label>Enter Amount (₹)</label>
                <input type="number" name="amount" required min="1" step="0.01" placeholder="0.00" autofocus>
            </div>

            <button type="submit" class="btn-deposit">Confirm Deposit</button>
        </form>

        <a href="dashboard" class="back-link">← Cancel and Go Back</a>
    </div>

</body>
</html>