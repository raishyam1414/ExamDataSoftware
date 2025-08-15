package com.excelFileUpload.ExamDataUpload.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.excelFileUpload.ExamDataUpload.Entity.ApiResponse;
import com.excelFileUpload.ExamDataUpload.Entity.UserLogin;
import com.excelFileUpload.ExamDataUpload.Service.EmailService;
import com.excelFileUpload.ExamDataUpload.Service.OTPService;
import com.excelFileUpload.ExamDataUpload.Service.UserService;

import jakarta.servlet.http.HttpSession;

import org.springframework.ui.Model;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import java.time.LocalDateTime;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/forgot-password")
public class ForgotPasswordController {

    private static final Logger logger = LoggerFactory.getLogger(ForgotPasswordController.class);
    
    // In-memory storage for OTPs (in production, use Redis or database)
    private final Map<String, OTPData> otpStorage = new ConcurrentHashMap<>();
    private final Map<String, Integer> attemptCounter = new ConcurrentHashMap<>();
    
    private static final int OTP_EXPIRY_MINUTES = 5;
    private static final int MAX_ATTEMPTS = 3;
    private static final int RESEND_LIMIT_MINUTES = 1;
    private static final int MAX_RESEND_COUNT = 3;

    @Autowired
    private UserService userService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private OTPService otpService;

    private static class OTPData {
        private String otp;
        private LocalDateTime createdAt;
        private int attempts;
        private int resendCount;
        private LocalDateTime lastResendAt;

        public OTPData(String otp) {
            this.otp = otp;
            this.createdAt = LocalDateTime.now();
            this.attempts = 0;
            this.resendCount = 0;
            this.lastResendAt = LocalDateTime.now();
        }

        public boolean isExpired() {
            return Duration.between(createdAt, LocalDateTime.now()).toMinutes() >= OTP_EXPIRY_MINUTES;
        }

        public boolean canResend() {
            if (lastResendAt == null) return true;
            return Duration.between(lastResendAt, LocalDateTime.now()).toMinutes() >= RESEND_LIMIT_MINUTES;
        }

        public boolean hasExceededResendLimit() {
            return resendCount >= MAX_RESEND_COUNT;
        }

        // Getters and setters
        public String getOtp() { return otp; }
        public void setOtp(String otp) { this.otp = otp; }
        public LocalDateTime getCreatedAt() { return createdAt; }
        public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
        public int getAttempts() { return attempts; }
        public void setAttempts(int attempts) { this.attempts = attempts; }
        public int getResendCount() { return resendCount; }
        public void setResendCount(int resendCount) { this.resendCount = resendCount; }
        public LocalDateTime getLastResendAt() { return lastResendAt; }
        public void setLastResendAt(LocalDateTime lastResendAt) { this.lastResendAt = lastResendAt; }
    }

    /**
     * Display forgot password form (Step 1)
     */
    @GetMapping
    public String showForgotPasswordForm() {
        return "forgotPassword";
    }

    /**
     * Process forgot password form and send OTP (Step 1 → Step 2)
     */
    @PostMapping("/send-otp")
    public String processForgotPassword(@RequestParam("email") String email, 
                                      HttpSession session, 
                                      Model model) {
        try {
            // Validate email format
            if (!isValidEmail(email)) {
                model.addAttribute("error", "Please enter a valid email address");
                return "forgotPassword";
            }

            // Check if user exists
            UserLogin user = userService.findByUsername(email);
            if (user == null) {
                // Don't reveal if email exists or not for security
                logger.warn("Password reset attempted for non-existent email: {}", email);
                model.addAttribute("message", "If this email is registered, you will receive an OTP shortly.");
                return "forgotPassword";
            }

            // Generate and send OTP
            String otp = generateOTP();
            otpStorage.put(email, new OTPData(otp));
            
            // Store email in session
            session.setAttribute("resetEmail", email);
            
            // Send OTP email
            boolean emailSent = sendOTPEmail(email, otp, user.getUsername());
            System.out.println("OTP recieved"+ otp);
            
            if (emailSent) {
                logger.info("OTP sent successfully to email: {}", email);
                return "redirect:/forgot-password/verifyOtp";
            } else {
                model.addAttribute("error", "Failed to send OTP. Please try again later.");
                return "forgotPassword";
            }

        } catch (Exception e) {
            logger.error("Error processing forgot password request for email: {}", email, e);
            model.addAttribute("error", "An error occurred. Please try again later.");
            return "forgotPassword";
        }
    }

    /**
     * Display OTP verification form (Step 2)
     */
    @GetMapping("/verifyOtp")
    public String showVerifyOTPForm(HttpSession session, Model model) {
        String email = (String) session.getAttribute("resetEmail");
        
        if (email == null) {
            model.addAttribute("error", "Session expired. Please start the password reset process again.");
            return "forgotPassword";
        }

        // Check if OTP exists and is not expired
        OTPData otpData = otpStorage.get(email);
        if (otpData == null || otpData.isExpired()) {
            model.addAttribute("error", "OTP has expired. Please request a new one.");
            otpStorage.remove(email);
            return "forgotPassword";
        }

        return "verifyOtp";
    }

    /**
     * Process OTP verification (Step 2 → Step 3)
     */
    @PostMapping("/verifyOtp")
    public String verifyOTP(@RequestParam("otp") String enteredOTP,
                           @RequestParam("email") String email,
                           HttpSession session,
                           Model model) {
        try {
            // Validate session
            String sessionEmail = (String) session.getAttribute("resetEmail");
            if (sessionEmail == null || !sessionEmail.equals(email)) {
                model.addAttribute("error", "Invalid session. Please start over.");
                return "forgotPassword";
            }

            // Get OTP data
            OTPData otpData = otpStorage.get(email);
            if (otpData == null) {
                model.addAttribute("error", "OTP not found. Please request a new one.");
                return "forgotPassword";
            }

            // Check if OTP is expired
            if (otpData.isExpired()) {
                model.addAttribute("error", "OTP has expired. Please request a new one.");
                otpStorage.remove(email);
                return "forgotPassword";
            }

            // Check if max attempts exceeded
            if (otpData.getAttempts() >= MAX_ATTEMPTS) {
                model.addAttribute("error", "Maximum verification attempts exceeded. Please request a new OTP.");
                otpStorage.remove(email);
                return "forgotPassword";
            }

            // Validate OTP
            if (enteredOTP == null || enteredOTP.trim().length() != 6) {
                otpData.setAttempts(otpData.getAttempts() + 1);
                model.addAttribute("error", "Please enter a valid 6-digit OTP");
                return "verifyOtp";
            }

            // Verify OTP
            System.out.println("OTP recieved"+ otpData.getOtp());
            if (otpData.getOtp().equals(enteredOTP.trim())) {
                // OTP verified successfully
                session.setAttribute("otpVerified", true);
                session.setAttribute("otpVerificationTime", LocalDateTime.now());
                otpStorage.remove(email); // Clean up
                attemptCounter.remove(email);
                model.addAttribute("email", email);
                
                logger.info("OTP verified successfully for email: {}", email);
                return "redirect:/forgot-password/reset-password";
            } else {
                // Invalid OTP
                otpData.setAttempts(otpData.getAttempts() + 1);
                int remainingAttempts = MAX_ATTEMPTS - otpData.getAttempts();
                
                if (remainingAttempts > 0) {
                    model.addAttribute("error", 
                        String.format("Invalid OTP. You have %d attempt(s) remaining.", remainingAttempts));
                } else {
                    model.addAttribute("error", "Maximum attempts exceeded. Please request a new OTP.");
                    otpStorage.remove(email);
                }
                
                logger.warn("Invalid OTP attempt for email: {}. Attempts: {}", email, otpData.getAttempts());
                return "verifyOtp";
            }

        } catch (Exception e) {
            logger.error("Error verifying OTP for email: {}", email, e);
            model.addAttribute("error", "An error occurred during verification. Please try again.");
            return "verifyOtp";
        }
    }

    @PostMapping("/resend-otp")
    @ResponseBody
    public ResponseEntity<ApiResponse> resendOTP(@RequestParam("email") String email,
                                               HttpSession session) {
        try {
            // Validate session
            String sessionEmail = (String) session.getAttribute("resetEmail");
            if (sessionEmail == null || !sessionEmail.equals(email)) {
                return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, "Invalid session. Please start over."));
            }

            // Check if user exists
            UserLogin user = userService.findByEmail(email);
            if (user == null) {
                return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, "User not found."));
            }

            // Get existing OTP data
            OTPData existingOtpData = otpStorage.get(email);
            
            // Check resend limits
            if (existingOtpData != null) {
                if (!existingOtpData.canResend()) {
                    return ResponseEntity.badRequest()
                        .body(new ApiResponse(false, "Please wait before requesting another OTP."));
                }
                
                if (existingOtpData.hasExceededResendLimit()) {
                    return ResponseEntity.badRequest()
                        .body(new ApiResponse(false, "Maximum resend limit reached. Please try again later."));
                }
            }

            // Generate new OTP
            String newOTP = generateOTP();
            OTPData newOtpData = new OTPData(newOTP);
            
            // Update resend count if existing data
            if (existingOtpData != null) {
                newOtpData.setResendCount(existingOtpData.getResendCount() + 1);
            }
            
            otpStorage.put(email, newOtpData);

            // Send OTP email
            boolean emailSent = sendOTPEmail(email, newOTP, user.getFirstName());
            
            if (emailSent) {
                logger.info("OTP resent successfully to email: {}", email);
                return ResponseEntity.ok(new ApiResponse(true, "OTP sent successfully!"));
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse(false, "Failed to send OTP. Please try again."));
            }

        } catch (Exception e) {
            logger.error("Error resending OTP for email: {}", email, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ApiResponse(false, "An error occurred. Please try again later."));
        }
    }

    /**
     * Display reset password form (Step 3)
     */
    @GetMapping("/reset-password")
    public String showResetPasswordForm(HttpSession session, Model model) {
        String email = (String) session.getAttribute("resetEmail");
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        LocalDateTime verificationTime = (LocalDateTime) session.getAttribute("otpVerificationTime");
        
        model.addAttribute("email"+ email);
        
        if (email == null || otpVerified == null || !otpVerified) {
            model.addAttribute("error", "Please complete OTP verification first.");
            return "forgotPassword";
        }

        // Check if verification is still valid (10 minutes)
        if (verificationTime != null && 
            Duration.between(verificationTime, LocalDateTime.now()).toMinutes() > 10) {
            session.removeAttribute("otpVerified");
            session.removeAttribute("otpVerificationTime");
            model.addAttribute("error", "Verification expired. Please start over.");
            return "forgotPassword";
        }

        return "reset-password";
    }

    /**
     * Process password reset (Step 3 → Complete)
     */
    @PostMapping("/reset-password")
    public String resetPassword(@RequestParam("newPassword") String password,
                              @RequestParam("confirmPassword") String confirmPassword,
                              HttpSession session,
                              Model model) {
        try {
            String email = (String) session.getAttribute("resetEmail");
            Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
            
            if (email == null || otpVerified == null || !otpVerified) {
                model.addAttribute("error", "Please complete OTP verification first.");
                return "forgotPassword";
            }

            // Validate passwords
            if (password == null || password.trim().length() < 8) {
                model.addAttribute("error", "Password must be at least 8 characters long.");
                return "reset-password";
            }

            if (!password.equals(confirmPassword)) {
                model.addAttribute("error", "Passwords do not match.");
                return "reset-password";
            }

            // Update user password
            boolean passwordUpdated = userService.updatePassword(email, password);
            
            if (passwordUpdated) {
                // Clear session
                session.removeAttribute("resetEmail");
                session.removeAttribute("otpVerified");
                session.removeAttribute("otpVerificationTime");
                
                logger.info("Password reset successfully for email: {}", email);
                model.addAttribute("message", "Password reset successfully! You can now log in with your new password.");
                return "login";
            } else {
                model.addAttribute("error", "Failed to reset password. Please try again.");
                return "reset-password";
            }

        } catch (Exception e) {
            logger.error("Error resetting password", e);
            model.addAttribute("error", "An error occurred. Please try again.");
            return "reset-password";
        }
    }

    // Helper methods

    private String generateOTP() {
        Random random = new Random();
        return String.format("%06d", random.nextInt(1000000));
    }

    private boolean sendOTPEmail(String email, String otp, String firstName) {
        try {
            String subject = "Password Reset OTP - ETS";
            String body = buildOTPEmailTemplate(otp, firstName);
            
            return emailService.sendEmail(email, subject, body);
        } catch (Exception e) {
            logger.error("Error sending OTP email to: {}", email, e);
            return false;
        }
    }

    private String buildOTPEmailTemplate(String otp, String firstName) {
        return String.format(
            "<html><body style='font-family: Arial, sans-serif;'>" +
            "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
            "<h2 style='color: #333;'>Password Reset Request</h2>" +
            "<p>Hello %s,</p>" +
            "<p>You requested to reset your password. Use the following OTP to verify your identity:</p>" +
            "<div style='background: #f8f9fa; padding: 20px; border-radius: 8px; text-align: center; margin: 20px 0;'>" +
            "<h1 style='color: #667eea; font-size: 36px; margin: 0; letter-spacing: 5px;'>%s</h1>" +
            "</div>" +
            "<p><strong>Important:</strong></p>" +
            "<ul>" +
            "<li>This OTP is valid for 5 minutes only</li>" +
            "<li>Do not share this OTP with anyone</li>" +
            "<li>If you didn't request this, please ignore this email</li>" +
            "</ul>" +
            "<p>Best regards,<br/>ETS Team</p>" +
            "</div></body></html>",
            firstName, otp
        );
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    // Cleanup expired OTPs (you might want to run this as a scheduled task)
    public void cleanupExpiredOTPs() {
        otpStorage.entrySet().removeIf(entry -> entry.getValue().isExpired());
    }
}
