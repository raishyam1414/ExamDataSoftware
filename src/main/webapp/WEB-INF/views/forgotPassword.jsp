<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Step 1</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --success-color: #10b981;
            --error-color: #ef4444;
            --glass-bg: rgba(255, 255, 255, 0.25);
            --glass-border: rgba(255, 255, 255, 0.18);
            --text-primary: #2d3748;
            --text-secondary: #718096;
            --shadow-light: 0 8px 32px rgba(31, 38, 135, 0.37);
            --shadow-hover: 0 15px 35px rgba(31, 38, 135, 0.2);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-primary);
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .container {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            border: 1px solid var(--glass-border);
            box-shadow: var(--shadow-light);
            padding: 22px 27px 15px;
            width: 100%;
            max-width: 450px;
            text-align: center;
            animation: fadeInUp 0.8s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logo {
            height: 60px;
            margin-bottom: 1.5rem;
            filter: drop-shadow(0 4px 8px rgba(0,0,0,0.1));
        }

        h1 {
            font-size: 2.2rem;
            font-weight: 700;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
        }

        .subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
            margin-bottom: 2rem;
            line-height: 1.5;
        }

        .step-indicator {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 2rem;
        }

        .step {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            font-weight: 600;
            font-size: 0.9rem;
            margin: 0 10px;
            transition: all 0.3s ease;
        }

        .step.active {
            background: var(--primary-gradient);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .step.inactive {
            background: rgba(255, 255, 255, 0.3);
            color: rgba(255, 255, 255, 0.7);
        }

        .step-line {
            width: 60px;
            height: 2px;
            background: rgba(255, 255, 255, 0.3);
        }

        .step-line.active {
            background: var(--primary-gradient);
        }

        .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }

        .form-label {
            display: block;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .input-wrapper {
            position: relative;
        }

        .form-control {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.9);
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
            transform: translateY(-2px);
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #718096;
            font-size: 1.1rem;
        }

        .btn {
            width: 100%;
            padding: 1rem;
            background: var(--primary-gradient);
            border: none;
            color: white;
            font-weight: 600;
            font-size: 1rem;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .message {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .message-success {
            background: rgba(16, 185, 129, 0.2);
            color: #065f46;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .message-error {
            background: rgba(239, 68, 68, 0.2);
            color: #7f1d1d;
            border: 1px solid rgba(239, 68, 68, 0.3);
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-weight: 500;
            margin-top: 1.5rem;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            color: white;
            transform: translateX(-5px);
        }

        .loading-spinner {
            display: none;
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255,255,255,0.3);
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 10px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .btn.loading .loading-spinner {
            display: inline-block;
        }

        @media (max-width: 480px) {
            .container {
                margin: 1rem;
                padding: 2rem;
            }

            h1 {
                font-size: 1.8rem;
            }

            .step-line {
                width: 40px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="<c:url value='/images/etsBlackLogo.png'/>" alt="ETS Logo" class="logo">
        <h1>Forgot Password</h1>
        <p class="subtitle">Don't worry! We'll help you reset your password securely.</p>

        <!-- Step Indicator -->
        <div class="step-indicator">
            <div class="step active">1</div>
            <div class="step-line"></div>
            <div class="step inactive">2</div>
            <div class="step-line"></div>
            <div class="step inactive">3</div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty error}">
            <div class="message message-error">
                <i class="fas fa-exclamation-triangle"></i>
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="message message-success">
                <i class="fas fa-check-circle"></i>
                ${message}
            </div>
        </c:if>

        <!-- Email Form -->
        <form id="emailForm" action="/forgot-password/send-otp" method="post">
            <div class="form-group">
                <label class="form-label">
                    <i class="fas fa-envelope"></i> Email Address
                </label>
                <div class="input-wrapper">
                    <i class="fas fa-envelope input-icon"></i>
                    <input type="email" 
                           name="email" 
                           class="form-control" 
                           placeholder="Enter your registered email address" 
                           value="${param.email}"
                           required>
                </div>
            </div>

            <button type="submit" class="btn" id="sendOtpBtn">
                <span class="loading-spinner"></span>
                <span class="btn-text">
                    <i class="fas fa-paper-plane"></i> Send OTP to Email
                </span>
            </button>
        </form>

        <a href="/loginPage" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Back to Login
        </a>
    </div>

    <script>
        // Form submission with loading state
        document.getElementById('emailForm').addEventListener('submit', function(e) {
            const btn = document.getElementById('sendOtpBtn');
            const btnText = btn.querySelector('.btn-text');
            
            btn.classList.add('loading');
            btn.disabled = true;
            btnText.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending OTP...';
        });

        // Auto-hide messages after 5 seconds
        setTimeout(() => {
            const messages = document.querySelectorAll('.message');
            messages.forEach(message => {
                message.style.opacity = '0';
                message.style.transform = 'translateY(-20px)';
                setTimeout(() => {
                    message.remove();
                }, 300);
            });
        }, 5000);
    </script>
</body>
</html>