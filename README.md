# 🎧 SoundScribe

### Your Personal Space for Music & Audiobooks

**SoundScribe** is a web-based audio streaming platform built using JavaServer Pages (JSP) and PostgreSQL. It provides users with a personalized space to explore their music library, listen to songs, enjoy audiobooks, and manage audio content through an intuitive interface.

---

## ✨ Features

### 🎵 Music Streaming
- Browse and explore your personal music library.
- Play and pause audio tracks.
- Skip to the next or previous track.
- Adjust playback volume.
- Track playback progress and seek through songs.
- Automatically play the next song when the current track ends.
- Search songs by title or artist.
- Display embedded album artwork using audio metadata.

### 📚 Audiobook Experience
- Dedicated audiobook listening section.
- Browse available audiobooks with cover artwork.
- Display book titles and narrator information.
- Playback controls with seek functionality.
- Skip forward by 30 seconds or backward by 15 seconds.
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

### 🎨 Modern User Interface
- Dark-themed interface.
- Responsive layouts.
- Modern styling with Tailwind CSS.
- Interactive audio player.
- Smooth transitions and animations.

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Java | Backend programming |
| JSP (JavaServer Pages) | Dynamic web pages |
| HTML5 | Page structure |
| CSS3 | Styling |
| JavaScript | Interactive functionality |
| Tailwind CSS | Modern UI styling |
| PostgreSQL | Database management |
| JDBC | Database connectivity |
| jsmediatags | Extracting audio metadata |
| Apache Tomcat | Web application server |

---

## 📸 Screenshots

Add screenshots of your application here.

| Music Dashboard | Audiobook Player |
|---|---|
| Add dashboard screenshot | Add audiobook screenshot |

---

## ⚙️ Installation & Setup

Follow these steps to run SoundScribe locally.

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
- An IDE such as Eclipse or IntelliJ IDEA

### 3. Database Configuration

Create a PostgreSQL database:

```sql
CREATE DATABASE audio_streaming_app_1;
```

Configure your PostgreSQL connection in the JSP database connection code.

```java
Class.forName("org.postgresql.Driver");

Connection con = DriverManager.getConnection(
    "jdbc:postgresql://localhost:5432/audio_streaming_app_1",
    "YOUR_USERNAME",
    "YOUR_PASSWORD"
);
```

**Note:** Configure the required database tables according to the SQL queries used in the application. The repository does not currently include a database schema or SQL initialization script.

### 4. Configure Apache Tomcat

1. Open your project in Eclipse or your preferred Java IDE.
2. Configure Apache Tomcat as the application server.
3. Add the PostgreSQL JDBC driver to the project.
4. Configure the database credentials.
5. Deploy the project to Tomcat.

### 5. Run the Application

Start the Tomcat server and open:

```text
http://localhost:8080/soundscribe/
```

---

## 📁 Project Structure

```text
soundscribe/
│
├── audiobooks.jsp       # Audiobook browsing and player
├── dashboard.jsp        # Main music streaming dashboard
├── login.jsp            # User login
├── register.jsp         # User registration
├── registerAction.jsp   # Registration processing
├── logout.jsp           # Logout functionality
├── navbar.jsp           # Navigation component
├── uploadSong.jsp       # Audio upload functionality
├── content.jsp          # Content handling
├── saveDraft.jsp        # Save drafts
├── checkDraftName.jsp   # Draft name validation
├── deleteDraft.jsp      # Delete drafts
└── one.jsp              # Additional application page
```

---

## 🔒 Security Notes

- Configure database credentials outside publicly accessible source code.
- Use secure password hashing for user authentication.
- Validate uploaded audio files and restrict file types and sizes.
- Use prepared statements to prevent SQL injection.
- Configure appropriate session security.

---

## 🚀 Future Enhancements

- Playlist creation and management.
- Recently played tracks.
- Favorites and liked songs.
- Personalized listening recommendations.
- User profile customization.
- Improved mobile experience.
- Audio streaming quality options.
- Audiobook listening history and bookmarks.

---

## 🎯 Project Objective

The objective of SoundScribe is to develop a web-based audio streaming platform that combines music playback and audiobook listening in one place while providing hands-on experience with JavaServer Pages, database connectivity, server-side programming, and frontend development.

---

## 👨‍💻 Author

**Aditya Sood**

- GitHub: [@adityasood386](https://github.com/adityasood386)
- Project: [SoundScribe](https://github.com/adityasood386/soundscribe)

---

<p align="center">
  <b>Built with ❤️ using Java, JSP & PostgreSQL</b>
</p>

<p align="center">
  ⭐ If you like this project, consider giving it a star!
</p>
