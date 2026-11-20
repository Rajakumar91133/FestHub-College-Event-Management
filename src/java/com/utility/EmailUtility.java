package com.utility;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtility {
    
    public static boolean sendOTP(String userEmail, String otp) {
        // अपना असली ईमेल और 16-अक्षरों वाला Google App Password यहाँ डालें
        final String senderEmail = "mysqlmghv.db@gmail.com"; 
        final String appPassword = "your email password"; 

        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(properties, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, appPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(userEmail));
            message.setSubject("College Event Management - Registration OTP");
            
            String emailContent = "<h3>Welcome to College Event Management System</h3>"
                    + "<p>Your OTP for registration is: <strong>" + otp + "</strong></p>"
                    + "<p>Please do not share this OTP with anyone.</p>";
            
            message.setContent(emailContent, "text/html");
            Transport.send(message);
            System.out.println("OTP sent successfully to: " + userEmail);
            return true;

        } catch (MessagingException e) {
            System.out.println("Failed to send OTP: " + e.getMessage());
            return false;
        }
    }
}