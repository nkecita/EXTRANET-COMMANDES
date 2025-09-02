<%
dim utilisateur as string
dim mot_de_passe as string
dim filtre as string
dim droits as string

utilisateur = ucase(request.querystring("login"))
mot_de_passe = ucase(request.querystring("passwd"))
filtre = ucase(request.querystring("filtre"))
droits = ucase(request.querystring("droits"))
session("admin") = "oui"
 Session("droits") = droits
session("client")="ADMIN"
Session("charte")="FICH"
Session("langue") = "fr-FR"
Response.Write("Affichage de la page ... Veuillez patienter")


if droits = "MARCHEENSEMBLE"  then
	response.Write("<form method='post' name='form1' action='etat_marche_ensemble.aspx'>") 
    response.Write("<input name='admin' type='text' type='hidden' value='" & session("admin") & "' />") 
    response.Write("<input name='droits' type='text' type='hidden' value='" & droits & "' />") 
    response.Write("<input name='langue' type='text' type='hidden' value='" & session("langue") & "' />") 
    response.Write("</form>") 
    response.Write("<SCRIPT LANGUAGE=javascript>")
    response.Write("form1.submit();")
	    response.Write("</SCRIPT>")
end if

if droits = "ADMIN" or droits = "CONSULT" or droits = "SUPERVISEUR" then

	response.Write("<form method='post' name='form1' action='listcommandehisto2.aspx'>") 
    response.Write("<input name='admin' type='text' type='hidden' value='" & session("admin") & "' />") 
    response.Write("<input name='droits' type='text' type='hidden' value='" & droits & "' />") 
    response.Write("<input name='filtre' type='text' type='hidden' value='" & filtre & "' />") 
    response.Write("</form>") 
    response.Write("<SCRIPT LANGUAGE=javascript>")
   response.Write("form1.submit();")
	    response.Write("</SCRIPT>")
end if


if droits = "ADMINCLE" then
	response.Write("<form method='post' name='form1' action='../repro.aspx?page=admin/menu_admin_clef.asp'>") 
    response.Write("<input name='admin' type='text' type='hidden' value='" & session("admin") & "' />") 
    response.Write("<input name='droits' type='text' type='hidden' value='" & droits & "' />") 
    response.Write("<input name='filtre' type='text' type='hidden' value='" & filtre & "' />") 
    response.Write("</form>") 
    response.Write("<SCRIPT LANGUAGE=javascript>")
    response.Write("form1.submit();")
        response.Write("</SCRIPT>")
		
end if

'Response.Redirect "../login.aspx"
%>