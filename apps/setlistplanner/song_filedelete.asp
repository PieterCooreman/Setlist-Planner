<%

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim songFile : set songFile=new cls_songFile
songFile.pick(form.request("iId"))

'create an instance of the afdeling class
dim song : set song = songFile.song : if song.iId=0 then aspl.die

form.writejs modalLabel (l("doyouwanttoremovethisfile"))

'catch ajax call!
if form.postback then

	'session securitycheck
	if form.sameSession then
				
		songFile.remove		
		
		form.writejs loadInTarget("modalform","song_files.asp","&iId=" & song.iId)	
		
		form.build
		
	end if
	
end if

dim iFileID : set iFileID = form.field("hidden")
iFileID.add "value",songFile.iId
iFileID.add "name","iId"

form.newline

dim delete : set delete=form.field("submit")
delete.add "html",l("deletecmd")	& " <strong>" & songFile.sFileName & "</strong>"
delete.add "class","btn btn-danger"	


dim back : set back=form.field("button")
back.add "html",l("cancel")
back.add "class","btn btn-secondary"
back.add "onclick",loadmodaliId("song_files.asp",song.iId,"")

form.build

%>