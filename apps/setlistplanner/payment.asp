<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

form.writejs modalLabel(l("upgradetopremium"))

form.write "<div class=""alert alert-success"">" &  l("upgrade") & "</div>"

dim paymenttxt : paymenttxt=aspl.LoadText(myApp.sPath & "/includes/payment.txt") 
paymenttxt=replace(paymenttxt,"[SUCCESS]","modalAspForm ('dashboard','&customAppID=" & myApp.IId & "&custumAppPath=" & server.urlencode("payment_received.asp") &"','&subscriptionID=' + data.subscriptionID);")

form.write "<div class=""alert alert-light"" style=""margin:0 auto;width:300px"">" & paymenttxt & "</div>"

%>