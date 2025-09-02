<!--#include file="..\include\config.asp"-->
<%
if(Not session("admin") = "oui") then
	response.Redirect "../login.aspx"
End if

on error resume next

set dataconn = server.CreateObject("ADODB.Connection")
set rsttmp = server.CreateObject("ADODB.recordset")
set rstcli = server.CreateObject("ADODB.recordset")
set rstcomm = server.CreateObject("ADODB.recordset")
set rstdetail = server.CreateObject("ADODB.recordset")
set rstAdd = server.CreateObject("ADODB.recordset")


dataconn.Open ConnString

temstr = "select * from commandes_repro where num_commande = " & request("nn")
rstcomm.Open temstr,dataconn,1,2
if not rstcomm.EOF then

rstcomm("transfert") = "oui"
rstcomm.Update

temstr = "select * from details_repro where num_commande = " & rstcomm("num_commande")
rstdetail.Open temstr,dataconn,1,3

tt = "select * from clients where codeclient = '" & rstcomm("num_client") & "'"
rstcli.Open tt,dataconn


temstr = "select * from adresses where codeclient = '" & rstcomm("num_client")  & "' and (codeadresse='000000')"
rstAdd.Open temstr,dataconn

num_comm = request("nn")

cpt = 6 - len(cstr(num_comm))
tt = ""
for i=1 to cpt

tt = tt & "0"
next

num_comm = tt & num_comm

%>
<html>
<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<title>NUMERO DE LA COMMANDE : WP<%=num_comm%></title>
</head>
<body>
<div> 
 <img src="../images/bann-mail-fr.jpg" style="width: 598px">
  <table width="600" cellspacing="0" bgcolor="246BCB">
    <tr> 
      <td> 
        <table width="100%" cellspacing="0" bgcolor="">
          <tr> 
            <td bgcolor="#FFFFFF"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td width="47%"><font size="1" color="333333">NUMERO 
                    DE LA COMMANDE : <b>WR<%=num_comm%></b></font></td>
                  <td width="53%"><font size="1" color="333333">DATE 
                    : <b><%=rstcomm("dtcomm")%></b></font></td>
                </tr>
                <tr> 
                  <td colspan="2"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="30%">&nbsp;</td>
                        <td width="70%">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="30%"><font size="1" color="333333">VOS COORDONNEES :</font></td>
                        <td width="70%"><font size="1" color="333333"><%=rstcli("raisonsociale")%>&nbsp;(<%=rstcli("codeclient")%>)</font></td>
                      </tr>
                      <tr> 
                        <td width="30%">&nbsp;</td>
                        <td width="70%"><font size="1" color="333333"><%=rstadd("adresse1")%><br /><%=rstadd("adresse2")%></font></td>
                      </tr>
                      <tr> 
                        <td width="30%">&nbsp;</td>
                        <td width="70%"><font size="1" color="333333"><%=rstadd("codepostal")%></font></td>
                      </tr>
                      <tr> 
                        <td width="30%">&nbsp;</td>
                        <td width="70%"><font size="1" color="333333"><%=rstadd("localite")%></font></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td colspan="2"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="30%"><font size="1" color="333333">ADRESSE 
                          DE LIVRAISON :</font></td>
                        <td width="70%"><font size="1" color="333333"><b><%=rstcomm("societe")%></b></font></td>
                      </tr>
                      <tr> 
                        <td width="30%">&nbsp;</td>
                        <td width="70%"><font size="1" color="333333"><b><%=rstcomm("adresse1")%></b></font></td>
                      </tr>
                                            <tr> 
                        <td width="30%">&nbsp;</td>
                        <td width="70%"><font size="1" color="333333"><b><%=rstcomm("adresse2")%></b></font></td>
                      </tr>
                      <tr> 
                        <td width="30%">&nbsp;</td>
                        <td width="70%"><font size="1" color="333333"><b><%=rstcomm("cdp")%></b></font></td>
                      </tr>
                      <tr> 
                        <td width="30%">&nbsp;</td>
                        <td width="70%"><font size="1" color="333333"><b><%=rstcomm("ville")%></b></font></td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td colspan="2"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="26%"><font size="1" color="333333">NOM 
                          DU RESPONSABLE : </font></td>
                        <td width="26%"><font size="1" color="333333"><%=rstcomm("responsable")%></font></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                      <tr> </tr>
                      <td width="26%"><font size="1" color="333333">TELEPHONE : 
                           </font></td>
                      <td width="19%"><font size="1" color="333333"><%=rstcomm("tel")%></font></td>
                      <td width="55%"><font size="1" color="333333"> 
                        DATE DE LIVRAISON SOUHAITEE : <b><%=rstcomm("delais")%></b></font></td>
                      </tr>
                      <tr> 
                        <td width="26%"><font size="1" color="333333">TELECOPIE :</font></td>
                        <td width="19%"><font size="1" color="333333"><%=rstcomm("fax")%></font></td>
                        <td width="55%">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <br>
</div>
<div>
<table width="600" cellspacing="0" bgcolor="246BCB">
    <tr> 
      <td> 
        <table width="100%" cellspacing="0" bgcolor="">
          <tr> 
            <td bgcolor="#FFFFFF">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="32%"><font size="1" color="333333"><u><b>DETAIL 
                    DE LA COMMANDE</b></u></font></td>
                  <td width="68%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="32%">&nbsp;</td>
                  <td width="68%">&nbsp;</td>
                </tr>
               <tr> 
                  <td colspan=2>
                  <font size="2">
                  <table border="0" cellpadding="0" cellspacing="2" width="100%">
		<tr>							
          <td colspan=2> 
              
            </td>
			</tr>
			<tr><td colspan=2>
			<table border=1>
			<tr><td width="10%" align="center" bgcolor="#CCCCCC"><font size="2"><b>Surete</b></font></td>
      <td width="20%" align="center" bgcolor="#CCCCCC"><font size="2"><b>Numéro carte</b></font></td>
      <td width="20%" align="center" bgcolor="#CCCCCC"><font size="2"><b>Quantité(s)</b></font></td>
      <td width="50%" align="center" bgcolor="#CCCCCC"><font size="2"><b>Référence Client</b></font></td>
      <td></td></tr>			
			<%do%>
			<tr>
			<td width="10%" align="center"><font size="2"><%=rstdetail("surete")%></font></td>
			<td width="20%" align="right"><font size="2"><%=rstdetail("num_carte")%></font></td>
			<td width="20%" align="right"><font size="2"><%=rstdetail("quantite")%></font></td>
			<td width="50%" align="center"><font size="2"><%=rstdetail("ref_client")%></font></td></tr>			
			<%
			rstdetail.MoveNext
			if rstdetail.EOF then exit do
			loop
			%>
	</table></font></td>
                  
                </tr>  
                <tr><td><br><br></td></tr>             
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <br>
 <table width="600" cellspacing="0" bgcolor="246BCB">
    <tr> 
      <td>      
        <table width="100%" cellspacing="0" bgcolor="">
          <tr> 
            <td bgcolor="#FFFFFF">
            
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="34%"><font  size="1" color="333333"><u><b><font  size="1" color="333333">CADRE 
                    RESERVE A L'USINE</font></b></u></font></td>
                  <td width="29%">&nbsp;</td>
                  <td width="37%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="34%">&nbsp;</td>
                  <td width="29%">&nbsp;</td>
                  <td width="37%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="34%">&nbsp;<font  size="1" color="333333">NUMERO 
                    DE LA COMMANDE FSB : </font></td>
                  <td width="29%">___________________</td>
                  <td width="37%"><font  size="1" color="333333"> 
                    NOM : ___________________________</font></td>
                </tr>
                <tr> 
                  <td width="34%">&nbsp;<font  size="1" color="333333">DATE 
                    DE DEPART USINE : </font></td>
                  <td width="29%">___/___/___</td>
                  <td width="37%"><font  size="1" color="333333">SIGNATURE 
                    :</font></td>
                </tr>
                <tr> 
                  <td width="34%">&nbsp;</td>
                  <td width="29%">&nbsp;</td>
                  <td width="37%">&nbsp;</td>
                </tr>
                <tr> 
                  <td width="34%">&nbsp;<font  size="1" color="333333">MONTANT 
                    HT :</font></td>
                  <td width="29%"> _________ €</td>
                  <td width="37%">&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  
</div>
</body>
</html>
<%end if%><%
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