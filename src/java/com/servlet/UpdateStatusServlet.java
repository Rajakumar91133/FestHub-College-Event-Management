package com.servlet;

import com.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Security: Only the admin can update the status
        if (session.getAttribute("org_id") == null) {
            response.sendRedirect("org_login.jsp");
            return;
        }

        // Extract Event ID and Action (Approve/Reject) from the URL
        String eventId = request.getParameter("id");
        String action = request.getParameter("action");
        
        // Setting the correct words to save in the database
        String finalStatus = "Pending";
        if (action != null && action.equalsIgnoreCase("Approve")) {
            finalStatus = "Approved";  // 'd' is important then visible to student 
        } else if (action != null && action.equalsIgnoreCase("Reject")) {
            finalStatus = "Rejected";
        }
        
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE events SET status = ? WHERE event_id = ?";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, finalStatus); // Now it will save as 'Approved' or 'Rejected'

            pstmt.setString(2, eventId);
            
            int i = pstmt.executeUpdate();
            
            if(i > 0) {
                // After success, redirect back to the Manage Events page
                response.sendRedirect("view_events.jsp?msg=updated");
            } else {
                response.sendRedirect("view_events.jsp?msg=error");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Update Status Error: " + e.getMessage());
            response.sendRedirect("view_events.jsp?msg=error");
        }
    }
}