
<header class="h-16 border-b border-zinc-800 bg-black flex items-center justify-between px-8 z-50">
    <div class="flex items-center gap-10 ">
        <h1 class="text-2xl font-black text-indigo-500 italic tracking-tighter uppercase ">ADITYA'S APP</h1>
        <nav class="flex gap-8 h-16 ">
            <a href="dashboard.jsp" 
               class="flex items-center text-sm font-bold transition-all px-2 border-b-2 <%= request.getRequestURI().contains("dashboard.jsp") ? "border-indigo-500 text-indigo-500" : "border-transparent text-zinc-500 hover:text-zinc-200 hover:-translate-y-1" %>">
               Music
            </a>
            <a href="audiobooks.jsp" 
               class="flex items-center text-sm font-bold transition-all px-2 border-b-2 <%= request.getRequestURI().contains("audiobooks.jsp") ? "border-indigo-500 text-indigo-500" : "border-transparent text-zinc-500 hover:text-zinc-200 hover:-translate-y-1" %>">
               Audiobooks
            </a>
            <a href="content.jsp" 
               class="flex items-center text-sm font-bold transition-all px-2 border-b-2 <%= request.getRequestURI().contains("content.jsp") ? "border-indigo-500 text-indigo-500" : "border-transparent text-zinc-500 hover:text-zinc-200 hover:-translate-y-1" %>">
               Content Writing
            </a>
        </nav>
    </div>
    <div class="flex items-center gap-4 text-xs text-zinc-500">
        <span>Welcome: <%= session.getAttribute("name") %></span>
        <a href="logout.jsp" class="bg-zinc-900 px-3 py-1 rounded border border-zinc-500 hover:bg-red-900 transition-all">Logout</a>
    </div>
</header>