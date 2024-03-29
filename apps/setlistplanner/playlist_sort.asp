<%

form.initialize=false

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")
aspl(myApp.sPath & "/includes/nav.asp")

dim playlist : set playlist=new cls_playlist : playlist.pick (form.request("iId"))
'security
if aspl.convertNmbr(playlist.iId)=0 then form.write "no playlist selected" : aspl.die

form.writejs modalLabel(l("sort") & " " & playlist.sName)

dim script : script=aspl.loadText(myApp.sPath & "/includes/script.js")
script=replace(script,"[FORMID]",form.id,1,-1,1)
form.writejs script

dim button : button="<div style=""width:100%;text-align:center"">"
button=button & "<button style=""border-color:#AEDFE0;background-color:#AEDFE0;margin-right:5px;margin-bottom:5px"" onclick=""" & loadmodaliId("playlist_randomsort.asp",playlist.iId,"") & """ id="""" class=""btn btn-info"">Random sort</button>"
button=button & "</div>"
form.write button

form.newline

if form.postback then

	'session securitycheck
	if form.sameSession then		
				
		if not aspl.isEmpty(form.request("iDivID")) then
			playlist.setSort form.request("iDivID")			
			form.writejs loadInTarget("dashboard","playlist_manage.asp","&iId=" & playlist.iId)
		end if
		
	end if
	
end if

dim songs : set songs=playlist.songsFast

'hidden field

dim iId : set iId=form.field("hidden")
iId.add "value",playlist.iId
iId.add "name","iId"
iId.add "id","iId"

dim iDivID : set iDivID=form.field("hidden")
iDivID.add "value",""
iDivID.add "name","iDivID"
iDivID.add "id","iDivID"

if songs.count=0 then
	form.write "<div style=""margin:0 auto;width:80%"" class=""alert alert-warning lead"">" & l("thisplaylisthasnosongsyet") & "</div>"
end if

dim drag : drag="<div id=""sortable"" style=""margin:0 auto;width:80%"">"

for each song in songs
	
	drag=drag & "<div id=""dd" & song & """ class=""alert alert-warning"" style=""cursor:move;margin-bottom:4px"">"
		
		drag=drag & "<div class=""row"" style=""width:100%"">"
		
			drag=drag & "<div class=""col"" "
			drag=drag & "style=""max-width:50px;background-size:50px 50px;background-position:center;background-repeat:no-repeat;"
			drag=drag & "background-image:url('" & myApp.sPath & "/includes/drag.png')"" >"
			drag=drag & "</div>"		
			
			drag=drag & "<div class=""col"">"					
				
				drag=drag & "<strong>" & aspl.htmlencode(songs(song).sTitle) & "</strong>"			
			
			drag=drag & "</div>"
		
		drag=drag & "</div>"
	
	drag=drag & "</div>"
	
next

drag=drag & "</div>"

form.write drag

%>