package com.excelFileUpload.ExamDataUpload.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.excelFileUpload.ExamDataUpload.Entity.UserLogin;

@Repository
public interface UserRepository extends JpaRepository<UserLogin, Long> {
	UserLogin findByUsername(String username);

	UserLogin findByEmail(String email);

	boolean existsByEmail(String email);

	boolean existsByUsername(String username);

	Optional<UserLogin> findByEmailIgnoreCase(String email);

	Optional<UserLogin> findByUsernameIgnoreCase(String username);

	@Query("SELECT u FROM UserLogin u WHERE u.email = :email AND u.accountEnabled = true")
	Optional<UserLogin> findActiveUserByEmail(@Param("email") String email);

	@Query("SELECT u FROM UserLogin u WHERE u.accountEnabled = true AND u.accountLocked = false")
	List<UserLogin> findAllActiveUsers();

	@Query("SELECT u FROM UserLogin u WHERE u.lastLogin < :date")
	List<UserLogin> findUsersInactiveAfter(@Param("date") LocalDateTime date);

	@Query("SELECT COUNT(u) FROM UserLogin u WHERE u.createdAt >= :startDate AND u.createdAt <= :endDate")
	long countUsersCreatedBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

	@Query("SELECT u FROM UserLogin u WHERE u.passwordResetRequired = true")
	List<UserLogin> findUsersRequiringPasswordReset();
}
