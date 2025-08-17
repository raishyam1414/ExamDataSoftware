package com.excelFileUpload.ExamDataUpload.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.excelFileUpload.ExamDataUpload.Entity.UserLogin;
import com.excelFileUpload.ExamDataUpload.Repository.UserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
	
	@Autowired
    private UserRepository userRepository;
	
	@Autowired
    private PasswordEncoder passwordEncoder;
    
    @GetMapping("/loginPage")
    public String showLoginPage() {
        return "login";
    }
    
    @PostMapping("/loginPage")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        Model model) {

        UserLogin user = userRepository.findByEmail(username);

        if (user == null) {
            model.addAttribute("error", "User not found!");
            return "login";
        }

        if (!passwordEncoder.matches(password, user.getPassword())) {
            model.addAttribute("error", "Invalid password!");
            return "login";
        }

        model.addAttribute("username", username);
        return "redirect:/dashboard/dashboard";
    }

    
    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "login";
    }
    
    @GetMapping("/register")
    public String showRegistrationPage() {
        return "register";
    }
    
    @PostMapping("/register")
    public String processRegistration(@RequestParam String username,
                                      @RequestParam String email,
                                      @RequestParam String password,
                                      Model model,
                                      RedirectAttributes redirectAttributes) {
        try {
            if (username == null || username.trim().isEmpty()) {
                model.addAttribute("error", "Username is required");
                return "register";
            }

            if (email == null || email.trim().isEmpty()) {
                model.addAttribute("error", "Email is required");
                return "register";
            }

            if (password == null || password.trim().isEmpty()) {
                model.addAttribute("error", "Password is required");
                return "register";
            }

            if (password.length() < 6) {
                model.addAttribute("error", "Password must be at least 6 characters long");
                return "register";
            }

            if (userRepository.existsByUsername(username.trim())) {
                model.addAttribute("error", "Username already exists");
                return "register";
            }

            if (userRepository.existsByEmail(email.trim().toLowerCase())) {
                model.addAttribute("error", "Email already registered");
                return "register";
            }

            UserLogin newUser = new UserLogin();
            newUser.setUsername(username.trim());
            newUser.setEmail(email.trim().toLowerCase());
            newUser.setPassword(passwordEncoder.encode(password));

            userRepository.save(newUser);

            redirectAttributes.addFlashAttribute("success", 
                "Registration successful! Please login with your credentials.");
            return "redirect:/loginPage";

        } catch (Exception e) {
            model.addAttribute("error", "Registration failed: " + e.getMessage());
            return "register";
        }
    }
    
}
