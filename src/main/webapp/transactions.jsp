<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History | NexusBank</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --success: #22c55e;
            --danger: #ef4444;
            --background: #f8fafc;
            --card: #ffffff;
            --dark: #0f172a;
            --secondary: #64748b;
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: var(--background);
            color: #1e293b;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .container { width: 100%; max-width: 900px; }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 10px;
        }

        h2 { margin: 0; font-weight: 700; color: var(--dark); }

        .card {
            background: var(--card);
            padding: 24px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            border: 1px solid #e2e8f0;
        }

        /* Responsive Table */
        .table-responsive {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        table { width: 100%; min-width: 600px; border-collapse: collapse; margin-top: 10px; }
        th { padding: 16px; text-align: left; color: var(--secondary); border-bottom: 2px solid #f1f5f9; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em; }
        td { padding: 16px; border-bottom: 1px solid #f1f5f9; font-size: 0.95rem; }
        tr:hover { background: #f8fafc; }

        /* Status Badges */
        .type-badge {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .badge-credit { background: #dcfce7; color: #15803d; }
        .badge-debit { background: #fee2e2; color: #991b1b; }

        .amount-credit { color: var(--success); font-weight: 700; }
        .amount-debit { color: var(--danger); font-weight: 700; }

        .back-btn {
            display: inline-flex;
            align-items: center;
            margin-top: 25px;
            text-decoration: none;
            color: var(--primary);
            font-weight: 600;
            transition: transform 0.2s;
        }
        .back-btn:hover { transform: translateX(-5px); }

        @media (max-width: 600px) {
            h2 { font-size: 1.5rem; }
            .card { padding: 15px; }
            td, th { padding: 12px; }
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="header">
            <h2>Transaction History</h2>
            <div style="color: var(--secondary); font-weight: 500;">
                User: <span style="color: var(--dark);">${sessionScope.user.name}</span>
            </div>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Type</th>
                            <th>Amount</th>
                            <th>Date & Time</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty transactionList}">
                                <c:forEach var="t" items="${transactionList}">
                                    <tr>
                                        <td style="font-family: monospace; color: var(--secondary);">#${t.id}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${t.type.equalsIgnoreCase('DEPOSIT') || t.type.contains('FROM')}">
                                                    <span class="type-badge badge-credit">Credit</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="type-badge badge-debit">Debit</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="${t.type.equalsIgnoreCase('DEPOSIT') || t.type.contains('FROM') ? 'amount-credit' : 'amount-debit'}">
                                            ${t.type.equalsIgnoreCase('DEPOSIT') || t.type.contains('FROM') ? '+' : '-'}
                                            ₹ <fmt:formatNumber value="${t.amount}" minFractionDigits="2" />
                                        </td>
                                        <td style="color: var(--secondary); font-size: 0.85rem;">
                                            <fmt:formatDate value="${t.timestamp}" pattern="dd MMM yyyy, HH:mm" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" style="text-align:center; padding: 40px; color: var(--secondary);">
                                        No recent transactions found.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <a href="dashboard" class="back-btn">← Back to Dashboard</a>
    </div>

</body>
</html>