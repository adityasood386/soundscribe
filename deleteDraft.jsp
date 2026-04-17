<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String userEmail = (String) session.getAttribute("user");
    String title = request.getParameter("title");

    if (userEmail == null || title == null || title.trim().isEmpty()) {
        out.print("Error: Missing session or title");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/audio_streaming_app_1", "postgres", "12345");
        String query = "DELETE FROM drafts WHERE user_owner = ? AND title = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, userEmail);
        ps.setString(2, title.trim());
        int rows = ps.executeUpdate();
        if (rows > 0) {
            out.print("Deleted");
        } else {
            out.print("Not found");
        }
    } catch (Exception e) {
        out.print("DB Error: " + e.getMessage());
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
