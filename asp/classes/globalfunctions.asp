<%

function convertToSearchField(value)

	if aspl.convertNmbr(value)<>0 then 
		convertToSearchField=value
		exit function
	end if
	
	if aspl.isempty(value) then 
		convertToSearchField=""
		exit function
	end if

	convertToSearchField=lcase(aspl.convertStr(value))
	
	convertToSearchField=replace(convertToSearchField,vbtab,"",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"`","",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"‘","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"’","",1,-1,1)
	convertToSearchField=replace(convertToSearchField,",","",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"æ","aa",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"ae","aa",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"ñ","n",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ô","o",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ø","o",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ö","o",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ó","o",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ò","o",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"õ","o",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"é","e",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"è","e",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ë","e",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ê","e",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ç","c",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"á","a",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"å","a",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"à","a",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"â","a",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ä","a",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ù","u",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"û","u",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ü","u",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"î","i",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"í","i",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ì","i",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ï","i",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ÿ","y",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"'","",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"-","",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"/","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"\","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,".","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,":","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,";","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"&","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"(","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,")","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField," ","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"?","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"!","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"+","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"*","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"""","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,">","",1,-1,1)	
	convertToSearchField=replace(convertToSearchField,"<","",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"=","",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"#","",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"€","",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"$","",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ij","y",1,-1,1)
	convertToSearchField=replace(convertToSearchField,"ey","y",1,-1,1)
	
	convertToSearchField=left(convertToSearchField,255)

end function


function backupDB	
	
	backupDB=false
	
	db.close	
	dbl.close	
	dba.close	
	
	set db=nothing
	set dbl=nothing
	set dba=nothing
	
	if err.number<>0 then exit function
	
	aspl.fso.copyfile server.mappath(dbpath),server.mappath("db/backup/backup_" & convertCalcDateTimeNoSpecialChars(now) & "_" & aspl.randomizer.createguid(2) & ".mdb.resx")
	aspl.fso.copyfile server.mappath(dblpath),server.mappath("db/backup/backup_languages_" & convertCalcDateTimeNoSpecialChars(now) & "_" & aspl.randomizer.createguid(2) & ".mdb.resx")
	aspl.fso.copyfile server.mappath(dbapath),server.mappath("db/backup/backup_myapp_" & convertCalcDateTimeNoSpecialChars(now) & "_" & aspl.randomizer.createguid(2) & ".mdb.resx")
		
	if err.number=0 then 
	
		backupDB=true		
		
		set db=aspl.plugin("database")
		db.dbms=1 'Access
		db.path=dbpath
		db.getconn.close
		db.getconn.open
		
		set dbl=aspl.plugin("database")
		dbl.dbms=1 'Access
		dbl.path=dblpath
		dbl.getconn.close
		dbl.getconn.open
		
		set dba=aspl.plugin("database")
		dba.dbms=1 'Access
		dba.path=dbapath
		dba.getconn.close
		dba.getconn.open
		
	end if	
	
	on error goto 0

end function


function compressDB
	
	err.clear

	on error resume next
	
	compressDB=false
	
	db.close
	dbl.close
	dba.close
		
	set db=nothing
	set dbl=nothing
	set dba=nothing

	dim jro : set jro = Server.CreateObject("JRO.JetEngine")
	jro.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.mappath(dbpath), "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.mappath(dbpath & "_compress.mdb")
	jro.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.mappath(dblpath), "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.mappath(dblpath & "_compress.mdb")
	jro.CompactDatabase "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.mappath(dbapath), "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server.mappath(dbapath & "_compress.mdb")
	set jro=nothing
	
	if err.number<>0 then exit function
	
	aspl.fso.deletefile server.mappath(dbpath)
	aspl.fso.deletefile server.mappath(dblpath)
	aspl.fso.deletefile server.mappath(dbapath)
	
	aspl.fso.copyfile server.mappath(dbpath & "_compress.mdb"),server.mappath("db/backup.mdb")
	aspl.fso.copyfile server.mappath(dblpath & "_compress.mdb"),server.mappath("db/backupl.mdb")
	aspl.fso.copyfile server.mappath(dbapath & "_compress.mdb"),server.mappath("db/backupa.mdb")
	
	aspl.fso.moveFile server.mappath(dbpath & "_compress.mdb"),server.mappath(dbpath)
	aspl.fso.moveFile server.mappath(dblpath & "_compress.mdb"),server.mappath(dblpath)
	aspl.fso.moveFile server.mappath(dbapath & "_compress.mdb"),server.mappath(dbapath)
	
	aspl.fso.deletefile server.mappath("db/backup.mdb")	
	aspl.fso.deletefile server.mappath("db/backupl.mdb")	
	aspl.fso.deletefile server.mappath("db/backupa.mdb")	
	
	if err.number=0 then 
	
		compressDB=true
		
		set db=aspl.plugin("database")
		db.dbms=1 'Access
		db.path=dbpath
		db.getconn.open
		
		set dbl=aspl.plugin("database")
		dbl.dbms=1 'Access
		dbl.path=dblpath
		dbl.getconn.open
		
		set dba=aspl.plugin("database")
		dba.dbms=1 'Access
		dba.path=dbapath
		dba.getconn.open
	
	end if
	
	on error goto 0
	
end function

function compressHTML(value)

	compressHTML=value
	
	while instr(compressHTML,vbtab)<>0
		compressHTML=replace(compressHTML,vbtab," ",1,-1,1)
	wend
	
	while instr(compressHTML,vbcrlf)<>0
		compressHTML=replace(compressHTML,vbcrlf," ",1,-1,1)
	wend
	
	while instr(compressHTML,vbCr)<>0
		compressHTML=replace(compressHTML,vbCr," ",1,-1,1)
	wend
	
	while instr(compressHTML,vbLf)<>0
		compressHTML=replace(compressHTML,vbLf," ",1,-1,1)
	wend
	
	while instr(compressHTML,"  ")<>0
		compressHTML=replace(compressHTML,"  "," ",1,-1,1)
	wend

end function


Function GetSQLTypeName(Field)
	Select Case aspl.convertNmbr(field.type)
	Case 3	if field.Properties("Autoincrement").Value then GetSQLTypeName = "COUNTER NOT NULL" else GetSQLTypeName = "LONG NULL"
	Case 7	GetSQLTypeName = "DATETIME NULL"
	Case 11	GetSQLTypeName = "BIT NULL"
	Case 6	GetSQLTypeName = "MONEY"
	Case 128	GetSQLTypeName = "BINARY"
	Case 17	GetSQLTypeName = "TINYINT"
	Case 131	GetSQLTypeName = "DECIMAL"
	Case 5	GetSQLTypeName = "FLOAT"
	Case 2	GetSQLTypeName = "INTEGER NULL"
	Case 4	GetSQLTypeName = "REAL"
	Case 72	GetSQLTypeName = "UNIQUEIDENTIFIER"
	Case 202	GetSQLTypeName = "TEXT(255)"
	Case 203	GetSQLTypeName = "MEMO NULL"
	End Select
End Function

%>