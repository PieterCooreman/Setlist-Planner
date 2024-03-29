<%
function isNewUser

	if dba.execute("select iId from tblPlaylist where iUserID=" & user.iId).eof then 
		isNewUser=true
	else
		isNewUser=false
	end if

end function

function googleSearch(id,value)

	if aspl.isEmpty(value) or aspl.convertNmbr(id)=0 then exit function

	googleSearch="&nbsp;<i><a class=""link"" target=""_blank"" href=""https://google.com/search?q=" & server.urlencode(value) &""">" & lcase(l("search")) & "</a></i>"

end function

sub addButtons

	'add custom buttons

	form.writejs "$('#topbuttons').html('');"

	if currentPayment.iId=0 then
		form.writejs "$('#topbuttons').append('<a class=""btn btn-warning"" onclick=""" & aspl.htmlEncJs(loadmodaliId("payment.asp","","")) & """ href=""#"">" & getIcon("upgrade") & l("upgradetopremium") & "</a>');"
	else
		form.writejs "$('#topbuttons').append('<a class=""btn btn-success"" onclick=""" & aspl.htmlEncJs(loadmodaliId("premium.asp","","")) & """ href=""#"">" & getIcon("star") & "Premium</a>');"
	end if	
	
	if user.bAdmin then
		form.writejs "$('#topbuttons').append('<a class=""btn btn-danger"" style=""margin-left:6px"" onclick=""" & aspl.htmlEncJs(loadmodal("admin.asp","")) & """ href=""#"">" & getIcon("manufacturing") & "</a>')"
	end if

	form.writejs "$('#topbuttons').append('<a style=""margin-left:6px"" class=""btn btn-primary"" href=""https://setlistplanner.com"" target=""_blank"" style=""background-color:#209CEE"">"&getIcon("home")& "</a>');"
	
end sub

%>