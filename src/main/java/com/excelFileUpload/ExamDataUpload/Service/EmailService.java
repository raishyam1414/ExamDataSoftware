package com.excelFileUpload.ExamDataUpload.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    @Autowired
    private JavaMailSender mailSender;

    @Value("${app.email.from:noreply@ets.com}")
    private String fromEmail;

    @Value("${app.email.enabled:true}")
    private boolean emailEnabled;

    public boolean sendEmail(String to, String subject, String htmlBody) {
        if (!emailEnabled) {
            logger.info("Email sending is disabled. Would send to: {} with subject: {}", to, subject);
            return true;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);

            mailSender.send(message);
            logger.info("Email sent successfully to: {}", to);
            return true;

        } catch (MessagingException e) {
            logger.error("Failed to send email to: {}", to, e);
            return false;
        } catch (Exception e) {
            logger.error("Unexpected error sending email to: {}", to, e);
            return false;
        }
    }

    public boolean sendPlainTextEmail(String to, String subject, String textBody) {
        if (!emailEnabled) {
            logger.info("Email sending is disabled. Would send to: {} with subject: {}", to, subject);
            return true;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(textBody, false);

            mailSender.send(message);
            logger.info("Plain text email sent successfully to: {}", to);
            return true;

        } catch (MessagingException e) {
            logger.error("Failed to send plain text email to: {}", to, e);
            return false;
        } catch (Exception e) {
            logger.error("Unexpected error sending plain text email to: {}", to, e);
            return false;
        }
    }
}
