<meta http-equiv="refresh" content="30;URL="menu_admin_clef.asp" />
<!--#include file="..\include\config.asp"-->
<%
if(Not session("admin") = "oui") then
	response.Redirect "../login.aspx"
End if
%>
<HTML>
<HEAD>
	<TITLE>Menu d'administration des repro</TITLE>
</HEAD>

<BODY>
<CENTER>
<font  SIZE="3">Menu d'administration des commandes de reproduction de clefs</font><br><br>
</center>
<br>
<u>Liste de commandes en attente</u><br><br>
<%
on error resume next

set dataconn = server.CreateObject("ADODB.Connection")
set rsttmp = server.CreateObject("ADODB.recordset")
set rstcli = server.CreateObject("ADODB.recordset")
set rstcomm = server.CreateObject("ADODB.recordset")


dataconn.Open ConnString

temstr = "select * from commandes_repro where transfert = 'non' order by num_commande"
rstcomm.Open temstr,dataconn,1,2
if not rstcomm.EOF then
%>
<table border=1>
<tr><td>Num&eacute;ro</td><td>Date</td><td>Client</td><td>Responsable</td></tr>
<%do
num_comm = rstcomm("num_commande")
cpt = 6 - len(cstr(num_comm))
tt = ""
for i=1 to cpt
tt = tt & "0"
next
num_comm = tt & num_comm
%>
<tr>
<td><a href="commande_repro.asp?nn=<%=rstcomm("num_commande")%>" target="_blanc"><%=num_comm%></a></td>
<td><%=rstcomm("dtcomm")%></td>
<td><%=rstcomm("societe")%></td>
<td><%=rstcomm("Responsable")%></td>
</tr>
<%rstcomm.MoveNext
if rstcomm.EOF then exit do
loop
%>

</table>
<%else%>
Aucune demande en attente ...
<%end if%>
<br>
<br>
<hr>
<a href="liste_commandes_repro.aspx">Consultation des anciennes commandes</a><br>
<br>
</BODY>
</HTML>
<%
function decoup_date(dt)
	if trim(dt) <> "" then
		aa = left(dt,4)
		jj = right(dt,2)
		mm = mid(dt,5,2)
		decoup_date = jj & "/" & mm & "/" & aa
	else
		decoup_date = ""
	end if
end function
%>