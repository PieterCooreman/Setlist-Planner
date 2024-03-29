<%
form.initialize=false

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim bNew, song : set song=new cls_song : bNew=false
song.pick(form.request("iId"))

if song.iId=0 and songRS.recordcount>14 and currentPayment.iId=0 then
	form.writejs loadmodalonload("payment.asp","")
	form.build
end if

form.writejs modalLabel(l("addeditsong"))

if form.postback then

	'session securitycheck
	if form.sameSession then	
		
		song.sTitle		=	form.request("sTitle")
		song.sLyrics	=	form.request("sLyrics")
		song.sComments	=	form.request("sComments")
		song.sTuning	=	form.request("sTuning")
		song.sBPM		=	form.request("sBPM")
		song.sArtist	=	form.request("sArtist")
		
		if song.iId=0 then bNew=true
						
		if song.save then
			
			aspl.addFB(l("changeshavebeensaved"))	
			
			if aspl.convertNmbr(form.request("iPlaylistID"))<>0 then
			
				if aspl.convertBool(form.request("addTo")) then
					dim playlist : set playlist=new cls_playlist
					playlist.pick(form.request("iPlaylistID"))
					playlist.addSong(song.iId)
					set playlist=nothing
					bNew=false
				end if
			
				form.writejs loadInTarget("dashboard","playlist_manage.asp","&iId=" & form.request("iPlaylistID"))
			
			else
			
				form.writejs loadInTarget("songs","songs.asp","")
			
			end if
			
		else
			bNew=false
		end if
		
	end if
	
end if

dim iId : set iId=form.field("hidden")
iId.add "value",song.iId
iId.add "name","iId"

dim iPlaylistID : set iPlaylistID=form.field("hidden")
iPlaylistID.add "value",form.request("iPlaylistID")
iPlaylistID.add "name","iPlaylistID"

dim addTo : set addTo=form.field("hidden")
addTo.add "value",form.request("addTo")
addTo.add "name","addTo"

dim sTitle : set sTitle=form.field("text")
sTitle.add "required",true
sTitle.add "class","form-control"
sTitle.add "label",l("title")
sTitle.add "name","sTitle"
sTitle.add "value",song.sTitle
sTitle.add "maxlength",255

form.newline

dim sArtist : set sArtist=form.field("text")
sArtist.add "class","form-control"
sArtist.add "label",l("artist")
sArtist.add "name","sArtist"
sArtist.add "value",song.sArtist
sArtist.add "maxlength",255

form.newline

dim sComments : set sComments=form.field("textarea")
sComments.add "class","form-control"
sComments.add "label",l("comments")
sComments.add "name","sComments"
sComments.add "value",song.sComments

form.newline

dim sLyrics : set sLyrics=form.field("textarea")
sLyrics.add "class","form-control"
sLyrics.add "label",l("lyricschords") & " " & googleSearch(song.iId,song.sTitle & " by " & song.sArtist & " lyrics chords") 
sLyrics.add "name","sLyrics"
sLyrics.add "value",song.sLyrics
sLyrics.add "style","height:120px;font-family: Consolas,monospace"

form.newline

dim tuninglist : set tuninglist=new cls_tuning

set sTuning = form.field("select")
sTuning.add "value",song.sTuning
sTuning.add "name","sTuning"
sTuning.add "id","sTuning"
sTuning.add "options",tuninglist.list
sTuning.add "label",l("tuning") & " " & googleSearch(song.iId,song.sTitle & " by " & song.sArtist & " tuning") 

form.newline

dim bpmList : set bpmList=new cls_bpm

set sBPM = form.field("select")
sBPM.add "value",song.sBPM
sBPM.add "name","sBPM"
sBPM.add "id","sBPM"
sBPM.add "options",bpmList.list
sBPM.add "label","BPM " & googleSearch(song.iId,song.sTitle & " by " & song.sArtist & " bpm") 

form.newline

dim submit : set submit=form.field("submit")
submit.add "html",l("Save")
submit.add "class","btn btn-primary"

if bNew then
	dim addAnother : set addAnother=form.field("button")
	addAnother.add "html",l("addanother")
	addAnother.add "class","btn btn-warning"	
	addAnother.add "onclick",loadmodaliId("song_edit.asp","","")
end if

if song.canBeDeleted then
	dim files : set files=form.field("button")
	files.add "html",l("files")
	files.add "class","btn btn-secondary"	
	files.add "onclick",loadmodaliId("song_files.asp",song.iId,"")
end if


if song.canBeDeleted and aspl.convertNmbr(form.request("iPlaylistID"))=0 then

	dim view : set view=form.field("button")
	view.add "html",l("view")
	view.add "class","btn btn-secondary"	
	view.add "onclick","$('#crmModal').modal('hide');" & loadmodalXLiId("song_view.asp",song.iId,"")
	
	dim delete : set delete=form.field("button")
	delete.add "html",l("Delete")
	delete.add "class","btn btn-secondary"	
	delete.add "onclick",loadmodaliId("song_delete.asp",song.iId,"")
	
end if

%>