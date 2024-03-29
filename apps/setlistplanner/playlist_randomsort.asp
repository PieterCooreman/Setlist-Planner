<%
form.initialize=false

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim playlist : set playlist=new cls_playlist
playlist.pick(form.request("iId"))
if not playlist.canBeDeleted then aspl.die

form.writejs modalLabel("Random sort " & playlist.sName)

if form.postback then

	'session securitycheck
	if form.sameSession then
		playlist.randomize()
		form.writejs "$('#crmModal').modal('hide');" & loadInTarget("dashboard","playlist_manage.asp","&iId=" & playlist.iId)
	end if
		
end if

aspl.addWarning(l("randomizetheorderofsongs"))

dim iId : set iId=form.field("hidden")
iId.add "value",playlist.iId
iId.add "name","iId"

dim submit : set submit=form.field("submit")
submit.add "html","Randomize"
submit.add "class","btn btn-danger"

dim cancel : set cancel=form.field("button")
cancel.add "html",l("cancel")
cancel.add "class","btn btn-secondary"
cancel.add "databsdismiss","modal"

%>