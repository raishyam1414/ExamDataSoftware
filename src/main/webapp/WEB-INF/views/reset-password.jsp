<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Reset Password</title>
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            background: #fff;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        h1 { margin-bottom: 1rem; }
        .form-group { margin-bottom: 1rem; text-align: left; }
        .form-group label { display: block; margin-bottom: .5rem; }
        .form-control {
            width: 100%;
            padding: .75rem;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
        }
        .btn {
            width: 100%;
            padding: .75rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            color: white;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
        }
        .error {
            background: #fee;
            color: #c33;
            padding: .75rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            border-left: 4px solid #c33;
        }
        .success {
            background: #e6ffed;
            color: #2d7a46;
            padding: .75rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            border-left: 4px solid #2d7a46;
        }
    </style>
</head>
<body>
    <div class="container">
		<img src="<c:url value='/images/etsBlackLogo.png'/>" alt="ETS Logo" class="logo" style="height: 51px;">
        <h1>Reset Password</h1>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>

        <form action="/forgot-password/reset-password" method="post">
			
            <div class="form-group">
                <label>New Password:</label>
                <input type="password" name="newPassword" class="form-control" placeholder="Enter new password" required>
            </div>

            <div class="form-group">
                <label>Confirm Password:</label>
                <input type="password" name="confirmPassword" class="form-control" placeholder="Confirm new password" required>
            </div>

            <button type="submit" class="btn">Reset Password</button>
        </form>
    </div>
</body>
</html>
