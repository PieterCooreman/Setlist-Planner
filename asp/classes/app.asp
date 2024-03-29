<%
class cls_app

	Public iId, sName, bActive, bPublic, bDeleted, sPath, sDefault, sDescription, bShowErrors, sPublicPath
	
	
	Private Sub Class_Initialize		
		iId=0
		bActive=true
		bPublic=false
		bDeleted=false
		bShowErrors=false
		sDefault="default.resx"
	End Sub	
	
	
	public function check
	
		check=true
		
		if aspl.isempty(sName) then
			aspl.addErr(l("nameismandatory"))
			check=false
		end if
		
		if aspl.isempty(sPath) then
			aspl.addErr(l("pathismandatory"))
			check=false
		end if
		
		if aspl.isempty(sDefault) then
			aspl.addErr(l("defaultscriptismandatory"))
			check=false
		end if		
		
	end function
			
	
	public function pick(id)	

		dim RS
		
		if aspl.isNumber(id) then
		
			dim sql : sql = "select * from tblApp where bDeleted=false and iId=" & id
			
			set RS = db.execute(sql)
			
			if not rs.eof then
			
				iId				= rs("iId")
				sName			= rs("sName")
				bActive			= rs("bActive")
				bPublic			= rs("bPublic")
				bDeleted		= rs("bDeleted")
				sPath			= rs("sPath")
				sDefault		= rs("sDefault")
				sDescription	= rs("sDescription")
				sPublicPath		= rs("sPublicPath")
				bShowErrors		= aspl.convertBool(rs("bShowErrors"))
	
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

		while left(sDefault,1)="/"
			sDefault=right(sDefault,len(sDefault)-1)
		wend
		
		while right(sPath,1)="/"
			sPath=left(sPath,len(sPath)-1)
		wend
				
		dim rs : set rs = db.rs		
		
		if iId=0 then			
			rs.Open "select * from tblApp where 1=2"
			rs.AddNew			
		else
			rs.Open "select * from tblApp where bDeleted=false and iId="& iId
		end if
		
		rs("sName")					= left(aspl.convertStr(sName),50)		
		rs("bPublic")				= aspl.convertBool(bPublic)
		rs("bActive")				= aspl.convertBool(bActive)
		rs("bDeleted")				= aspl.convertBool(bDeleted)
		rs("bShowErrors")			= aspl.convertBool(bShowErrors)
		rs("sPath")					= left(aspl.convertStr(sPath),50)	
		rs("sDefault")				= left(aspl.convertStr(sDefault),50)
		rs("sPublicPath")			= left(aspl.convertStr(sPublicPath),50)
		rs("sDescription")			= aspl.convertStr(sDescription)
		
		rs.Update 
		
		iId = aspl.convertNmbr(rs("iId"))
				
		rs.close
		
		Set rs = nothing		
		
	end function
	
	public function remove
	
		remove=false
		
		if iId<>0 then
			dim rs					
			set rs=db.execute("update tblApp set bDeleted=true where iId=" & aspl.convertNmbr(iId))
			set rs=nothing
			remove=true
		end if
		
	end function
	
	public function canBeDeleted
	
		canBeDeleted=true
		
		if iId=0 then canBeDeleted=false
	
	end function	

	public property get bHasAccess
	
		bHasAccess=true
		
		if not bPublic and not user.bAdmin then bHasAccess=false
		if not bActive then bHasAccess=false
	
	end property

end class


%>