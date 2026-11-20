package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check from the URL where the logout request came from
        String userType = request.getParameter("type");
        
        // Session destroy 
        HttpSession session = request.getSession();
        session.invalidate();
        
        // If the Organizer (HOD/Staff) is logging out
        if ("org".equals(userType)) {
            response.sendRedirect("org_login.jsp");
        } 
        // If the student is logging out (or hasn't typed anything)
        else {
            response.sendRedirect("login.jsp");
        }
    }
}