<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
<jsp:include page="navbar.jsp" />
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
if (session.getAttribute("user") == null) {
	response.sendRedirect("login.jsp");
	return;
}

Connection con = null;
Statement st = null;
ResultSet rs = null;
List<String[]> books = new ArrayList<>();
try {
	Class.forName("org.postgresql.Driver");
	con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/audio_streaming_app_1", "postgres", "12345");
	st = con.createStatement();
	rs = st.executeQuery("SELECT title, narrator, filepath, cover_url FROM audiobooks");
	while (rs.next()) {
		books.add(new String[]{rs.getString("title"), rs.getString("narrator"), rs.getString("filepath"),
		rs.getString("cover_url") != null ? rs.getString("cover_url") : ""});
	}
} catch (Exception e) {
	out.println("DB Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Audiobooks</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
::-webkit-scrollbar {
	width: 4px;
}

::-webkit-scrollbar-track {
	background: transparent;
}

::-webkit-scrollbar-thumb {
	background: #3f3f46;
	border-radius: 99px;
}

/* Carousel */
.carousel-track {
	display: flex;
	transition: transform .45s cubic-bezier(.25, .46, .45, .94);
}

.carousel-card {
	flex-shrink: 0;
	width: 180px;
	cursor: pointer;
	transition: transform .2s, box-shadow .2s;
}

.carousel-card:hover {
	transform: translateY(-6px) scale(1.03);
}

.carousel-card.active-card .card-cover {
	box-shadow: 0 0 0 3px #6366f1, 0 20px 40px rgba(99, 102, 241, .4);
}

.card-cover {
	width: 100%;
	aspect-ratio: 1;
	border-radius: 1.25rem;
	object-fit: cover;
	background: linear-gradient(135deg, #312e81, #1e1b4b);
	border: 1px solid rgba(255, 255, 255, .08);
	transition: box-shadow .2s;
}

/* Audio progress */
input[type=range] {
	-webkit-appearance: none;
	appearance: none;
	height: 4px;
	border-radius: 9999px;
	background: rgba(255, 255, 255, 0.1);
	outline: none;
	cursor: pointer;
}

input[type=range]::-webkit-slider-thumb {
	-webkit-appearance: none;
	width: 14px;
	height: 14px;
	border-radius: 50%;
	background: #6366f1;
	cursor: pointer;
	box-shadow: 0 0 8px rgba(99, 102, 241, .8);
}

@
keyframes fade-in {
	from {opacity: 0;
	transform: translateY(12px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.fade-in {
	animation: fade-in .35s ease forwards;
}
</style>
</head>
<body
	class="bg-zinc-950 text-zinc-100 h-screen flex flex-col overflow-hidden">

	<div class="flex-grow flex overflow-hidden">

		<!-- Sidebar search -->
		<aside
			class="w-72 bg-black border-r border-zinc-800 flex flex-col p-6">
			<div class="relative mb-5">
				<svg
					class="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-500 w-4 h-4"
					fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path stroke-linecap="round" stroke-linejoin="round"
						stroke-width="2"
						d="M21 21l-4.35-4.35M17 11A6 6 0 1 1 5 11a6 6 0 0 1 12 0z" /></svg>
				<input type="text" id="searchInput" onkeyup="filterBooks()"
					placeholder="Search books..."
					class="w-full bg-zinc-900 border border-zinc-800 text-sm rounded-xl pl-10 pr-4 py-3 focus:outline-none focus:border-indigo-500 transition-all placeholder-zinc-600">
			</div>
			<p
				class="text-[10px] font-bold uppercase tracking-widest text-zinc-600 mb-3">All
				Books</p>
			<div id="bookList" class="flex-grow overflow-y-auto space-y-1.5">
				<%
				for (int i = 0; i < books.size(); i++) {
					String[] b = books.get(i);
				%>
				<div onclick="selectBook(<%=i%>)" id="list-item-<%=i%>"
					class="book-list-item p-3 rounded-xl hover:bg-zinc-900 cursor-pointer border border-transparent hover:border-zinc-800 transition-all group">
					<p
						class="book-title font-semibold text-sm truncate group-hover:text-indigo-400"><%=b[0]%></p>
					<p class="book-narrator text-xs text-zinc-500"><%=b[1]%></p>
				</div>
				<%
				}
				%>
				<%
				if (books.isEmpty()) {
				%>
				<p class="text-xs text-zinc-600 italic text-center mt-10">No
					audiobooks found.</p>
				<%
				}
				%>
			</div>
		</aside>

		<!-- Main content -->
		<main
			class="flex-1 flex flex-col bg-gradient-to-b from-zinc-900 to-black overflow-hidden">

			<!-- Carousel Section -->
			<div class="px-10 pt-8 pb-4">
				<div class="flex items-center justify-between mb-5">
					<h2 class="text-lg font-black tracking-tight">📚 Audiobooks
						Library</h2>
					<div class="flex gap-2">
						<button onclick="carouselPrev()" id="btn-prev"
							class="w-9 h-9 rounded-full bg-white/5 hover:bg-white/10 border border-white/10 flex items-center justify-center transition-all disabled:opacity-30">
							<svg class="w-4 h-4" fill="none" stroke="currentColor"
								viewBox="0 0 24 24">
								<path stroke-linecap="round" stroke-linejoin="round"
									stroke-width="2" d="M15 19l-7-7 7-7" /></svg>
						</button>
						<button onclick="carouselNext()" id="btn-next"
							class="w-9 h-9 rounded-full bg-white/5 hover:bg-white/10 border border-white/10 flex items-center justify-center transition-all disabled:opacity-30">
							<svg class="w-4 h-4" fill="none" stroke="currentColor"
								viewBox="0 0 24 24">
								<path stroke-linecap="round" stroke-linejoin="round"
									stroke-width="2" d="M9 5l7 7-7 7" /></svg>
						</button>
					</div>
				</div>

				<!-- Carousel -->
				<div class="relative overflow-hidden">
					<div id="carousel-track" class="carousel-track gap-5 pb-2">
						<%
						for (int i = 0; i < books.size(); i++) {
							String[] b = books.get(i);
						%>
						<div class="carousel-card" id="card-<%=i%>"
							onclick="selectBook(<%=i%>)">
							<%
							if (!b[3].isEmpty()) {
							%>
							<img src="<%=b[3]%>" class="card-cover" alt="<%=b[0]%>"
								onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
							<div
								class="card-cover hidden items-center justify-center text-5xl">📖</div>
							<%
							} else {
							%>
							<div class="card-cover flex items-center justify-center text-5xl">📖</div>
							<%
							}
							%>
							<p class="text-xs font-bold mt-2 truncate text-zinc-200"><%=b[0]%></p>
							<p class="text-[10px] text-zinc-500 truncate"><%=b[1]%></p>
						</div>
						<%
						}
						%>
					</div>
				</div>
			</div>

			<!-- Divider -->
			<div class="h-px bg-zinc-800 mx-10 mb-4"></div>

			<!-- Player area -->
			<div class="flex-1 flex items-center justify-center px-10 pb-6">

				<!-- Empty -->
				<div id="empty-state"
					class="flex flex-col items-center gap-4 text-zinc-600">
					<span class="text-6xl">📖</span>
					<p class="text-base font-medium">Select an audiobook to start
						listening</p>
				</div>

				<!-- Now Playing -->
				<div id="player-ui" class="hidden fade-in w-full max-w-2xl">
					<div class="flex gap-8 items-center">
						<!-- Cover -->
						<div class="relative flex-shrink-0">
							<div
								class="absolute inset-0 bg-indigo-500/20 blur-[40px] rounded-3xl"></div>
							<img id="player-cover" src=""
								class="relative w-44 h-44 object-cover rounded-3xl border border-white/10 shadow-2xl hidden">
							<div id="player-cover-placeholder"
								class="relative w-44 h-44 rounded-3xl border border-white/10 bg-zinc-800 flex items-center justify-center text-6xl">📖</div>
						</div>

						<!-- Info & Controls -->
						<div class="flex-1 min-w-0">
							<p
								class="text-xs font-bold uppercase tracking-widest text-indigo-400 mb-1">Now
								Playing</p>
							<h2 id="display-title"
								class="text-2xl font-black tracking-tight truncate mb-1">Book
								Title</h2>
							<p id="display-narrator" class="text-zinc-400 text-sm mb-5">Narrated
								by: —</p>

							<!-- Progress -->
							<div class="mb-4">
								<input type="range" id="progress-bar" min="0" max="100"
									value="0" class="w-full"
									style="background: linear-gradient(to right, #6366f1 0%, rgba(255, 255, 255, .1) 0%)"
									oninput="seekTo(this.value)">
								<div class="flex justify-between text-[11px] text-zinc-500 mt-1">
									<span id="current-time">0:00</span> <span id="total-time">0:00</span>
								</div>
							</div>

							<!-- Controls -->
							<div class="flex items-center gap-4">
								<button onclick="skip(-15)"
									class="text-zinc-400 hover:text-white transition-colors text-xs font-bold flex flex-col items-center gap-0.5">
									<svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
										<path
											d="M12 5V1L7 6l5 5V7c3.31 0 6 2.69 6 6s-2.69 6-6 6-6-2.69-6-6H4c0 4.42 3.58 8 8 8s8-3.58 8-8-3.58-8-8-8z" /></svg>
									<span>15s</span>
								</button>

								<button id="play-pause-btn" onclick="togglePlayPause()"
									class="w-12 h-12 rounded-full bg-indigo-600 hover:bg-indigo-500 flex items-center justify-center shadow-lg shadow-indigo-500/30 transition-all hover:scale-105 active:scale-95">
									<svg id="play-icon" class="w-5 h-5 ml-0.5" fill="currentColor"
										viewBox="0 0 24 24">
										<path d="M8 5v14l11-7z" /></svg>
									<svg id="pause-icon" class="w-5 h-5 hidden" fill="currentColor"
										viewBox="0 0 24 24">
										<path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z" /></svg>
								</button>

								<button onclick="skip(30)"
									class="text-zinc-400 hover:text-white transition-colors text-xs font-bold flex flex-col items-center gap-0.5">
									<svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
										<path
											d="M12 5V1l5 5-5 5V7c-3.31 0-6 2.69-6 6s2.69 6 6 6 6-2.69 6-6h2c0 4.42-3.58 8-8 8s-8-3.58-8-8 3.58-8 8-8z" /></svg>
									<span>30s</span>
								</button>

								<!-- Speed -->
								<select id="speed-select" onchange="setSpeed(this.value)"
									class="ml-2 bg-zinc-900 border border-zinc-700 text-sm rounded-lg px-3 py-1.5 focus:outline-none focus:border-indigo-500 text-zinc-300 cursor-pointer">
									<option value="0.75">0.75×</option>
									<option value="1" selected>1×</option>
									<option value="1.25">1.25×</option>
									<option value="1.5">1.5×</option>
									<option value="2">2×</option>
								</select>
							</div>
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>

	<audio id="audio-player" crossorigin="anonymous"></audio>

	<script>
const booksData = [
  <%for (int i = 0; i < books.size(); i++) {
	String[] b = books.get(i);%>
  { title: '<%=b[0].replace("'", "\\'")%>', narrator: '<%=b[1].replace("'", "\\'")%>', path: '<%=b[2].replace("'", "\\'")%>', cover: '<%=b[3].replace("'", "\\'")%>' }<%=i < books.size() - 1 ? "," : ""%>
  <%}%>
];

const audio = document.getElementById('audio-player');
let carouselOffset = 0;
const CARD_W = 200; 
const VISIBLE = 4;

function carouselPrev() {
  carouselOffset = Math.max(0, carouselOffset - 1);
  updateCarousel();
}
function carouselNext() {
  const max = Math.max(0, booksData.length - VISIBLE);
  carouselOffset = Math.min(max, carouselOffset + 1);
  updateCarousel();
}
function updateCarousel() {
  document.getElementById('carousel-track').style.transform = `translateX(-${carouselOffset * CARD_W}px)`;
  document.getElementById('btn-prev').disabled = carouselOffset === 0;
  document.getElementById('btn-next').disabled = carouselOffset >= booksData.length - VISIBLE;
}
updateCarousel();

function selectBook(index) {
  const book = booksData[index];
  if (!book) return;

  // Highlight in sidebar
  document.querySelectorAll('.book-list-item').forEach((el,i) => {
    el.classList.toggle('bg-zinc-900', i === index);
    el.classList.toggle('border-indigo-500/50', i === index);
  });
  // Highlight in carousel
  document.querySelectorAll('.carousel-card').forEach((el,i) => el.classList.toggle('active-card', i === index));

  // Show player
  document.getElementById('empty-state').classList.add('hidden');
  const ui = document.getElementById('player-ui');
  ui.classList.remove('hidden');
  ui.classList.remove('fade-in');
  
  ui.classList.add('fade-in');

  document.getElementById('display-title').innerText = book.title;
  document.getElementById('display-narrator').innerText = 'Narrated by: ' + book.narrator;

  const coverImg = document.getElementById('player-cover');
  const coverPH = document.getElementById('player-cover-placeholder');
  if (book.cover && book.cover !== 'null' && book.cover !== '') {
    coverImg.src = book.cover;
    coverImg.classList.remove('hidden');
    coverPH.classList.add('hidden');
  } else {
    coverImg.classList.add('hidden');
    coverPH.classList.remove('hidden');
  }

  audio.src = book.path;
  audio.playbackRate = parseFloat(document.getElementById('speed-select').value);
  audio.play();
  setPlayState(true);
}

function togglePlayPause(){
  if(audio.paused){audio.play();setPlayState(true);}
  else{audio.pause();setPlayState(false);}
}
function setPlayState(p){
  document.getElementById('play-icon').classList.toggle('hidden',p);
  document.getElementById('pause-icon').classList.toggle('hidden',!p);
}
function seekTo(v){ if(audio.duration) audio.currentTime=(v/100)*audio.duration; }
function skip(s){ audio.currentTime = Math.max(0, Math.min(audio.duration||0, audio.currentTime+s)); }
function setSpeed(v){ audio.playbackRate = parseFloat(v); }
function fmt(s) {
	  s = Math.floor(s);
	  const h = Math.floor(s / 3600);
	  const m = Math.floor((s % 3600) / 60);
	  const sec = s % 60;
	  if (h > 0) {
	    return h + ':' + (m < 10 ? '0' : '') + m + ':' + (sec < 10 ? '0' : '') + sec;
	  }
	  return m + ':' + (sec < 10 ? '0' : '') + sec;
	}

	audio.addEventListener('timeupdate', () => {
	  if (!audio.duration || isNaN(audio.duration)) return;
	  const current = Math.min(audio.currentTime, audio.duration); // clamp here only
	  const p = (current / audio.duration) * 100;
	  const bar = document.getElementById('progress-bar');
	  bar.value = p;
	  document.getElementById('current-time').innerText = fmt(current);
	});

	audio.addEventListener('loadedmetadata', () => {
	  if (!audio.duration || isNaN(audio.duration)) return;
	  document.getElementById('total-time').innerText = fmt(audio.duration);
	});
	

function filterBooks(){
  const f=document.getElementById('searchInput').value.toLowerCase();
  document.querySelectorAll('.book-list-item').forEach(el=>{
    const t=el.querySelector('.book-title').innerText.toLowerCase();
    el.classList.toggle('hidden', !t.includes(f));
  });
}
</script>
</body>
</html>
