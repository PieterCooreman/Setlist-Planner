<%
aspl(myApp.sPath & "/includes/begin.asp")

dim playlist : set playlist=new cls_playlist : playlist.pick (form.request("iId"))
'security
if aspl.convertNmbr(playlist.iId)=0 then aspl.die
	
dim url : url="https://chart.googleapis.com/chart" 'url to where your script is located!

dim data : data="cht=qr&chs=320x320&chl=" & server.urlEncode(playlist.getToken)

dim oXMLHTTP : set oXMLHTTP = Server.CreateObject("Msxml2.ServerXMLHTTP")
oXMLHTTP.open "POST", url
oXMLHTTP.setRequestHeader "Content-type", "application/x-www-form-urlencoded;charset=utf-8"
oXMLHTTP.send data

response.clear

Response.ContentType = "image/png"
Response.AddHeader "Content-Disposition", "attachment; filename=QR_" & aspl.safefilename(playlist.sName) & ".png"

response.binarywrite oXMLHTTP.responseBody

set oXMLHTTP=nothing

response.flush()
response.clear
aspl.die
%>