package com.excelFileUpload.ExamDataUpload.Controller;

import com.excelFileUpload.ExamDataUpload.Entity.UserLogin;
import com.excelFileUpload.ExamDataUpload.Repository.UserRepository;
import com.excelFileUpload.ExamDataUpload.Service.QuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/questions")
public class QuestionController {

    @Autowired
    private QuestionService questionService;
    
    @GetMapping("/upload")
    public String showUploadPage() {
        return "upload";
    }

    @PostMapping("/upload")
    public String uploadExcel(@RequestParam("file") MultipartFile file,@RequestParam("workorder") String workOrder,
                            RedirectAttributes redirectAttributes,
                            Model model) {

        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Please select a file to upload.");
            return "redirect:/questions/upload";
        }

        if (!file.getOriginalFilename().endsWith(".xlsx")) {
            redirectAttributes.addFlashAttribute("error", "Invalid file type. Please upload an Excel file (.xlsx).");
            return "redirect:/questions/upload";
        }

        try {
            QuestionService.ValidationResult result = questionService.processExcelFile(file, workOrder);

            if (result.isValid()) {
                questionService.saveQuestions(result.getValidQuestions());

                String successMessage = "Successfully uploaded " + result.getValidQuestions().size() + " questions!";

                if (!result.getAllFeedback().isEmpty()) { 
                    model.addAttribute("allFeedback", result.getAllFeedback());
                    model.addAttribute("success", successMessage + " Please review the warnings below.");
                    return "upload"; 
                }

                redirectAttributes.addFlashAttribute("success", successMessage);
                return "redirect:/questions/upload";
            } else {
                model.addAttribute("allFeedback", result.getAllFeedback());
                model.addAttribute("error", "File upload failed due to critical validation errors. Please correct them.");
                return "upload"; 
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "An unexpected error occurred during file processing: " + e.getMessage());
            System.err.println("Upload Error: " + e.getMessage());
            e.printStackTrace(); 
            return "redirect:/questions/upload";
        }
    }

}