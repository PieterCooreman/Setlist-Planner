<%
aspl(myApp.sPath & "/includes/begin.asp")

dim playlist : set playlist=new cls_playlist : playlist.pick (form.request("iId"))
'security
if aspl.convertNmbr(playlist.iId)=0 then aspl.die

form.writejs modalLabelXL(playlist.sName & " (" & playlist.songsFast.count & " " & lcase(l("songs")) & ")")

'quickjump
dim quickjump : set quickjump=form.field("select")
quickjump.add "options",songDict
quickjump.add "emptyfirst"," QuickJump to..."
quickjump.add "onchange","if(this.value!=''){" & loadmodalXLiId("song_view.asp","' + this.value + '","&qj=1") & "};"
quickjump.add "class","form-control"
quickjump.add "style","width:50%"
quickjump.add "name","iQJiId"
if not aspl.isEmpty(form.request("qj")) then
	quickjump.add "value",song.iId
end if

form.newline

form.write "<iframe id=""golive"" height=""1000px"" frameborder=""no"" src="""" style=""border:0;border-style:none;width:100%""></iframe>"

form.writejs "refreshIframeReset='" & playlist.gettoken & "';refreshIframe='" & playlist.gettoken & "&noheader=1&colormode=' + localStorage.getItem('theme');document.getElementById('golive').src=refreshIframe;"

%>