package com.excelFileUpload.ExamDataUpload.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.excelFileUpload.ExamDataUpload.Entity.ExamData;
import com.excelFileUpload.ExamDataUpload.Repository.QuestionRepository;

import java.util.List;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private QuestionRepository examDataRepository;

    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        model.addAttribute("questions", examDataRepository.findAll());
        return "dashboard";
    }

    @PostMapping("/filter")
    public String filterData(@RequestParam(required = false) String subject,
                              @RequestParam(required = false) String topic,
                              @RequestParam(required = false) String subtopic,
                              @RequestParam(required = false) String grade,
                              @RequestParam(required = false) String difficultyLevel,
                              @RequestParam(required = false) String question,
                              @RequestParam(required = false) String workorder,
                              Model model) {

        List<ExamData> filtered = examDataRepository.filterQuestions(
                subject.isEmpty() ? null : subject,
                topic.isEmpty() ? null : topic,
                subtopic.isEmpty() ? null : subtopic,
                grade.isEmpty() ? null : grade,
                difficultyLevel.isEmpty() ? null : difficultyLevel,
                question.isEmpty() ? null : question,
                workorder.isEmpty() ? null : workorder
        );

        model.addAttribute("questions", filtered);
        model.addAttribute("formSubmitted", true);
        return "dashboard";
    }

    @PostMapping("/delete")
    @Transactional
    public String deleteByWorkorder(@RequestParam String workorder, RedirectAttributes redirectAttributes) {
        int deletedCount = examDataRepository.deleteByWorkorder(workorder);

        if (deletedCount > 0) {
            redirectAttributes.addFlashAttribute("message", "✅ " + deletedCount + " record(s) with Workorder '" + workorder + "' deleted successfully.");
        } else {
            redirectAttributes.addFlashAttribute("error", "❌ No record found with Workorder '" + workorder + "'.");
        }

        return "redirect:/dashboard/dashboard";
    }

}