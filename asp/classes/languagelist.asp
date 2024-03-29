<%
class cls_languageList

	Public list
	
	Private Sub Class_Initialize
	
		Set list = aspL.dict
	
		dim sql : sql="select * from tblLanguage where bDeleted=false order by sName"
		
		dim language, rs : set rs=dbL.execute(sql)				
		
		while not rs.eof			
		
			set language=new cls_language : language.pick(aspl.convertNmbr(rs("iId")))
		
			list.add language.iId,language
			
			set language=nothing
		
			rs.movenext
			
		wend 
		
		set rs=nothing		
		
	End Sub
	
	public function dict
	
		Set dict = aspL.dict
	
		dim sql : sql="select iId, sName from tblLanguage where bActive=true and bDeleted=false order by sName"
		
		dim language, rs : set rs=dbL.execute(sql)				
		
		while not rs.eof			
		
			dict.add aspl.convertNmbr(rs("iId")),aspl.convertStr(rs("sName"))		
		
			rs.movenext
			
		wend 
		
		set rs=nothing
		
	end function
	
	Private Sub Class_Terminate
	
		Set list = nothing
		
	End Sub	

end class
%>