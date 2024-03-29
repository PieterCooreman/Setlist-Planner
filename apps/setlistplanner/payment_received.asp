<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

if form.request("subscriptionID")<>"" then
	
	dim payment : set payment=new cls_payment
	
	payment.iUserID			= user.iId
	payment.subscriptionID	= form.request("subscriptionID")
	payment.dPaid			= date()
	payment.save
	
	aspl.addFB(l("upgradesuccess"))

	dim cdomessage : set cdomessage=aspL.plugin("cdomessage")		
	cdomessage.receiveremail=user.sEmail
	cdomessage.subject="Setlist Planner Premium"	

	dim body : body=aspl.loadText(myApp.sPath & "/includes/mail.txt")
	body=replace(body,"[BODY]",l("upgradesuccess"),1,-1,1)
	cdomessage.body=body
	cdomessage.send
	set cdomessage=nothing
	
	addButtons()

end if


%>