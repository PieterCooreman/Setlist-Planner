<%

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim song, songFile : set songFile = new cls_songFile
songFile.pick(form.request("iId"))

set song=songFile.song : if song.iId=0 then aspl.die

aspL.dumpBinary myApp.sPath & "/uploads/" & songFile.iId & songFile.sToken & ".resx",songFile.sFilename & "." & songFile.sExt

%>