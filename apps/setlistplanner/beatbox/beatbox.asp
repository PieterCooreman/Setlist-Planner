<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
Response.Buffer				= true
Response.ContentType		= "text/html"
Response.CacheControl		= "no-cache"
Response.AddHeader "pragma", "no-cache"
Response.Expires			= -1
Response.ExpiresAbsolute	= Now()-1

dim sBPM : sBPM=trim(request.querystring("sBPM"))
if sBPM="" then sBPM=90
if not isNumeric(sBPM) then sBPM=90
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Setlist Planner Beat Box</title>
</head>
<body style="font-size:16px;background-color:pink">
<script>

	//load some audio samples	
	var kick = new Audio("kick.mp3"); // buffers automatically when created
	var tick = new Audio("tick.mp3");	
	
	var bpm=<%=sBPM%>;
	var origbpm=bpm;
	var started=0;
	var loopkick;
	var looptick;	
	var calcInterval;
	var dotick=true;
	var alwaystick=false;
	var counttick=0;
	var nmbrticks=0;
	var alwaystikk=false;
	var currentBeat=0;
	var kickCount=0;	
	
	function reset() {
		started=0;
		kickCount=0;		
		clearInterval(looptick);
		clearInterval(loopkick);		
		calcInterval=(60 / bpm) * 1000;
		alwaystick=false;
		dotick=true;
		alwaystikk=false;
		counttick=0;
		document.getElementById('stopbutton').style.display='block';		
		}
		
	function restart() {
	
		console.log('Restart');
		
		switch (currentBeat) {
			case 0 : break;
			case 1 : initkick();break;
			case 2 : inittick();break;
			case 3 : initkicktick();break;
			case 4 : initkickticktick();break;			
		}
	
	}
		
	function initkick() {
	
		currentBeat	= 1;
	
		reset();		
		startKick();
		loopkick	= setInterval(startKick,calcInterval);		
	}
	
	function inittick() {
	
		currentBeat	= 2;
	
		reset();		
		alwaystikk	= true;		
		startTick();
		looptick	= setInterval(startTick,calcInterval);		
	}	
	
	function initkicktick() {	
		
		currentBeat	= 3;
	
		reset();				
		startKick();		
		loopkick	= setInterval(startKick,calcInterval);
		looptick	= setInterval(startTick,calcInterval/2);			
	
	}	
	
	function initkickticktick() {
	
		currentBeat		= 4;
	
		reset();	
		alwaystick		= true;	
		nmbrticks		= 2;		
		startKick();	
		loopkick		= setInterval(startKick,calcInterval);
		looptick		= setInterval(startTick,calcInterval*(1/3));				
	
	}

	function startKick() {	

		kickCount++
	
		kick.currentTime = 0;kick.play();	
		
		if (kickCount>1){reset();setTimeout(restart(),calcInterval);}
		
		}
		
	
	function startTick() {		
	
		if (dotick||alwaystick||alwaystikk) {	
		
			counttick++;
			
			if (counttick>nmbrticks&&alwaystick) {
				//reset();restart();return null;	
				return null;					
				}	
			
			tick.currentTime = 0;
			tick.play();					
			dotick=false;			
		}
		else
		{			
			dotick=true;
		}		
				
		}
</script>

<iframe frameborder=no style="width:100%;height:80px" src="../samples/kick/"></iframe>

<!--
<table border="0" cellpadding="5" cellspacing="0" style="width:100%">
	<tr>
		<td style="width:50%">	
			<select onchange="reset();bpm=this.value;restart();" style="width:100%;border-style:none;border-radius:6px;margin-right:8px;margin-bottom:6px;font-size:16px;padding:35px" id="setBPM">
		<%
		dim i
		for i=35 to 250
			response.write "<option value=""" & i & """ "
			
			if cstr(sBPM)=cstr(i) then response.write " selected=""selected"" "
			
			response.write " style=""font-size:16px"">BPM " & i & "</option>"
		next
		%>
		</select>
		</td>
		<td style="width:50%">
			<button id="stopbutton" type="button" style="display:none;border-radius:6px;border-style:none;color:#FFF;background-color:Red;width:100%;font-size:16px;padding:35px;margin-right:6px;margin-bottom:6px" onclick="currentBeat=0;reset();this.style.display='none';">Stop</button>
		</td>
	</tr>
	<tr>
		<td><button type="button" style="border-radius:6px;border-style:none;color:#FFF;background-color:#FF007F;width:100%;font-size:16px;padding:15px;margin-right:6px;margin-bottom:6px" onclick="initkick();">Kick</button></td>
		<td><button type="button" style="border-radius:6px;border-style:none;color:#FFF;background-color:#FF007F;width:100%;font-size:16px;padding:15px;margin-right:6px;margin-bottom:6px" onclick="inittick();">Hi-hat</button></td>
	</tr>
	<tr>
		<td><button type="button" style="border-radius:6px;border-style:none;color:#FFF;background-color:#FF007F;width:100%;font-size:16px;padding:15px;margin-right:6px;margin-bottom:6px" onclick="initkicktick();">Kick + Hi-hat</button></td>
		<td><button type="button" style="border-radius:6px;border-style:none;color:#FFF;background-color:#FF007F;width:100%;font-size:16px;padding:15px;margin-right:6px;margin-bottom:6px" onclick="initkickticktick();">Kick + 2Hh</button></td>
	</tr>	
	<tr>	
		<td colspan=2 style="text-align:center">
		
		<button type="button" style="background-color:#EEEEEE;border-radius:6px;border-style:none;width:25%;font-size:16px;padding:15px;margin-right:6px;margin-bottom:6px" onclick="reset();bpm=origbpm/2;restart();">Half <%=round(sBPM/2,0)%></button>
		<button type="button" style="background-color:#EEEEEE;border-radius:6px;border-style:none;width:25%;font-size:16px;padding:15px;margin-right:6px;margin-bottom:6px" onclick="reset();bpm=origbpm;restart();">Normal <%=sBPM%></button>
		<button type="button" style="background-color:#EEEEEE;border-radius:6px;border-style:none;width:25%;font-size:16px;padding:15px;margin-right:6px;margin-bottom:6px" onclick="reset();bpm=origbpm*2;restart();">Double <%=sBPM*2%></button>
				
		</td>
	</tr>

</table>
-->
</body>
</html>