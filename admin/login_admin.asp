<%
utilisateur = ucase(Request("login"))
mot_de_passe = ucase(Request("passwd"))
filtre = ucase(Request("filtre"))
droits = ucase(Request("droits"))
session("admin") = "oui"
 Session("droits") = droits

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

    response.Write("<form method='post' name='form1' action='listcommandehisto.aspx'>") 
    response.Write("<input name='admin' type='text' type='hidden' value='" & session("admin") & "' />") 
    response.Write("<input name='droits' type='text' type='hidden' value='" & droits & "' />") 
    response.Write("<input name='filtre' type='text' type='hidden' value='" & filtre & "' />") 
    response.Write("<input name='charte' type='text' type='hidden' value='" & session("charte") & "' />") 
    response.Write("<input name='utilisateur' type='text' type='hidden' value='" & session("utilisateur") & "' />") 
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