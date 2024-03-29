<%

aspl(myApp.sPath & "/includes/begin.asp")

on error resume next

dim uploadsDirVar, filesize, filename, sExt

'default path: uploads
uploadsDirVar = server.MapPath (myApp.sPath & "/uploads") 

dim upload  : set upload = aspL.plugin("uploader")

upload.Save uploadsDirVar

dim fileKey, sFile

for each fileKey in Upload.UploadedFiles.keys
	
	filesize	= Upload.UploadedFiles(fileKey).Length
	filename	= Upload.UploadedFiles(fileKey).filename	
	sExt		= left(aspl.getFileType(filename),15)
	
	filename=left(filename,len(filename)-(len(sExt)+1))
		
	set sFile=new cls_songFile
	sFile.sFilename	= left(filename,50)	
	sFile.sExt		= sExt
	sFile.iFilesize	= filesize
	sFile.iSongID	= aspl.getRequest("iId")
	sFile.sToken	= aspl.randomizer.createguid(10)		
	sFile.save
	
	'rename to resx
	Upload.UploadedFiles(fileKey).rename(server.mappath(myApp.sPath & "/uploads/") & "\" & sFile.iID & sFile.sToken & ".resx")	 ' doc.iId
	
	set sFile=nothing
	
next

set upload=nothing

on error goto 0
%>