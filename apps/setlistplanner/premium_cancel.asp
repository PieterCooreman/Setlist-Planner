<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

form.writejs modalLabel("Premium")

if form.postback then

	'session securitycheck
	if form.sameSession then
		
		currentPayment.dCancel=date
		currentPayment.save()
		
		aspl.addFB(l("cancelmessagesubject") & ".")

		dim cdomessage : set cdomessage=aspL.plugin("cdomessage")		
		cdomessage.receiveremail=user.sEmail
		
		dim body : body=aspl.loadText(myApp.sPath & "/includes/mail.txt")	
		body=replace(body,"[body]",br(l("cancelmessagebody")),1,-1,1)
		body=replace(body,"[date]",FormatDateTime(dateAdd("yyyy",1,cdate(currentPayment.dPaid)),1),1,-1,1)
		
		cdomessage.subject=l("cancelmessagesubject")	
		
		cdomessage.body=body
		cdomessage.send	
		
		set cdomessage=nothing
		
		set close=form.field("button")
		close.add "html",l("close")
		close.add "class","btn btn-secondary"
		close.add "databsdismiss","modal"
		
		addButtons()
		
		form.build
	
	end if

end if

aspl.addWarning l("cancelpremium2") & " <strong>" &  FormatDateTime(dateAdd("yyyy",1,cdate(currentPayment.dPaid)),1) & "</strong>"

dim cancel : set cancel=form.field("submit")
cancel.add "html",l("cancelpremium")
cancel.add "class","btn btn-danger"

dim close : set close=form.field("button")
close.add "html",l("close")
close.add "class","btn btn-secondary"
close.add "databsdismiss","modal"

%>