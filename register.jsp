<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.io.*, java.util.*, javax.mail.*, javax.mail.internet.*,java.sql.*,java.security.*"%>

<html>
<head>
<script src="https://cdn.tailwindcss.com" type="text/javascript"></script>
<%
String message = "User registered successfully";
String err = null;
if (request.getParameter("name") != null) {

	String name = request.getParameter("name");
	String username = request.getParameter("username");
	String email = request.getParameter("email");
	String password = request.getParameter("password");

	Class.forName("org.postgresql.Driver");
	String urlDB = "jdbc:postgresql://localhost:5432/audio_streaming_app_1";
	String usernameDB = "postgres";
	String passwordDB = "12345";

	String sql = "INSERT INTO users (name, username, email, password) VALUES (?, ?, ?, ?)";

	try (Connection con = DriverManager.getConnection(urlDB, usernameDB, passwordDB);
	PreparedStatement ps = con.prepareStatement(sql);) {

		ps.setString(1, name);
		ps.setString(2, username);
		ps.setString(3, email);
		ps.setString(4, password);

		ps.executeUpdate();

		//out.println("<p style='color:green'>User Registered</p>");

	} catch (SQLException e) {
		System.out.println(e);
		err="23505";

	if ("23505".equals(e.getSQLState())) {
			
	err="Email already exists";
		}
	else{
		err="Database error occured";
	}

	}
}
%>

</head>

<body class="bg-gray-900 flex justify-center items-center h-screen">



	<form name="registerForm" action="register.jsp"
		class="bg-gray-800 p-6 rounded text-white w-80">

		<h2 class="text-xl mb-4">Register</h2>

		<input type="text" name="name" placeholder="Name"
			class="w-full p-2 mb-3 text-black" required> <input
			type="text" name="username" placeholder="Username"
			class="w-full p-2 mb-3 text-black" required> <input
			type="email" name="email" placeholder="Email"
			class="w-full p-2 mb-3 text-black" required> <input
			type="password" name="password" placeholder="Password"
			class="w-full p-2 mb-3 text-black" required> <input
			class="bg-blue-500 w-full p-2 rounded" type="submit" value="register">

		<a href="login.jsp"
			class="block mx-auto text-center text-blue-600 hover:text-blue-800 hover:underline font-medium transition duration-200 ease-in-out">
			Already a user? Click here to login </a>
		<%
		if (request.getParameter("name") != null && err==null) {
		%>
		<a href="login.jsp"
			class="block mx-auto text-center text-blue-600 hover:text-blue-800 hover:underline font-medium transition duration-200 ease-in-out">User
			registered successfully.Click here to login</a>
		<%
		}
		
		%>
		<% if (err != null) { %>
    <div class="block mx-auto text-center text-red-600 font-medium transition duration-200 ease-in-out">
        <%= err %>
    </div>
<% } %>


	</form>

</body>
</html>
