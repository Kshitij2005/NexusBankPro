<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.nexusbank.model.WithdrawalRequest, com.nexusbank.model.User, com.nexusbank.model.Loan" %>
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

        body { font-family: 'Inter', sans-serif; background-color: var(--bg); margin: 0; padding: 10px; color: #1e293b; }
        .container { width: 100%; max-width: 1100px; margin: 20px auto; box-sizing: border-box; }

        .admin-header {
            background: var(--primary);
            color: white;
            padding: 20px;
            border-radius: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
            flex-wrap: wrap;
            gap: 15px;
        }

        .admin-info h2 { margin: 0; font-size: 1.25rem; }
        .role-badge { background: rgba(255,255,255,0.2); padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; }

        .alert { padding: 15px; border-radius: 12px; margin-bottom: 20px; font-weight: 600; text-align: center; border: 1px solid transparent; font-size: 0.9rem; }
        .alert-error { background: #fee2e2; color: #b91c1c; border-color: #fecaca; }
        .alert-success { background: #dcfce7; color: #15803d; border-color: #bbf7d0; }

        .table-card { background: white; border-radius: 16px; padding: 15px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; margin-bottom: 25px; }
        .table-responsive { width: 100%; overflow-x: auto; -webkit-overflow-scrolling: touch; }

        table { width: 100%; min-width: 700px; border-collapse: collapse; text-align: left; }
        th { padding: 12px; color: #64748b; font-weight: 600; font-size: 0.8rem; text-transform: uppercase; border-bottom: 2px solid #f1f5f9; }
        td { padding: 12px; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; }
        tr:hover { background: #f8fafc; }

        .status-pill { padding: 4px 8px; border-radius: 6px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; white-space: nowrap; }
        .status-check { background: #dcfce7; color: #15803d; }
        .status-wait { background: #fef3c7; color: #b45309; }
        .status-lock { background: #f1f5f9; color: #94a3b8; }
        .status-fail { background: #fee2e2; color: #b91c1c; border: 1px solid #fca5a5; }

        .btn-approve { background: var(--accent); color: white; border: none; padding: 8px 14px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; display: inline-block; font-size: 0.85rem; }
        .btn-danger { background: var(--danger) !important; }
        .btn-approve:hover { filter: brightness(90%); transform: translateY(-1px); }

        .logout-btn { color: #94a3b8; text-decoration: none; font-weight: 500; font-size: 0.9rem; }
        .back-link { color: var(--accent); font-weight: 600; text-decoration: none; display: flex; align-items: center; gap: 5px; margin-bottom: 15px; font-size: 0.9rem; }

        .hierarchy-box { display: flex; gap: 10px; align-items: center; }

        @media (max-width: 600px) {
            .admin-header { justify-content: center; text-align: center; }
            .admin-info { width: 100%; }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="admin-header">
        <div class="admin-info">
            <h2>Portal: ${sessionScope.user.name}</h2>
            <span class="role-badge">Level: ${sessionScope.user.role}</span>
        </div>
        <div style="display:flex; align-items:center; gap: 15px;">
            <button onclick="location.href='managerDashboard'" style="background:none; border: 1px solid #475569; color: white; padding: 6px 12px; border-radius: 8px; cursor: pointer; font-size: 0.75rem;">Refresh</button>
            <a href="logout" class="logout-btn">Logout</a>
        </div>
    </div>

    <%-- Success/Error Alerts --%>
    <c:if test="${not empty param.error}"><div class="alert alert-error">⚠️ ${param.error}</div></c:if>
    <c:if test="${not empty param.message}"><div class="alert alert-success">✅ ${param.message}</div></c:if>

    <%-- LOAN SECTION: DIRECTORY STYLE --%>
    <div class="table-card" style="border-top: 4px solid var(--accent);">
        <c:choose>
            <%-- VIEW 1: LOAN CUSTOMER DIRECTORY --%>
            <c:when test="${!viewingLoanDetails}">
                <h3 style="margin-top: 0; margin-bottom: 20px; color: var(--primary);">🚀 Loan: Customer Directory</h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Customer Name</th>
                                <th>User ID</th>
                                <th style="text-align:right">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cust" items="${loanCustomerList}">
                                <tr>
                                    <td style="font-weight: 600; color: var(--primary);">${cust.name}</td>
                                    <td style="color: #64748b;">#${cust.id}</td>
                                    <td align="right">
                                        <a href="managerDashboard?viewLoanCustomer=${cust.id}" class="btn-approve">View Loan Requests</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty loanCustomerList}">
                                <tr><td colspan="3" style="text-align: center; color: #94a3b8; padding: 30px;">No pending loan customers.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </c:when>

            <%-- VIEW 2: SPECIFIC USER LOAN DETAILS --%>
            <c:otherwise>
                <a href="managerDashboard" class="back-link">← Back to Loan Directory</a>
                <h3 style="margin-top: 0; margin-bottom: 20px; color: var(--primary);">Loan Requests: User #${param.viewLoanCustomer}</h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Amount</th>
                                <th>Purpose & Term</th>
                                <th style="text-align:center">M1</th>
                                <th style="text-align:center">M2</th>
                                <th style="text-align:center">M3</th>
                                <th style="text-align:right">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="loan" items="${specificUserLoans}">
                                <tr>
                                    <td style="font-weight: 700; color: var(--primary);">₹ <fmt:formatNumber value="${loan.amount}" pattern="#,##0.00" /></td>
                                    <td>
                                        <span class="status-pill status-lock">${loan.purpose}</span><br>
                                        <small style="color:var(--secondary)">Tenure: ${loan.tenure} Months</small>
                                    </td>

                                    <%-- Hierarchy Icons --%>
                                    <td align="center">${loan.m1Approved ? "✅" : "⏳"}</td>
                                    <td align="center">${loan.m2Approved ? "✅" : "⏳"}</td>
                                    <td align="center">${loan.m3Approved ? "✅" : "⏳"}</td>

                                    <td align="right">
                                        <c:if test="${loan.status == 'PENDING'}">
                                            <div class="hierarchy-box" style="justify-content: flex-end;">
                                                <form action="approveLoan" method="POST" style="margin:0;">
                                                    <input type="hidden" name="loanId" value="${loan.id}">
                                                    <c:choose>
                                                        <c:when test="${sessionScope.user.role == 'M1' && !loan.m1Approved}">
                                                            <button type="submit" name="action" value="APPROVED" class="btn-approve">Approve (M1)</button>
                                                        </c:when>
                                                        <c:when test="${sessionScope.user.role == 'M2' && loan.m1Approved && !loan.m2Approved}">
                                                            <button type="submit" name="action" value="APPROVED" class="btn-approve">Approve (M2)</button>
                                                        </c:when>
                                                        <c:when test="${sessionScope.user.role == 'M3' && loan.m1Approved && loan.m2Approved && !loan.m3Approved}">
                                                            <button type="submit" name="action" value="APPROVED" class="btn-approve" style="background:var(--success)">Final Payout</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-pill status-lock">Pending Hierarchy</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button type="submit" name="action" value="REJECTED" class="btn-approve btn-danger" style="padding: 8px 10px;">Reject</button>
                                                </form>
                                            </div>
                                        </c:if>
                                        <c:if test="${loan.status != 'PENDING'}">
                                            <span class="status-pill ${loan.status == 'APPROVED' ? 'status-check' : 'status-fail'}">
                                                ${loan.status}
                                            </span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- WITHDRAWAL SECTION --%>
    <div class="table-card">
        <c:choose>
            <c:when test="${!viewingCustomer}">
                <h3 style="margin-top: 0; margin-bottom: 20px; color: var(--primary);">Withdrawal: Customer Directory</h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Customer Name</th>
                                <th>User ID</th>
                                <th style="text-align:right">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cust" items="${customerList}">
                                <tr>
                                    <td style="font-weight: 600; color: var(--primary);">${cust.name}</td>
                                    <td style="color: #64748b;">#${cust.id}</td>
                                    <td align="right"><a href="managerDashboard?viewCustomer=${cust.id}" class="btn-approve">View Details</a></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>

            <c:otherwise>
                <a href="managerDashboard" class="back-link">← Back to Directory</a>
                <h3 style="margin-top: 0; margin-bottom: 20px; color: var(--primary);">History: User #${param.viewCustomer}</h3>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>Req ID</th>
                                <th>Amount</th>
                                <th style="text-align:center">Status</th>
                                <th style="text-align:right">Sign-off</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${pendingRequests}">
                                <tr>
                                    <td>#${r.id}</td>
                                    <td style="font-weight: 700;">₹ <fmt:formatNumber value="${r.amount}" pattern="#,##0.00" /></td>
                                    <td align="center">
                                        <span class="status-pill ${r.status == 'COMPLETED' ? 'status-check' : (r.status.contains('REJECTED') ? 'status-fail' : 'status-wait')}">
                                            ${r.status}
                                        </span>
                                    </td>
                                    <td align="right">
                                        <c:if test="${r.status != 'COMPLETED' && !r.status.contains('REJECTED')}">
                                            <form action="managerDashboard" method="POST" style="margin:0;">
                                                <input type="hidden" name="requestId" value="${r.id}">
                                                <input type="hidden" name="action" value="approve">
                                                <c:choose>
                                                    <c:when test="${sessionScope.user.role == 'M1' && !r.m1Approved}"><button class="btn-approve">M1 Sign</button></c:when>
                                                    <c:when test="${sessionScope.user.role == 'M2' && r.m1Approved && !r.m2Approved}"><button class="btn-approve">M2 Sign</button></c:when>
                                                    <c:when test="${sessionScope.user.role == 'M3' && r.m1Approved && r.m2Approved && !r.m3Approved}"><button class="btn-approve">Final Sign</button></c:when>
                                                    <c:otherwise><span class="status-pill status-lock">Wait Hierarchy</span></c:otherwise>
                                                </c:choose>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>