package com.excelFileUpload.ExamDataUpload;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;

@SpringBootApplication
public class ExamDataUploadApplication {

	public static void main(String[] args) {
		SpringApplication.run(ExamDataUploadApplication.class, args);
	}
	
	@GetMapping("/")
    public String home() {
        return "redirect:/loginPage";
    }

}
