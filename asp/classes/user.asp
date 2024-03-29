<%

class cls_user

	public iId, sFirstname, sLastname, sEmail, sPw, sToken, iLanguageID, p_language
	public bDeleted, bAdmin, bConfirmed
	public dCreatedTS, dUpdatedTS, dLoginTS, dDeletedTS, bSendMail

	private sub class_initialize
		iId=0
		bSendMail=true
		bConfirmed=false
		bAdmin=false
		bDeleted=false		
		iLanguageID=defaultLanguage.iId
		if aspl.convertNmbr(session("iLanguageID"))<>0 then
			iLanguageID=aspl.convertNmbr(session("iLanguageID"))
		end if
		set p_language=nothing
		sToken=sha256(lcase(aspl.randomizer.CreateGUID(10)))
	end sub
	
	public property get sFullname
		sFullname=sFirstname & " " & sLastname
	end property
	
	public function check
	
		check=true
		
		if aspl.isempty(sEmail) then
			aspl.addErr(l("emailismandatory"))
			check=false
		end if	
		
		if not aspl.CheckEmailSyntax(sEmail) then
			aspl.addErr(l("wrongemailaddress"))
			check=false
		end if
		
		if aspl.isempty(sFirstname) then
			aspl.addErr(l("firstnameismandatory"))
			check=false
		end if
		
		if aspl.isempty(sLastname) then
			aspl.addErr(l("lastnameismandatory"))
			check=false
		end if
		
		if instr(sLastname,"<")<>0 or instr(sLastname,">")<>0 or instr(sFirstname,">")<>0 or instr(sLastname,">")<>0 then
			aspl.addErr(l("donotusespecialcharactersinyourname"))
			check=false
		end if
		
		'check for double emails!		
		if check then		
			
			dim sql : sql = "select * from tblUser where bDeleted=false and lcase(sEmail)='" & lcase(sEmail) & "' and iId<>" & iId			
			
			dim rs : set rs = db.execute(sql)
			
			if not rs.eof then			
				aspl.addErr(l("emailaddressisknownalready"))
				check=false
			end if
			
			set rs=nothing
		
		end if
		
	end function
	
	
	public function userToBeConfirmed(token, id)
	
		'security enhancements
		id		=	aspl.sqli(id)
		token	=	aspl.sqli(token)
	
		dim sql : sql = "select iId from tblUser "
		sql=sql & " where bDeleted=false "
		sql=sql & " and bConfirmed=false "
		sql=sql & " and iId=" & id & " and sToken='" & token & "'"
			
		dim rs : set rs = db.execute(sql)
		
		if not rs.eof then
			userToBeConfirmed=true
		else
			userToBeConfirmed=false
		end if
		
		set rs=nothing		
	
	end function
	
	public function userResetPW(token, id)
	
		'security enhancements
		id		=	aspl.sqli(id)
		token	=	aspl.sqli(token)
	
		dim sql : sql = "select iId from tblUser "
		sql=sql & " where bDeleted=false "		
		sql=sql & " and iId=" & id & " and sToken='" & token & "'"
			
		dim rs : set rs = db.execute(sql)
		
		if not rs.eof then
			userResetPW=true
		else
			userResetPW=false
		end if
		
		set rs=nothing		
	
	end function
	
	
	public function confirm
	
		bConfirmed=true : save()
		
		session("userToBeConfirmed")=0
	
	end function
	
	
	public function pick(id)	

		dim RS
		
		if aspl.isNumber(id) then
		
			dim sql : sql = "select * from tblUser where bDeleted=false and iId=" & id
			
			set RS = db.execute(sql)
			
			if not rs.eof then
			
				iId					= rs("iId")
				sFirstname			= rs("sFirstname")
				sLastname			= rs("sLastname")
				sEmail				= rs("sEmail")
				sPw					= rs("sPw")				
				bAdmin				= aspl.convertBool(rs("bAdmin"))
				bConfirmed			= aspl.convertBool(rs("bConfirmed"))
				sToken				= rs("sToken")
				iLanguageID			= rs("iLanguageID")				
				dCreatedTS			= rs("dCreatedTS")
				dUpdatedTS			= rs("dUpdatedTS")
				dCreatedTS			= rs("dCreatedTS")
				dLoginTS			= rs("dLoginTS")
	
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
		
		dim rs : set rs = db.rs
		dim bNewUser : bNewUser=false
		
		if iId=0 then
			bNewUser=true
			rs.Open "select * from tblUser where 1=2"
			rs.AddNew
			rs("dCreatedTS")	=	now()
			rs("iCreatedBy")	=	user.iId
		else
			rs.Open "select * from tblUser where tblUser.bDeleted=false and iId="& iId
		end if
		
		rs("sFirstname")			= left(aspl.convertStr(sFirstname),100)
		rs("sLastname")				= left(aspl.convertStr(sLastname),100)
		rs("sEmail")				= left(aspl.convertStr(lcase(sEmail)),100)
		rs("sPw")					= sPw		
		rs("sToken")				= left(aspl.convertStr(sToken),10)	
		rs("iLanguageID")			= aspl.convertNull(iLanguageID)		
		rs("bAdmin")				= aspl.convertBool(bAdmin)
		rs("bConfirmed")			= aspl.convertBool(bConfirmed)		
		rs("dUpdatedTS")			= now()
		rs("iUpdatedBy")			= aspl.convertNull(user.iId)
		
		rs.Update 
		
		iId = aspl.convertNmbr(rs("iId"))
		
		'zend een bevestigingsmail naar nieuwe leden
		if bNewUser and bSendMail then
		
			overruleLID=iLanguageID 'needed for the language function
		
			dim subject,cdomessage : set cdomessage=aspL.plugin("cdomessage")
			cdomessage.receiveremail=rs("sEmail")
			
			subject=l("subjectwelcomemail") 
			subject=replace(subject,"[systemname]",system.sName,1,-1,1)
			cdomessage.subject=subject			
			
			dim body : body=l("welcomemail")
			body=replace(body,"[systemname]",system.sName,1,-1,1)			
			body=replace(body,"[clicklink]",getSiteUrl & "/?asplEvent=confirmemail&sToken=" & rs("sToken") & "&iId=" & iId,1,-1,1)	
			cdomessage.body=body
			cdomessage.send
			set cdomessage=nothing
			
			overruleLID=0
		
		end if		
		
		rs.close
		
		Set rs = nothing		
		
	end function
	
	public function remove
	
		remove=false
		
		if iId<>0 then
			dim rs			
			set rs=db.execute("update tblUser set bDeleted=true, dDeletedTS=now where iId=" & aspl.convertNmbr(iId))
			set rs=nothing
			remove=true
		end if
		
	end function	
	
	
	public function canBeDeleted
	
		canBeDeleted=true
	
		if iId=user.iId then canBeDeleted=false
		if iId=0 then canBeDeleted=false
	
	end function
	
	
	public function setLoginTS
	
		if iId<>0 then
	
			if aspl.isEmpty(session("setLoginTS")) then
			
				db.execute("update tblUser set dLoginTS=now where iId=" & iId)
				 
			end if
			
			session("setLoginTS")="1"
		
		end if
	
	end function	
	
	public function mustexist
	
		if aspl.convertNmbr(iId)=0 then
		
			aspl.die
			
		end if
	
	end function
	
	
	sub checkifadmin
		if not aspl.convertBool(bAdmin) then
			aspl.asperror("Security issue") : aspl.die
		end if
	end sub
	
	
	sub checkonline
		if aspl.convertNmbr(iId)=0 then
			aspl.asperror("Security issue") : aspl.die
		end if
	end sub
	
	
	public function language
	
		if p_language is nothing then 
			set p_language=new cls_language
			p_language.pick(iLanguageID)			
		end if
		
		set language=p_language
	
	end function
	
	
end class


class cls_userlist

	public function dict
	
		Set dict = aspL.dict
	
		dim sql : sql="select * from tblUser order by sLastname, sFirstname asc"
		
		dim sFirstname, sLastname, bDeleted, iId, rs : set rs=db.execute(sql)				
		
		while not rs.eof	

			iId			=	aspl.convertNmbr(rs("iId"))
			sFirstname	=	aspl.convertStr(rs("sFirstname"))
			sLastname	=	aspl.convertStr(rs("sLastname"))
			bDeleted	=	aspl.convertBool(rs("bDeleted"))
		
			if bDeleted then 
				bDeleted=" (deleted)"
			else
				bDeleted=""
			end if
		
			dict.add iId,sLastname & " " & sFirstname & bDeleted
		
			rs.movenext
			
		wend 
		
		set rs=nothing
		
	end function


end class

%>