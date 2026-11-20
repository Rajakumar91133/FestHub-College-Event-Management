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

public class OrgLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // Checking in the `organizers` table of the database
            String sql = "SELECT * FROM organizers WHERE email = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // If the organizer is found, save its details in the session
                HttpSession session = request.getSession();
                session.setAttribute("org_id", rs.getInt("org_id"));
                session.setAttribute("org_name", rs.getString("name"));
                session.setAttribute("org_email", rs.getString("email"));
                session.setAttribute("org_role", rs.getString("role")); // Super Admin या Organizer
                session.setAttribute("org_dept_id", rs.getInt("dept_id"));
                
                // Send the organizer to its dashboard (we'll create it later)
                response.sendRedirect("org_dashboard.jsp");
                
            } else {
                // if details wrong
                response.sendRedirect("org_login.jsp?error=invalid");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("org_login.jsp?error=invalid");
        }
    }
}