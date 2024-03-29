<%

aspl(myApp.sPath & "/includes/begin.asp")

form.id="contact_doc_new_aspForm"
form.onSubmit=""

'create an instance of the afdeling class
dim song : set song = new cls_song
song.pick (form.request("iId")) : if song.iId=0 then aspl.die

form.writeJS modalLabel(l("files") & " " & song.sTitle)

'iSongID
dim iSongID : set iSongID = form.field("hidden")
iSongID.add "value",song.iId
iSongID.add "name","iSongID"
iSongID.add "id","iSongID"

dim loadS : loadS=aspL.loadText(myApp.sPath & "/song_upload.txt")
loadS=replace(loadS,"[songID]",song.iId,1,-1,1)
loadS=replace(loadS,"[aspLiteAjaxHandler]","?asplEvent=dashboard&customAppID=" & myApp.iId & "&custumAppPath=" & server.urlEncode("song_uploadfile.asp") & "&iId="& song.iId,1,-1,1)
loadS=replace(loadS,"[REDIRECT]",loadmodaliId("song_files.asp",song.iId,""),1,-1,1)
loadS=replace(loadS,"[uploadstartdonotclosethistab]",l("uploadstartdonotclosethistab"),1,-1,1)

form.write loadS
%>