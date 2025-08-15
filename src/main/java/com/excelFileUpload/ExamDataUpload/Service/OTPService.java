package com.excelFileUpload.ExamDataUpload.Service;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class OTPService {

    private static final Logger logger = LoggerFactory.getLogger(OTPService.class);
    private final SecureRandom secureRandom = new SecureRandom();
    
    // You can implement Redis-based storage here for production
    private final Map<String, OTPInfo> otpStorage = new ConcurrentHashMap<>();

    public static class OTPInfo {
        private String otp;
        private LocalDateTime createdAt;
        private LocalDateTime expiresAt;
        private int attempts;
        
        public OTPInfo(String otp, LocalDateTime createdAt, LocalDateTime expiresAt) {
            this.otp = otp;
            this.createdAt = createdAt;
            this.expiresAt = expiresAt;
            this.attempts = 0;
        }
        
        // Getters and setters
        public String getOtp() { return otp; }
        public LocalDateTime getCreatedAt() { return createdAt; }
        public LocalDateTime getExpiresAt() { return expiresAt; }
        public int getAttempts() { return attempts; }
        public void setAttempts(int attempts) { this.attempts = attempts; }
        
        public boolean isExpired() {
            return LocalDateTime.now().isAfter(expiresAt);
        }
    }

    public String generateSecureOTP(int length) {
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < length; i++) {
            otp.append(secureRandom.nextInt(10));
        }
        return otp.toString();
    }

    public String generateAndStoreOTP(String identifier, int validityMinutes) {
        String otp = generateSecureOTP(6);
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expiryTime = now.plusMinutes(validityMinutes);
        
        otpStorage.put(identifier, new OTPInfo(otp, now, expiryTime));
        
        logger.info("OTP generated for identifier: {} valid until: {}", 
                   identifier, expiryTime.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
        
        return otp;
    }

    public boolean validateOTP(String identifier, String enteredOTP) {
        OTPInfo otpInfo = otpStorage.get(identifier);
        
        if (otpInfo == null) {
            logger.warn("OTP validation failed - no OTP found for identifier: {}", identifier);
            return false;
        }
        
        if (otpInfo.isExpired()) {
            logger.warn("OTP validation failed - expired OTP for identifier: {}", identifier);
            otpStorage.remove(identifier);
            return false;
        }
        
        otpInfo.setAttempts(otpInfo.getAttempts() + 1);
        
        if (otpInfo.getOtp().equals(enteredOTP)) {
            logger.info("OTP validation successful for identifier: {}", identifier);
            otpStorage.remove(identifier); // Remove after successful validation
            return true;
        } else {
            logger.warn("OTP validation failed - incorrect OTP for identifier: {}. Attempts: {}", 
                       identifier, otpInfo.getAttempts());
            return false;
        }
    }

    public void invalidateOTP(String identifier) {
        otpStorage.remove(identifier);
        logger.info("OTP invalidated for identifier: {}", identifier);
    }

    public boolean isOTPExpired(String identifier) {
        OTPInfo otpInfo = otpStorage.get(identifier);
        return otpInfo == null || otpInfo.isExpired();
    }

    public int getAttemptCount(String identifier) {
        OTPInfo otpInfo = otpStorage.get(identifier);
        return otpInfo != null ? otpInfo.getAttempts() : 0;
    }

    // Cleanup method - you might want to run this as a scheduled task
    public void cleanupExpiredOTPs() {
        otpStorage.entrySet().removeIf(entry -> entry.getValue().isExpired());
        logger.info("Cleaned up expired OTPs");
    }
}