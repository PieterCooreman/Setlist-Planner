<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

form.writejs modalLabel("Premium")

aspl.addFB l("yourepremium") & " <strong>" &  FormatDateTime(dateAdd("yyyy",1,cdate(currentPayment.dPaid)),1) & "</strong>."

if not aspl.isEmpty(currentPayment.dCancel) then

	aspl.addErr (l("alreadycancelled"))

else

	dim cancel : set cancel=form.field("button")
	cancel.add "html",l("cancelpremium")
	cancel.add "class","btn btn-warning"
	cancel.add "onclick",loadmodal("premium_cancel.asp","")

end if

%>