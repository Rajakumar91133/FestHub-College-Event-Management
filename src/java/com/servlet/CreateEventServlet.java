package com.servlet;

import com.db.DBConnection;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

// this annotation is important for file upload 
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB (Iske upar temp file banegi)
        maxFileSize = 1024 * 1024 * 10, // 10MB (Ek file ki max size)
        maxRequestSize = 1024 * 1024 * 50 // 50MB (Total request size)
)
public class CreateEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // Security Check: back to login page if there is no organiser login
        if (session.getAttribute("org_id") == null) {
            response.sendRedirect("org_login.jsp");
            return;
        }

        // 1. collect all text data form form
        String title = request.getParameter("title");
        String eventDate = request.getParameter("event_date");
        String eventTime = request.getParameter("event_time");
        String venue = request.getParameter("venue");
        String chiefGuest = request.getParameter("chief_guest");
        String message = request.getParameter("event_message");
        String contactNo = request.getParameter("contact_no");

        // take Organizer details from session 
        int orgId = (Integer) session.getAttribute("org_id");
        int deptId = (Integer) session.getAttribute("org_dept_id");
        String status = "Pending"; // Naya event by default pending rahega

        // 2. set Folder for file upload (Aapke project ke andar 'uploads' folder)
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String bannerPath = "";
        String noticePath = "";

        try {
            // 3. save Banner Image (Agar user ne select ki hai toh)
            Part bannerPart = request.getPart("banner");
            if (bannerPart != null && bannerPart.getSize() > 0) {
                String bannerFileName = System.currentTimeMillis() + "_" + bannerPart.getSubmittedFileName();
                File bannerFile = new File(uploadPath, bannerFileName);
                try (InputStream input = bannerPart.getInputStream()) {
                    Files.copy(input, bannerFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                bannerPath = "uploads/" + bannerFileName;
            }

            // 4. save Permission Notice (PDF)  (Yeh required hai)
            Part noticePart = request.getPart("notice");
            if (noticePart != null && noticePart.getSize() > 0) {
                String noticeFileName = System.currentTimeMillis() + "_" + noticePart.getSubmittedFileName();
                File noticeFile = new File(uploadPath, noticeFileName);
                try (InputStream input = noticePart.getInputStream()) {
                    Files.copy(input, noticeFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                noticePath = "uploads/" + noticeFileName;
            }

            // 5. save all data in Database 
            Connection conn = DBConnection.getConnection();

            // Updated SQL Query  where 'message' or 'contact_no' both
            String sql = "INSERT INTO events (title, event_date, event_time, venue, chief_guest, message, contact_no, banner_path, notice_path, status, org_id, dept_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, eventDate);
            pstmt.setString(3, eventTime);
            pstmt.setString(4, venue);
            pstmt.setString(5, chiefGuest);
            pstmt.setString(6, message);
            pstmt.setString(7, contactNo);
            pstmt.setString(8, bannerPath);
            pstmt.setString(9, noticePath);
            pstmt.setString(10, status);
            pstmt.setInt(11, orgId);
            pstmt.setInt(12, deptId);

            int i = pstmt.executeUpdate();

            // if event save then so success message 
            if (i > 0) {
                response.sendRedirect("create_event.jsp?msg=success");
            } else {
                response.sendRedirect("create_event.jsp?msg=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // in Console error mrssage print  
            System.out.println("CreateEventServlet Error: " + e.getMessage());
            response.sendRedirect("create_event.jsp?msg=error");
        }
    }
}
