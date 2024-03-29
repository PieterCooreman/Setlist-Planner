<%
aspl(myApp.sPath & "/includes/begin.asp")
if not isNewUser then aspl.die

form.writejs modalLabel(l("welcome") & "!")

aspl.addInfo(l("introsetlist"))

dim setlist : set setlist=new cls_playlist
setlist.sDescription=l("setlistdescription")
setlist.sName=aspl.pcase(user.sFirstname) & " live on stage!"
setlist.save

dim song
set song=new cls_song
song.sTitle="Country Roads"
song.sArtist="John Denver"
song.sBPM="164"
song.sTuning="A"
song.sComments="Capo II"
song.sLyrics=aspl.loadText(myapp.sPath & "/includes/song1.txt")
song.save
setlist.addSong(song.iId)

set song=new cls_song
song.sTitle="Sweet Home Alabama"
song.sArtist="Lynyrd Skynyrd"
song.sBPM="98"
song.sTuning="G"
song.sLyrics=aspl.loadText(myapp.sPath & "/includes/song2.txt")
song.save
setlist.addSong(song.iId)

set song=new cls_song
song.sTitle="Baby Can I Hold You"
song.sArtist="Tracy Chapman"
song.sBPM="74"
song.sTuning="D"
song.sLyrics=aspl.loadText(myapp.sPath & "/includes/song3.txt")
song.save
setlist.addSong(song.iId)

form.writejs loadInTarget("dashboard","playlist_manage.asp","&iId=" & setlist.iId)

set setlist=nothing



%>