package com.excelFileUpload.ExamDataUpload.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.excelFileUpload.ExamDataUpload.Entity.UserLogin;
import com.excelFileUpload.ExamDataUpload.Repository.UserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {
	
	@Autowired
    private UserRepository userRepository;
    
    @GetMapping("/loginPage")
    public String showLoginPage() {
        return "login";
    }
    
    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        Model model) {

        UserLogin user = userRepository.findByUsername(username);

        if (user == null) {
            model.addAttribute("error", "User not found!");
            return "login";
        }

        if (!user.getPassword().equals(password)) {
            model.addAttribute("error", "Invalid password!");
            return "login";
        }

        model.addAttribute("username", username);
        return "dashboard";
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/loginPage";
    }
    
}
