<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String userEmail = (String) session.getAttribute("user");
    String title = request.getParameter("title");
    boolean exists = false;

    if (userEmail != null && title != null) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/audio_streaming_app_1", "postgres", "12345");
            
            String query = "SELECT 1 FROM drafts WHERE user_owner = ? AND title = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, userEmail);
            ps.setString(2, title.trim());
            ResultSet rs = ps.executeQuery();
            
            if(rs.next())
            	exists = true;
            
            con.close();
        } catch (Exception e) 
        {
        	e.printStackTrace(); 
        	}
    }
    // Only output when called directly (not via jsp:include)
    if (request.getParameter("title") != null) {
        out.print(exists ? "exists" : "available");
    }
%>