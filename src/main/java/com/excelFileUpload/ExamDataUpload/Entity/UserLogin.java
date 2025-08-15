package com.excelFileUpload.ExamDataUpload.Entity;


import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class UserLogin {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    @Column(unique = true, nullable = false)
    private String username;
    
    @Column(nullable = false)
    private String password;
    
    @Column(name = "first_name")
    private String firstName;
    
    @Column(name = "last_name")
    private String lastName;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Column(name = "last_login")
    private LocalDateTime lastLogin;
    
    @Column(name = "last_password_change")
    private LocalDateTime lastPasswordChange;
    
    @Column(name = "password_reset_required")
    private Boolean passwordResetRequired;
    
    @Column(name = "account_locked")
    private Boolean accountLocked;
    
    @Column(name = "failed_login_attempts")
    private Boolean failedLoginAttempts;
    
    @Column(name = "account_enabled")
    private Boolean accountEnabled;
    
    // Constructors
    public UserLogin() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public UserLogin(String email, String username, String firstName, String lastName) {
        this();
        this.email = email;
        this.username = username;
        this.firstName = firstName;
        this.lastName = lastName;
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }
    
    public LocalDateTime getLastPasswordChange() { return lastPasswordChange; }
    public void setLastPasswordChange(LocalDateTime lastPasswordChange) { this.lastPasswordChange = lastPasswordChange; }
    
    public boolean isPasswordResetRequired() { return passwordResetRequired; }
    public void setPasswordResetRequired(boolean passwordResetRequired) { this.passwordResetRequired = passwordResetRequired; }
    
    public boolean isAccountLocked() { return accountLocked; }
    public void setAccountLocked(boolean accountLocked) { this.accountLocked = accountLocked; }
    
    public Boolean getPasswordResetRequired() {
		return passwordResetRequired;
	}

	public void setPasswordResetRequired(Boolean passwordResetRequired) {
		this.passwordResetRequired = passwordResetRequired;
	}

	public Boolean getAccountLocked() {
		return accountLocked;
	}

	public void setAccountLocked(Boolean accountLocked) {
		this.accountLocked = accountLocked;
	}

	public Boolean getFailedLoginAttempts() {
		return failedLoginAttempts;
	}

	public void setFailedLoginAttempts(Boolean failedLoginAttempts) {
		this.failedLoginAttempts = failedLoginAttempts;
	}

	public Boolean getAccountEnabled() {
		return accountEnabled;
	}

	public void setAccountEnabled(Boolean accountEnabled) {
		this.accountEnabled = accountEnabled;
	}

	public boolean isAccountEnabled() { return accountEnabled; }
    public void setAccountEnabled(boolean accountEnabled) { this.accountEnabled = accountEnabled; }
    
    // Utility methods
    public String getFullName() {
        StringBuilder fullName = new StringBuilder();
        if (firstName != null && !firstName.trim().isEmpty()) {
            fullName.append(firstName.trim());
        }
        if (lastName != null && !lastName.trim().isEmpty()) {
            if (fullName.length() > 0) {
                fullName.append(" ");
            }
            fullName.append(lastName.trim());
        }
        return fullName.toString();
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", email='" + email + '\'' +
                ", username='" + username + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", accountEnabled=" + accountEnabled +
                ", accountLocked=" + accountLocked +
                '}';
    }
}