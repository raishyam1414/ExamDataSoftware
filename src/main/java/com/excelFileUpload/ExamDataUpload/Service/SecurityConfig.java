package com.excelFileUpload.ExamDataUpload.Service;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())  // Disable CSRF
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll()  // Allow all requests
            )
            .formLogin(login -> login.disable()) // Disable form login
            .httpBasic(basic -> basic.disable()); // Disable basic auth
        http.logout(logout -> logout
                .logoutUrl("/logout")           // keep your logout endpoint
                .logoutSuccessUrl("/loginPage")     // redirect here after logout
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
        );


        return http.build();
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}

