package com.excelFileUpload.ExamDataUpload.Entity;

import jakarta.persistence.*;

@Entity
@Table(name = "questions")
public class ExamData {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "s_no")
	private Integer sNo;

	@Column(name = "subject")
	private String subject;
	
	@Column(name = "workorder")
	private String workorder;
	
	@Column(name = "topic")
	private String topic;
	
	@Column(name = "subtopic")
	private String subtopic;
	
	@Column(name = "grade")
	private String grade;

	@Column(name = "difficulty_level")
	private String difficultyLevel;

	@Column(columnDefinition = "TEXT")
	private String question;

	@Column(name = "option1")
	private String option1;

	@Column(name = "option2")
	private String option2;

	@Column(name = "option3")
	private String option3;

	@Column(name = "option4")
	private String option4;

	@Column(name = "correct_answer")
	private String correctAnswer;

	@Column(name = "description")
	private String description;

	@Column(name = "reference")
	private String references;
	
	@Column(name = "status")
	private String status;

	// Getters and Setters
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getSNo() {
		return sNo;
	}

	public void setSNo(Integer sNo) {
		this.sNo = sNo;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getTopic() {
		return topic;
	}

	public void setTopic(String topic) {
		this.topic = topic;
	}

	public String getSubtopic() {
		return subtopic;
	}

	public void setSubtopic(String subtopic) {
		this.subtopic = subtopic;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public Integer getsNo() {
		return sNo;
	}

	public void setsNo(Integer sNo) {
		this.sNo = sNo;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDifficultyLevel() {
		return difficultyLevel;
	}

	public void setDifficultyLevel(String difficultyLevel) {
		this.difficultyLevel = difficultyLevel;
	}

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public String getOption1() {
		return option1;
	}

	public void setOption1(String option1) {
		this.option1 = option1;
	}

	public String getOption2() {
		return option2;
	}

	public void setOption2(String option2) {
		this.option2 = option2;
	}

	public String getOption3() {
		return option3;
	}

	public void setOption3(String option3) {
		this.option3 = option3;
	}

	public String getOption4() {
		return option4;
	}

	public void setOption4(String option4) {
		this.option4 = option4;
	}

	public String getCorrectAnswer() {
		return correctAnswer;
	}

	public void setCorrectAnswer(String correctAnswer) {
		this.correctAnswer = correctAnswer;
	}

	public String getReferences() {
		return references;
	}

	public void setReferences(String references) {
		this.references = references;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getWorkorder() {
		return workorder;
	}

	public void setWorkorder(String workorder) {
		this.workorder = workorder;
	}
}
