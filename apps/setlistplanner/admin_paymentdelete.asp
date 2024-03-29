<%
form.initialize=false

aspl(myApp.sPath & "/includes/begin.asp")

if not user.bAdmin then aspl.die

form.writejs modalLabel("Payment delete")

dim payment : set payment=new cls_payment : payment.pick(form.request("iId"))

if form.postback then

	'session securitycheck
	if form.sameSession then		
							
		if payment.delete then			
			addButtons()
			form.writejs loadmodalonload("admin.asp","")
			
		end if
		
	end if
	
end if

aspl.addWarning("Are you sure to delete this payment? No way to undo!")

dim iId : set iId=form.field("hidden")
iId.add "value",payment.iId
iId.add "name","iId"

dim submit : set submit=form.field("submit")
submit.add "html",l("delete")
submit.add "class","btn btn-danger"

dim cancel : set cancel=form.field("button")
cancel.add "html",l("cancel")
cancel.add "class","btn btn-secondary"
cancel.add "onclick",loadmodal("admin.asp","")

%>