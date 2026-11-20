package com.servlet;

import com.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ApplyEventServlet extends HttpServlet {

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session.getAttribute("user_name") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // to get data from form
        String eventId = request.getParameter("event_id");
        String phoneNumber = request.getParameter("phone_number");
        String activityRole = request.getParameter("activity_role");
        
        String userName = (String) session.getAttribute("user_name"); 
        String regNo = ""; 
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // get student registration number 
            String getStudentSql = "SELECT registration_no FROM students WHERE name = ?";
            PreparedStatement psStudent = conn.prepareStatement(getStudentSql);
            psStudent.setString(1, userName);
            ResultSet rsStudent = psStudent.executeQuery();
            
            if(rsStudent.next()) {
                regNo = rsStudent.getString("registration_no"); 
            }
            
            //check student apply earlyer
            String checkSql = "SELECT * FROM event_participants WHERE event_id = ? AND registration_no = ?";
            PreparedStatement pstmtCheck = conn.prepareStatement(checkSql);
            pstmtCheck.setString(1, eventId);
            pstmtCheck.setString(2, regNo);
            ResultSet rs = pstmtCheck.executeQuery();

            if (rs.next()) {
                response.sendRedirect("view_available_events.jsp?msg=already_applied");
            } else {
                // new registration 
                String insertSql = "INSERT INTO event_participants (event_id, registration_no, phone_number, activity_role) VALUES (?, ?, ?, ?)";
                PreparedStatement pstmtInsert = conn.prepareStatement(insertSql);
                
                pstmtInsert.setString(1, eventId);
                pstmtInsert.setString(2, regNo);
                pstmtInsert.setString(3, phoneNumber);
                pstmtInsert.setString(4, activityRole);
                
                int i = pstmtInsert.executeUpdate();
                if (i > 0) {
                    response.sendRedirect("view_available_events.jsp?msg=success");
                } else {
                    response.sendRedirect("view_available_events.jsp?msg=error");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ApplyEvent Error: " + e.getMessage());
            response.sendRedirect("view_available_events.jsp?msg=error");
        }
    }
}