<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
option explicit

Response.Buffer				= true
Response.ContentType		= "text/html"
Response.CacheControl		= "no-cache"
Response.AddHeader "pragma", "no-cache"
Response.Expires			= -1
Response.ExpiresAbsolute	= Now()-1

dim colormode : colormode=request.querystring("mode")

if request.querystring("colormode")<>"" then

	if request.querystring("colormode")="dark" then
		colormode=2
	else
		colormode=1
	end if

end if

'zware hack
dim sl : sl=trim(request.querystring("sl") & "-" & request.querystring("noheader"))
if len(sl)<2 then response.end 

if application(sl)<>"" then
	response.clear
	response.write cssMode(getSiteUrl & "/share/?sl="& sl,application(sl),colormode)
	response.flush
	response.end
end if

on error resume next
dim s : s=split(sl,"-")
response.redirect(getSiteUrl & "/?asplEvent=dashboard&customAppID=12&custumAppPath=share&iLid=" & server.urlencode(s(2)) & "&sToken=" & server.urlencode(s(1)) & "&iId=" & server.urlencode(s(0)) & "&noheader=" & request.querystring("noheader") & "&mode=" & server.urlencode(colormode))
if err.number<>0 then response.write "<strong>Wrong code. Please try again!</strong>" : response.end 
on error goto 0

function getSiteUrl

	if lcase(cstr(request.servervariables("HTTPS")))="on" then
		getSiteUrl="https://"
	else
		getSiteUrl="http://"
	end if
	
	getSiteUrl=getSiteUrl & request.servervariables("HTTP_HOST") & request.servervariables("SCRIPT_NAME") 	
	getSiteUrl=replace(getSiteUrl,"/default.asp","",1,-1,1)
	getSiteUrl=replace(getSiteUrl,"/share","",1,-1,1)
	
end function

%>
<!-- #include file="functions.asp"-->
