<%
class cls_playlist

	Public iId, sName, sDescription, iUserID, dUpdatedTS, bDeleted, sToken
	Private hasScrollerCSS
	
	Private Sub Class_Initialize		
		iId=0	
		bDeleted=false	
		hasScrollerCSS=false		
	End Sub	
	
	public function check
	
		check=true
		
		if aspl.isempty(sName) then
			aspl.addErr(l("nameismandatory"))
			check=false
		end if		
		
	end function
			
	
	public function pick(id)	
		
		if aspl.isNumber(id) then
		
			dim rs, sql : sql = "select * from tblPlaylist where bDeleted=false and iUserID=" & user.iId & " and iId=" & id
			
			set rs = dba.execute(sql)
			
			if not rs.eof then
			
				iId					= rs("iId")
				sName				= rs("sName")
				iUserID				= rs("iUserID")
				sDescription		= rs("sDescription")
				dUpdatedTS			= rs("dUpdatedTS")
				bDeleted			= rs("bDeleted")
				sToken				= rs("sToken")
	
			end if
			
			set RS = nothing
			
		end if
		
	end function
	
	
	public function save()
	
		if check() then
			save=true
		else
			save=false
			exit function
		end if		
		
		dim rs : set rs = dba.rs		
		
		if iId=0 then			
			rs.Open "select * from tblPlaylist where 1=2"			
			rs.AddNew
			rs("sToken")			= aspl.randomizer.CreateGUID(10)			
		else
			rs.Open "select * from tblPlaylist where bDeleted=false and iUserID=" & user.iId & " and iId="& iId
		end if
		
		rs("sName")					= left(aspl.textonly(sName),255)		
		rs("sDescription")			= aspl.convertStr(aspl.removeTabs(sDescription))
		rs("iUserID")				= aspl.convertNull(user.iId)
		rs("bDeleted")				= aspl.convertBool(bDeleted)
		rs("dUpdatedTS")			= now()	
				
		rs.Update 
		
		iId = aspl.convertNmbr(rs("iId"))		
		
		rs.close
		
		Set rs = nothing		
		
	end function
	
	
	public property get getToken
	
		if aspl.isEmpty(sToken) then
		
			sToken=aspl.randomizer.CreateGUID(10)	
		
			dba.execute("update tblPlaylist set sToken='" & aspl.sqli(sToken) & "' where iId=" & iId)
		
		end if
		
		getToken=getSiteUrl & "/share/?sl=" & iId & "-" & sToken & "-" & user.iLanguageID
	
	end property
	
	
	public property get qr
	
		qr="https://chart.googleapis.com/chart?cht=qr&chs=320x320&chl=" & server.urlEncode(getToken)
	
	end property
	
	
	public function remove
	
		remove=false		
		
		if iId<>0 then
		
			bDeleted=true : save()	

			dba.execute("delete from tblPlaylistSong where iPlaylistID=" & iId)
			
			remove=true
			
		end if
		
	end function
	
	
	public function copy
	
		copy=false
		
		dim oldID : oldID=iId 
	
		if iId<>0 then		
		
			sName=sName & " (" & l("copyw") & ")" 
			iId=0 : save()
			
			'alle songs copieren
			dim rs, rsCopy
			set rs=dba.execute("select * from tblPlaylistSong where iPlaylistID=" & oldID)
			set rsCopy=dba.rs
			rsCopy.open "select * from tblPlaylistSong where 1=2"
			
			while not rs.eof
				
				rsCopy.AddNew
				
				rsCopy("iPlaylistID")	=	iId
				rsCopy("iSongID")		=	rs("iSongID")
				rsCopy("iSort")			=	rs("iSort")
								
				rsCopy.Update
				rs.movenext
				
			wend
			
			set rsCopy=nothing
			set rs=nothing
			
			copy=true
			
		end if
	
	end function
	
	
	public function songids
	
		Set songids = aspL.dict
	
		dim sql : sql="select iSongID from tblPlaylistSong where iPlaylistID=" & iId
		
		dim rs : set rs=dba.execute(sql)				
		
		while not rs.eof					
				
			songids.add aspl.convertNmbr(rs("iSongID")),""	
		
			rs.movenext
			
		wend 
		
		set rs=nothing	
		
	end function
	
	public sub randomize
	
		dim rs : set rs=dba.RS
		rs.open "select iSort, iId from tblPlaylistSong where iPlaylistID=" & iId & " order by Rnd(-Timer() * [iId]) Asc"
				
		dim counter : counter=1		
		while not rs.eof	
			
			rs("iSort")=counter	
			rs.update()
			
			rs.movenext
			counter=counter+1
			
		wend
		
		rs.close
		
		set rs=nothing	
	
	end sub
	
	
	public property get songCount
		
		dim rs : set rs=dba.execute("select count(iId) from tblPlaylistSong where iPlaylistID=" & iId)
		songCount=aspl.convertNmbr(rs(0)) : set rs=nothing
	
	end property
	
	public function songs
	
		Set songs = aspL.dict
	
		dim sql : sql="select iId, iSongID from tblPlaylistSong where iPlaylistID=" & iId & " order by iSort asc"
		
		dim song, rs : set rs=dba.execute(sql)				
		
		while not rs.eof			
		
			set song=new cls_song : song.pick(aspl.convertNmbr(rs("iSongID")))
		
			songs.add aspl.convertNmbr(rs("iId")),song
			
			set song=nothing
		
			rs.movenext
			
		wend 
		
		set rs=nothing	
		
	end function
	
	public function songsFast
	
		Set songsFast = aspL.dict
	
		dim sql
		sql="select tblSong.sTitle, tblSong.sComments, tblSong.sTuning, tblSong.sBPM, tblPlaylistSong.iId, tblPlaylistSong.iSongID, tblPlaylistSong.iSort "
		sql=sql & " from tblPlaylistSong inner join tblSong on tblPlaylistSong.iSongID=tblSong.iId "
		sql=sql & " where tblPlaylistSong.iPlaylistID=" & iId
		sql=sql & " order by tblPlaylistSong.iSort asc"
		
		dim song, rs : set rs=dba.execute(sql)				
		
		while not rs.eof			
		
			set song=new cls_song
			
			song.iId		 	= rs("iSongID")
			song.sTitle		 	= rs("sTitle")
			song.sComments		= rs("sComments")
			song.sBPM		 	= rs("sBPM")
			song.sTitle		 	= rs("sTitle")
			song.sTuning		= rs("sTuning")
			song.iSort			= rs("iSort")
		
			songsFast.add aspl.convertNmbr(rs("iId")),song
			
			set song=nothing
		
			rs.movenext
			
		wend 
		
		set rs=nothing	
		
	end function
	
	
	public function addSong(songID)
	
		dim rs : set rs=dba.execute("select iId from tblPlaylistSong where iPlaylistID=" & iId & " and iSongID=" & songID)
	
		if rs.eof then 
		
			dim rsAdd : set rsAdd=dba.RS
			rsAdd.open "select * from tblPlaylistSong where 1=2"
			
			rsAdd.AddNew
			rsAdd("iSongID")=songID
			rsAdd("iPlaylistID")=iId
			rsAdd("iSort")=songCount+1
			
			rsAdd.Update
			set rsAdd=nothing
		
		end if
		
	end function
	
	
	public function deleteSong(songID)
	
		dim rs : set rs=dba.execute("select iSort from tblPlaylistSong where iPlaylistID=" & iId & " and iId=" & songID)
	
		if not rs.eof then 				
			
			'rangorde herstellen
			dim rsDel
			set rsDel=dba.execute("update tblPlaylistSong set iSort=iSort-1 where iPlaylistID=" & iId & " and iSort>" & aspl.convertNmbr(rs(0)))
			set rsDel=nothing			
			 
			set rsDel=dba.execute("delete from tblPlaylistSong where iId=" & songID)
			set rsDel=nothing	
			
		end if
		
		set rs=nothing
		
	end function
		
	
	public function setSort(ids)
	
		dim sortIDs : sortIDs=split(ids,",")
		
		dim safeID, i, counter : counter=0
		for i=lbound(sortIDs) to ubound(sortIDS)
			counter=counter+1	
			safeID=replace(sortIDs(i),"dd","",1,-1,1)
			safeID=aspl.convertNmbr(safeID)
			if safeID<>0 then dba.execute("update tblPlayListSong set iSort=" & counter & " where iPlaylistID=" & iId & " and iId=" & safeID)
		next	
		
	end function
	
	
	public function canBeDeleted
	
		canBeDeleted=true
		
		if iId=0 then canBeDeleted=false
	
	end function	
	
		
	public function scroller
	
		scroller="<div class=""no-print""><button class=""autoscroll"" style=""font-size:16px;border-style:none;background-color:#DC3545;color:#FFF;padding:17px;border-radius:6px;margin-right:5px;margin-top:10px"" "
		scroller=scroller & "onclick=""scrollpage(this);return false;"" href=""#"">Autoscroll</button>"
		scroller=scroller & "<button onclick=""scrollStarted=0;clearInterval(intervalId);intervalTimeout=intervalTimeout+25;scrollpage(this);return false;"" style=""visibility:hidden;font-size:16px;border-style:none;background-color:#DC3545;color:#FFF;padding:17px;border-radius:6px;margin-right:5px"" class=""tweak"">&nbsp;&nbsp;-&nbsp;&nbsp;</button>"
		scroller=scroller & "<button onclick=""scrollStarted=0;clearInterval(intervalId);intervalTimeout=intervalTimeout-25;scrollpage(this);return false;"" style=""visibility:hidden;font-size:16px;border-style:none;background-color:#DC3545;color:#FFF;padding:17px;border-radius:6px;"" class=""tweak"">&nbsp;&nbsp;+&nbsp;&nbsp;</button></div>"		
		
		'add no-rpint some style
		if not hasScrollerCSS then
			hasScrollerCSS=true
			scroller=scroller & "<style>@media print {.no-print, .no-print * { display: none !important;}}</style>"
		end if		
	
	end function
	
	
	private function nav(counter,includeJS,songObj,includeMetronome)
	
			nav="<p style=""margin-top:25px;margin-bottom:25px"">"			
			nav=nav & "<a style=""border-radius:6px;color:#111;text-decoration:none;background-color:#FFC107;margin-right:10px;margin-top:15px;padding:17px"" href=""#top"">&nbsp;&nbsp;Top&nbsp;&nbsp;</a>"
			nav=nav & "<a style=""border-radius:6px;color:#EEE;text-decoration:none;background-color:#0B5ED7;margin-right:10px;margin-top:15px;padding:17px"" href=""#songID"&counter+1&""">&nbsp;&nbsp;" & l("next") & "&nbsp;&nbsp;</a>"
			nav=nav & "<a style=""border-radius:6px;color:#EEE;text-decoration:none;background-color:#198754;margin-right:10px;margin-top:15px;padding:17px"" href=""#songIDChords"&counter&""">&nbsp;&nbsp;" & l("chords") & "&nbsp;&nbsp;</a>"
									
			if includeJS then				
			
				if includeMetronome and not aspl.isEmpty(songObj.sBPM) and currentPayment.iId<>0 then
					
					nav=nav & "<a style=""border-radius:6px;color:#EEE;text-decoration:none;background-color:#FF007F;margin-right:10px;margin-top:15px;padding:17px"" href=""#"" onclick=""if(document.getElementById('beatbox" & songObj.iId & "').style.display=='block'){document.getElementById('beatbox" & songObj.iId & "').style.display='none'} else {document.getElementById('beatbox" & songObj.iId & "').style.display='block';document.getElementById('beatbox" & songObj.iId & "').innerHTML='" & aspl.htmlEncJS(songObj.beatbox) & "'};return false;"">&nbsp;&nbsp;Beatbox&nbsp;&nbsp;</a>"				
								
					nav=nav & "<a style=""border-radius:6px;color:#111;text-decoration:none;background-color:#0DCAF0;margin-right:10px;margin-top:15px;padding:17px"" href=""#"" onclick=""if(document.getElementById('metronome" & songObj.iId & "').style.display=='block'){document.getElementById('metronome" & songObj.iId & "').style.display='none'} else {document.getElementById('metronome" & songObj.iId & "').style.display='block';document.getElementById('metronome" & songObj.iId & "').innerHTML='" & aspl.htmlEncJS(songObj.metronome) & "'};return false;"">" & l("metronome") & "</a>"
					
					
					nav=nav &  "<div id=""metronome" & songObj.iId & """ style=""margin-top:10px;display:none""></div>"
				
					nav=nav &  "<div id=""beatbox" & songObj.iId & """ style=""margin-top:10px;display:none""></div>"
				end if				
				
				nav=nav &  "<div>" & scroller & "</div>"
				
			end if
			
			nav=nav & "</p><div style=""clear:both""></div>"
	
	end function
	
	public function htmlHeader
	
		htmlHeader="<table cellspacing=""0"" cellpadding=""8"" style=""border-radius:6px;width:100%;background-color:#444444""><tr><td style=""width:40px"">"
		htmlHeader=htmlHeader & "<a target=""_blank"" href=""http://www.setlistplanner.com"">"
		htmlHeader=htmlHeader & "<img border=""0"" style=""border-style:none"" alt=""" & system.sName & """ src=""" & getSiteUrl & "/" & myApp.sPath & "/image/logo.png"" />"
		htmlHeader=htmlHeader & "</a></td>"
		htmlHeader=htmlHeader & "<td style=""color:#EEE;"">created by <strong><a style=""text-decoration:none;color:#EEE"" target=""_blank"" href=""http://www.setlistplanner.com"">Setlist Planner</strong></a>"
		htmlHeader=htmlHeader & "</td>"
		htmlHeader=htmlHeader & "<td>###BUTTON###</td></tr></table>"
		
	end function
	
	public function html(includeJS)
	
		dim drawLyrics, counter, records, song, songsCopy : set songsCopy=songs : records="<a name=""top""></a>" : counter=0
				
		records=records & "<div style=""XXXXXXX"">"		
		records=records & htmlHeader		
		records=records & "<h1 style=""color:#000000"">" & aspl.htmlEncode(sName) & " (" & songsCopy.count & " " & lcase(l("songs")) & ")</h1>"
		records=records & "<h3 style=""color:#000000"">" & aspl.htmlEncode(sDescription) & "</h3>"
		records=records & "</div>"

		records=records & "<table style=""color:#000000;width:100%;font-family:Arial;font-size:16px"" border=""1"" cellpadding=""5"" cellspacing=""0"">"
		records=records & "<thead>"
		records=records & "<tr>"
		records=records & "<th>N°</th>"
		records=records & "<th>" & l("song") & "</th>"
		records=records & "<th>" & l("artist") & "</th>"
		records=records & "<th>" & l("comments") &"</th>"
		records=records & "<th>" & left(l("tuning"),1) & "</th>"
		records=records & "<th>BPM</th>"		
		records=records & "</tr>"		
		records=records & "</thead>"
		records=records & "<tbody>"		
		
		for each song in songsCopy
		
			counter=counter+1
			
			records=records & "<tr>"
			records=records & "<td style=""text-align:center"">" & counter & "</td>"
			records=records & "<td style=""min-width:150px;text-align:left"">"			
			
			if includeJS then		
			
				records=records & "<button style=""font-weight:700;width:100%;text-align:left;border-style:none;border-radius:6px;font-size:16px;padding:15px;background-color:#666;color:White"" onclick=""location.assign('#songID" & counter & "');"">" & aspl.htmlEncode(songsCopy(song).sTitle) & "</button>"
			
			else
			
				records=records & "<a style=""font-weight:700;font-size:16px;"" href=""#songID" & counter & """>" & aspl.htmlEncode(songsCopy(song).sTitle) & "</a>"
			
			end if
			
			records=records & "</td>"
			records=records & "<td>" & aspl.htmlEncode(songsCopy(song).sArtist) & "</td>"
			records=records & "<td>" & aspl.htmlEncode(songsCopy(song).sComments) & "</td>"
			records=records & "<td style=""text-align:center"">" & aspl.htmlEncode(songsCopy(song).sTuning) & "</td>"
			records=records & "<td style=""text-align:center"">" & aspl.htmlEncode(songsCopy(song).sBPM) & "</td>"
			records=records & "</tr>"
		next
		
		records=records & "</tbody></table>"
		
		records=records & "<div style=""page-break-after: always;""></div>"

		counter=0
		for each song in songsCopy		
		
			set song=songsCopy(song)
		
			counter=counter+1	
			
			records=records & "<a name=""songID" & counter & """ alt="""" href=""#""></a><br><br>"						
			records=records & "<div>"
			records=records & "<h2 style=""color:#000000"">" & counter & ". " & aspl.htmlEncode(song.sTitle) &" (" & aspl.htmlEncode(song.sArtist)  & ")</h2>"	
						
			'################################### nav
			records=records & nav(counter,includeJS,song,true)
			'################################### end nav
			
			records=records & "<p style=""background-color:Darkred;color:#EEE;padding:10px;border-radius:6px"">"			
			
			records=records & aspl.htmlEncode(song.sComments) 
			
			if not aspl.isEmpty(song.sTuning) then
				records=records & "&nbsp;" & l("tuning") & ": <strong>" & aspl.htmlEncode(song.sTuning)  & "</strong>"
			end if
			
			if not aspl.isEmpty(song.sBPM) then
				records=records & "&nbsp;BPM: <strong>" & aspl.htmlEncode(song.sBPM)& "</strong>"
			end if
			
			records=records & "</p>"	
			
			'song files
			dim songfile,songfiles : set songfiles=song.files			
			
			if songfiles.count>0 and currentpayment.iId<>0 then			
				
				dim images, thumbsize
				
				if includeJS then
					thumbsize=130					
				else
					thumbsize=1000
				end if
				
				for each songfile in songfiles
				
					records=records & "<div style=""border-radius:6px;border:1px solid #CCC;padding:10px;text-align:center;float:left;width:"
					
					if includeJS then
						records=records & thumbsize & "px;"
					else
						records=records & "95%;"
					end if
					
					records=records & ";background-color:#EEEEEE;margin-top:1px;margin-right:10px"">"
									
					select case lcase(songfiles(songfile).sExt)
					
						case "jpg","jpeg","gif","png"
						
							if includeJS then
								records=records & "<a style=""font-size:13px;color:#111;text-decoration:none;"" target=""_blank"" href=""" & songfiles(songfile).imageSrc(1600) & """><img alt=""" & aspl.htmlEncode(songfiles(songfile).sFilename) & """ src=""" & songfiles(songfile).imageSrc(thumbsize) & """ style=""border-radius:6px;width:100%"" /><br />"
							else
								records=records & "<a href=""#""><img alt=""" & aspl.htmlEncode(songfiles(songfile).sFilename) & """ src=""" & songfiles(songfile).imageSrc(thumbsize) & """ style=""border-radius:6px;width:100%"" /><br />"
							end if
							
						case else
						
							records=records & "<a style=""color:#111;text-decoration:none;"" href=""" & directlink("song_filedownload.asp","&iId=" & songfile) & """>"
						
						
					end select				
					
					records=records & aspl.htmlEncode(songfiles(songfile).sFilename) & "." & aspl.htmlEncode(songfiles(songfile).sExt) & "</a></div>"
					
				next				
				
				records=records & "<div style=""clear:both""><br /></div>"
				
			end if			

			drawLyrics=br(aspl.htmlEncode(song.drawLyrics))
			
			if not aspl.isEmpty(drawLyrics) then
				records=records & "<div style=""border-radius:6px;background-color:#FFFFFF;color:#000000;padding:20px;font-size:16px;"">" & drawLyrics & "</div>"				
			end if			

			'######################################## nav
			records=records & nav(counter,includeJS,song,false)
			'######################################## end nav			
			
			if not aspl.isEmpty(song.sLyrics) then				
				records=records & "<a name=""songIDChords" & counter & """></a><pre style=""border-radius:6px;background-color:#FFFFFF;color:#000000;padding:20px;overflow:scroll;"">" & aspl.htmlEncode(song.sLyrics) & "</pre>"
			end if			
						
			records=records & "</div>"		
			
			if counter<songscopy.count then
				records=records & nav(counter,includeJS,song,false)
				records=records & "<div style=""page-break-after: always;""></div>"
			end if
			
			set song=nothing
			
		next
		
		set songsCopy=nothing
				
		dim cdomessage : set cdomessage=aspL.plugin("cdomessage")
		records=cdomessage.wrapInHTML(records,sName)
		
		set cdomessage=nothing
		
		
		records=replace(records,"</head>",aspl.loadText(myApp.sPath & "/includes/socialsharing.txt") & vbcrlf & "</head>",1,-1,1)
		records=replace(records,"[siteurl]",getSiteUrl & "/",1,-1,1)
		records=replace(records,"<body>","<body style=""font-family:Arial;font-size:16px;font-color:#000000;background-color:#FFFFFF"">",1,-1,1)
		
		if includeJS then
			records=replace(records,"</head>","<script>" & vbcrlf & aspl.loadText(myApp.sPath & "/includes/scroll.js") & vbcrlf & "</script>" & vbcrlf & "</head>",1,-1,1)
		end if		
				
		html=records

	end function

	public sub mail
	
		dim cdomessage : set cdomessage=aspL.plugin("cdomessage")		
		cdomessage.receiveremail=user.sEmail
		cdomessage.subject=sName	
		cdomessage.body=replace(html(false),"###BUTTON###","",1,-1,1)
		cdomessage.send
		set cdomessage=nothing
	
	end sub
	

end class

class cls_playlists

	public list

	Private Sub Class_Initialize		
		
		Set list = aspL.dict
	
		dim sql : sql="select * from tblPlaylist where bDeleted=false and iUserID=" & user.iId & " order by sName"
		
		dim playlist, rs : set rs=dba.execute(sql)				
		
		while not rs.eof			
		
			set playlist=new cls_playlist : playlist.pick(aspl.convertNmbr(rs("iId")))
		
			list.add playlist.iId,playlist
			
			set playlist=nothing
		
			rs.movenext
			
		wend 
		
		set rs=nothing			

	End Sub	
	
	
	
	Private Sub Class_Terminate
	
		Set list = nothing
		
	End Sub	
	

end class

%>