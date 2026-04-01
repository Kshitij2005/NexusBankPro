<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Transaction History - NexusBank</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f2f2f2; }
        .deposit { color: green; font-weight: bold; }
        .withdraw { color: red; font-weight: bold; }
        .back-btn { display: inline-block; margin-top: 20px; text-decoration: none; color: blue; }
    </style>
</head>
<body>

    <h2>Transaction History</h2>
    <p>Account Holder: <strong>${sessionScope.user.name}</strong></p>

    <table>
        <thead>
            <tr>
                <th>Transaction ID</th>
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
                            <td>${t.id}</td>
                            <td class="${t.type.toLowerCase()}">${t.type}</td>
                            <td>$ <fmt:formatNumber value="${t.amount}" minFractionDigits="2" /></td>
                            <td><fmt:formatDate value="${t.timestamp}" pattern="dd-MMM-yyyy HH:mm:ss" /></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="4" style="text-align:center;">No transactions found.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <a href="dashboard.jsp" class="back-btn">← Back to Dashboard</a>

</body>
</html>