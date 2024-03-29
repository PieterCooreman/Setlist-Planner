<%

form.initialize=false

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim playlist : set playlist=new cls_playlist
playlist.pick(form.request("iId"))

form.writejs modalLabel(l("addeditplaylist"))

if playlist.iId=0 and currentPayment.iId=0 then
	form.writejs loadmodalonload("payment.asp","")
	form.build
end if


if form.postback then

	'session securitycheck
	if form.sameSession then

		if aspl.convertStr(form.request("doCopy"))="1" then
		
			if playlist.copy then				
				
				form.writejs loadInTarget("modalform","playlist_edit.asp","&copy=1&iId=" & playlist.iId)
				
				form.writejs loadInTarget("playlists","playlists.asp","")						
				
				
			end if
		
		else	
		
			playlist.sName			=	form.request("sName")
			playlist.sDescription	=	form.request("sDescription")
							
			if playlist.save then
				
				aspl.addFB(l("changeshavebeensaved"))				
				
				if aspl.convertNmbr(form.request("iPlayListID"))<>0 then				
					form.writejs loadInTarget("dashboard","playlist_manage.asp","&iId=" & playlist.iId)
				else
					form.writejs loadInTarget("playlists","playlists.asp","")
				end if
				
			end if
		
		end if
		
	end if
	
end if

if form.request("copy")="1" then
	aspl.addFB (l("itemhasbeencopied"))
end if

dim iId : set iId=form.field("hidden")
iId.add "value",playlist.iId
iId.add "name","iId"

dim iPlayListID : set iPlayListID=form.field("hidden")
iPlayListID.add "value",aspl.convertNmbr(form.request("iPlayListID"))
iPlayListID.add "name","iPlayListID"

dim sName : set sName=form.field("text")
sName.add "required",true
sName.add "class","form-control"
sName.add "label",l("name")
sName.add "name","sName"
sName.add "value",playlist.sName
sName.add "maxlength",255

form.newline

dim sDescription : set sDescription=form.field("textarea")
sDescription.add "class","form-control"
sDescription.add "label",l("description")
sDescription.add "name","sDescription"
sDescription.add "value",playlist.sDescription

form.newline

dim submit : set submit=form.field("submit")
submit.add "html",l("Save")
submit.add "class","btn btn-primary"

if playlist.canBeDeleted and aspl.convertNmbr(form.request("iPlayListID"))=0 then

	dim doCopy : set doCopy=form.field("hidden")
	doCopy.add "value","0"
	doCopy.add "name","doCopy"
	doCopy.add "id","doCopy"
	
	dim copy : set copy=form.field("button")
	copy.add "html",l("copy")
	copy.add "class","btn btn-warning"	
	copy.add "onclick","$('#doCopy').val('1');$('#" & form.id & "').submit();return false;"
	
	dim manage : set manage=form.field("button")
	manage.add "html",l("manage")
	manage.add "class","btn btn-secondary"	
	manage.add "onclick","$('#crmModal').modal('hide');" & load("playlist_manage.asp","&iId=" & playlist.iId)

	dim delete : set delete=form.field("button")
	delete.add "html",l("Delete")
	delete.add "class","btn btn-secondary"	
	delete.add "onclick",loadmodaliId("playlist_delete.asp",playlist.iId,"")
	
end if

%>