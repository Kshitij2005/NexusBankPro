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
            padding: 20px;
        }

        .container { width: 100%; max-width: 1000px; }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            width: 100%;
            flex-wrap: wrap;
            gap: 10px;
        }

        h2 { margin: 0; font-weight: 700; color: var(--dark); font-size: 1.5rem; }

        .alert {
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            animation: slideIn 0.3s ease-out;
            border: 1px solid transparent;
            font-size: 0.9rem;
        }
        .alert-success { background: #dcfce7; color: #166534; border-color: #bbf7d0; }
        .alert-error { background: #fee2e2; color: #991b1b; border-color: #fecaca; }

        @keyframes slideIn {
            from { transform: translateY(-10px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            width: 100%;
        }

        .card {
            background: var(--card);
            padding: 24px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            border: 1px solid #e2e8f0;
            margin-bottom: 5px;
            display: flex;
            flex-direction: column;
        }

        .full-width-card { grid-column: 1 / -1; }

        .balance-card {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            color: white;
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .balance-card h3 { color: #94a3b8; font-size: 0.875rem; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 8px; }
        .balance-amount { font-size: 2.5rem; font-weight: 700; margin: 0; }
        .acc-number { opacity: 0.7; font-family: monospace; font-size: 1.1rem; }

        .transfer-form {
            display: grid;
            grid-template-columns: 1fr 1fr auto;
            gap: 15px;
            align-items: flex-end;
        }

        .status-pill {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-check { background: #dcfce7; color: #15803d; }
        .status-wait { background: #fef3c7; color: #b45309; }
        .status-rejected { background: #fee2e2; color: #991b1b; }

        .type-badge {
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 700;
            margin-right: 5px;
        }
        .badge-credit { background: #dcfce7; color: #15803d; }
        .badge-debit { background: #fee2e2; color: #991b1b; }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            box-sizing: border-box;
            font-size: 1rem;
            margin-top: 5px;
        }
        input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1); }

        .btn {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 1rem;
            text-align: center;
            text-decoration: none;
        }
        .btn-primary { background: var(--primary); color: white; }
        .btn-primary:hover { background: #1d4ed8; transform: translateY(-1px); }
        .btn-outline { background: #f8fafc; color: #1e293b; border: 1px solid #e2e8f0; }

        .table-responsive { width: 100%; overflow-x: auto; -webkit-overflow-scrolling: touch; }
        table { width: 100%; min-width: 550px; border-collapse: collapse; }
        th { padding: 12px; text-align: left; color: #64748b; border-bottom: 2px solid #f1f5f9; font-size: 0.85rem; text-transform: uppercase; }
        td { padding: 12px; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; }

        .footer-nav {
            margin-top: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            flex-wrap: wrap;
            gap: 10px;
            color: var(--secondary);
            font-size: 0.85rem;
        }
        .logout-link { color: var(--danger); font-weight: 600; text-decoration: none; }

        @media (max-width: 768px) {
            .dashboard-grid { grid-template-columns: 1fr; }
            .transfer-form { grid-template-columns: 1fr; }
            .balance-card { flex-direction: column; text-align: center; }
            .balance-amount { font-size: 2rem; }
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="header">
            <h2>Hello, ${sessionScope.user.name} 👋</h2>
            <div class="acc-number">A/C: ${sessionScope.account.accountNumber}</div>
        </div>

        <%-- Alerts --%>
        <c:if test="${not empty param.message}">
            <div class="alert alert-success">✅ ${param.message}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">❌ ${param.error}</div>
        </c:if>

        <div class="dashboard-grid">
            <%-- Balance Card --%>
            <div class="card balance-card full-width-card">
                <div>
                    <h3>Current Balance</h3>
                    <p class="balance-amount">
                        ₹ <fmt:formatNumber value="${sessionScope.account.balance}" minFractionDigits="2" />
                    </p>
                </div>
                <a href="viewBalance" style="color: #38bdf8; text-decoration: none; font-size: 0.85rem; font-weight: 700; border: 1px solid #38bdf8; padding: 10px 16px; border-radius: 10px;">🔄 REFRESH</a>
            </div>

            <%-- Quick Fund Transfer --%>
            <div class="card full-width-card">
                <h4 style="margin-top:0; color: var(--primary);">Quick Fund Transfer</h4>
                <form action="transferMoney" method="POST" class="transfer-form">
                    <div>
                        <label style="font-size: 0.75rem; font-weight: 700; color: var(--secondary);">RECEIVER ACCOUNT NUMBER</label>
                        <input type="text" name="receiverAccNo" required placeholder="Enter A/C Number">
                    </div>
                    <div>
                        <label style="font-size: 0.75rem; font-weight: 700; color: var(--secondary);">AMOUNT (₹)</label>
                        <input type="number" name="amount" required min="1" step="0.01" placeholder="0.00">
                    </div>
                    <button type="submit" class="btn btn-primary btn-mobile-full" style="width: auto; padding: 12px 30px;">Send Money</button>
                </form>
            </div>

            <%-- Deposit --%>
            <div class="card">
                <h4 style="margin-top:0">Deposit Funds</h4>
                <form action="deposit" method="post">
                    <input type="number" name="amount" min="1" step="0.01" placeholder="Enter amount" required>
                    <button type="submit" class="btn btn-primary" style="margin-top:12px">Deposit Now</button>
                </form>
            </div>

            <%-- Withdraw --%>
            <div class="card">
                <h4 style="margin-top:0">Withdraw Funds</h4>
                <form action="withdraw" method="post">
                    <input type="number" name="amount" min="1" step="0.01" placeholder="Enter amount" required>
                    <button type="submit" class="btn btn-outline" style="margin-top:12px">Request Withdrawal</button>
                </form>
            </div>

            <%-- Nexus Credit (Loan Section) --%>
            <div class="card full-width-card" style="border-left: 5px solid var(--primary); background: linear-gradient(to right, #ffffff, #f0f7ff);">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap;">
                    <div style="flex: 1; min-width: 250px;">
                        <h4 style="margin-top:0; color: var(--primary);">Nexus Credit 🚀</h4>
                        <p style="font-size: 0.85rem; color: var(--secondary); max-width: 450px;">
                            Need funds for education, business, or a home? Apply for a smart loan with multi-tier approval.
                        </p>
                    </div>
                    <div style="margin-top: 10px;">
                        <a href="applyLoan.jsp" class="btn btn-primary" style="padding: 10px 25px;">Apply for Loan</a>
                    </div>
                </div>
            </div>

            <%-- NEW: Loan Application Status --%>
            <div class="card full-width-card" style="border-top: 3px solid var(--primary);">
                <h4 style="margin-top: 0; margin-bottom: 15px; color: var(--primary);">My Loan Status</h4>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Amount</th>
                                <th>Purpose</th>
                                <th>Status</th>
                                <th style="text-align: center;">M1</th>
                                <th style="text-align: center;">M2</th>
                                <th style="text-align: center;">M3</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="loan" items="${userLoans}">
                                <tr>
                                    <td style="font-weight: 600;">₹ <fmt:formatNumber value="${loan.amount}" minFractionDigits="2" /></td>
                                    <td>${loan.purpose}</td>
                                    <td>
                                        <span class="status-pill ${loan.status == 'APPROVED' ? 'status-check' : (loan.status == 'REJECTED' ? 'status-rejected' : 'status-wait')}">
                                            ${loan.status}
                                        </span>
                                    </td>
                                    <td style="text-align: center;">${loan.m1Approved ? "✅" : "⏳"}</td>
                                    <td style="text-align: center;">${loan.m2Approved ? "✅" : "⏳"}</td>
                                    <td style="text-align: center;">${loan.m3Approved ? "✅" : "⏳"}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty userLoans}">
                                <tr><td colspan="6" style="text-align: center; color: #94a3b8; padding: 20px;">No active loan applications found.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- Withdrawal Tracking --%>
            <div class="card full-width-card">
                <h4 style="margin-top: 0; margin-bottom: 15px;">Withdrawal Tracking (Compliance)</h4>
                <div class="table-responsive">
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
                                        <span class="status-pill ${req.status == 'COMPLETED' ? 'status-check' : (req.status.contains('REJECTED') ? 'status-rejected' : 'status-wait')}">
                                            ${req.status}
                                        </span>
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
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- Transaction Logs --%>
            <div class="card full-width-card">
                <h4 style="margin-top: 0; margin-bottom: 15px; color: var(--primary);">Transaction Logs</h4>
                <div class="table-responsive">
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
                                        <c:set var="isCredit" value="${tx.type.equalsIgnoreCase('DEPOSIT') || tx.type.contains('FROM') || tx.type.contains('LOAN')}" />
                                        <span class="type-badge ${isCredit ? 'badge-credit' : 'badge-debit'}">
                                            ${isCredit ? 'CREDIT' : 'DEBIT'}
                                        </span>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--dark); font-weight: 500;">
                                        ${tx.type}
                                    </td>
                                    <td style="font-weight: 700; color: ${isCredit ? 'var(--success)' : 'var(--danger)'}">
                                        ${isCredit ? '+' : '-'} ₹ <fmt:formatNumber value="${tx.amount}" minFractionDigits="2" />
                                    </td>
                                    <td style="color: var(--secondary); font-size: 0.8rem;">${tx.timestamp}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <div class="footer-nav">
            <span>NexusBank Security v2.5</span>
            <a href="logout" class="logout-link">Secure Logout</a>
        </div>
    </div>
</body>
</html>