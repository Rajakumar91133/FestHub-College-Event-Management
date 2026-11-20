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

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. get email and password from form
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // 2. get data base connection
            Connection conn = DBConnection.getConnection();

            // 3. Running an SQL query (to check if this email and password are in the database)
            String sql = "SELECT * FROM students WHERE email = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // 4. If the user is found (login successful)

                // Save the user's name and other information in the session
                HttpSession session = request.getSession();
                session.setAttribute("user_name", rs.getString("name"));
                session.setAttribute("user_email", rs.getString("email"));
                session.setAttribute("user_regno", rs.getString("registration_no"));
                session.setAttribute("user_course", rs.getString("course"));
                session.setAttribute("user_department", rs.getString("department"));

                // Send the user to the student dashboard
                response.sendRedirect("student_dashboard.jsp");

            } else {
                // 5. if email or password is wrong
                // YAHAN FIX KIYA HAI: "invalid" likha hai taki login.jsp isko pakad sake
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Login Error: " + e.getMessage());
            // Server error hone par bhi same warning dikhayenge
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}
