<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Login - Exam Upload</title>
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
        .logo {
            width: 120px;
            height: auto;
            margin-bottom: 1rem;
        }
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
    </style>
</head>
<body>
    <div class="container">
        <!-- Logo -->
        <img src="<c:url value='/images/etsBlackLogo.png'/>" alt="ETS Logo" class="logo">

        <h1>Exam Upload</h1>
        <p>Secure Question Management</p>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form action="/login" method="post">
            <div class="form-group">
                <label>Email:</label>
                <input type="text" name="username" class="form-control" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
            </div>

            <button type="submit" class="btn">Sign In</button>
        </form>
    </div>
</body>
</html>
