<%
class cls_label

	Public iId, sCode, sValue, iLanguageID, dUpdatedTS
	
	Private Sub Class_Initialize		
		iId=0		
	End Sub	
	
	public function check
	
		check=true
		
		if aspl.isempty(sCode) then
			aspl.addErr(l("codeismandatory"))
			check=false
		end if	

		if aspl.isempty(sValue) then
			aspl.addErr(l("valueismandatory"))
			check=false
		end if

		if aspl.convertNmbr(iLanguageID)=0 then
			aspl.addErr(l("languageismandatory"))
			check=false
		end if		
		
		'code mag niet bestaan
		if iId=0 then
			dim rs : set rs=dbL.execute("select iId from tblLabel where sCode='" & sCode & "' and iLanguageID=" & aspl.convertNmbr(iLanguageID))
			if not rs.eof then aspl.addErr("Code exists already") : check=false			
		end if
	
		
	end function
			
	
	public function pick(id)	

		dim RS
		
		if aspl.isNumber(id) then
		
			dim sql : sql = "select * from tblLabel where iId=" & id
			
			set RS = dbL.execute(sql)
			
			if not rs.eof then
			
				iId					= rs("iId")
				sCode				= rs("sCode")
				sValue				= rs("sValue")
				iLanguageID			= rs("iLanguageID")	
				dUpdatedTS			= rs("dUpdatedTS")				
	
			end if
			
			set RS = nothing
			
		end if
		
	end function
	
	public function save()
	
		if check() then
			save=true
		else
			save=false
			exit function
		end if
		
		dim rs : set rs = dbL.rs		
		
		if iId=0 then			
			rs.Open "select * from tblLabel where 1=2"
			rs.AddNew			
		else
			rs.Open "select * from tblLabel where iId="& iId
		end if
		
		rs("sCode")					= trim(lcase(left(aspl.convertStr(sCode),50)))
		rs("sValue")				= trim(aspl.convertStr(sValue))
		rs("iLanguageID")			= aspl.convertNull(iLanguageID)
		rs("dUpdatedTS")			= now()
						
		rs.Update 
		
		iId = aspl.convertNmbr(rs("iId"))		
		
		rs.close
		
		Set rs = nothing		
		
	end function
	
	
	public function canBeDeleted
	
		canBeDeleted=true
		
		if iId=0 then canBeDeleted=false
	
	end function
	
	
	public function remove 
	
		if not canBeDeleted then remove=false : exit function
		
		dbL.execute("delete from tblLabel where sCode='" & aspl.sqli(sCode) & "'")
		
		remove=true
	
	
	end function
	

end class

%>