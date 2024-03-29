<%
form.initialize=false

aspl(myApp.sPath & "/includes/begin.asp")

if not user.bAdmin then aspl.die

form.writejs modalLabel("Payment details")

dim payment : set payment=new cls_payment : payment.pick(form.request("iId"))

if form.postback then

	'session securitycheck
	if form.sameSession then	
		
		if aspl.isEmpty(form.request("dPaid")) then 
			payment.dPaid	= null
		else
			payment.dPaid 	= cdate(form.request("dPaid"))		
		end if
		
		payment.subscriptionID 	= form.request("subscriptionID")
		payment.iUserID 		= form.request("iUserID")
				
		if aspl.isEmpty(form.request("dCancel")) then 
			payment.dCancel	= null
		else
			payment.dCancel = cdate(form.request("dCancel"))
		end if
							
		if payment.save then			
			addButtons()
			form.writejs loadmodalonload("admin.asp","")
			
		end if
		
	end if
	
end if

dim iId : set iId=form.field("hidden")
iId.add "value",payment.iId
iId.add "name","iId"

'user
dim userlist : set userlist=new cls_userlist

dim iUserID : set iUserID=form.field("select")
iUserID.add "options",userlist.dict
iUserID.add "required",true
iUserID.add "class","form-control"
iUserID.add "label","User"
iUserID.add "name","iUserID"
iUserID.add "value",payment.iUserID

form.newline

dim dPaid : set dPaid=form.field("date")
dPaid.add "required",true
dPaid.add "class","form-control"
dPaid.add "label","dPaid"
dPaid.add "name","dPaid"
dPaid.add "value",aspl.convertHtmlDate(payment.dPaid)

form.newline

dim subscriptionID : set subscriptionID=form.field("text")
subscriptionID.add "required",true
subscriptionID.add "class","form-control"
subscriptionID.add "label","subscriptionID"
subscriptionID.add "name","subscriptionID"
subscriptionID.add "value",payment.subscriptionID
subscriptionID.add "maxlength",50

form.newline

dim dCancel : set dCancel=form.field("date")
dCancel.add "class","form-control"
dCancel.add "label","dCancel"
dCancel.add "name","dCancel"
dCancel.add "value",aspl.convertHtmlDate(payment.dCancel)

form.newline

dim submit : set submit=form.field("submit")
submit.add "html",l("Save")
submit.add "class","btn btn-primary"

if payment.iId<>0 then

	dim delete : set delete=form.field("button")
	delete.add "html",l("delete")
	delete.add "class","btn btn-danger"
	delete.add "onclick",loadModaliID("admin_paymentdelete.asp",payment.iId,"")

end if
%>