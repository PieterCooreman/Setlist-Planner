<%
class cls_language

	Public iId, sName, bActive, bDefault, bDeleted	
	
	Private Sub Class_Initialize		
		iId=0
		bActive=true
		bDefault=false
		bDeleted=false	
	End Sub	
	
	public function check
	
		check=true
		
		if aspl.isempty(sName) then
			aspl.addErr(l("nameismandatory"))
			check=false
		end if		
		
	end function
			
	
	public function pick(id)	

		dim RS
		
		if aspl.isNumber(id) then
		
			dim sql : sql = "select * from tblLanguage where bDeleted=false and iId=" & id
			
			set RS = dbL.execute(sql)
			
			if not rs.eof then
			
				iId					= rs("iId")
				sName				= rs("sName")
				bActive				= rs("bActive")
				bDefault			= rs("bDefault")
				bDeleted			= rs("bDeleted")
	
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
		
		if bDefault then bActive=true 'default taal is steeds actief
		
		dim rs : set rs = dbL.rs		
		
		if iId=0 then			
			rs.Open "select * from tblLanguage where 1=2"
			rs.AddNew			
		else
			rs.Open "select * from tblLanguage where bDeleted=false and iId="& iId
		end if
		
		rs("sName")					= left(aspl.convertStr(sName),50)		
		rs("bDefault")				= aspl.convertBool(bDefault)
		rs("bActive")				= aspl.convertBool(bActive)
		rs("bDeleted")				= aspl.convertBool(bDeleted)		
				
		rs.Update 
		
		iId = aspl.convertNmbr(rs("iId"))
		
		if bDefault then 
			dbL.execute("update tblLanguage set bDefault=false where iId<>" & iId)
		end if
		
		rs.close
		
		Set rs = nothing		
		
	end function
	
	public function remove
	
		remove=false
		
		if iId<>0 then
			dim rs		
			set rs=dbL.execute("delete from tblLabel where iLanguageID=" & aspl.convertNmbr(iId))
			set rs=nothing
			set rs=dbL.execute("update tblLanguage set bDeleted=true where iId=" & aspl.convertNmbr(iId))
			set rs=nothing
			remove=true
		end if
		
	end function
	
	public function canBeDeleted
	
		canBeDeleted=true
		
		if iId=0 or aspl.convertBool(bDefault) then canBeDeleted=false
	
	end function	

end class


dim p_defaultLanguage : set p_defaultLanguage=nothing
function defaultLanguage
	
	if p_defaultLanguage is nothing then

		set p_defaultLanguage=new cls_language

		dim rs : set rs=dbL.execute("select iId from tblLanguage where bDefault=true")
		
		if not rs.eof then p_defaultLanguage.pick(rs(0))
	
	end if
	
	set defaultLanguage=p_defaultLanguage

end function


dim overruleLID : overruleLID=0 : dim looper : looper=0
function l(sCode)

	sCode=trim(sCode)	
	
	looper=looper+1 : if looper>2 then looper=0 : l="" : exit function
	
	'overrule default language
	if aspl.convertNmbr(aspl.getRequest("iLid"))<>0 then user.iLanguageID=aspl.convertNmbr(aspl.getRequest("iLid"))
	if aspl.convertNmbr(session("iLanguageID"))<>0 then user.iLanguageID=aspl.convertNmbr(session("iLanguageID"))
	
	
	dim langID
	if user.language.iId=0 or not user.language.bActive or user.language.bDeleted then 
		langID=defaultLanguage.iId
	else
		langID=user.language.iId
	end if
	
	'bij het versturen van mails in andere talen
	if overruleLID<>0 then langID=overruleLID

	dim rs : set rs=dbL.execute("select sValue from tblLabel where iLanguageID=" & aspl.convertNmbr(langID) & " and sCode='" & lcase(aspl.sqli(sCode)) & "'")
		
	if not rs.eof then
		l=aspl.convertStr(rs(0))
		looper=0		
	else		
		overruleLID=defaultLanguage.iId		
		l=l(sCode)
	end if
	
	set rs=nothing

end function

function ll(sCode,iLangId)	

	sCode=trim(sCode)
	
	dim rs : set rs=dbL.execute("select sValue from tblLabel where iLanguageID=" & aspl.convertNmbr(iLangId) & " and sCode='" & aspl.sqli(sCode) & "'")
		
	if not rs.eof then
		ll=aspl.convertStr(rs(0))
	else
		ll=""
	end if
	
	set rs=nothing

end function

function llobj(sCode,iLangId)	

	set llobj=new cls_label

	dim rs : set rs=dbL.execute("select iId from tblLabel where iLanguageID=" & aspl.convertNmbr(iLangId) & " and sCode='" & aspl.sqli(sCode) & "'")
		
	if not rs.eof then
		llobj.pick(rs(0))
	end if
	
	set rs=nothing

end function

%>