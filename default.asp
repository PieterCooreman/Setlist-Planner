<!-- #include file="asplite/asplite.asp"-->
<!-- #include file="asp/includes.asp"-->
<!-- #include file="share/functions.asp"-->
<%

'create a database object. 
const dbpath	=	"db/db.mdb"
const dblpath	=	"db/languages.mdb"
const dbapath	=	"db/myapp.mdb"

dim db 	: set db=aspL.plugin("database") 	: db.path=dbpath
dim dbL	: set dbL=aspL.plugin("database") 	: dbL.path=dblpath
dim dba	: set dba=aspL.plugin("database") 	: dba.path=dbapath

dim system : set system=new cls_system
dim sec : set sec=new cls_Sec  : sec.autologin
dim user : set user=sec.user : user.setLoginTS

if not aspl.isEmpty(aspL.getRequest("asplEvent")) then
	aspL("asp/" & aspL.getRequest("asplEvent") & ".resx")		
end if

'show signup/login form or dashboard?
dim main
if sec.autologin then 
	main=aspl.loadText("html/dashboard.htm")
else
	main=aspl.loadText("html/login.htm")
	
	if system.bAllowNewRegistrations or aspl.convertNmbr(session("userToBeConfirmed"))<>0 then
		main=replace(main,"[display]","",1,-1,1)
	else
		main=replace(main,"[display]","d-none",1,-1,1)
	end if
	
end if

'#######################################################
'#####  NAV
'#######################################################

dim nav
nav="<ul class=""navbar-nav me-auto mb-2 mb-md-0"">"

nav=nav & "<li class=""nav-item"">"
nav=nav & "<a class=""nav-link"" href=""[curPageURL]"">"
nav=nav & getIcon("home")
nav=nav & l("home") & "</a></li>"

if user.bAdmin then
	nav=nav & "<li class=""nav-item"">"	
	nav=nav & "<a class=""nav-link"" href=""#"" onclick=""$('.navbar-collapse').collapse('hide');load('admin_dashboard','dashboard','');return false;"">"
	nav=nav & getIcon("settings")
	nav=nav & l("admin") & "</a></li>"	
end if

if sec.autologin then
	nav=nav & "<li class=""nav-item"">"
	nav=nav & "<a class=""nav-link"" href=""#"" onclick=""$('.navbar-collapse').collapse('hide');modalAspForm('myaccount','','');return false;"">"
	nav=nav & getIcon("person") & l("account ") & "</a>"
	nav=nav & "</li>"
	nav=nav & "<li class=""nav-item"">"
	nav=nav & "<a class=""nav-link"" href=""#"" onclick=""$('.navbar-collapse').collapse('hide');modalAspForm('signout','','');return false;"">"
	nav=nav & getIcon("logout") & l("signout") & "</a>"
	nav=nav & "</li>"
end if

nav=nav & "</ul>"

dim body : body=aspL.loadText("html/default.htm")
body=replace(body,"[main]",main,1,-1,1)
body=replace(body,"[nav]",nav,1,-1,1)
body=replace(body,"[titletag]",server.htmlEncode(system.sName),1,-1,1)

if not aspl.isEmpty(system.sName) then
	body=replace(body,"[systemlogo]","<img style=""margin-right:3px"" src=""" & system.sLogo & """ alt=""" & server.htmlEncode(system.sName) & """ width=""32"" height=""32"" />",1,-1,1)
else
	body=replace(body,"[systemlogo]","",1,-1,1)
end if

body=replace(body,"[socialsharing]",system.sSocialSharing,1,-1,1)
body=replace(body,"[light]",l("light"),1,-1,1)
body=replace(body,"[dark]",l("dark"),1,-1,1)
body=replace(body,"[auto]",l("auto"),1,-1,1)
body=replace(body,"[systemName]",system.sName,1,-1,1)
body=replace(body,"[forgotpassword]",l("forgotpassword"),1,-1,1)
body=replace(body,"[close]",l("close"),1,-1,1)
body=replace(body,"[signin]",l("signin"),1,-1,1)
body=replace(body,"[register]",l("register"),1,-1,1)
body=replace(body,"[curPageURL]",getSiteUrl,1,-1,1)
body=replace(body,"[terms]","<a href=""#"" onclick=""modalAspForm ('terms','','')"">" & l("terms") & "</a>",1,-1,1)

'user pasword is admin
if sec.autologin then
 
	if user.sPw="8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918" then
	
		dim changedefaultpw : changedefaultpw="<div id=""changedefaultpw"" class=""container"">"
		changedefaultpw=changedefaultpw & "<div class=""alert alert-danger mb-4"">"
		changedefaultpw=changedefaultpw & "<a class=""btn btn-danger"" href=""#"" "
		changedefaultpw=changedefaultpw & "onclick=""modalAspForm('myaccount_resetpw','','');return false;"">"
		changedefaultpw=changedefaultpw & aspl.htmlEncode(l ("changedefaultpw")) &"</a></div></div>"	
	
		body=replace(body,"[PWWARNING]",changedefaultpw,1,-1,1)
		
	end if
	
end if

body=replace(body,"[PWWARNING]","",1,-1,1)

response.write body

'destroy aspLite
set aspL=nothing

%>
