<%
'load all includes

form.initialize=false

aspl(myApp.sPath & "/includes/begin.asp")

dim song : set song=new cls_song
song.pick(form.request("iId")) : if song.iId=0 then aspl.die

form.writejs modalLabelXL(song.sTitle & " (" & song.sArtist & ")")

dim playlist : set playlist=new cls_playlist : playlist.pick(form.request("iPlaylistID"))

form.write "<a name=""top""></a>"

'quickjump
dim quickjump : set quickjump=form.field("select")
quickjump.add "options",songDict
quickjump.add "emptyfirst"," QuickJump to..."
quickjump.add "onchange","if(this.value!=''){" & loadmodalXLiId("song_view.asp","' + this.value + '","&qj=1") & "};"
quickjump.add "class","form-control"
quickjump.add "name","iQJiId"
quickjump.add "style","width:50%"
if not aspl.isEmpty(form.request("qj")) then
	quickjump.add "value",song.iId
end if

form.newline

dim edit : set edit=form.field("button")
edit.add "html",l("edit")
edit.add "class","btn btn-primary"
edit.add "onclick","$('#crmModalXL').modal('hide');" & loadmodaliId("song_edit.asp",song.iId,"&iPlaylistID="& playlist.iId)

if playlist.iId<>0 then

	dim remove : set remove=form.field("button")
	remove.add "html",l("delete")
	remove.add "class","btn btn-danger"
	remove.add "onclick","$('#crmModalXL').modal('hide');" & loadInTarget("dashboard","playlist_manage.asp","&iId=" & playlist.iId & "&iDeletedID=" & form.request("iLinkID"))	
	
	if song.nextsong(playlist.iId).iId<>0 then
	
		dim nextsong : set nextsong=form.field("button")
		nextsong.add "html",l("next")
		nextsong.add "class","btn btn-warning"
		nextsong.add "onclick",loadmodalXLiId("song_view.asp",song.nextsong(playlist.iId).iId,"&iPlaylistID="& playlist.iId)
		
	end if 
	
end if

if not aspl.isEmpty(song.sBPM) and currentpayment.iId<>0 then
	
	dim metronome : set metronome=form.field("button")
	metronome.add "html",l("metronome")
	metronome.add "class","btn btn-info"
	if form.request("bMetronome")="1" then
		metronome.add "onclick",loadmodalXLiId("song_view.asp",song.iId,"&iPlaylistID="& playlist.iId)
	else
		metronome.add "onclick",loadmodalXLiId("song_view.asp",song.iId,"&bMetronome=1&iPlaylistID="& playlist.iId)
	end if
	
	dim beatbox : set beatbox=form.field("button")
	beatbox.add "html","Beatbox"
	beatbox.add "class","btn"
	beatbox.add "style","color:#FFF;background-color:#FF007F;margin-bottom:7px;margin-right:7px;"
	if form.request("bBeatbox")="1" then
		beatbox.add "onclick",loadmodalXLiId("song_view.asp",song.iId,"&iPlaylistID="& playlist.iId)
	else
		beatbox.add "onclick",loadmodalXLiId("song_view.asp",song.iId,"&bBeatbox=1&iPlaylistID="& playlist.iId)
	end if
	
end if

if not aspl.isEmpty(song.sLyrics) then 
	dim chords : set chords=form.field("button")
	chords.add "html",l("chords")
	chords.add "class","btn btn-success"
	chords.add "onclick","location.assign('#chords');"
end if

dim close : set close=form.field("button")
close.add "html",l("close")
close.add "class","btn btn-secondary"
close.add "databsdismiss","modal"

form.newline

dim button, songfiles, songfile : set songfiles=song.files

if currentpayment.iId<>0 then

	if songfiles.count>0 then form.newline

	dim images
	 
	for each songfile in songfiles
		
		set button=form.field("button")
		button.add "html",songfiles(songfile).sFilename & "." & songfiles(songfile).sExt
		button.add "class","btn btn-warning"
		
		select case lcase(songfiles(songfile).sExt)

			case "jpg","jpeg","png","gif","bmp"		
			
				button("html")=button("html") & " (" & l("clicktoview") & ")"
				
				form.writeJS "var state" & songfile &"=0;"	
		
				button.add "onclick","if(state" & songfile &"==0) {$('#songID" & songfile & "').removeClass('d-none');state" & songfile &"=1;$('#songID" & songfile & "').attr('src','" & songfiles(songfile).imageSrc(1600) & "');} else {$('#songID" & songfile & "').addClass('d-none');state" & songfile &"=0;};"
				'form.write 
				images=images & "<img id=""songID" & songfile & """ class=""d-none"" style=""width:100%"" src="""" />"
			
			case else
			
				button.add "onclick",songfiles(songfile).downloadLink
			
		end select
		
	next

	if images<>"" then form.write images

end if

dim iId : set iId=form.field("hidden")
iId.add "value",song.iId
iId.add "name","iId"
iId.add "id","iId"

dim iPlaylistID : set iPlaylistID=form.field("hidden")
iPlaylistID.add "value",form.request("iPlaylistID")
iPlaylistID.add "name","iPlaylistID"
iPlaylistID.add "id","iPlaylistID"

dim iLinkID : set iLinkID=form.field("hidden")
iLinkID.add "value",form.request("iLinkID")
iLinkID.add "name","iLinkID"
iLinkID.add "id","iLinkID"

if form.request("bMetronome")="1" then
	form.newline
	form.write song.metronome
end if

if form.request("bBeatbox")="1" then
	form.newline
	form.write song.beatbox
end if

form.newline

dim extra

if not aspl.isEmpty(song.sTuning) then 
	extra=extra & l("tuning") & ": <strong>" & aspl.htmlencode(song.sTuning) & "</strong>&nbsp;"
end if

if not aspl.isEmpty(song.sBPM) then 
	extra=extra & "BPM: <strong>" & aspl.htmlencode(song.sBPM) & "</strong>&nbsp;"
end if

if not aspl.isEmpty(extra) then
	form.write "<div class=""alert alert-info"">" & extra & "</div>"
end if

if not aspl.isEmpty(song.sComments) then 
	form.write "<div class=""alert alert-danger"">" & br(aspl.htmlencode(song.sComments)) & "</div>"
end if

'drawlyrics?
dim drawlyrics : drawlyrics=song.drawlyrics

if not aspl.isEmpty(drawlyrics) then 
	form.write "<div class=""alert alert-warning"">" & br(aspl.htmlencode(drawlyrics)) & "</div>"
end if

if not aspl.isEmpty(song.sLyrics) then 

	form.write "<a name=""chords""></a>"

	dim top : set top=form.field("button")
	top.add "html","Top"
	top.add "class","btn btn-warning mt-5"
	top.add "onclick","location.assign('#top');"

	form.write "<div class=""alert alert-light""><pre style=""overflow:scroll"">" & br(aspl.htmlencode(song.sLyrics)) & "</pre></div>"
end if

%>