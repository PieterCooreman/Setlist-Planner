<%
class cls_payment

	public iId, iUserID, dPaid, subscriptionID, dCancel
	
	Private Sub Class_Initialize		
		iId=0		
	End Sub	
	
	public function pick(id)	

		if aspl.isNumber(id) then
		
			dim rs,sql : sql = "select * from tblPayment where iId=" & id
			
			set RS = dba.execute(sql)
			
			if not rs.eof then
			
				iId					= rs("iId")
				iUserID				= rs("iUserID")
				dPaid				= rs("dPaid")
				subscriptionID		= rs("subscriptionID")				
				dCancel				= rs("dCancel")
	
			end if
			
			set RS = nothing
			
		end if
		
	end function
	
	public function save
	
		dim rs : set rs = dba.rs		
		
		if iId=0 then			
			rs.Open "select * from tblPayment where 1=2"
			rs.AddNew			
		else
			rs.Open "select * from tblPayment where iId="& iId
		end if		
	
		rs("iUserID") 			= iUserID
		rs("subscriptionID") 	= left(aspl.textonly(subscriptionID),50)	
		rs("dPaid")				= dPaid		
		rs("dCancel")			= dCancel
		
		rs.Update 
		
		iId = aspl.convertNmbr(rs("iId"))		
		
		rs.close
		
		Set rs = nothing	

		save=true		
	
	
	end function
	
	
	public function delete
	
		delete=false
	
		if iId<>0 then
			dba.execute("delete from tblPayment where iId=" & iId)
			delete=true
		end if	
	
	end function

end class

dim p_currentPayment : set p_currentPayment=nothing

function currentPayment

	if p_currentPayment is nothing then

		set p_currentPayment=new cls_payment

		dim rs : set rs=dba.execute("select iId from tblPayment where iUserID=" & user.iId)

		if not rs.eof then
			p_currentPayment.pick(rs(0))
		end if

		set rs=nothing
	
	end if
	
	set currentPayment=p_currentPayment

end function
%>