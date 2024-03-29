<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

if not user.bAdmin then aspl.die

form.writejs modalLabel("Payments")

dim addnew : set addNew=form.field("button")
addnew.add "class","btn btn-primary"
addnew.add "html",l("addnew")
addnew.add "onclick",loadmodal("admin_detail.asp","")

dim table,rs : set rs=dba.execute("select * from tblPayment order by dPaid desc")

table="<table id=""payments"" class=""table table-striped"" style=""width:100%"">"
table=table & "<thead><tr>"
table=table & "<th>User</th>"
table=table & "<th>Paid</th>"
table=table & "<th>Paypal ID</th>"
table=table & "<th>Cancel date</th>"

table=table & "</tr></thead><tbody>"

while not rs.eof

	table=table & "<tr>"	
	
	dim deletedStr, rsU : set rsU=db.execute("select * from tblUser where iId=" & rs("iUserID"))
	
	if not rsU.eof then
		if aspl.convertBool(rsU("bDeleted")) then
			deletedStr=" (deleted)"
		else
			deletedStr=""
		end if
		table=table & "<td>" & aspl.convertStr(rsU("sLastname") & " " & rsU("sFirstname") & deletedStr) & "<br>"
		table=table & "<small><a class=""link"" href=""mailto:" & rsU("sEmail") & """>" & rsU("sEmail") & "</a></small></td>"
	else
		table=table & "<td></td>"
	end if
	
	set rsU=nothing
	
	table=table & "</td>"
	table=table & "<td>" & convertCalcDate(rs("dPaid"))  &"</td>"
	table=table & "<td><a class=""link"" href=""#"" onclick=""" & loadmodaliId("admin_detail.asp",aspl.convertNmbr(rs("iId")),"") & """>" &  aspl.convertStr(rs("subscriptionID"))  &"</a></td>"	
	table=table & "<td>" & convertCalcDate(rs("dCancel"))  &"</td>"
	table=table & "</tr>"
	rs.movenext
	
wend 

table=table & "</tbody></table>"

form.write table & datatable("payments")

%>