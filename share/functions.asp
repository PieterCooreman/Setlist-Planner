<%
function cssMode(token,value,mode)

	select case cstr(mode)
	
		case "8"		
			'purple		
			cssMode=replace(value,"FFFFFF","@@@@@@",1,-1,1)
			cssMode=replace(cssMode,"000000","FFFFFF",1,-1,1)
			cssMode=replace(cssMode,"@@@@@@","46244C",1,-1,1)	
	

		case "7"
			'olive green		
			cssMode=replace(value,"FFFFFF","@@@@@@",1,-1,1)
			cssMode=replace(cssMode,"000000","FFFFFF",1,-1,1)
			cssMode=replace(cssMode,"@@@@@@","464A31",1,-1,1)	
			
	
		case "6"		
			'brown		
			cssMode=replace(value,"FFFFFF","@@@@@@",1,-1,1)
			cssMode=replace(cssMode,"000000","FFFFFF",1,-1,1)
			cssMode=replace(cssMode,"@@@@@@","4b261b",1,-1,1)	
	
		case "5"		
			'blue		
			cssMode=replace(value,"FFFFFF","@@@@@@",1,-1,1)
			cssMode=replace(cssMode,"000000","FFFFFF",1,-1,1)
			cssMode=replace(cssMode,"@@@@@@","192841",1,-1,1)	
	
		case "4"		
			'green		
			cssMode=replace(value,"FFFFFF","@@@@@@",1,-1,1)
			cssMode=replace(cssMode,"000000","FFFFFF",1,-1,1)
			cssMode=replace(cssMode,"@@@@@@","023020",1,-1,1)			
	
		case "3"
			'red		
			cssMode=replace(value,"FFFFFF","@@@@@@",1,-1,1)
			cssMode=replace(cssMode,"000000","FFFFFF",1,-1,1)
			cssMode=replace(cssMode,"@@@@@@","4F0101",1,-1,1)	
	
		case "2"
			'darkmode		
			cssMode=replace(value,"FFFFFF","@@@@@@",1,-1,1)
			cssMode=replace(cssMode,"000000","FFFFFF",1,-1,1)
			cssMode=replace(cssMode,"@@@@@@","212529",1,-1,1)			
			
		case else

			cssMode=value
			
	end select
	
	cssMode=replace(cssMode,"###BUTTON###",getselect(token,request.querystring("mode")),1,-1,1)
	
	if request.querystring("noheader")<>"" then	
		cssMode=replace(cssMode,"XXXXXXX","display:none",1,-1,1)
	else
		cssMode=replace(cssMode,"XXXXXXX","",1,-1,1)
	end if

end function


function getselect(token,mode)

	getselect="<select style=""float:right;font-family:Arial;font-size:16px;padding:7px"" onchange=""location.assign('" & token &"&mode=' + this.value);"">"
	getselect=getselect & "<option value=""0"">Theme</option>"
	getselect=getselect & "<option value=""1"">Light</option>"
	getselect=getselect & "<option value=""2"">Dark</option>"
	getselect=getselect & "<option value=""3"">Red</option>"
	getselect=getselect & "<option value=""4"">Green</option>"
	getselect=getselect & "<option value=""5"">Blue</option>"
	getselect=getselect & "<option value=""6"">Brown</option>"
	getselect=getselect & "<option value=""7"">Olive</option>"
	getselect=getselect & "<option value=""8"">Purple</option>"
	getselect=getselect & "</select>"

end function

%>