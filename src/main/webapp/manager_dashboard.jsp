<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.nexusbank.model.WithdrawalRequest, com.nexusbank.model.User" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NexusBank | Manager Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0f172a;
            --accent: #2563eb;
            --success: #22c55e;
            --pending: #f59e0b;
            --danger: #ef4444;
            --bg: #f1f5f9;
        }

        body { font-family: 'Inter', sans-serif; background-color: var(--bg); margin: 0; padding: 20px; color: #1e293b; }
        .container { max-width: 1100px; margin: 40px auto; }

        .admin-header {
            background: var(--primary);
            color: white;
            padding: 30px;
            border-radius: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
        }

        .admin-info h2 { margin: 0; font-size: 1.5rem; }
        .role-badge { background: rgba(255,255,255,0.2); padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; }

        .alert { padding: 15px; border-radius: 12px; margin-bottom: 20px; font-weight: 600; text-align: center; border: 1px solid transparent; }
        .alert-error { background: #fee2e2; color: #b91c1c; border-color: #fecaca; }
        .alert-success { background: #dcfce7; color: #15803d; border-color: #bbf7d0; }

        .table-card { background: white; border-radius: 16px; padding: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { padding: 16px; color: #64748b; font-weight: 600; font-size: 0.85rem; text-transform: uppercase; border-bottom: 2px solid #f1f5f9; }
        td { padding: 16px; border-bottom: 1px solid #f1f5f9; font-size: 0.95rem; }
        tr:hover { background: #f8fafc; }

        .status-pill { padding: 4px 10px; border-radius: 6px; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; }
        .status-check { background: #dcfce7; color: #15803d; }
        .status-wait { background: #fef3c7; color: #b45309; }
        .status-lock { background: #f1f5f9; color: #94a3b8; }
        .status-fail { background: #fee2e2; color: #b91c1c; border: 1px solid #fca5a5; }

        .btn-approve { background: var(--accent); color: white; border: none; padding: 8px 16px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; display: inline-block; }
        .btn-approve:hover { background: #1d4ed8; transform: translateY(-1px); box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2); }

        .logout-btn { color: #94a3b8; text-decoration: none; font-weight: 500; transition: color 0.2s; }
        .logout-btn:hover { color: #f87171; }

        .back-link { color: var(--accent); font-weight: 600; text-decoration: none; display: flex; align-items: center; gap: 5px; margin-bottom: 15px; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="container">
    <div class="admin-header">
        <div class="admin-info">
            <h2>Portal: ${sessionScope.user.name}</h2>
            <span class="role-badge">Level: ${sessionScope.user.role}</span>
        </div>
        <div style="display:flex; align-items:center; gap: 20px;">
            <button onclick="location.href='managerDashboard'" style="background:none; border: 1px solid #475569; color: white; padding: 5px 10px; border-radius: 8px; cursor: pointer; font-size: 0.8rem;">Refresh Home</button>
            <a href="logout" class="logout-btn">Logout</a>
        </div>
    </div>

    <%-- Error/Success Messages from Servlet --%>
    <c:if test="${not empty param.error}">
        <div class="alert alert-error">⚠️ ${param.error}</div>
    </c:if>
    <c:if test="${not empty param.message}">
        <div class="alert alert-success">✅ ${param.message}</div>
    </c:if>

    <div class="table-card">
        <c:choose>
            <%-- VIEW 1: CUSTOMER DIRECTORY (When viewingCustomer is false) --%>
            <c:when test="${!viewingCustomer}">
                <h3 style="margin-top: 0; margin-bottom: 20px; color: var(--primary);">Customer Pending Requests</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Customer Name</th>
                            <th>Account Number</th>
                            <th>User ID</th>
                            <th style="text-align:right">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cust" items="${customerList}">
                            <tr>
                                <td style="font-weight: 600; color: var(--primary);">${cust.name}</td>
                                <td style="font-family: monospace; letter-spacing: 1px;">${cust.accountNumber}</td>
                                <td style="color: #64748b;">#${cust.id}</td>
                                <td align="right">
                                    <a href="managerDashboard?viewCustomer=${cust.id}" class="btn-approve">View Requests</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty customerList}">
                            <tr><td colspan="4" style="text-align: center; color: #94a3b8; padding: 40px;">No pending customer withdrawals found.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </c:when>

            <%-- VIEW 2: INDIVIDUAL CUSTOMER REQUESTS (When viewingCustomer is true) --%>
            <c:otherwise>
                <a href="managerDashboard" class="back-link">← Back to Directory</a>
                <h3 style="margin-top: 0; margin-bottom: 20px; color: var(--primary);">Withdrawal History: User ID #${param.viewCustomer}</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Req ID</th>
                            <th>Amount</th>
                            <th style="text-align:center">Current Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${pendingRequests}">
                            <tr>
                                <td>#${r.id}</td>
                                <td style="font-weight: 700;">₹ <fmt:formatNumber value="${r.amount}" pattern="#,##0.00" /></td>

                                <td align="center">
                                    <c:choose>
                                        <c:when test="${r.status == 'COMPLETED'}">
                                            <span class="status-pill status-check">✅ SUCCESS</span>
                                        </c:when>
                                        <c:when test="${r.status.contains('FAILED') || r.status.contains('REJECTED')}">
                                            <span class="status-pill status-fail" title="${r.status}">
                                                ❌ ${r.status.contains('Funds') ? 'INSUFFICIENT FUNDS' : 'FAILED'}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-pill status-wait">${r.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${r.status == 'COMPLETED' || r.status.contains('REJECTED') || r.status.contains('FAILED')}">
                                            <span style="color: #94a3b8; font-size: 0.85rem; font-style: italic;">Transaction Archived</span>
                                        </c:when>

                                        <c:otherwise>
                                            <form action="managerDashboard" method="POST" style="margin: 0;">
                                                <input type="hidden" name="requestId" value="${r.id}">
                                                <input type="hidden" name="action" value="approve">

                                                <c:choose>
                                                    <%-- M1 Role --%>
                                                    <c:when test="${sessionScope.user.role == 'M1'}">
                                                        <c:choose>
                                                            <c:when test="${!r.m1Approved}">
                                                                <button type="submit" class="btn-approve">Approve</button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: #22c55e; font-weight: 600;">Signed ✅</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>

                                                    <%-- M2 Role --%>
                                                    <c:when test="${sessionScope.user.role == 'M2'}">
                                                        <c:choose>
                                                            <c:when test="${!r.m2Approved && r.m1Approved}">
                                                                <button type="submit" class="btn-approve">Approve</button>
                                                            </c:when>
                                                            <c:when test="${r.m2Approved}">
                                                                <span style="color: #22c55e; font-weight: 600;">Signed ✅</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-pill status-lock">🔒 Wait M1</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>

                                                    <%-- M3 Role --%>
                                                    <c:when test="${sessionScope.user.role == 'M3'}">
                                                        <c:choose>
                                                            <c:when test="${!r.m3Approved && r.m1Approved && r.m2Approved}">
                                                                <button type="submit" class="btn-approve">Final Sign</button>
                                                            </c:when>
                                                            <c:when test="${r.m3Approved}">
                                                                <span style="color: #22c55e; font-weight: 600;">Signed ✅</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-pill status-lock">🔒 Wait M1/M2</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                </c:choose>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // Refresh logic if needed
</script>

</body>
</html>