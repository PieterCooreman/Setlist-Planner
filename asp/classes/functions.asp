<%

function modalLabel(value)
	modalLabel="$('#crmModalLabel').html('" & aspl.htmlEncJS(value) & "')"
end function

function modalLabelXL(value)
	modalLabelXL="$('#crmModalLabelXL').html('" & aspl.htmlEncJS(value) & "')"
end function

function loadhome
	loadhome="load('dashboard','dashboard','');"
end function

function wait(seconds)

	Dim dteWait
	dteWait = DateAdd("s", seconds, Now())
	Do Until (Now() > dteWait)
	Loop

end function

function uitleg(title,txt)

	txt=replace(aspl.loadText("html/uitleg/" & txt & ".txt"),"""","&quot;",1,-1,1)
	txt=replace(txt,vbcrlf,"",1,-1,1)
	
	title=replace(title,"""","&quot;",1,-1,1)
	
	uitleg="<a class=""link"" href=""#"" onclick=""return false;"" "
	uitleg=uitleg & "data-bs-toggle=""popover"" title=""" & title & """ "
	uitleg=uitleg & "data-bs-content=""" & txt & """>"
	uitleg=uitleg & geticon("help") & "</a>"

end function

Function LinkURLs(tempTxt)

	tempTxt=aspl.convertStr(tempTxt)
	
	'Make <br /> from linebreaks
	tempTxt=replace(tempTxt,vbcrlf,"<br />",1,-1,1)
	
	Dim regEx
	Set regEx = New RegExp
	regEx.Global = True
	regEx.IgnoreCase = True
	'Hyperlink Email Addresses
	regEx.Pattern = "([_.a-z0-9-]+@[_.a-z0-9-]+\.[a-z]{2,3})" 
	tempTxt = regEx.Replace(tempTxt, "<a class=""link"" href=""mailto:$1"">$1</a>")
	
	'Hyperlink URL's
	regEx.Pattern = "((www\.|(http|https|ftp|news|file)+\:\/\/)[_.a-z0-9-]+\.[a-z0-9\/_:@=.+?,##%&~-]*[^.|\'|\# |!|\(|?|,| |>|<|;|\)])"
	tempTxt = regEx.Replace(tempTxt, "<a class=""link"" href=""$1"" target = '_blank'>$1</a>")          
	
	'Make <a href="www = <a href="http://www
	tempTxt = Replace(tempTxt, "href=""www", "href=""http://www",1,-1,1)
	
	LinkURLs = tempTxt
	
End Function 

function removeTabs(value)

	if not aspl.isEmpty(value) then
		removeTabs=replace(value,vbtab,"",1,-1,1)
	else
		removeTabs=""
	end if

end function


sub quickEmail(email,subject,body)

	dim cdomessage : set cdomessage=aspL.plugin("cdomessage")
	cdomessage.receiveremail=email
	cdomessage.subject=subject
	cdomessage.body=body
	cdomessage.send
	set cdomessage=nothing

end sub


function removeWhites(value)
	
	value=removeTabs(value)
	removeWhites=replace(value," ","",1,-1,1)

end function 


sub systemError

	dim body : body=user.sFullname & "<br><br>" & replace(aspl.formcollection,vbcrlf,"<br>",1,-1,1) & "<br><br>" & replace(aspl.ServerVariables,vbcrlf,"<br>",1,-1,1)
	
	if err.number<>0 then body=body & "<br><br><strong>Error description:</strong> " & err.description	
	
	'hier een mail versturen!
	dim cdomessage : set cdomessage=aspL.plugin("cdomessage")
	cdomessage.receiveremail=system.crmEmailSystem
	cdomessage.subject="System error op " & system.crmUrl	
	cdomessage.body=body
	cdomessage.send
	set cdomessage=nothing
	
	err.clear()
	
end sub

function threedots(value,length)
	
	if len(aspl.convertStr(value))>length then
		threedots=left(value,length) & "..."
	else
		threedots=value
	end if

end function

function spinner

	spinner="this.innerHTML+='&nbsp;<div class=""spinner-border spinner-border-sm"" role=""status""></div>';"

end function

function phonepattern

	phonepattern="\+?\d+" '"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$"
	
end function

function phonelegend

	phonelegend="<small class=""form-text text-muted"">+32475123456 of 0032475123456</small>"
	
end function

function datatable(tableID)

	datatable=vbcrlf & "<script>" 
	datatable=datatable & "$(document).ready(function() {" 
	datatable=datatable & "$('#" & tableID & "').DataTable( {"
	
	select case user.iLanguageId
	
		case 5 'NL
			datatable=datatable & "language: { url: 'html/dataTables.dutch.json',},"
	
	end select
	
	
	datatable=datatable & "lengthMenu: [ 10, 25, 50, 100, 200, 300, 400, 500, 1000, 2000 ],"
	datatable=datatable & "responsive: true"
	datatable=datatable & "});} );</script>" & vbcrlf & vbcrlf

end function

function datatableFirstColumn(tableID)

	datatableFirstColumn=vbcrlf & "<script>" &_
		"$(document).ready(function() {" &_
			"$('#" & tableID & "').DataTable( {" &_					
				"order: [[ 0, 'desc' ]]," &_	
				"lengthMenu: [ 10, 25, 50, 100, 200, 300, 400, 500, 1000, 2000 ]," &_			
				"responsive: true" &_	
				"});} );</script>" & vbcrlf & vbcrlf				

end function

function mandatory

	mandatory="<div class=""text-muted clearfix"">(*) "& l ("mandatoryfields") &"</div>"
	
end function

 
function geticon(value)

	geticon="<span class=""material-symbols-outlined icon"">" & value & "</span> "

end function


function select2SimpleModal(fieldID)

	select2SimpleModal="$('#" & fieldID & "').select2({ placeholder: '', allowClear: true, theme: ""bootstrap-5"",dropdownParent: $('#crmModal')});"
	
end function

function select2SimpleModalXL(fieldID)

	select2SimpleModalXL="$('#" & fieldID & "').select2({ placeholder: '', allowClear: true, theme: ""bootstrap-5"",dropdownParent: $('#crmModalXL')});"
	
end function

function select2Modal(fieldID,asplEvent)

	select2Modal=select2(fieldID,asplEvent)
	
	select2Modal=replace(select2Modal,"<script>","",1,-1,1)
	select2Modal=replace(select2Modal,"</script>","",1,-1,1)
	select2Modal=replace(select2Modal,"'bootstrap-5',","'bootstrap-5',dropdownParent: $('#crmModal'),",1,-1,1)	

end function


function select2(fieldID,asplEvent)

	select2="<script>var select2" & fieldID & "=" &_
	"$('#" & fieldID &"').select2({" &_	
	"placeholder: '', allowClear: true, theme: 'bootstrap-5'," &_
	"delay: 500," &_
	"language: {" &_
	"""noResults"": function(){" &_
	"return ""Geen resultaat gevonden"";" &_
	"}," &_
	"""searching"": function(){" &_
	"return ""Zoeken..."";" &_
	"}" &_
	"}"
	
	if not aspl.isEmpty(asplEvent) then
		select2 = select2 & ",ajax: {url: aspLiteAjaxHandler + '?asplEvent=" & asplEvent & "',dataType: 'json',delay: 500}" 
	end if
	
	select2 = select2 & "});"	
	
	select2 = select2 & "</script>"	

end function

function select2WL(fieldID,asplEvent)

	select2WL="<script>var select2" & fieldID & "=" &_
	"$('#" & fieldID &"').select2({" &_	
	"placeholder: '', allowClear: true," &_
	"delay: 500," &_
	"selectionCssClass  : ""form-control""," &_
	"language: {" &_
	"""noResults"": function(){" &_
	"return ""Geen resultaat gevonden"";" &_
	"}," &_
	"""searching"": function(){" &_
	"return ""Zoeken..."";" &_
	"}" &_
	"}"
	
	if not aspl.isEmpty(asplEvent) then
		select2WL = select2WL & ",ajax: {url: aspLiteAjaxHandler + '?asplEvent=" & asplEvent & "',dataType: 'json',delay: 500}" 
	end if
	
	select2WL = select2WL & "});"	
	
	select2WL = select2WL & "</script>"	

end function

function setTitle(icon,value)

	if not aspl.isEmpty(icon) then icon=getIcon(icon) & " "

	setTitle="<script>$('#crmPageTitle').html('" & icon & aspl.htmlEncJS(value) & "');</script>"

end function

function removeComma(value)

	value=trim(value)

	if right(value,1)="," then
		value=left(value,len(value)-1)
	end if
	
	if left(value,1)="," then
		value=right(value,len(value)-1)
	end if	
	
	removeComma=value

end function

function wrapInIframe(src)

	wrapInIframe="<iframe src=""" & src & """ style=""border-width:0;width:100%;height:700px"" frameborder=""0"" scrolling=""no""></iframe>"

end function

'select a date-format
dim dateformat
dateformat="dd/mm/yy" 'or mm/dd/yy see function dateFromPicker - you can add more - see https://jqueryui.com/datepicker/

function dateFromPicker(theDate)

	on error resume next
	
	if not aspL.isEmpty(theDate) then
	
		dim arrDate
		arrDate=split(theDate,"/")
		
		select case dateformat
		
			case "dd/mm/yy" : dateFromPicker=dateserial(arrDate(2),arrDate(1),arrDate(0))
				
			case "mm/dd/yy" : dateFromPicker=dateserial(arrDate(2),arrDate(0),arrDate(1))
				
		end select
	
	else
	
		dateFromPicker=""
		
	end if
	
	if err.number<>0 then
		dateFromPicker=""
	end if
	
	on error goto 0
	
end function

function dateToPicker(theDate)
	
	on error resume next 

	if not aspL.isEmpty(theDate) then
	
		select case dateformat
		
			case "dd/mm/yy" : dateToPicker=aspl.padLeft(day(theDate),2,0) & "/" & aspl.padLeft(month(theDate),2,0) & "/" & year(theDate)
				
			case "mm/dd/yy" : dateToPicker=aspl.padLeft(month(theDate),2,0) & "/" & aspl.padLeft(day(theDate),2,0) & "/" & year(theDate)
				
		end select
		
	else
		dateToPicker=""
	end if
	
	if err.number<>0 then
		dateToPicker=""
	end if
	
	on error goto 0
	
end function

function initDatePicker (id)

	initDatePicker="$('#" & id & "').datepicker({ changeMonth: true, changeYear: true, yearRange: ""1900:" & year(date)+10 &""",inline: true, dateFormat:'" & dateformat & "'})"

end function


function initheader(title,badge)

	initheader="$('#crmPageTitle').html('" & aspl.htmlEncJs(title) & "');$('#crmBadge').html('" & aspl.convertStr(badge) &"');"

end function

function setBadge(badge)
	
	setBadge="<script>$('#crmBadge').html('" & badge &"');</script>"

end function

function clickEmail(email)
	
	clickEmail="<a class=""link"" href=""mailto:" & email & """>" & email & "</a>"

end function

function clickPhone(phone)
	
	clickPhone="<a class=""link"" href=""tel:" & phone & """>" & phone & "</a>"

end function

function jaNee(bool)

	if aspl.convertBool(bool) then
		jaNee="Ja"
	else
		jaNee="Neen"
	end if

end function

function setPostback

	setPostback="<input type=""hidden"" value=""true"" name=""postback"">" &_
	"<input type=""hidden"" value=""" & aspl.convertNmbr(session.SessionID) & """ name=""asplSessionId"">"
	
end function

function postback

	if aspl.convertBool(aspl.getRequest("postback")) and aspl.convertNmbr(aspL.getRequest("asplSessionId"))=aspl.convertNmbr(session.SessionID) then
		postback=true
	else
		postback=false
	end if 

end function

function convertEuroDate(dt)

	if aspl.isEmpty(dt) then convertEuroDate="" : exit function
	if not isDate(dt) then convertEuroDate=dt  : exit function

	convertEuroDate=aspl.padLeft(day(dt),2,0) & "/" & aspl.padLeft(month(dt),2,0) & "/" & year(dt)
	
end function


function convertEuroDateTime(dt)

	if aspl.isEmpty(dt) then convertEuroDateTime="" : exit function
	if not isDate(dt) then convertEuroDateTime=dt  : exit function

	convertEuroDateTime=aspl.padLeft(day(dt),2,0) &_
						"/" & aspl.padLeft(month(dt),2,0) &_
						"/" & year(dt) &_
						" " & aspl.padLeft(hour(dt),2,0) &_
						":" & aspl.padLeft(minute(dt),2,0) &_
						":" & aspl.padLeft(second(dt),2,0)					

end function

function convertEuroDateTimeWarning(dt,warning)

	if aspl.isEmpty(dt) then
		convertEuroDateTimeWarning="<i>" & warning & "</i>"
	else
		convertEuroDateTimeWarning=convertEuroDateTime(dt)
	end if

end function


function convertCalcDate(dt)

	if aspl.isEmpty(dt) then convertCalcDate="" : exit function
	if not isDate(dt) then convertCalcDate=dt  : exit function

	convertCalcDate=year(dt) & "/" & aspl.padLeft(month(dt),2,0) & "/" & aspl.padLeft(day(dt),2,0)			

end function


function convertCalcDateTime(dt)

	if aspl.isEmpty(dt) then convertCalcDateTime="" : exit function
	if not isDate(dt) then convertCalcDateTime=dt  : exit function
	
	convertCalcDateTime=convertCalcDate(dt) &  " " & aspl.padLeft(hour(dt),2,0) & ":" &  aspl.padLeft(minute(dt),2,0)

end function


function convertCalcDateTimeNoSpecialChars(dt)

	convertCalcDateTimeNoSpecialChars=convertCalcDateTime(dt)
	convertCalcDateTimeNoSpecialChars=replace(convertCalcDateTimeNoSpecialChars,"/","_",1,-1,1)
	convertCalcDateTimeNoSpecialChars=replace(convertCalcDateTimeNoSpecialChars,":","_",1,-1,1)
	convertCalcDateTimeNoSpecialChars=replace(convertCalcDateTimeNoSpecialChars," ","_",1,-1,1)
	
end function


Function RemoveHTML( strText )
    Dim TAGLIST
    TAGLIST = ";!--;!DOCTYPE;A;ACRONYM;ADDRESS;APPLET;AREA;B;BASE;BASEFONT;" &_
              "BGSOUND;BIG;BLOCKQUOTE;BODY;BR;BUTTON;CAPTION;CENTER;CITE;CODE;" &_
              "COL;COLGROUP;COMMENT;DD;DEL;DFN;DIR;DIV;DL;DT;EM;EMBED;FIELDSET;" &_
              "FONT;FORM;FRAME;FRAMESET;HEAD;H1;H2;H3;H4;H5;H6;HR;HTML;I;IFRAME;IMG;" &_
              "INPUT;INS;ISINDEX;KBD;LABEL;LAYER;LAGEND;LI;LINK;LISTING;MAP;MARQUEE;" &_
              "MENU;META;NOBR;NOFRAMES;NOSCRIPT;OBJECT;OL;OPTION;P;PARAM;PLAINTEXT;" &_
              "PRE;Q;S;SAMP;SCRIPT;SELECT;SMALL;SPAN;STRIKE;STRONG;STYLE;SUB;SUP;" &_
              "TABLE;TBODY;TD;TEXTAREA;TFOOT;TH;THEAD;TITLE;TR;TT;U;UL;VAR;WBR;XMP;"
    dim BLOCKTAGLIST
     BLOCKTAGLIST = ";APPLET;EMBED;FRAMESET;HEAD;NOFRAMES;NOSCRIPT;OBJECT;SCRIPT;STYLE;"
    
    Dim nPos1
    Dim nPos2
    Dim nPos3
    Dim strResult
    Dim strTagName
    Dim bRemove
    Dim bSearchForBlock
    
    nPos1 = InStr(strText, "<")
    Do While nPos1 > 0
        nPos2 = InStr(nPos1 + 1, strText, ">")
        If nPos2 > 0 Then
            strTagName = Mid(strText, nPos1 + 1, nPos2 - nPos1 - 1)
    strTagName = Replace(Replace(strTagName, vbCr, " ",1,-1,1), vbLf, " ",1,-1,1)
            nPos3 = InStr(strTagName, " ")
            If nPos3 > 0 Then
                strTagName = Left(strTagName, nPos3 - 1)
            End If
            
            If Left(strTagName, 1) = "/" Then
                strTagName = Mid(strTagName, 2)
                bSearchForBlock = False
            Else
                bSearchForBlock = True
            End If
            
            If InStr(1, TAGLIST, ";" & strTagName & ";", vbTextCompare) > 0 Then
                bRemove = True
                If bSearchForBlock Then
                    If InStr(1, BLOCKTAGLIST, ";" & strTagName & ";", vbTextCompare) > 0 Then
                        nPos2 = Len(strText)
                        nPos3 = InStr(nPos1 + 1, strText, "</" & strTagName, vbTextCompare)
                        If nPos3 > 0 Then
                            nPos3 = InStr(nPos3 + 1, strText, ">")
                        End If
                        
                        If nPos3 > 0 Then
                            nPos2 = nPos3
                        End If
                    End If
                End If
            Else
                bRemove = False
            End If
            
            If bRemove Then
                strResult = strResult & Left(strText, nPos1 - 1)
                strText = Mid(strText, nPos2 + 1)
            Else
                strResult = strResult & Left(strText, nPos1)
                strText = Mid(strText, nPos1 + 1)
            End If
        Else
            strResult = strResult & strText
            strText = ""
        End If
        
        nPos1 = InStr(strText, "<")
    Loop
    
    strResult = strResult & strText 
   
    strResult=Replace(strResult, "&euro;", "€",1,-1,1)
    strResult=Replace(strResult, "<o:p>", "",1,-1,1)
    strResult=Replace(strResult, "</o:p>", "",1,-1,1)       
    strResult=replace(strResult, vbcrlf," ",1,-1,1)  
        
    RemoveHTML = remove2whites(strResult)
End Function

Function RemoveJS( strText )
	dim TAGLIST
   TAGLIST = ";!--;!DOCTYPE;ACRONYM;APPLET;AREA;BASE;BASEFONT;" &_
              "BGSOUND;BODY;BUTTON;CODE;" &_
              "COMMENT;DFN;DIR;EMBED;" &_
              "FORM;FRAME;FRAMESET;HEAD;HTML;IFRAME;" &_
              "INPUT;ISINDEX;KBD;LABEL;LAYER;LAGEND;LINK;LISTING;MAP;" &_
              "MENU;META;NOBR;NOFRAMES;NOSCRIPT;OBJECT;PARAM;PLAINTEXT;" &_
              "Q;S;SAMP;SCRIPT;STYLE;" &_
              "TITLE;VAR;WBR;XMP;"
              
    dim BLOCKTAGLIST 
    BLOCKTAGLIST= ";APPLET;EMBED;FRAMESET;HEAD;NOFRAMES;NOSCRIPT;OBJECT;SCRIPT;STYLE;"
    
    Dim nPos1
    Dim nPos2
    Dim nPos3
    Dim strResult
    Dim strTagName
    Dim bRemove
    Dim bSearchForBlock
    
    nPos1 = InStr(strText, "<")
    Do While nPos1 > 0
        nPos2 = InStr(nPos1 + 1, strText, ">")
        If nPos2 > 0 Then
            strTagName = Mid(strText, nPos1 + 1, nPos2 - nPos1 - 1)
			strTagName = Replace(Replace(strTagName, vbCr, " "), vbLf, " ",1,-1,1)
            nPos3 = InStr(strTagName, " ")
            If nPos3 > 0 Then
                strTagName = Left(strTagName, nPos3 - 1)
            End If
            
            If Left(strTagName, 1) = "/" Then
                strTagName = Mid(strTagName, 2)
                bSearchForBlock = False
            Else
                bSearchForBlock = True
            End If
            
            If InStr(1, TAGLIST, ";" & strTagName & ";", vbTextCompare) > 0 Then
                bRemove = True
                If bSearchForBlock Then
                    If InStr(1, BLOCKTAGLIST, ";" & strTagName & ";", vbTextCompare) > 0 Then
                        nPos2 = Len(strText)
                        nPos3 = InStr(nPos1 + 1, strText, "</" & strTagName, vbTextCompare)
                        If nPos3 > 0 Then
                            nPos3 = InStr(nPos3 + 1, strText, ">")
                        End If
                        
                        If nPos3 > 0 Then
                            nPos2 = nPos3
                        End If
                    End If
                End If
            Else
                bRemove = False
            End If
            
            If bRemove Then
                strResult = strResult & Left(strText, nPos1 - 1)
                strText = Mid(strText, nPos2 + 1)
            Else
                strResult = strResult & Left(strText, nPos1)
                strText = Mid(strText, nPos1 + 1)
            End If
        Else
            strResult = strResult & strText
            strText = ""
        End If
        
        nPos1 = InStr(strText, "<")
    Loop
    
    strResult = strResult & strText
    
    convertTo_iso_8859_1(strResult) 
   
    strResult=Replace(strResult, "&euro;", "€",1,-1,1)
    strResult=Replace(strResult, "<o:p>", "",1,-1,1)
    strResult=Replace(strResult, "</o:p>", "",1,-1,1)       
    strResult=replace(strResult, vbcrlf," ",1,-1,1)  
        
    removeJS = remove2whites(strResult)
	
End Function


function filterJS(s)
	
	dim arrJS, jsKey
	arrJS=array("javascript:", "vbscript:", "onabort", "onactivate", "onafterprint", "onafterupdate", "onbeforeactivate", "onbeforecopy", "onbeforecut", "onbeforedeactivate", "onbeforeeditfocus", "onbeforepaste", "onbeforeprint", "onbeforeunload", "onbeforeupdate", "onblur", "onbounce", "oncellchange", "onchange", "onclick", "oncontextmenu", "oncontrolselect", "oncopy", "oncut", "ondataavailable", "ondatasetchanged", "ondatasetcomplete", "ondblclick", "ondeactivate", "ondrag", "ondragend", "ondragenter", "ondragleave", "ondragover", "ondragstart", "ondrop", "onerror", "onerrorupdate", "onfilterchange", "onfinish", "onfocus", "onfocusin", "onfocusout", "onhelp", "onkeydown", "onkeypress", "onkeyup", "onlayoutcomplete", "onload", "onlosecapture", "onmousedown", "onmouseenter", "onmouseleave", "onmousemove", "onmouseout", "onmouseover", "onmouseup", "onmousewheel", "onmove", "onmoveend", "onmovestart", "onpaste", "onpropertychange", "onreadystatechange", "onreset", "onresize", "onresizeend", "onresizestart", "onrowenter", "onrowexit", "onrowsdelete", "onrowsinserted", "onscroll", "onselect", "onselectionchange", "onselectstart", "onstart", "onstop", "onsubmit", "onunload")
	
	for jsKey=lbound(arrJS) to ubound(arrJS)
		s=replace(s,arrJS(jsKey),"[" & arrJS(jsKey) & "]",1,-1,1)
	next
	
	filterJS=s
	
end function


function remove2whites(byref svalue)

	if instr(svalue,"  ")<>0 then
		svalue=replace(svalue,"  "," ",1,-1,1)
		svalue=remove2whites(svalue)
	end if
	
	remove2whites=svalue
	
end function


function pageBreak

	pageBreak="<div style=""clear:left;display:block;page-break-before:always""></div>"

end function

function disconnectedRS

	set disconnectedRS=server.createobject("adodb.recordset")
	set disconnectedRS.ActiveConnection = Nothing
	disconnectedRS.CursorLocation=3
	disconnectedRS.CursorType=3
	disconnectedRS.LockType=4

end function


dim sha256O
function sha256(value)
	
	if aspl.isEmpty(sha256O) then set sha256O=aspl.plugin("sha256")	
	sha256=sha256O.SHA256(value)
	
end function



function getSiteUrl

	if lcase(aspl.convertStr(request.servervariables("HTTPS")))="on" then
		getSiteUrl="https://"
	else
		getSiteUrl="http://"
	end if
	
	getSiteUrl=getSiteUrl & request.servervariables("HTTP_HOST") & request.servervariables("SCRIPT_NAME") 	
	getSiteUrl=replace(getSiteUrl,"/default.asp","",1,-1,1)
	
end function


function embedYT (value)

	embedYT="<iframe width=""360"" height=""220"" src=""https://www.youtube.com/embed/" & value & """ title=""YouTube video player"" frameborder=""0"" allow=""accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"" allowfullscreen></iframe>"

end function


function clickLink(value)

	if aspl.isEmpty(value) then exit function
	
	if lcase(left(value,4))<>"http" then
		clickLink="http://" & value
	end if

end function

function roundP(defaultvalue,percent)

	if aspl.convertNmbr(percent)=100 then roundP=defaultvalue : exit function

	roundP=round((percent/100)*defaultvalue,0)

end function

function br(value)

	value=aspl.convertStr(value)
	
	br=replace(value,vbcrlf,"<br>",1,-1,1)

end function

function prepPhoneJS
	prepPhoneJS="this.value=this.value.replace(/\s+/g, '');"
	prepPhoneJS=prepPhoneJS & "this.value=this.value.replace('/', '');"
	prepPhoneJS=prepPhoneJS & "this.value=this.value.replace('.', '');"
	prepPhoneJS=prepPhoneJS & "this.value=this.value.replace('-', '');"
end function

function yesNo(bool)

	if aspl.convertBool(bool) then
		yesNo=l("yes")
	else
		yesNo=l("no")
	end if

end function



%>
<!-- #include file="globalfunctions.asp"-->
