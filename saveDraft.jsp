<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 'user' attribute now contains the email address from session
    String userEmail = (String) session.getAttribute("user");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    if (userEmail != null && title != null && !title.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/audio_streaming_app_1", "postgres", "12345");
            
            /* to insert and upserts If the combination of user_owner and title 
               already exists, it updates the existing content and timestamp instead.
            */
            String query = "INSERT INTO drafts (user_owner, title, content, last_edited) " +
                           "VALUES (?, ?, ?, CURRENT_TIMESTAMP) "+
                                   "ON CONFLICT (user_owner, title) " +
                                   "DO UPDATE SET content = EXCLUDED.content, last_edited = CURRENT_TIMESTAMP" ;
            
            ps = con.prepareStatement(query);
            ps.setString(1, userEmail);
            ps.setString(2, title.trim());
            ps.setString(3, content);
            
            ps.executeUpdate();
            out.print("Success");
            
        } catch (Exception e) {
            // Send back the specific error for debugging
            out.print("DB Error: " + e);
        } finally {
            if (ps != null)
            	ps.close();
            if (con != null) 
            	con.close();
        }
    } else {
        out.print("Error: Missing session or title");
    }
%>