package com.servlet;

import com.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLIntegrityConstraintViolationException; // Yeh naya import add kiya hai
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class VerifyOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Take the OTP that the user entered in the form
        String userOtp = request.getParameter("user_otp");
        
        // To get the OTP from the session that we sent on the email
        HttpSession session = request.getSession();
        String generatedOtp = (String) session.getAttribute("generated_otp");
        
        // match both otp
        if (generatedOtp != null && generatedOtp.equals(userOtp)) {
            // OTP is correct! Now extract all the user's data from the session
            String name = (String) session.getAttribute("temp_name");
            String regNo = (String) session.getAttribute("temp_regNo");
            String email = (String) session.getAttribute("temp_email");
            String department = (String) session.getAttribute("temp_department");
            String course = (String) session.getAttribute("temp_course");
            String password = (String) session.getAttribute("temp_password");
            
            // data save in MySQL 
            try {
                Connection conn = DBConnection.getConnection();
                String sql = "INSERT INTO students (name, registration_no, email, department, course, password) VALUES (?, ?, ?, ?, ?, ?)";
                
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                pstmt.setString(2, regNo);
                pstmt.setString(3, email);
                pstmt.setString(4, department);
                pstmt.setString(5, course);
                pstmt.setString(6, password); 
                
                int i = pstmt.executeUpdate();
                
                if (i > 0) {
                    // SUCCESS: Data save ho gaya! Session clear karein aur login page par bhej dein
                    session.invalidate(); 
                    response.sendRedirect("login.jsp?msg=registered");
                } else {
                    response.sendRedirect("register.jsp?error=server");
                }
                
            } catch (SQLIntegrityConstraintViolationException e) {
                // ERROR: Agar Registration No ya Email pehle se database mein maujood hai
                response.sendRedirect("register.jsp?error=duplicate");
                
            } catch (Exception e) {
                // ERROR: Baki kisi bhi tarah ke server ya database error ke liye
                e.printStackTrace();
                response.sendRedirect("register.jsp?error=server");
            }
            
        } else {
            // Agar OTP galat hai, toh wapas usi page par error ke sath bhejein
            response.sendRedirect("verify_otp.jsp?error=invalid_otp");
        }
    }
}