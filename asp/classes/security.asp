<%

'token 1: email
'token 2: password

class cls_Sec

	private p_user, bAppreloaded

	private sub class_initialize
		
		set p_user=nothing
		bAppreloaded=false
	
	end sub

	public function autologin
	
		if aspl.convertBool(session("sec")) then 
			autologin=true
		else
			autologin=signin(decrypt(request.cookies("token1")),request.cookies("token2"))
		end if

		if autologin and not bAppreloaded then 
			Application.Contents.RemoveAll()
			bAppreloaded=true
		end if
	
	end function	
	
	public function signin(email,pw)	
	
		signin=false
		
		dim userID
		
		'eerste check: is er iets leeg?
		if aspl.isempty(email) or aspl.isempty(pw) then
			signin=false			
			exit function
		end if
		
		email	= lcase(trim(left(email,100)))
		pw		= trim(left(pw,255))
	
		dim rs
		set rs=db.execute("select * from tblUser where tblUser.bDeleted=false and sEmail='" & aspl.sqli(email) & "' and sPw='" & aspl.sqli(pw) & "'")
		
		if rs.eof then
		
			set rs=nothing	
			exit function	
			
		else
			userID=rs("iId")
			set rs=nothing
			signin=true
		end if
		
		if signin then		
		
			Response.Cookies("token1")=encrypt(email)
			Response.Cookies("token1").expires=dateAdd("d",1500,date())
			Response.Cookies("token2")=pw
			Response.Cookies("token2").expires=dateAdd("d",1500,date())	
			
			session("sec")=true	
			session("userID")=userID	
			session("iLanguageID")=0
			
		end if		
	
	end function
	
	public function user
	
		if p_user is nothing then
		
			set p_user=new cls_user
	
			if aspl.isNumber(session("userID")) then				
				p_user.pick(session("userID"))
			end if 
			
			if aspl.convertBool(p_user.bAdmin) then 
				session("bAdminUser")=true
			else
				session("bAdminUser")=false
			end if
		
		end if
		
		set user=p_user
	
	end function
	
	
	public function signout
	
		Response.Cookies("token1")=""
		Response.Cookies("token2")=""
		Response.Cookies("token1").expires=DateAdd("d",-2,date)
		Response.Cookies("token2").expires=DateAdd("d",-2,date)
		
		aspl.removeAllCookies
		
		session("sec")=false
		session("userID")=""
		session.abandon()
		signout=true		
	
	end function
	
	
	public function resetPw(sEmail)		
	
		if not aspl.CheckEmailSyntax(sEmail) then exit function
		if aspl.isEmpty(sEmail) then exit function 
		sEmail	= lcase(trim(left(sEmail,255)))
		
		'bestaat het email adres in de users tabel?
		dim rs : set rs=db.execute("select iId, sToken from tblUser where tblUser.bDeleted=false and sEmail='" & aspl.sqli(sEmail) & "'")
		
		if rs.eof then 
			set rs=nothing
			exit function	
		end if			
		
		'hier een mail versturen!
		dim cdomessage : set cdomessage=aspL.plugin("cdomessage")
		cdomessage.receiveremail=sEmail
		cdomessage.subject=l("subjectresetpw")
		
		dim body : body=l("bodyresetpw")
		body=replace(body,"[systemName]",system.sName,1,-1,1)
		body=replace(body,"[subjectresetpw]",l("subjectresetpw"),1,-1,1)
		body=replace(body,"[link]",getSiteUrl & "/?asplEvent=resetpw&iId=" & rs("iId")	& "&sToken=" & rs("sToken") ,1,-1,1)	
		cdomessage.body=body
		cdomessage.send
		set cdomessage=nothing	
		
		set rs=nothing	
		
	end function
	

end class

%>