package com.excelFileUpload.ExamDataUpload.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.excelFileUpload.ExamDataUpload.Entity.UserLogin;

@Repository
public interface UserRepository extends JpaRepository<UserLogin, Long> {
	UserLogin findByUsername(String username);
}

