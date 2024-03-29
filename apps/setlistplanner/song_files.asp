<%

aspl(myApp.sPath & "/includes/begin.asp")

'create an instance of the song class
dim song : set song = new cls_song : song.pick(form.request("iId"))

if currentPayment.iId=0 then
	form.writejs loadmodalonload("payment.asp","")
	form.build
end if

form.writejs modalLabel(l("files") & " " & song.sTitle)

set back=form.field("button")
back.add "html",l("back")
back.add "class","btn btn-secondary"
back.add "onclick",loadmodaliId("song_edit.asp",song.iId,"")

dim add : set add=form.field("button")
add.add "html",l("add")
add.add "class","btn btn-primary"
add.add "onclick",loadmodaliId("song_upload.asp",song.iId,"")

form.newline

dim rows, file, files
set files=song.files

rows="<table class=""table table-striped"">"
rows=rows & "<thead>"
rows=rows & "<tr>"
rows=rows & "<th>" & l("name") & "</th>"
rows=rows & "<th>" & l("size") & "</th>"
rows=rows & "</tr>"
rows=rows & "</thead>"
rows=rows & "<tbody>"

for each file in files

	rows=rows & "<tr>"		
		rows=rows & "<td><a class=""link"" onclick="""& loadmodaliId("song_fileedit.asp",file,"") &";return false;"" href=""#"">"
		rows=rows & server.htmlEncode(files(file).sFilename) & "</a></td>" 
		rows=rows & "<td>" & round(files(file).iFileSize/1024,0) & " kB</td>"
	rows=rows & "</tr>"
	
next
rows=rows & "</tbody>"
rows=rows & "</table>"

set files=nothing

form.write rows

%>