<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - Step 2</title>
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
 
        .email-info {
            background: rgba(102, 126, 234, 0.2);
            color: rgba(255, 255, 255, 0.95);
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            font-weight: 500;
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
 
        .step.completed {
            background: var(--success-color);
            color: white;
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
 
        .step-line.completed {
            background: var(--success-color);
        }
 
        .otp-container {
            margin-bottom: 2rem;
        }
 
        .otp-inputs {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 1.5rem 0;
        }
 
        .otp-input {
            width: 50px;
            height: 50px;
            text-align: center;
            font-size: 1.5rem;
            font-weight: 600;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.9);
            transition: all 0.3s ease;
        }
 
        .otp-input:focus {
            outline: none;
            border-color: #667eea;
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
            transform: scale(1.05);
        }
 
        .otp-input.error {
            border-color: var(--error-color);
            background: rgba(239, 68, 68, 0.1);
        }
 
        .timer-container {
            margin: 1rem 0;
        }
 
        .timer {
            font-size: 1.1rem;
            font-weight: 600;
            color: rgba(255, 255, 255, 0.9);
        }
 
        .timer.expired {
            color: var(--error-color);
        }
 
        .resend-container {
            margin: 1rem 0;
        }
 
        .resend-btn {
            background: none;
            border: none;
            color: #667eea;
            font-weight: 600;
            cursor: pointer;
            text-decoration: underline;
            transition: all 0.3s ease;
        }
 
        .resend-btn:hover {
            color: #764ba2;
        }
 
        .resend-btn:disabled {
            color: rgba(255, 255, 255, 0.5);
            cursor: not-allowed;
            text-decoration: none;
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
 
            .otp-inputs {
                gap: 10px;
            }
 
            .otp-input {
                width: 45px;
                height: 45px;
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="<c:url value='/images/etsBlackLogo.png'/>" alt="ETS Logo" class="logo">
        <h1>Verify OTP</h1>
        <p class="subtitle">We've sent a 6-digit verification code to your email.</p>
 
        <!-- Step Indicator -->
        <div class="step-indicator">
            <div class="step completed">1</div>
            <div class="step-line completed"></div>
            <div class="step active">2</div>
            <div class="step-line"></div>
            <div class="step inactive">3</div>
        </div>
 
        <!-- Email Info -->
        <div class="email-info">
            <i class="fas fa-envelope"></i>
            OTP sent to: <strong>${sessionScope.resetEmail}</strong>
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
 
        <!-- OTP Form -->
        <form id="otpForm" action="/forgot-password/verifyOtp" method="post">
            <div class="otp-container">
                <div class="otp-inputs">
                    <input type="text" class="otp-input" maxlength="1" data-index="0" required>
                    <input type="text" class="otp-input" maxlength="1" data-index="1" required>
                    <input type="text" class="otp-input" maxlength="1" data-index="2" required>
                    <input type="text" class="otp-input" maxlength="1" data-index="3" required>
                    <input type="text" class="otp-input" maxlength="1" data-index="4" required>
                    <input type="text" class="otp-input" maxlength="1" data-index="5" required>
                </div>
                <input type="hidden" name="otp" id="otpValue">
                <input type="hidden" name="email" value="${sessionScope.resetEmail}">
            </div>
 
            <!-- Timer -->
            <div class="timer-container">
                <div class="timer" id="timer">OTP expires in: <span id="countdown">05:00</span></div>
            </div>
 
            <button type="submit" class="btn" id="verifyBtn">
                <span class="btn-text">
                    <i class="fas fa-shield-alt"></i> Verify OTP
                </span>
            </button>
        </form>
 
        <!-- Resend OTP -->
        <div class="resend-container">
            <p style="color: rgba(255, 255, 255, 0.8); margin-bottom: 0.5rem;">Didn't receive the code?</p>
            <button type="button" class="resend-btn" id="resendBtn" disabled>
                <i class="fas fa-redo"></i> Resend OTP
            </button>
        </div>
 
        <a href="/forgot-password" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Change Email Address
        </a>
    </div>
 
    <script>
        // OTP Input Handling
        const otpInputs = document.querySelectorAll('.otp-input');
        const otpValue = document.getElementById('otpValue');
        const form = document.getElementById('otpForm');
        const verifyBtn = document.getElementById('verifyBtn');
        const btnText = verifyBtn.querySelector('.btn-text');
 
        otpInputs.forEach((input, index) => {
            input.addEventListener('input', function(e) {
                const value = e.target.value;
                
                // Only allow numbers
                if (!/^\d*$/.test(value)) {
                    e.target.value = '';
                    return;
                }
 
                // Move to next input
                if (value && index < otpInputs.length - 1) {
                    otpInputs[index + 1].focus();
                }
 
                // Update hidden input with complete OTP
                updateOTPValue();
            });
 
            input.addEventListener('keydown', function(e) {
                // Move to previous input on backspace
                if (e.key === 'Backspace' && !e.target.value && index > 0) {
                    otpInputs[index - 1].focus();
                }
            });
 
            input.addEventListener('paste', function(e) {
                e.preventDefault();
                const paste = (e.clipboardData || window.clipboardData).getData('text');
                const digits = paste.replace(/\D/g, '').slice(0, 6);
                
                digits.split('').forEach((digit, i) => {
                    if (otpInputs[i]) {
                        otpInputs[i].value = digit;
                    }
                });
 
                if (digits.length === 6) {
                    otpInputs[5].focus();
                }
 
                updateOTPValue();
            });
        });
 
        function updateOTPValue() {
            const otp = Array.from(otpInputs).map(input => input.value).join('');
            otpValue.value = otp;
        }

        // Timer functionality
        let timeLeft = 300; // 5 minutes in seconds
        const countdown = document.getElementById('countdown');
        const timer = document.getElementById('timer');
        const resendBtn = document.getElementById('resendBtn');

        function formatTime(seconds) {
            const minutes = Math.floor(seconds / 60);
            const remainingSeconds = seconds % 60;
            return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
        }

        function updateTimer() {
            if (timeLeft <= 0) {
                timer.classList.add('expired');
                countdown.textContent = '00:00';
                timer.innerHTML = '<i class="fas fa-clock"></i> OTP has expired';
                resendBtn.disabled = false;
                otpInputs.forEach(input => input.disabled = true);
                verifyBtn.disabled = true;
                return;
            }

            countdown.textContent = formatTime(timeLeft);
            timeLeft--;
        }

        // Start timer
        const timerInterval = setInterval(updateTimer, 1000);
        updateTimer(); // Initial call

        // Form submission with loading state
        form.addEventListener('submit', function(e) {
            const otp = otpValue.value;
            
            if (otp.length !== 6) {
                e.preventDefault();
                showError('Please enter the complete 6-digit OTP');
                return;
            }

            // Add loading state
            verifyBtn.classList.add('loading');
            verifyBtn.disabled = true;
            btnText.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Verifying...';
        });

        // Resend OTP functionality
        resendBtn.addEventListener('click', function() {
            resendBtn.disabled = true;
            resendBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';

            fetch('/forgot-password/resend-otp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'email=' + encodeURIComponent('${sessionScope.resetEmail}')
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSuccess('OTP sent successfully! Please check your email.');
                    // Reset timer
                    timeLeft = 300;
                    timer.classList.remove('expired');
                    timer.innerHTML = 'OTP expires in: <span id="countdown">05:00</span>';
                    clearInterval(timerInterval);
                    const newTimerInterval = setInterval(updateTimer, 1000);
                    
                    // Re-enable inputs and verify button
                    otpInputs.forEach(input => input.disabled = false);
                    verifyBtn.disabled = false;
                    
                    // Clear previous OTP
                    otpInputs.forEach(input => input.value = '');
                    otpInputs[0].focus();
                    updateOTPValue();
                } else {
                    showError(data.message || 'Failed to resend OTP. Please try again.');
                }
            })
            .catch(error => {
                showError('Network error. Please try again.');
            })
            .finally(() => {
                resendBtn.innerHTML = '<i class="fas fa-redo"></i> Resend OTP';
                setTimeout(() => {
                    resendBtn.disabled = false;
                }, 30000); // 30 second delay before allowing another resend
            });
        });

        // Helper functions for showing messages
        function showError(message) {
            removeExistingMessages();
            const errorDiv = document.createElement('div');
            errorDiv.className = 'message message-error';
            errorDiv.innerHTML = `<i class="fas fa-exclamation-triangle"></i> ${message}`;
            
            const form = document.getElementById('otpForm');
            form.parentNode.insertBefore(errorDiv, form);
            
            // Add error styling to inputs
            otpInputs.forEach(input => input.classList.add('error'));
            
            setTimeout(() => {
                otpInputs.forEach(input => input.classList.remove('error'));
            }, 3000);
        }

        function showSuccess(message) {
            removeExistingMessages();
            const successDiv = document.createElement('div');
            successDiv.className = 'message message-success';
            successDiv.innerHTML = `<i class="fas fa-check-circle"></i> ${message}`;
            
            const form = document.getElementById('otpForm');
            form.parentNode.insertBefore(successDiv, form);
        }

        function removeExistingMessages() {
            const existingMessages = document.querySelectorAll('.message');
            existingMessages.forEach(msg => {
                if (!msg.innerHTML.includes('${error}') && !msg.innerHTML.includes('${message}')) {
                    msg.remove();
                }
            });
        }

        // Auto-focus first input on page load
        document.addEventListener('DOMContentLoaded', function() {
            otpInputs[0].focus();
        });

        // Handle keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && otpValue.value.length === 6) {
                form.submit();
            }
        });
    </script>
</body>
</html>