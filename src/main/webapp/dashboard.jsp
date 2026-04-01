<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NexusBank | Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --secondary: #64748b;
            --success: #22c55e;
            --danger: #ef4444;
            --warning: #f59e0b;
            --background: #f8fafc;
            --card: #ffffff;
            --dark: #0f172a;
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: var(--background);
            color: #1e293b;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
        }

        .container { width: 100%; max-width: 900px; }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        h2 { margin: 0; font-weight: 700; color: var(--dark); }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            animation: slideIn 0.3s ease-out;
            border: 1px solid transparent;
        }
        .alert-success { background: #dcfce7; color: #166534; border-color: #bbf7d0; }
        .alert-error { background: #fee2e2; color: #991b1b; border-color: #fecaca; }
        .alert-warning { background: #fef3c7; color: #92400e; border-color: #fde68a; }

        @keyframes slideIn {
            from { transform: translateY(-10px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .card {
            background: var(--card);
            padding: 24px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            border: 1px solid #e2e8f0;
            margin-bottom: 20px;
        }

        .balance-card {
            grid-column: span 2;
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .balance-card h3 { color: #94a3b8; font-size: 0.875rem; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 8px; }
        .balance-amount { font-size: 2.5rem; font-weight: 700; margin: 0; }
        .acc-number { opacity: 0.7; font-family: monospace; font-size: 1.1rem; }

        .status-pill {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-check { background: #dcfce7; color: #15803d; }
        .status-wait { background: #fef3c7; color: #b45309; }
        .status-rejected { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

        /* Badge for Transactions */
        .type-badge {
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 700;
            margin-right: 5px;
        }
        .badge-credit { background: #dcfce7; color: #15803d; }
        .badge-debit { background: #fee2e2; color: #991b1b; }

        input[type="number"], input[type="text"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 1rem;
            margin-top: 5px;
        }

        .btn {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 1rem;
        }

        .btn-primary { background: var(--primary); color: white; }
        .btn-primary:hover { background: #1d4ed8; }
        .btn-outline { background: #f8fafc; color: #1e293b; border: 1px solid #e2e8f0; }
        .btn-outline:hover { background: #f1f5f9; }

        table { width: 100%; border-collapse: collapse; }
        th { padding: 12px; text-align: left; color: #64748b; border-bottom: 2px solid #f1f5f9; font-size: 0.85rem; text-transform: uppercase; }
        td { padding: 12px; border-bottom: 1px solid #f1f5f9; }

        .footer-nav {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
        }
        .logout-link { color: var(--danger); font-weight: 600; text-decoration: none; }
    </style>
</head>
<body>

    <div class="container">
        <div class="header">
            <h2>Hello, ${sessionScope.user.name} 👋</h2>
            <div class="acc-number">
                A/C: ${sessionScope.account.accountNumber != null ? sessionScope.account.accountNumber : 'N/A'}
            </div>
        </div>

        <%-- Alerts --%>
        <c:if test="${not empty param.message}">
            <div class="alert ${param.message.contains('Pending') || param.message.contains('Submitted') ? 'alert-warning' : 'alert-success'}">
                ✅ ${param.message}
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">
                ❌ ${param.error}
            </div>
        </c:if>

        <div class="dashboard-grid">
            <%-- Balance Card --%>
            <div class="card balance-card">
                <div>
                    <h3>Current Balance</h3>
                    <p class="balance-amount">
                        ₹ <fmt:formatNumber value="${sessionScope.account.balance != null ? sessionScope.account.balance : 0.00}" minFractionDigits="2" />
                    </p>
                </div>
                <a href="viewBalance" style="color: #38bdf8; text-decoration: none; font-size: 0.875rem; font-weight: 600;">🔄 REFRESH</a>
            </div>

            <%-- New Fund Transfer Section --%>
            <div class="card" style="grid-column: span 2;">
                <h4 style="margin-top:0; color: var(--primary);">Quick Fund Transfer</h4>
                <form action="transferMoney" method="POST" style="display: grid; grid-template-columns: 1fr 1fr auto; gap: 15px; align-items: flex-end;">
                    <div>
                        <label style="font-size: 0.75rem; font-weight: 700; color: var(--secondary);">RECEIVER ACCOUNT NUMBER</label>
                        <input type="text" name="receiverAccNo" required placeholder="Enter A/C Number">
                    </div>
                    <div>
                        <label style="font-size: 0.75rem; font-weight: 700; color: var(--secondary);">AMOUNT (₹)</label>
                        <input type="number" name="amount" required min="1" step="0.01" placeholder="0.00">
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: auto; padding: 12px 30px;">Send Money</button>
                </form>
            </div>

            <%-- Quick Actions --%>
            <div class="card">
                <h4 style="margin-top:0">Deposit Funds</h4>
                <form action="deposit" method="post">
                    <input type="number" name="amount" min="1" step="0.01" placeholder="Enter amount" required>
                    <button type="submit" class="btn btn-primary" style="margin-top:10px">Deposit Now</button>
                </form>
            </div>

            <div class="card">
                <h4 style="margin-top:0">Withdraw Funds</h4>
                <form action="withdraw" method="post">
                    <input type="number" name="amount" min="1" step="0.01" placeholder="Enter amount" required>
                    <button type="submit" class="btn btn-outline" style="margin-top:10px">Request Withdrawal</button>
                </form>
            </div>
        </div>

        <%-- SECTION 1: WITHDRAWAL TRACKING --%>
        <div class="card">
            <h4 style="margin-top: 0; margin-bottom: 15px;">Withdrawal Status</h4>
            <table>
                <thead>
                    <tr>
                        <th>Amount</th>
                        <th>Status</th>
                        <th style="text-align: center;">M1</th>
                        <th style="text-align: center;">M2</th>
                        <th style="text-align: center;">M3</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="req" items="${userRequests}">
                        <tr>
                            <td style="font-weight: 600;">₹ <fmt:formatNumber value="${req.amount}" minFractionDigits="2" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${req.status == 'COMPLETED'}">
                                        <span class="status-pill status-check">Completed</span>
                                    </c:when>
                                    <c:when test="${req.status.contains('REJECTED') || req.status.contains('FAILED')}">
                                        <span class="status-pill status-rejected">Failed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill status-wait">${req.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: center;">${req.m1Approved ? "✅" : "⏳"}</td>
                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${req.amount >= 600000}">${req.m2Approved ? "✅" : "⏳"}</c:when>
                                    <c:otherwise><span style="color:#cbd5e1">N/A</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${req.amount >= 2500000}">${req.m3Approved ? "✅" : "⏳"}</c:when>
                                    <c:otherwise><span style="color:#cbd5e1">N/A</span></c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty userRequests}">
                        <tr><td colspan="5" style="text-align:center; color: var(--secondary); padding: 20px;">No withdrawal requests found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <%-- SECTION 2: TRANSACTION HISTORY --%>
        <div class="card">
            <h4 style="margin-top: 0; margin-bottom: 15px; color: var(--primary);">Transaction Logs</h4>
            <table>
                <thead>
                    <tr>
                        <th>Type</th>
                        <th>Description</th>
                        <th>Amount</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="tx" items="${transactions}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${tx.type.equalsIgnoreCase('DEPOSIT') || tx.type.contains('FROM')}">
                                        <span class="type-badge badge-credit">CREDIT</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="type-badge badge-debit">DEBIT</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="font-size: 0.85rem; color: var(--dark); font-weight: 500;">
                                ${tx.type}
                            </td>
                            <td style="font-weight: 700; color: ${tx.type.equalsIgnoreCase('DEPOSIT') || tx.type.contains('FROM') ? 'var(--success)' : 'var(--danger)'}">
                                <c:choose>
                                    <c:when test="${tx.type.equalsIgnoreCase('DEPOSIT') || tx.type.contains('FROM')}">+</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                                ₹ <fmt:formatNumber value="${tx.amount}" minFractionDigits="2" />
                            </td>
                            <td style="color: var(--secondary); font-size: 0.8rem;">${tx.timestamp}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="footer-nav">
            <span style="color: var(--secondary); font-size: 0.9rem;">NexusBank Security v2.5</span>
            <a href="logout" class="logout-link">Secure Logout</a>
        </div>
    </div>
</body>
</html>