package com.excelFileUpload.ExamDataUpload.Service;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.excelFileUpload.ExamDataUpload.Entity.ExamData;
import com.excelFileUpload.ExamDataUpload.Repository.QuestionRepository;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class QuestionService {

    @Autowired
    private QuestionRepository questionRepository;

    public class ValidationResult {
        private boolean isValid; // True if no critical errors preventing save
        private List<String> allFeedback; // Consolidated list for errors and warnings
        private List<ExamData> validQuestions;

        public ValidationResult() {
            this.allFeedback = new ArrayList<>();
            this.validQuestions = new ArrayList<>();
        }

        public boolean isValid() {
            return isValid;
        }

        public void setValid(boolean valid) {
            isValid = valid;
        }

        public List<String> getAllFeedback() {
            return allFeedback;
        }

        public void setAllFeedback(List<String> allFeedback) {
            this.allFeedback = allFeedback;
        }

        public List<ExamData> getValidQuestions() {
            return validQuestions;
        }

        public void setValidQuestions(List<ExamData> validQuestions) {
            this.validQuestions = validQuestions;
        }
    }

    public ValidationResult processExcelFile(MultipartFile file, String workorder) throws IOException {
        ValidationResult result = new ValidationResult();
        List<ExamData> questions = new ArrayList<>();

        try (Workbook workbook = new XSSFWorkbook(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                ExamData question = extractQuestionFromRow(row, i + 1, workorder);
                if (question == null) {
                    result.getAllFeedback().add("ERROR: Row " + (i + 1) + ": Could not parse row. Ensure all required cells are correctly formatted.");
                    continue; 
                }

                question.setWorkorder(workorder);

                questions.add(question);
            }
        }

        performAllValidations(questions, result);

        if (result.getAllFeedback().stream().anyMatch(msg -> msg.startsWith("ERROR:"))) {
            result.setValid(false);
        } else {
            result.setValid(true);
            result.setValidQuestions(questions);
        }

        return result;
    }


    private ExamData extractQuestionFromRow(Row row, int rowNum, String workOrder) {
        try {
            ExamData question = new ExamData();
            question.setSNo(getCellValueAsInteger(row.getCell(0)));
            question.setSubject(getCellValueAsString(row.getCell(1)));
            question.setTopic(getCellValueAsString(row.getCell(2)));
            question.setSubtopic(getCellValueAsString(row.getCell(3)));
            question.setGrade(getCellValueAsString(row.getCell(4)));
            question.setDifficultyLevel(getCellValueAsString(row.getCell(5)));
            question.setQuestion(getCellValueAsString(row.getCell(6)));
            question.setOption1(getCellValueAsString(row.getCell(7)));
            question.setOption2(getCellValueAsString(row.getCell(8)));
            question.setOption3(getCellValueAsString(row.getCell(9)));
            question.setOption4(getCellValueAsString(row.getCell(10)));
            question.setCorrectAnswer(getCellValueAsString(row.getCell(11)));
            question.setDescription(getCellValueAsString(row.getCell(12)));
            question.setReferences(getCellValueAsString(row.getCell(13)));
            question.setStatus(getCellValueAsString(row.getCell(14)));
            question.setWorkorder(workOrder);
            return question;
        } catch (Exception e) {
            System.err.println("Error extracting data from row " + rowNum + ": " + e.getMessage());
            return null;
        }
    }

    private void performAllValidations(List<ExamData> questions, ValidationResult result) {
        Set<String> seenQuestionsInBatch = new HashSet<>();
        // Fetch existing questions only once for performance
        Set<String> existingQuestionsInDB = questionRepository.findAll().stream()
                .map(q -> q.getQuestion().toLowerCase().trim())
                .collect(Collectors.toSet());

        for (int i = 0; i < questions.size(); i++) {
            ExamData q = questions.get(i);
            int rowNum = i + 2; // Excel row number (1-indexed + header row)

            // --- Critical Validation Checks (Prevent Saving) ---
            if (q.getQuestion() == null || q.getQuestion().trim().isEmpty()) {
                result.getAllFeedback().add("ERROR: Row " + rowNum + ": Question field cannot be empty.");
                continue;
            }

            String normalizedQuestion = q.getQuestion().toLowerCase().trim();

            // Check for duplicate questions in current batch
            if (seenQuestionsInBatch.contains(normalizedQuestion)) {
                result.getAllFeedback().add("ERROR: Row " + rowNum + ": Duplicate question found in the uploaded file - '" + q.getQuestion() + "'");
                continue;
            }
            seenQuestionsInBatch.add(normalizedQuestion);

            // Check if question already exists in database
            if (existingQuestionsInDB.contains(normalizedQuestion)) {
                result.getAllFeedback().add("ERROR: Row " + rowNum + ": Question already exists in the database - '" + q.getQuestion() + "'");
                continue;
            }

            // Validate options count
            List<String> options = Arrays.asList(q.getOption1(), q.getOption2(), q.getOption3(), q.getOption4());
            long nonEmptyOptions = options.stream().filter(opt -> opt != null && !opt.trim().isEmpty()).count();

            if (nonEmptyOptions != 4) {
                result.getAllFeedback().add("ERROR: Row " + rowNum + ": Question must have exactly 4 options, found " + nonEmptyOptions);
                continue;
            }

            // Check for duplicate options for a single question
            Set<String> uniqueOptions = new HashSet<>();
            boolean hasDuplicateOptions = false;
            for (String option : options) {
                if (option != null && !option.trim().isEmpty()) {
                    String normalizedOption = option.toLowerCase().trim();
                    if (uniqueOptions.contains(normalizedOption)) {
                        result.getAllFeedback().add("ERROR: Row " + rowNum + ": Duplicate options found for question - '" + option + "'");
                        hasDuplicateOptions = true;
                        break;
                    }
                    uniqueOptions.add(normalizedOption);
                }
            }
            if (hasDuplicateOptions) continue;
        }
    }

    private String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate().toString();
                }
                // Handle large numbers or those that might be interpreted as scientific notation
                DataFormatter formatter = new DataFormatter();
                return formatter.formatCellValue(cell).trim(); // Formats numeric cells as strings reliably
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                try {
                    // Attempt to evaluate formula as string, fallback to numeric then blank
                    return cell.getStringCellValue().trim();
                } catch (IllegalStateException e) {
                    try {
                        // If it's a numeric formula result
                        return String.valueOf(new java.text.DecimalFormat("#.######").format(cell.getNumericCellValue()));
                    } catch (IllegalStateException | NumberFormatException ex) {
                        return ""; // Or handle as error
                    }
                }
            default:
                return "";
        }
    }

    private Integer getCellValueAsInteger(Cell cell) {
        if (cell == null) return null;
        switch (cell.getCellType()) {
            case NUMERIC:
                return (int) cell.getNumericCellValue();
            case STRING:
                try {
                    return Integer.parseInt(cell.getStringCellValue().trim());
                } catch (NumberFormatException e) {
                    return null; // Return null if not a valid integer string
                }
            case FORMULA:
                try {
                    return (int) cell.getNumericCellValue();
                } catch (IllegalStateException | NumberFormatException ex) {
                    return null; // Return null if formula doesn't result in an integer
                }
            default:
                return null;
        }
    }

    public void saveQuestions(List<ExamData> questions) {
        questionRepository.saveAll(questions);
    }
}