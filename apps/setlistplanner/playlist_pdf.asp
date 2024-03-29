<%
aspl(myApp.sPath & "/includes/begin.asp")

dim playlist : set playlist=new cls_playlist : playlist.pick (form.request("iId"))
'security
if aspl.convertNmbr(playlist.iId)=0 then aspl.die

dim url : url=system.sChromeASP 'url to where your script is located!

dim data : data="pw=" & system.sChromeASPpw
data=data & "&filename=export"
data=data & "&filetype=pdf"
data=data & "&html=" & server.urlencode(replace(playlist.html(false),"###BUTTON###","",1,-1,1))

dim oXMLHTTP : set oXMLHTTP = Server.CreateObject("Msxml2.ServerXMLHTTP")
oXMLHTTP.open "POST", url
oXMLHTTP.setRequestHeader "Content-type", "application/x-www-form-urlencoded;charset=utf-8"
oXMLHTTP.send data

response.clear

Response.ContentType = "application/pdf"
Response.AddHeader "Content-Disposition", "attachment; filename=" & aspl.safeFileName(playlist.sName) & ".pdf"

response.binarywrite oXMLHTTP.responseBody

set oXMLHTTP=nothing

response.flush()
response.clear
aspl.die


%>