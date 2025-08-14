package com.excelFileUpload.ExamDataUpload.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.excelFileUpload.ExamDataUpload.Entity.ExamData;

import java.util.List;

@Repository
public interface QuestionRepository extends JpaRepository<ExamData, Long> {
    
    @Query("SELECT q FROM ExamData q WHERE q.question = ?1")
    List<ExamData> findByQuestion(String question);
    
    @Query("SELECT COUNT(q) FROM ExamData q WHERE q.question = ?1")
    long countByQuestion(String question);
    
    @Query("SELECT e FROM ExamData e WHERE " +
            "(:subject IS NULL OR e.subject = :subject) AND " +
            "(:topic IS NULL OR e.topic = :topic) AND " +
            "(:subtopic IS NULL OR e.subtopic = :subtopic) AND " +
            "(:grade IS NULL OR e.grade = :grade) AND " +
            "(:difficultyLevel IS NULL OR e.difficultyLevel = :difficultyLevel) AND " +
            "(:question IS NULL OR e.question LIKE %:question%) AND " +
            "(:workorder IS NULL OR e.workorder = :workorder)")
    List<ExamData> filterQuestions(String subject, String topic, String subtopic, String grade,
                                   String difficultyLevel, String question, String workorder);

    int deleteByWorkorder(String workorder);
}