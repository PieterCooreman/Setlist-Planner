<%

form.initialize=false

aspl(myApp.sPath & "/includes/begin.asp")

dim playlist : set playlist=new cls_playlist : playlist.pick (form.request("iId"))
'security
if aspl.convertNmbr(playlist.iId)=0 then form.write "no playlist selected" : aspl.die

if form.postback then

	'session securitycheck
	if form.sameSession then		

		if aspl.convertNmbr(form.request("doMailb"))=1 then
			'no longer used
			playlist.mail()
			aspl.addFB(l("mailsent"))
			form.writejs "window.scrollTo(0, 0);"
		end if		
		
	end if

end if

dim doMail : set doMail=form.field("hidden")
doMail.add "value","0"
doMail.add "name","doMailb"
doMail.add "id","doMailb"

dim iId : set iId=form.field("hidden")
iId.add "value",playlist.iId
iId.add "name","iId"
iId.add "id","iId"

if currentPayment.iId<>0 then

	dim buttons
	if not aspl.isEmpty(system.sChromeASP) then
		buttons=buttons & "<a style=""margin-right:5px;margin-bottom:5px"" href=""" & directlink("playlist_pdf.asp","&iId=" &playlist.iId) & """ id="""" class=""btn btn-danger"">PDF</a>"
	end if
	buttons=buttons & "<a onclick=""" & loadmodaliId("playlist_qr.asp",playlist.iId,"") & """ style=""margin-right:5px;margin-bottom:5px"" href=""#"" id="""" class=""btn btn-secondary"">QR</a>"
	'buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" type=""button"" onclick=""location.assign('" & directlink("playlist_download.asp","&iId=" & playlist.iId)& "');"" id="""" class=""btn btn-success"">" & l("download") & "</button>"
	buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" type=""button"" onclick=""window.prompt('Copy to clipboard: Ctrl+C, Enter', '" & playlist.getToken & "');"" id="""" class=""btn btn-info"">" & l("share") & "</button>"
	'buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" type=""button"" onclick=""$('#doMailb').val('1');$('#" & form.id & "').submit();return false;"" id="""" class=""btn btn-warning"">" & l("tomail") & "</button>"

	form.write buttons
	form.newline
	
end if

dim table : table=aspl.loadText(myApp.sPath & "/includes/export.txt")

'vertalingen
table=replace(table,"[TITLE]",l("title"),1,-1,1)
table=replace(table,"[REMARKS]",l("comments"),1,-1,1)
table=replace(table,"[TUNING]",left(l("tuning"),1),1,-1,1)
table=replace(table,"[ARTIST]",l("artist"),1,-1,1)

select case user.iLanguageId
	
	case 5 'NL
		table=replace(table,"[LANGUAGE]","language: { url: 'html/dataTables.dutch.json',},",1,-1,1)

end select
	
table=replace(table,"[LANGUAGE]","",1,-1,1)

dim counter, records, song, songs : set songs=playlist.songs : records="" : counter=0

for each song in songs

	counter=counter+1

	records=records & "<tr>"
	records=records & "<td>" & counter &"</td>"
	records=records & "<td>" & aspl.htmlEncode(songs(song).sTitle) &"</td>"	
	records=records & "<td>" & aspl.htmlEncode(songs(song).sArtist) &"</td>"	
	records=records & "<td>" & aspl.htmlEncode(songs(song).sComments) &"</td>"
	records=records & "<td>" & aspl.htmlEncode(songs(song).sTuning) &"</td>"
	records=records & "<td>" & aspl.htmlEncode(songs(song).sBPM) &"</td>"
	records=records & "</tr>"	

next

table=replace(table,"[RECORDS]",records,1,-1,1)
table=replace(table,"[PLAYLIST]",aspl.htmlencjs(playlist.sName),1,-1,1)

form.write table

form.writejs modalLabel("Export " & lcase(l("playlist")) & " " & playlist.sName & " (" & songs.count & " " & lcase(l("songs")) & ")")

%>