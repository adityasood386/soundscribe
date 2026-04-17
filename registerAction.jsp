<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
 <%@ page import = "java.io.*, java.util.*, javax.mail.*, javax.mail.internet.*,java.sql.*,java.security.*"%>

<html>
<head>
<script src="https://cdn.tailwindcss.com"></script>
<%
String name=request.getParameter("name");
String username=request.getParameter("username");
String email=request.getParameter("email");
String password=request.getParameter("password");

Class.forName("org.postgresql.Driver"); 
String urlDB = "jdbc:postgresql://localhost:5432/postgres";
String usernameDB = "postgres";
String passwordDB = "12345";


String sql = "INSERT INTO users (name, username, email, password) "
        + "VALUES (?, ?, ?, ?)";

try (
        Connection con = DriverManager.getConnection(urlDB, usernameDB, passwordDB);
        PreparedStatement ps = con.prepareStatement(sql);
    ) {
        ps.setString(1, name);
        ps.setString(2, username);
        ps.setString(3, email);
        ps.setString(4, password);
        

        ps.executeUpdate();
        out.println("User registered successfully!");

    } catch (SQLException e) {
        if ("23505".equals(e.getSQLState())) {
            out.println("Email already exists");
        } 
    }



%>
</head>
<body>

</body>
</html>