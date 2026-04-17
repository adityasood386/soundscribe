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
try {
	Class.forName("org.postgresql.Driver");
	con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/audio_streaming_app_1", "postgres", "12345");
	st = con.createStatement();
	rs = st.executeQuery("SELECT * FROM songs");
} catch (Exception e) {
	out.println("DB Error: " + e.getMessage());
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Audio Streaming App</title>
<script src="https://cdn.tailwindcss.com"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jsmediatags/3.9.5/jsmediatags.min.js"></script>
<style>
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
	transition: transform .15s;
	box-shadow: 0 0 8px rgba(99, 102, 241, .8);
}

input[type=range]::-webkit-slider-thumb:hover {
	transform: scale(1.3);
}

@
keyframes spin-slow {
	to {transform: rotate(360deg);
}

}
.spin-slow {
	animation: spin-slow 8s linear infinite;
}

.spin-slow.paused {
	animation-play-state: paused;
}

.song-item.active {
	background: rgba(99, 102, 241, .12);
	border-color: rgba(99, 102, 241, .4);
}

.song-item.active .song-title {
	color: #818cf8;
}

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
</style>
</head>
<body
	class="bg-zinc-950 text-zinc-100 h-screen flex flex-col overflow-hidden">

	<div class="flex-grow flex overflow-hidden">

		<!-- Sidebar -->
		<aside
			class="w-80 bg-black/60 backdrop-blur-xl border-r border-white/10 flex flex-col p-6 shadow-2xl z-20">
			<div class="relative mb-5">
				<svg
					class="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-500 w-4 h-4"
					fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path stroke-linecap="round" stroke-linejoin="round"
						stroke-width="2"
						d="M21 21l-4.35-4.35M17 11A6 6 0 1 1 5 11a6 6 0 0 1 12 0z" /></svg>
				<input type="text" id="searchInput" onkeyup="filterSongs()"
					placeholder="Search library..."
					class="w-full bg-white/5 border border-white/10 text-sm rounded-xl pl-10 pr-4 py-3 focus:outline-none focus:border-indigo-500/50 focus:bg-white/10 transition-all placeholder-zinc-500">
			</div>
			<p
				class="text-[10px] font-bold uppercase tracking-widest text-zinc-600 mb-3">Library</p>
			<div id="songContainer"
				class="flex-grow overflow-y-auto space-y-5 pr-1 py-6">
				<%
				int songIdx = 0;
				if (rs != null) {
					while (rs.next()) {
						String fp = rs.getString("filepath");
						String st2 = rs.getString("title").replace("'", "\\'");
						String ar = rs.getString("artist").replace("'", "\\'");
				%>
				<div
					onclick="playTrack('<%=fp%>','<%=st2%>','<%=ar%>',<%=songIdx%>)"
					id="song-<%=songIdx%>"
					class="song-item flex items-center gap-3 p-3 rounded-2xl cursor-pointer border border-white/5 bg-white/5 hover:bg-white/10 hover:border-indigo-500/30 hover:-translate-y-1 transition-all group">
					<div
						class="w-9 h-9 rounded-xl bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center flex-shrink-0 text-indigo-400 text-xs ">🎵</div>
					<div class="overflow-hidden">
						<p
							class="song-title font-bold text-sm truncate group-hover:text-indigo-400 transition-colors "><%=rs.getString("title")%></p>
						<p class="song-artist text-[11px] text-zinc-500 mt-0.5"><%=rs.getString("artist")%></p>
					</div>
				</div>
				<%
				songIdx++;
				}
				}
				%>
			</div>
		</aside>

		<!-- Main Player -->
		<main
			class="flex-1 flex flex-col items-center justify-center bg-gradient-to-br from-zinc-900 via-black to-zinc-950 relative overflow-hidden">
			<div
				class="absolute -top-32 -left-32 w-96 h-96 bg-indigo-600/10 blur-[130px] rounded-full pointer-events-none"></div>
			<div id="glow-blob"
				class="absolute bottom-0 right-0 w-[500px] h-[500px] bg-indigo-500/5 blur-[160px] rounded-full pointer-events-none transition-all duration-1000"></div>

			<!-- Empty state -->
			<div id="empty-state"
				class="flex flex-col items-center gap-5 text-zinc-600 z-10">
				<div
					class="w-24 h-24 rounded-full bg-white/5 border border-white/10 flex items-center justify-center">
					<span class="text-4xl">🎧</span>
				</div>
				<p class="text-base font-medium tracking-wide">Select a track to
					start the vibe</p>
			</div>

			<!-- Player UI -->
			<div id="player-ui"
				class="hidden flex-col items-center w-full max-w-lg px-8 z-10">
				<!-- Vinyl -->
				<div class="relative mb-8">
					<div
						class="absolute inset-0 rounded-full bg-indigo-500/20 blur-[60px] scale-110"></div>
					<div id="vinyl"
						class="relative w-64 h-64 rounded-full shadow-2xl spin-slow paused">
						<div
							class="absolute inset-0 rounded-full bg-gradient-to-br from-zinc-800 to-zinc-950 border border-white/10"></div>
						<div class="absolute inset-4 rounded-full border border-white/5"></div>
						<div class="absolute inset-8 rounded-full border border-white/5"></div>
						<div class="absolute inset-12 rounded-full border border-white/5"></div>
						<img id="album-art" src=""
							class="absolute inset-[25%] w-[50%] h-[50%] object-cover rounded-full border-2 border-white/20 hidden z-10">
						<div id="art-placeholder"
							class="absolute inset-[25%] w-[50%] h-[50%] rounded-full bg-indigo-500/20 border-2 border-indigo-500/30 flex items-center justify-center z-10">
							<span class="text-2xl">♫</span>
						</div>
					</div>
				</div>

				<!-- Info -->
				<div class="text-center mb-7">
					<h2 id="display-title"
						class="text-3xl font-black tracking-tight truncate max-w-sm">Title</h2>
					<p id="display-artist"
						class="text-indigo-400 text-base font-medium mt-1">Artist</p>
				</div>

				<!-- Card -->
				<div
					class="w-full bg-white/5 backdrop-blur-2xl rounded-3xl border border-white/10 shadow-2xl p-6">
					<!-- Progress -->
					<div class="mb-4">
						<input type="range" id="progress-bar" min="0" max="100" value="0"
							class="w-full"
							style="background: linear-gradient(to right, #6366f1 0%, rgba(255, 255, 255, .1) 0%)"
							oninput="seekTo(this.value)">
						<div
							class="flex justify-between text-[11px] text-zinc-500 mt-1 px-0.5">
							<span id="current-time">0:00</span> <span id="total-time">0:00</span>
						</div>
					</div>
					<!-- Controls -->
					<div class="flex items-center justify-center gap-6 mb-5">
						<button onclick="prevTrack()" title="Previous"
							class="text-zinc-400 hover:text-white transition-colors p-2 rounded-full hover:bg-white/5">
							<svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
								<path d="M6 6h2v12H6zm3.5 6 8.5 6V6z" /></svg>
						</button>
						<button id="play-pause-btn" onclick="togglePlayPause()"
							class="w-14 h-14 rounded-full bg-indigo-600 hover:bg-indigo-500 flex items-center justify-center shadow-lg shadow-indigo-500/30 transition-all hover:scale-105 active:scale-95">
							<svg id="play-icon" class="w-6 h-6 ml-0.5" fill="currentColor"
								viewBox="0 0 24 24">
								<path d="M8 5v14l11-7z" /></svg>
							<svg id="pause-icon" class="w-6 h-6 hidden" fill="currentColor"
								viewBox="0 0 24 24">
								<path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z" /></svg>
						</button>
						<button onclick="nextTrack()" title="Next"
							class="text-zinc-400 hover:text-white transition-colors p-2 rounded-full hover:bg-white/5">
							<svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
								<path
									d="M6 18l8.5-6L6 6v12zm2-8.14 4.96 3.14L8 16.14V9.86zM16 6h2v12h-2z" /></svg>
						</button>
					</div>
					<!-- Volume -->
					<div class="flex items-center gap-3">
						<svg class="w-4 h-4 text-zinc-500 flex-shrink-0"
							fill="currentColor" viewBox="0 0 24 24">
							<path
								d="M3 9v6h4l5 5V4L7 9H3zm13.5 3c0-1.77-1.02-3.29-2.5-4.03v8.05c1.48-.73 2.5-2.25 2.5-4.02z" /></svg>
						<input type="range" id="volume-bar" min="0" max="100" value="80"
							class="flex-1" oninput="setVolume(this.value)">
						<svg class="w-4 h-4 text-zinc-400 flex-shrink-0"
							fill="currentColor" viewBox="0 0 24 24">
							<path
								d="M3 9v6h4l5 5V4L7 9H3zm13.5 3c0-1.77-1.02-3.29-2.5-4.03v8.05c1.48-.73 2.5-2.25 2.5-4.02zM14 3.23v2.06c2.89.86 5 3.54 5 6.71s-2.11 5.85-5 6.71v2.06c4.01-.91 7-4.49 7-8.77s-2.99-7.86-7-8.77z" /></svg>
					</div>
				</div>
			</div>
		</main>
	</div>

	<audio id="audio-player" crossorigin="anonymous"></audio>

	<script>
  const audio = document.getElementById('audio-player');
  let currentIndex = -1;
  const songs = [];
  document.querySelectorAll('.song-item').forEach((el, i) => {
    const onclickStr = el.getAttribute('onclick');
    const matches = onclickStr.match(/'((?:[^'\\]|\\.)*)'/g) || [];
    songs.push({
      path: matches[0] ? matches[0].replace(/'/g,'') : '',
      title: el.querySelector('.song-title').innerText,
      artist: el.querySelector('.song-artist').innerText,
      index: i
    });
  });

  function playTrack(fp, title, artist, index) {
    currentIndex = index;
    document.querySelectorAll('.song-item').forEach((el,i) => el.classList.toggle('active', i===index));
    document.getElementById('empty-state').classList.add('hidden');
    const ui = document.getElementById('player-ui');
    ui.classList.remove('hidden');
    ui.classList.add('flex');
    document.getElementById('display-title').innerText = title;
    document.getElementById('display-artist').innerText = artist;
    audio.src = fp;
    audio.volume = document.getElementById('volume-bar').value / 100;
    audio.play();
    setPlayingState(true);
    document.getElementById('album-art').classList.add('hidden');
    document.getElementById('art-placeholder').classList.remove('hidden');
    fetch(fp).then(r=>r.blob()).then(blob=>{
      window.jsmediatags.read(blob,{
        onSuccess:function(tag){
          const pic=tag.tags.picture;
          if(pic){
            let b64='';
            for(let i=0;i<pic.data.length;i++) b64+=String.fromCharCode(pic.data[i]);
            const img=document.getElementById('album-art');
            img.src='data:'+pic.format+';base64,'+btoa(b64);
            img.classList.remove('hidden');
            document.getElementById('art-placeholder').classList.add('hidden');
          }
        }
      });
    }).catch(()=>{});
  }

  function setPlayingState(playing) {
    document.getElementById('vinyl').classList.toggle('paused',!playing);
    document.getElementById('play-icon').classList.toggle('hidden',playing);
    document.getElementById('pause-icon').classList.toggle('hidden',!playing);
  }

  function togglePlayPause(){
    if(audio.paused){audio.play();setPlayingState(true);}
    else{audio.pause();setPlayingState(false);}
  }

  function nextTrack(){
    if(!songs.length) return;
    const s=songs[(currentIndex+1)%songs.length];
    playTrack(s.path,s.title,s.artist,s.index);
  }

  function prevTrack(){
    if(!songs.length) return;
    if(audio.currentTime>3){audio.currentTime=0;return;}
    const s=songs[(currentIndex-1+songs.length)%songs.length];
    playTrack(s.path,s.title,s.artist,s.index);
  }

  function seekTo(v){if(audio.duration) audio.currentTime=(v/100)*audio.duration;}
  function setVolume(v){
    audio.volume=v/100;
    document.getElementById('volume-bar').style.background=`linear-gradient(to right,#6366f1 ${v}%,rgba(255,255,255,.1) ${v}%)`;
  }
  function fmt(s){const m=Math.floor(s/60);return m+':'+(Math.floor(s%60)<10?'0':'')+Math.floor(s%60);}

  audio.addEventListener('timeupdate',()=>{
    if(!audio.duration) return;
    const p=(audio.currentTime/audio.duration)*100;
    const bar=document.getElementById('progress-bar');
    bar.value=p;
    bar.style.background=`linear-gradient(to right,#6366f1 ${p}%,rgba(255,255,255,.1) ${p}%)`;
    document.getElementById('current-time').innerText=fmt(audio.currentTime);
  });
  audio.addEventListener('loadedmetadata',()=>{document.getElementById('total-time').innerText=fmt(audio.duration);});
  audio.addEventListener('ended',nextTrack);

  // Init volume bar fill on page load
  document.addEventListener('DOMContentLoaded', () => setVolume(80));

  function filterSongs(){
    const f=document.getElementById('searchInput').value.toLowerCase();
    document.querySelectorAll('.song-item').forEach(el=>{
      const t=el.querySelector('.song-title').innerText.toLowerCase();
      const a=el.querySelector('.song-artist').innerText.toLowerCase();
      el.classList.toggle('hidden',!(t.includes(f)||a.includes(f)));
    });
  }
</script>

</body>
</html>