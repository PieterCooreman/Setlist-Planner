<%
class cls_system

	public smtpserver,smtpport,sendusing,pickupdir,smtpusessl,smtpusername,smtpuserpw,fromemail,fromname
	public sName, bAllowNewRegistrations, bAllowUsersDelete
	public sLogo, sTerms, sSocialSharing, sSystemEmail, sChromeASP, sChromeASPpw
		
	private sub class_initialize
		
		dim rs : set rs=db.execute("select * from tblSystem")	
		
		smtpserver 				= rs("smtpserver")
		smtpport 				= aspl.convertNmbr(rs("smtpport"))
		sendusing 				= aspl.convertNmbr(rs("sendusing"))
		pickupdir 				= rs("pickupdir")
		smtpusessl 				= rs("smtpusessl")
		smtpusername 			= rs("smtpusername")
		smtpuserpw 				= rs("smtpuserpw")
		fromemail 				= rs("fromemail")
		fromname 				= rs("fromname")	
		sName					= rs("sName")
		bAllowNewRegistrations	= aspl.convertBool(rs("bAllowNewRegistrations"))
		bAllowUsersDelete		= aspl.convertBool(rs("bAllowUsersDelete"))
		sLogo					= rs("sLogo")		
		sTerms					= rs("sTerms")	
		sSocialSharing			= rs("sSocialSharing")
		sSystemEmail			= rs("sSystemEmail")
		sChromeASP				= rs("sChromeASP")
		sChromeASPpw			= rs("sChromeASPpw")
		
	end sub	
				
	private function check	
		check=true		
	end function	
	
	public function save
	
		if check() then
			save=true
		else
			save=false
			exit function
		end if
		
		dim rs
		set rs = db.rs
		
		rs.Open "select * from tblSystem"	
		
		rs("smtpserver")				= smtpserver
		rs("smtpport")					= smtpport		
		rs("sendusing")					= sendusing
		rs("pickupdir")					= pickupdir
		rs("smtpusessl")				= smtpusessl		
		rs("smtpusername")				= smtpusername
		rs("smtpuserpw")				= smtpuserpw
		rs("fromemail")					= fromemail
		rs("fromname")					= fromname
		rs("sName")						= sName
		rs("bAllowNewRegistrations")	= bAllowNewRegistrations
		rs("bAllowUsersDelete")			= bAllowUsersDelete
		rs("sLogo")						= sLogo
		rs("sTerms")					= sTerms
		rs("sSocialSharing")			= sSocialSharing
		rs("sSystemEmail")				= sSystemEmail
		rs("sChromeASP")				= sChromeASP
		rs("sChromeASPpw")				= sChromeASPpw
		
		rs.update
		rs.close
		set rs=nothing

	
	end function
	
	public property get fromnameget
	
		fromnameget=replace(fromname,"[systemname]",system.sName,1,-1,1)
	
	end property

end class
%>