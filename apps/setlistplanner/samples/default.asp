<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Buffer				= true
Response.ContentType		= "text/html"
Response.CacheControl		= "no-cache"
Response.AddHeader "pragma", "no-cache"
Response.Expires			= -1
Response.ExpiresAbsolute	= Now()-1

%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Setlist Planner Kick Machine</title>
   
   <script>
   function play(file) {

		var audio = document.getElementById('audio');
		audio.pause();

		var source = document.getElementById('audioSource');
		source.src = file;
		
		audio.load(); //call this to just preload the audio without playing
		audio.currentTime=0;
		audio.play(); //call this to play the song right away
	
   }
   </script>
</head>
<body style="background-color:pink;font-family:Arial;font-size:16px">
<center>
<select style="margin-bottom:7px;border-radius:15px;padding:15px;font-size:16px" onchange="play(this.value)">
<option></option>
<%
dim fso : set fso=server.createobject("scripting.filesystemobject")
dim file,folder : set folder=fso.getfolder(server.mappath("."))
dim showname
for each file in folder.files
	if instr(file.name,"mp3")<>0 then		
		
		response.write "<option value="""& server.htmlEncode(file.name) & """>"
		showname=replace(file.name,"kick","Kick ",1,-1,1)
		showname=replace(showname,"tick","Kick & Hh ",1,-1,1)
		showname=replace(showname,".mp3","",1,-1,1)
		showname=showname & " BPM"		
		
		response.write server.htmlEncode(showname) & "</option>"
		
	end if
next

set fso=nothing
%>
</select>
<br>
<audio id="audio" controls="controls" loop>
	 <source id="audioSource" src="" type="audio/mpeg"></source>
  Your browser does not support the audio format.
</audio>
</center>
</body>