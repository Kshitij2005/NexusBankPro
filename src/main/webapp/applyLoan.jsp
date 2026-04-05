<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NexusBank | Apply for a Loan</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --background: #f8fafc;
            --card: #ffffff;
            --dark: #0f172a;
            --secondary: #64748b;
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: var(--background);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .loan-card {
            background: var(--card);
            padding: 40px;
            border-radius: 24px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 500px;
            border: 1px solid #e2e8f0;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .brand h2 { color: var(--primary); margin: 0; font-size: 1.8rem; font-weight: 800; }
        .brand p { color: #64748b; margin-top: 5px; font-size: 0.9rem; margin-bottom: 30px; }

        .form-group { margin-bottom: 20px; text-align: left; }
        label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.85rem; color: #475569; }

        input, select {
            width: 100%; padding: 14px; border: 2px solid #e2e8f0; border-radius: 12px;
            font-size: 1rem; box-sizing: border-box; transition: 0.2s;
            background: #fcfdfe;
        }
        input:focus, select:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1); }

        .btn-apply {
            width: 100%; padding: 14px; background-color: var(--primary); color: white;
            border: none; border-radius: 12px; font-size: 1rem; font-weight: 700;
            cursor: pointer; margin-top: 10px; transition: 0.2s;
        }
        .btn-apply:hover { background-color: #1d4ed8; transform: translateY(-1px); }

        .back-link { display: inline-block; margin-top: 25px; color: var(--secondary); text-decoration: none; font-size: 0.9rem; font-weight: 500; }
        .back-link:hover { color: var(--dark); text-decoration: underline; }

        .note { background: #fff7ed; color: #9a3412; padding: 12px; border-radius: 10px; font-size: 0.8rem; margin-top: 20px; text-align: left; }
    </style>
</head>
<body>

    <div class="loan-card">
        <div class="brand">
            <h2>Nexus Credit</h2>
            <p>Smart loan solutions tailored for you.</p>
        </div>

        <form action="applyLoan" method="POST">
            <div class="form-group">
                <label>Loan Amount (₹)</label>
                <input type="number" name="amount" required min="5000" placeholder="e.g. 50000">
            </div>

            <div class="form-group">
                <label>Purpose of Loan</label>
                <select name="purpose" required>
                    <option value="" disabled selected>Select Purpose</option>
                    <option value="Education">🎓 Education</option>
                    <option value="Personal">🏠 Home/Personal</option>
                    <option value="Business">💼 Business Growth</option>
                    <option value="Vehicle">🚗 Vehicle Purchase</option>
                </select>
            </div>

            <div class="form-group">
                <label>Tenure (Months)</label>
                <select name="tenure" required>
                    <option value="6">6 Months</option>
                    <option value="12">12 Months</option>
                    <option value="24">24 Months</option>
                    <option value="36">36 Months</option>
                </select>
            </div>

            <button type="submit" class="btn-apply">Submit Application</button>
        </form>

        <div class="note">
            🛡️ <strong>AI Assessment:</strong> Eligibility is calculated based on your current liquidity and transaction history. Applications are reviewed by M1-M3 managers.
        </div>

        <a href="dashboard.jsp" class="back-link">← Cancel and Go Back</a>
    </div>

</body>
</html>