<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim addnew : set addNew=form.field("button")
addnew.add "class","btn btn-primary"
addnew.add "html",l("addnew")
addnew.add "onclick",loadmodal("playlist_edit.asp","")

dim table : table="<table id=""playliststable"" class=""table table-striped"">"
table=table & "<thead>"
table=table & "<tr>"
table=table & "<th>"&l("name")&"</th>"
table=table & "<th>N°</th>"
table=table & "</tr>"
table=table & "</thead>"
table=table & "<tbody>"

dim playlist, playlists : set playlists=new cls_playlists

set playlists=playlists.list

for each playlist in playlists
	table=table & "<tr>"
		table=table & "<td><a class=""link"" href=""#"" onclick=""" & load("playlist_manage.asp","&iId=" & playlist) & """>" & aspl.htmlencode(playlists(playlist).sName) & "</a></td>"
		table=table & "<td>" & playlists(playlist).songCount & "</td>"		
	table=table & "</tr>"
next

table=table & "</tbody>"
table=table & "</table>"

dim dt : dt=datatable("playliststable")
dt=replace(dt," 10, 25,","",1,-1,1) 

form.write table & dt
%>