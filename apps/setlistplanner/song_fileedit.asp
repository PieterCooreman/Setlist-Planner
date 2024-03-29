<%

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim songFile : set songFile=new cls_songFile
songFile.pick(form.request("iId"))

'create an instance of the afdeling class
set song = songFile.song : if song.iId=0 then aspl.die

form.writejs modalLabel(song.sTitle)

'catch ajax call!
if form.postback then

	'session securitycheck
	if form.sameSession then
				
		songFile.sFilename	= trim(form.request("sFilename"))		
						
		if songFile.save then
						
			aspl.addFB(l("changeshavebeensaved"))			
			
		end if				
		
	end if
	
end if

dim iFileID : set iFileID = form.field("hidden")
iFileID.add "value",songFile.iId
iFileID.add "name","iId"

form.newline

dim sFilename : set sFilename = form.field("text")
sFilename.add "label",l("name")
sFilename.add "value",songFile.sFilename
sFilename.add "name","sFilename"
sFilename.add "required",true
sFilename.add "maxlength",255

form.newline

dim save : set save = form.field("submit")
save.add "html",l("save")
save.add "class","btn btn-primary"

dim download : set download = form.field("button")
download.add "html","Download"
download.add "onclick",songFile.downloadLink
download.add "class","btn btn-warning"

dim cancel : set cancel=form.field("button")
cancel.add "html",l("cancel")
cancel.add "class","btn btn-secondary"
cancel.add "onclick",loadmodaliId("song_files.asp",song.iId,"")

if songFile.canBeDeleted then

	dim delete : set delete=form.field("button")
	delete.add "html",l("delete")
	delete.add "class","btn btn-danger"	
	delete.add "onclick",loadmodaliId("song_filedelete.asp",songFile.iId,"")
	
end if

form.build

%>