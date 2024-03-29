<%

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim playlist : set playlist=new cls_playlist
playlist.pick(form.request("iId"))
if not playlist.canBeDeleted then aspl.die

form.writejs modalLabel("QR-code " & playlist.sName)

form.write "<div><img alt=""QR"" src=""" & playlist.qr & """ /></div>"

form.newline

dim iId : set iId=form.field("hidden")
iId.add "value",playlist.iId
iId.add "name","iId"

dim submit : set submit=form.field("button")
submit.add "html","Download QR-code"
submit.add "class","btn btn-success"
submit.add "onclick","location.assign('" & directlink("playlist_qrdownload.asp","&iId=" & playlist.iId)& "');"


dim cancel : set cancel=form.field("button")
cancel.add "html",l("close")
cancel.add "class","btn btn-secondary"
cancel.add "databsdismiss","modal"
%>