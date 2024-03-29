<%

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim song : set song=new cls_song
song.pick(form.request("iId"))
if not song.canBeDeleted then aspl.die

if form.postback then

	'session securitycheck
	if form.sameSession then
	
		if song.remove then			
			
			form.writejs loadInTarget("songs","songs.asp","")
			
			aspl.addFB(l("itemdeleted"))
			
			form.writejs "setTimeout(function(){$('#crmModal').modal('hide')},1600);"
			
			form.build
			
		end if
		
	end if
	
end if

dim iId : set iId=form.field("hidden")
iId.add "value",song.iId
iId.add "name","iId"

aspl.addWarning(l("deletecmd") & " <b>" & server.htmlencode(song.sTitle) & "</b>?")

dim submit : set submit=form.field("submit")
submit.add "html",l("Delete")
submit.add "class","btn btn-danger"

dim cancel : set cancel=form.field("button")
cancel.add "html",l("cancel")
cancel.add "class","btn btn-secondary"
cancel.add "onclick",loadmodaliId("song_edit.asp",song.iId,"")

%>