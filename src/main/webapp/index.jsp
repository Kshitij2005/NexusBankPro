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
            overflow-x: hidden;
        }

        /* Navigation Bar */
        nav {
            padding: 15px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
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
            padding: 60px 20px;
            background: radial-gradient(circle at top right, #e0e7ff 0%, #f8fafc 50%);
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .hero h1 {
            font-size: 4.5rem;
            font-weight: 800;
            margin: 0;
            line-height: 1;
            letter-spacing: -3px;
            color: #0f172a;
        }

        .hero h1 span {
            color: var(--primary);
            background: linear-gradient(to bottom right, #2563eb, #38bdf8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero p {
            font-size: 1.2rem;
            color: #64748b;
            max-width: 650px;
            margin: 25px 0 45px;
            line-height: 1.6;
        }

        /* Buttons */
        .cta-group {
            display: flex;
            gap: 15px;
            width: 100%;
            justify-content: center;
        }

        .btn {
            padding: 16px 32px;
            border-radius: 14px;
            text-decoration: none;
            font-weight: 700;
            font-size: 1rem;
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            display: inline-block;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
            box-shadow: 0 10px 20px -5px rgba(37, 99, 235, 0.3);
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
            transform: translateY(-3px);
            box-shadow: 0 15px 25px -5px rgba(37, 99, 235, 0.4);
        }

        .btn-secondary {
            background-color: white;
            color: var(--secondary);
            border: 1px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background-color: #f1f5f9;
            transform: translateY(-3px);
            border-color: #cbd5e1;
        }

        /* Features/Badges */
        .badges {
            margin-top: 80px;
            display: flex;
            gap: 40px;
            color: #94a3b8;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .badge { display: flex; align-items: center; gap: 10px; }

        footer {
            padding: 20px;
            text-align: center;
            font-size: 0.8rem;
            color: #94a3b8;
            border-top: 1px solid #f1f5f9;
        }

        @media (max-width: 768px) {
            nav { padding: 15px 20px; }
            .hero h1 { font-size: 3rem; letter-spacing: -1.5px; }
            .hero p { font-size: 1rem; }
            .cta-group { flex-direction: column; align-items: center; }
            .btn { width: 80%; text-align: center; }
            .badges { gap: 20px; flex-direction: column; align-items: center; margin-top: 40px; }
            .nav-links { display: none; } /* Simplified for demo */
        }
    </style>
</head>
<body>

    <nav>
        <a href="index.jsp" class="logo">NexusBank</a>
        <div class="nav-links">
            <a href="login.jsp" style="text-decoration:none; color:var(--secondary); font-weight:600; margin-right:20px; font-size: 0.9rem;">Sign In</a>
            <a href="register.jsp" class="btn btn-primary" style="padding:10px 22px; font-size:0.85rem; border-radius: 10px; box-shadow: none;">Get Started</a>
        </div>
    </nav>

    <div class="hero">
        <h1>Secure. Fast. <span>Modern.</span></h1>
        <p>Experience the next generation of digital banking. Manage your funds, request withdrawals, and track transactions with industry-leading security and multi-tier approval logic.</p>

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

    <footer>
        &copy; 2026 NexusBank Digital Systems. All rights reserved. Built for B.Tech AI & Data Science Project.
    </footer>

</body>
</html>