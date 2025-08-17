package com.excelFileUpload.ExamDataUpload.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.excelFileUpload.ExamDataUpload.Entity.UserLogin;
import com.excelFileUpload.ExamDataUpload.Repository.UserRepository;

import jakarta.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public UserLogin findByEmail(String email) {
        try {
            return userRepository.findByEmail(email.toLowerCase().trim());
        } catch (Exception e) {
            logger.error("Error finding user by email: {}", email, e);
            return null;
        }
    }

    public UserLogin findByUsername(String username) {
        try {
            return userRepository.findByUsername(username.toLowerCase().trim());
        } catch (Exception e) {
            logger.error("Error finding user by username: {}", username, e);
            return null;
        }
    }

    @Transactional
    public boolean updatePassword(String email, String newPassword) {
        try {
        	UserLogin user = findByEmail(email);
            if (user == null) {
                logger.warn("Attempted to update password for non-existent user: {}", email);
                return false;
            }

            String encodedPassword = passwordEncoder.encode(newPassword);
            user.setPassword(encodedPassword);
            user.setPasswordResetRequired(false);
            user.setLastPasswordChange(java.time.LocalDateTime.now());
            
            userRepository.save(user);
            logger.info("Password updated successfully for user: {}", email);
            return true;

        } catch (Exception e) {
            logger.error("Error updating password for user: {}", email, e);
            return false;
        }
    }

    public boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        // Add more password validation rules as needed
        boolean hasUppercase = password.chars().anyMatch(Character::isUpperCase);
        boolean hasLowercase = password.chars().anyMatch(Character::isLowerCase);
        boolean hasDigit = password.chars().anyMatch(Character::isDigit);
        boolean hasSpecialChar = password.chars().anyMatch(ch -> "!@#$%^&*()_+-=[]{}|;:,.<>?".indexOf(ch) >= 0);

        return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
    }

    public UserLogin save(UserLogin user) {
        try {
            return userRepository.save(user);
        } catch (Exception e) {
            logger.error("Error saving user: {}", user.getEmail(), e);
            throw e;
        }
    }

    public boolean existsByEmail(String email) {
        try {
            return userRepository.existsByEmail(email.toLowerCase().trim());
        } catch (Exception e) {
            logger.error("Error checking if email exists: {}", email, e);
            return false;
        }
    }

    public boolean existsByUsername(String username) {
        try {
            return userRepository.existsByUsername(username.toLowerCase().trim());
        } catch (Exception e) {
            logger.error("Error checking if username exists: {}", username, e);
            return false;
        }
    }
}