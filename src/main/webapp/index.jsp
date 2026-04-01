<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NexusBank | Future of Banking</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --secondary: #1e293b;
            --accent: #38bdf8;
            --background: #f8fafc;
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: var(--background);
            color: var(--secondary);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Navigation Bar */
        nav {
            padding: 20px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .logo {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--primary);
            text-decoration: none;
            letter-spacing: -1px;
        }

        /* Hero Section */
        .hero {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 0 20px;
            background: radial-gradient(circle at top right, #e0e7ff 0%, #f8fafc 50%);
        }

        .hero h1 {
            font-size: 4rem;
            font-weight: 800;
            margin: 0;
            line-height: 1.1;
            letter-spacing: -2px;
            color: #0f172a;
        }

        .hero h1 span {
            color: var(--primary);
        }

        .hero p {
            font-size: 1.25rem;
            color: #64748b;
            max-width: 600px;
            margin: 20px 0 40px;
        }

        /* Buttons */
        .cta-group {
            display: flex;
            gap: 15px;
        }

        .btn {
            padding: 15px 35px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 700;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
            box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: white;
            color: var(--secondary);
            border: 1px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background-color: #f1f5f9;
            transform: translateY(-2px);
        }

        /* Features/Badges */
        .badges {
            margin-top: 60px;
            display: flex;
            gap: 30px;
            color: #94a3b8;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .badge { display: flex; align-items: center; gap: 8px; }

        @media (max-width: 768px) {
            .hero h1 { font-size: 2.5rem; }
            .cta-group { flex-direction: column; width: 100%; max-width: 300px; }
            nav { padding: 20px; }
        }
    </style>
</head>
<body>

    <nav>
        <a href="index.jsp" class="logo">NexusBank</a>
        <div>
            <a href="login.jsp" style="text-decoration:none; color:var(--secondary); font-weight:600; margin-right:20px;">Sign In</a>
            <a href="register.jsp" class="btn btn-primary" style="padding:10px 20px; font-size:0.9rem;">Get Started</a>
        </div>
    </nav>

    <div class="hero">
        <h1>Secure. Fast. <span>Modern.</span></h1>
        <p>Experience the next generation of digital banking. Manage your funds, request withdrawals, and track transactions with military-grade security.</p>

        <div class="cta-group">
            <a href="register.jsp" class="btn btn-primary">Create Free Account</a>
            <a href="login.jsp" class="btn btn-secondary">Access Dashboard</a>
        </div>

        <div class="badges">
            <div class="badge">🛡️ Multi-tier Approval</div>
            <div class="badge">⚡ Instant Deposits</div>
            <div class="badge">📊 Real-time Tracking</div>
        </div>
    </div>

</body>
</html>