<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.io.*, java.util.*, javax.mail.*, javax.mail.internet.*,java.sql.*,java.security.*"%>

<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.tailwindcss.com" type="text/javascript"></script>
<meta charset="UTF-8">
<title>Login</title>
<%
String username = request.getParameter("username");
String email = request.getParameter("email");
String password = request.getParameter("password");

if (email != null && password != null) {

	Class.forName("org.postgresql.Driver");
	String urlDB = "jdbc:postgresql://localhost:5432/audio_streaming_app_1";
	String usernameDB = "postgres";
	String passwordDB = "12345";

	String sql = "SELECT COUNT(*) FROM users WHERE email=? AND password=?";

	try (Connection con = DriverManager.getConnection(urlDB, usernameDB, passwordDB);
	PreparedStatement ps = con.prepareStatement(sql);) {

		ps.setString(1, email);
		ps.setString(2, password);

		ResultSet rs = ps.executeQuery();

		if (rs.next()) {
	int count = rs.getInt(1);

	if (count > 0) {
		session.setAttribute("user", email);
		session.setAttribute("name",username);
		response.sendRedirect("dashboard.jsp");

	} else {
		response.sendRedirect("login.jsp?error=1");
	}
		}

	} catch (Exception e) {
		out.println(e);
	}
}
%>

</head>

<body class="bg-gray-900 flex justify-center items-center h-screen">

	<form name="loginForm" action="login.jsp"
		class="bg-gray-800 p-6 rounded text-white w-80">

		<h2 class="text-xl mb-4">Login</h2>


		<input type="text" name="username" placeholder="Username"
			class="w-full p-2 mb-3 text-black" required> <input
			type="email" name="email" placeholder="Email"
			class="w-full p-2 mb-3 text-black" required> <input
			type="password" name="password" placeholder="Password"
			class="w-full p-2 mb-3 text-black" required> <input
			class="bg-blue-500 w-full p-2 rounded" type="submit" value="login">

		<a href="register.jsp"
			class="block mx-auto text-center text-blue-600 hover:text-blue-800 hover:underline font-medium transition duration-200 ease-in-out">
			New user? Click here to register </a>

		<%
		String error = request.getParameter("error");
		if ("1".equals(error)) {
		%>
		<div class=" text-red-500 p-2 mb-4 text-center">Email or
			Password is incorrect!</div>
		<%
}
%>




	</form>

</body>


</html>