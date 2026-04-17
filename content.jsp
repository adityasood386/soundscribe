<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.net.*"%>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
if (session.getAttribute("user") == null) {
	response.sendRedirect("login.jsp");
	return;
}

String userEmail = (String) session.getAttribute("user");
String loadTitle = request.getParameter("loadTitle");
String currentTitle = "";
String currentContent = "";

try {
	Class.forName("org.postgresql.Driver");
	Connection con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/audio_streaming_app_1", "postgres", "12345");
	String fetchQuery;
	PreparedStatement psFetch;
	if (loadTitle != null) {
		fetchQuery = "SELECT title, content FROM drafts WHERE user_owner = ? AND title = ?";
		psFetch = con.prepareStatement(fetchQuery);
		psFetch.setString(1, userEmail);
		psFetch.setString(2, loadTitle);
	} else {
		fetchQuery = "SELECT title, content FROM drafts WHERE user_owner = ? ORDER BY last_edited DESC LIMIT 1";
		psFetch = con.prepareStatement(fetchQuery);
		psFetch.setString(1, userEmail);
	}
	ResultSet rsDraft = psFetch.executeQuery();
	if (rsDraft.next()) {
		currentTitle = rsDraft.getString("title");
		currentContent = rsDraft.getString("content");
	}
	con.close();
} catch (Exception e) {
	e.printStackTrace();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Content Writing</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
  .editor-textarea:focus { outline: none; }
  ::-webkit-scrollbar{width:4px;} ::-webkit-scrollbar-track{background:transparent;} ::-webkit-scrollbar-thumb{background:#3f3f46;border-radius:99px;}
  .draft-item:hover .delete-btn { opacity:1; }
  .delete-btn { opacity:0; transition: opacity .15s; }
</style>
</head>
<body class="bg-zinc-950 text-zinc-100 h-screen flex flex-col overflow-hidden">

<jsp:include page="navbar.jsp" />

<div class="flex flex-1 overflow-hidden">

  <!-- Sidebar -->
  <aside class="w-72 bg-black border-r border-zinc-900 flex flex-col p-6">
    <div class="flex items-center justify-between mb-6">
      <h2 class="text-xs font-bold text-zinc-500 uppercase tracking-widest">My Drafts</h2>
      <button onclick="newDraft()" class="text-indigo-500 hover:text-indigo-400 text-xl font-bold transition-colors" title="New Draft">+</button>
    </div>

    <div class="flex-grow overflow-y-auto space-y-2">
      <%
      try {
        Connection conSide = DriverManager.getConnection("jdbc:postgresql://localhost:5432/audio_streaming_app_1", "postgres", "12345");
        String listSql = "SELECT title, last_edited FROM drafts WHERE user_owner = ? ORDER BY last_edited DESC";
        PreparedStatement psSide = conSide.prepareStatement(listSql);
        psSide.setString(1, userEmail);
        ResultSet rsSide = psSide.executeQuery();
        boolean hasDrafts = false;
        while (rsSide.next()) {
          hasDrafts = true;
          String dTitle = rsSide.getString("title");
          boolean isActive = dTitle.equals(currentTitle);
      %>
      <div class="draft-item relative flex items-center gap-1 rounded-xl border <%=isActive ? "bg-zinc-900 border-indigo-500/50" : "border-transparent hover:bg-zinc-900 hover:border-zinc-800"%> group transition-all">
        <div onclick="window.location.href='content.jsp?loadTitle=<%=URLEncoder.encode(dTitle, "UTF-8")%>'"
          class="flex-1 p-3 cursor-pointer min-w-0">
          <p class="text-sm font-semibold truncate <%=isActive ? "text-indigo-400" : "group-hover:text-indigo-400"%>"><%=dTitle%></p>
          <p class="text-[10px] text-zinc-500">Edited: <%=rsSide.getTimestamp("last_edited").toString().substring(0,16)%></p>
        </div>
        <button class="delete-btn flex-shrink-0 mr-2 w-7 h-7 rounded-lg bg-red-500/10 hover:bg-red-500/30 border border-red-500/20 hover:border-red-500/40 flex items-center justify-center text-red-400 hover:text-red-300 transition-all"
          onclick="event.stopPropagation(); deleteDraft('<%=dTitle.replace("'", "\\'")%>')"
          title="Delete draft">
          <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
          </svg>
        </button>
      </div>
      <%
        }
        if (!hasDrafts) {
          out.print("<p class='text-xs text-zinc-600 italic text-center mt-10'>No drafts yet.</p>");
        }
        conSide.close();
      } catch (Exception e) {
        out.print("Error loading sidebar");
      }
      %>
    </div>
  </aside>

  <!-- Editor -->
  <main class="flex-1 bg-zinc-950 flex flex-col p-12 overflow-y-auto">
    <div class="max-w-3xl mx-auto w-full flex flex-col h-full">

      <div class="flex gap-4 mb-6 pb-4 border-b border-zinc-900 items-center">
        <span class="text-[10px] text-zinc-500 font-bold uppercase tracking-widest">Editor</span>
        <div class="ml-auto flex items-center gap-3">
          <span id="saveStatus" class="text-[11px] text-zinc-600"></span>
          <button onclick="saveDraft()" id="saveBtn"
            class="text-indigo-500 hover:text-indigo-400 text-sm font-bold transition-all">Save Changes</button>
        </div>
      </div>

      <input type="text" id="draftTitle" placeholder="Enter Title..."
        class="bg-transparent text-4xl font-black mb-8 focus:outline-none placeholder-zinc-800 tracking-tight w-full"
        value="<%=currentTitle.isEmpty() ? "" : currentTitle%>">

      <textarea id="draftContent"
        class="editor-textarea flex-1 bg-transparent text-zinc-300 leading-relaxed text-lg resize-none w-full"
        placeholder="Start writing your masterpiece here..."><%=currentContent%></textarea>

      <div class="mt-8 text-[10px] text-zinc-600 uppercase font-bold flex justify-between items-center">
        <span id="wordCount">Words: 0</span>
        <span id="charCount">Chars: 0</span>
      </div>
    </div>
  </main>
</div>

<!-- New Draft Modal -->
<div id="draftModal" class="fixed inset-0 bg-black/80 backdrop-blur-sm z-[100] hidden items-center justify-center">
  <div class="bg-zinc-900 border border-zinc-800 p-8 rounded-3xl w-full max-w-sm shadow-2xl">
    <h3 class="text-xl font-bold mb-2">New Draft</h3>
    <p class="text-zinc-500 text-sm mb-6">Give your masterpiece a name</p>
    <input type="text" id="newDraftName"
      class="w-full bg-black border border-zinc-800 rounded-xl px-4 py-3 mb-6 focus:outline-none focus:border-indigo-500 text-zinc-100"
      placeholder="Draft Title..."
      onkeydown="if(event.key==='Enter') confirmNewDraft()">
    <div class="flex gap-3">
      <button onclick="closeModal()" class="flex-1 px-4 py-3 rounded-xl bg-zinc-800 hover:bg-zinc-700 font-bold text-sm transition">Cancel</button>
      <button onclick="confirmNewDraft()" class="flex-1 px-4 py-3 rounded-xl bg-indigo-600 hover:bg-indigo-500 font-bold text-sm transition">Create</button>
    </div>
  </div>
</div>

<!-- Delete Confirm Modal -->
<div id="deleteModal" class="fixed inset-0 bg-black/80 backdrop-blur-sm z-[100] hidden items-center justify-center">
  <div class="bg-zinc-900 border border-zinc-800 p-8 rounded-3xl w-full max-w-sm shadow-2xl">
    <div class="w-12 h-12 rounded-full bg-red-500/10 border border-red-500/20 flex items-center justify-center mx-auto mb-4">
      <svg class="w-6 h-6 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
      </svg>
    </div>
    <h3 class="text-xl font-bold mb-2 text-center">Delete Draft?</h3>
    <p class="text-zinc-400 text-sm mb-1 text-center">You're about to delete:</p>
    <p id="deleteTargetName" class="text-indigo-400 font-bold text-center mb-6 truncate"></p>
    <p class="text-zinc-600 text-xs text-center mb-6">This action cannot be undone.</p>
    <div class="flex gap-3">
      <button onclick="closeDeleteModal()" class="flex-1 px-4 py-3 rounded-xl bg-zinc-800 hover:bg-zinc-700 font-bold text-sm transition">Cancel</button>
      <button onclick="confirmDelete()" class="flex-1 px-4 py-3 rounded-xl bg-red-600 hover:bg-red-500 font-bold text-sm transition">Delete</button>
    </div>
  </div>
</div>

<script>
let pendingDeleteTitle = null;

function newDraft() {
  document.getElementById('draftModal').classList.remove('hidden');
  document.getElementById('draftModal').classList.add('flex');
  document.getElementById('newDraftName').focus();
}
function closeModal() {
  document.getElementById('draftModal').classList.add('hidden');
  document.getElementById('draftModal').classList.remove('flex');
  document.getElementById('newDraftName').value = '';
}

async function confirmNewDraft() {
  const name = document.getElementById('newDraftName').value.trim();
  if (!name) { alert("Please enter a name."); return; }
  try {
    const checkRes = await fetch("checkDraftName.jsp?title=" + encodeURIComponent(name));
    const status = await checkRes.text();
    if (status.trim() === "exists") {
      alert("A draft named '" + name + "' already exists.");
      return;
    }
    const res = await fetch("saveDraft.jsp?title=" + encodeURIComponent(name) + "&content=");
    const result = await res.text();
    if (result.trim() === "Success") {
      window.location.href = "content.jsp?loadTitle=" + encodeURIComponent(name);
    }
  } catch (e) {
    alert("Server error. Please try again.");
  }
}

function deleteDraft(title) {
  pendingDeleteTitle = title;
  document.getElementById('deleteTargetName').innerText = '"' + title + '"';
  document.getElementById('deleteModal').classList.remove('hidden');
  document.getElementById('deleteModal').classList.add('flex');
}
function closeDeleteModal() {
  document.getElementById('deleteModal').classList.add('hidden');
  document.getElementById('deleteModal').classList.remove('flex');
  pendingDeleteTitle = null;
}

async function confirmDelete() {
  if (!pendingDeleteTitle) return;
  try {
    const res = await fetch("deleteDraft.jsp?title=" + encodeURIComponent(pendingDeleteTitle));
    const result = await res.text();
    if (result.trim() === "Deleted") {
      closeDeleteModal();
      // If we deleted the currently open draft, go to content.jsp
      const currentTitleVal = document.getElementById('draftTitle').value;
      if (currentTitleVal === pendingDeleteTitle) {
        window.location.href = 'content.jsp';
      } else {
        window.location.reload();
      }
    } else {
      alert("Delete failed: " + result);
    }
  } catch (e) {
    alert("Server error.");
  }
}

window.onclick = function(event) {
  const draftModal = document.getElementById('draftModal');
  const deleteModal = document.getElementById('deleteModal');
  if (event.target === draftModal) closeModal();
  if (event.target === deleteModal) closeDeleteModal();
};

async function saveDraft() {
  const title = document.getElementById('draftTitle').value;
  const content = document.getElementById('draftContent').value;
  const saveBtn = document.getElementById('saveBtn');
  const saveStatus = document.getElementById('saveStatus');
  if (!title.trim()) { alert("Please enter a title before saving."); return; }
  saveBtn.innerText = "Saving...";
  saveBtn.classList.add('animate-pulse');
  try {
    const res = await fetch("saveDraft.jsp?title=" + encodeURIComponent(title) + "&content=" + encodeURIComponent(content));
    const result = await res.text();
    if (result.trim() === "Success") {
      saveBtn.innerText = "Saved!";
      saveStatus.innerText = "All changes saved";
      saveBtn.classList.remove('animate-pulse');
      setTimeout(() => {
        window.location.href = "content.jsp?loadTitle=" + encodeURIComponent(title);
      }, 800);
    } else {
      alert("Save failed: " + result);
      saveBtn.innerText = "Error";
    }
  } catch (e) {
    saveBtn.innerText = "Network Error";
  }
}

// Word & char counter
const area = document.getElementById('draftContent');
area.addEventListener('input', () => {
  const words = area.value.trim() ? area.value.trim().split(/\s+/).length : 0;
  document.getElementById('wordCount').innerText = "Words: " + words;
  document.getElementById('charCount').innerText = "Chars: " + area.value.length;
});
area.dispatchEvent(new Event('input'));

// Ctrl+S to save
document.addEventListener('keydown', e => {
  if ((e.ctrlKey || e.metaKey) && e.key === 's') { e.preventDefault(); saveDraft(); }
});
</script>
</body>
</html>
