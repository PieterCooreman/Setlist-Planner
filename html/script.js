	
	function loadQS(qs) {
		aspAjax('GET',aspLiteAjaxHandler,qs,aspForm)
	};

	function load(event,target,addQS) {	
		//$('#' + target).html(aspLiteSpinner);
		aspAjax('GET',aspLiteAjaxHandler,'asplEvent=' + event + addQS + '&asplTarget=' + target,aspForm)
	};
	
	function loadID(event,target,iId) {	
		//$('#' + target).html(aspLiteSpinner);
		aspAjax('GET',aspLiteAjaxHandler,'iId=' + iId + '&asplEvent=' + event + '&asplTarget=' + target,aspForm)
	};
	
	function modalAspForm (event,qs,qs2) {
		$('#crmModal').modal({backdrop: 'static',keyboard: false}); //beletten dat de modal per ongeluk sluit
		$('#crmModal').modal('show'); //modalwindow alvast openen
		//$('#modalform').html(aspLiteSpinner); //modalwindow initialiseren met wachtend rondje
		aspAjax ("post",aspLiteAjaxHandler,"iId=" + qs + "&asplTarget=modalform" + qs2 + "&asplEvent=" + event,successModalAspForm)
	};	
	
	function modalAspFormXL (event,qs,qs2) {
			$('#crmModalXL').modal({backdrop: 'static',keyboard: false}); //beletten dat de modal per ongeluk sluit
			$('#crmModalXL').modal('show'); //modalwindow alvast openen
			//$('#modalformXL').html(aspLiteSpinner); //modalwindow initialiseren met wachtend rondje
			aspAjax ("post",aspLiteAjaxHandler,"iId=" + qs + "&asplTarget=modalformXL" + qs2 + "&asplEvent=" + event,successModalAspForm)
		};
		
	function modalAspFormFM (event,qs,qs2) {
			$('#crmModalFM').modal({backdrop: 'static',keyboard: false}); //beletten dat de modal per ongeluk sluit
			$('#crmModalFM').modal('show'); //modalwindow alvast openen
			//$('#modalformFM').html(aspLiteSpinner); //modalwindow initialiseren met wachtend rondje
			aspAjax ("post",aspLiteAjaxHandler,"iId=" + qs + "&asplTarget=modalformFM" + qs2 + "&asplEvent=" + event,successModalAspForm)
		};

	function successModalAspForm(data) {		
		aspForm(data)			
	};	
	
	
	
	function drawSimpleDT(id){
		$('#' + id ).DataTable( {
			info:false,
			responsive:true,			
			paging:false			
			} 
		);
	}	
	
	