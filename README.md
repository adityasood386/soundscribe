# 🎧 SoundScribe

### Your Personal Space for Music & Audiobooks

SoundScribe is a web-based audio streaming platform developed using **Java, JSP, HTML5, Tailwind CSS, JavaScript, and PostgreSQL**. It brings music streaming and audiobook listening together in one platform, providing users with an intuitive interface to explore, play, and manage audio content.

---

## ✨ Features

### 🎵 Music Streaming
- Browse and explore the music library.
- Play and pause audio tracks.
- Skip to the next and previous tracks.
- Adjust playback volume.
- Track playback progress and seek through songs.
- Automatically play the next song when the current track ends.
- Search songs by title or artist.
- Display album artwork using audio metadata.

### 📚 Audiobook Experience
- Dedicated audiobook listening section.
- Browse available audiobooks with cover artwork.
- Display book titles and narrator information.
- Audio playback with seek functionality.
- Skip forward by 30 seconds and backward by 15 seconds.
- Adjustable playback speed (0.75x to 2x).

### 👤 User Management
- User registration and login.
- Session-based authentication.
- Logout functionality.
- Protected dashboard access.

### 📂 Content & Draft Management
- Upload audio content.
- Save content as drafts.
- Check draft names.
- Delete unwanted drafts.

### 🎨 User Interface
- Modern dark-themed interface.
- Responsive layouts.
- Tailwind CSS utility-based styling.
- Interactive audio player.
- Smooth transitions and animations.

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Java | Backend programming |
| JSP (JavaServer Pages) | Dynamic server-side web pages |
| HTML5 | Frontend structure |
| Tailwind CSS | Utility-first CSS styling |
| JavaScript | Client-side interactivity |
| PostgreSQL | Relational database management |
| JDBC | Database connectivity |
| Apache Tomcat 10.1 | Web application server |
| jsmediatags | Audio metadata extraction |

---

## ⚙️ Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/adityasood386/soundscribe.git
```

Navigate to the project directory:

```bash
cd soundscribe
```

### 2. Prerequisites

Make sure you have installed:

- Java JDK
- Apache Tomcat 10.1
- PostgreSQL
- PostgreSQL JDBC Driver
- Eclipse IDE or IntelliJ IDEA

### 3. Database Configuration

Create a PostgreSQL database:

```sql
CREATE DATABASE audio_streaming_app_1;
```

Configure your PostgreSQL connection in the application's database connection code.

Example JDBC connection:

```java
Class.forName("org.postgresql.Driver");

Connection con = DriverManager.getConnection(
    "jdbc:postgresql://localhost:5432/audio_streaming_app_1",
    "YOUR_USERNAME",
    "YOUR_PASSWORD"
);
```

**Note:** Create the required database tables according to the SQL queries used in the application.

### 4. Configure Apache Tomcat

1. Import the project into Eclipse or your preferred Java IDE.
2. Configure Apache Tomcat 10.1 as the application server.
3. Add the PostgreSQL JDBC driver to the project.
4. Configure your database credentials.
5. Deploy the project to Tomcat.

### 5. Run the Application

Start the Tomcat server and open your browser:

```text
http://localhost:8080/soundscribe/
```

---

## 📁 Project Structure

```text
soundscribe/
│
├── audiobooks.jsp
├── dashboard.jsp
├── login.jsp
├── register.jsp
├── registerAction.jsp
├── logout.jsp
├── navbar.jsp
├── uploadSong.jsp
├── content.jsp
├── saveDraft.jsp
├── checkDraftName.jsp
├── deleteDraft.jsp
└── one.jsp
```

*The structure above highlights the main JSP application files.*

---

## 🔮 Future Enhancements

- Playlist creation and management.
- Recently played tracks.
- Favorites and liked songs.
- Personalized music recommendations.
- User profile customization.
- Improved mobile experience.
- Audio streaming quality options.
- Audiobook listening history and bookmarks.

---

## 🎯 Project Objective

The objective of SoundScribe is to develop a web-based audio streaming platform that combines music playback and audiobook listening in one place.

The project demonstrates practical implementation of Java web development, JSP, frontend technologies, database connectivity, session management, and interactive media playback.

---

## 👨‍💻 Author

**Aditya Sood**

- GitHub: [@adityasood386](https://github.com/adityasood386)
- Repository: [SoundScribe](https://github.com/adityasood386/soundscribe)

---

<p align="center">
  Made with ❤️ using Java, JSP, HTML5, Tailwind CSS & PostgreSQL
</p>

<p align="center">
  ⭐ If you like this project, consider giving it a star!
</p>
