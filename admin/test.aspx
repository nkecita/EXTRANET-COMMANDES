<%@ Page Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<script runat="server">
    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
       response.write(System.Configuration.ConfigurationManager.AppSettings("connectionstring"))
	response.write(request.ServerVariables("SERVER_NAME"))
	session("CHARTE")="FICH"
	response.write("charte : " & Session("charte").ToString().ToUpper())
	response.write(System.Configuration.ConfigurationManager.AppSettings("urlecon"))
	Dim mytool As New Tool_fichet
	response.write(mytool.get_info_visiteur(request.ServerVariables("SERVER_NAME"),"Environnement"))
	response.write(mytool.get_info_visiteur(request.ServerVariables("SERVER_NAME"),"commande"))
	response.write(mytool.get_info_visiteur(request.ServerVariables("SERVER_NAME"),"COMMANDE"))
	response.write(mytool.get_info_visiteur(request.ServerVariables("SERVER_NAME"),"BU"))
    End Sub
</script>

<center>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Econ _ Gestion des commandes par le configurateur de produits</title>
    <link runat="server" id="style_chooser" rel="stylesheet" type="text/css" />
</head>
<body>
   
</body>
</html>