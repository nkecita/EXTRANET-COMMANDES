<!DOCTYPE html>
<%@ Page Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>


<script runat="server">

    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        If (Session("client") Is Nothing Or Session("client") = "") Then
            Response.Redirect("loginnew.aspx")
        End If

        Dim CurrentDomain As String
        CurrentDomain = Request.ServerVariables("SERVER_NAME")

        If Request.QueryString("Model") = "Devis" Then
            Dim MyTool As New Tool_fichet
            MyTool.url_econ("", CurrentDomain)
        End If
        If Not Session("charte") Is Nothing Then
            Select Case Session("charte").ToString().ToUpper()
                Case "FICH"
                    If Session("langue") = "it-IT" Then
                        style_chooser.Attributes("href") = "style/e_style_pff-it.css"
                        lbl_e_menu_g.Text = "Italia"
                    Else
                        style_chooser.Attributes("href") = "style/e_style_pff.css"
                        If isValidator(Session("client"), connectionString) = True Then
                            If Session("langue") = "fr-FR" Then
                                lbl_e_menu_g.Text = "Connect&eacute; en tant que Point Fort Fichet"
                            ElseIf Session("langue") = "nl-BE" Then
                                lbl_e_menu_g.Text = "Ingelogd als Point Fort Fichet"
                            ElseIf Session("langue") = "es-ES" Then
                                lbl_e_menu_g.Text = "Conectado como Point Fort Fichet"
                            End If
                        Else
                            If Session("langue") = "fr-FR" Then
                                lbl_e_menu_g.Text = "Connect&eacute; en tant que Point Fort Fichet"
                            ElseIf Session("langue") = "nl-BE" Then
                                lbl_e_menu_g.Text = "Ingelogd als Point Fort Fichet"
                            ElseIf Session("langue") = "es-ES" Then
                                lbl_e_menu_g.Text = "Conectado como Point Fort Fichet"
                            End If
                        End If
                    End If
                Case "STRE"
                    style_chooser.Attributes("href") = "style/e_style_stre.css"
                    lbl_e_menu_g.Text = "Connect&eacute; en tant que concessionnaire Stremler"
                Case "ABLO"
                    style_chooser.Attributes("href") = "style/e_style_abloy.css"
                    lbl_e_menu_g.Text = "Connect&eacute; en tant que client ABLOY"
                Case "VACH"
                    style_chooser.Attributes("href") = "style/e_style_vachette.css"
                    lbl_e_menu_g.Text = "Connect&eacute; en tant que client VACHETTE"
                Case "YALE"
                    style_chooser.Attributes("href") = "style/e_style_yale.css"
                    lbl_e_menu_g.Text = "Connect&eacute; en tant que client YALE"
                Case "SHER"
                    style_chooser.Attributes("href") = "style/e_style_sher.css"
                    lbl_e_menu_g.Text = "Connect&eacute; en tant que client SHERLOCK"
                Case "REHAB"
                    style_chooser.Attributes("href") = "style/e_style_rehab.css"
                    lbl_e_menu_g.Text = "Connect&eacute; en tant que client REHAB"
                Case "FSBA"
                    style_chooser.Attributes("href") = "style/e_style_rehab.css"
                    lbl_e_menu_g.Text = "Connect&eacute; en tant que client Fichet Serrurerie B&acirc;timent"
                Case Else

                    style_chooser.Attributes("href") = "style/e_style_aa.css"

            End Select
        Else


            style_chooser.Attributes("href") = "style/e_style_aa.css"

        End If

        Dim finalUrl As String = String.Empty

        If Request.QueryString("Model") = "DEVIS" Then
            Dim sPath As String = ResolveBasePath()
            '  sPath = sPath.Replace("http", "https")

            ' Construction manuelle de la query string
            Dim sb As New StringBuilder()
            sb.Append("Environment=" & Server.UrlEncode(Request.QueryString("Environment")))
            sb.Append("&Model=" & Server.UrlEncode(Request.QueryString("Model")))
            sb.Append("&modelversion=" & Server.UrlEncode(Request.QueryString("modelversion")))
            sb.Append("&Configuration=" & Server.UrlEncode(Request.QueryString("Configuration")))
            sb.Append("&Version=" & Server.UrlEncode(Request.QueryString("Version")))
            sb.Append("&language=" & Server.UrlEncode(Request.QueryString("language")))
            sb.Append("&Customer=" & Server.UrlEncode(Request.QueryString("Customer")))
            sb.Append("&Product=" & Server.UrlEncode(Request.QueryString("Product")))
            sb.Append("&test=" & Server.UrlEncode(Request.QueryString("Product")))

            finalUrl = sPath & "eConEngineHtml.aspx?" & sb.ToString()
        Else
            If Session("chaine_econ") IsNot Nothing Then
                finalUrl = Session("chaine_econ").ToString()
                finalUrl = finalUrl.Replace("http", "https")
            End If
        End If

        ' Injection de l’iframe
        iframeEcon.Text = "<iframe name='I1' src='" & finalUrl & "' frameborder='0' scrolling='auto' style='height:96%;width:100%'>" &
                  "Votre navigateur ne prend pas en charge les cadres intégrés ou est configuré pour ne pas les afficher." &
                  "</iframe>"

        '   Response.Write(iframeEcon.Text)
    End Sub
    Private Function ResolveBasePath() As String
        Dim charte As String = If(TryCast(Session("charte"), String), "").ToUpper()

        Select Case charte
            Case "FICH" : Return ConfigurationManager.AppSettings("urlecon") & "/econ4/"
            Case "TEST" : Return "https://econ2-test.assaabloy.fr/econ-test/"
            Case "ABLO" : Return ConfigurationManager.AppSettings("urleconabloy") & "/econ4-abloy/"
            Case "STRE" : Return ConfigurationManager.AppSettings("urleconstremler") & "/econ4-stremler/"
            Case "VACH" : Return ConfigurationManager.AppSettings("urleconvachette") & "/econ4-vachette/"
            Case "YALE" : Return ConfigurationManager.AppSettings("urleconyale") & "/econ4-yale/"
            Case "SHER" : Return ConfigurationManager.AppSettings("urleconsherlock") & "/econ4-sherlock/"
            Case "REHAB", "FSBA" : Return ConfigurationManager.AppSettings("urleconrehab") & "/econ4-rehab/"
            Case Else : Return ConfigurationManager.AppSettings("urlecon") & "/econ4/"
        End Select
    End Function

    Sub btn_logout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("loginnew.aspx")
    End Sub
    Public Function isValidator(pCodeclient As String, pConnString As String) As Boolean
        Dim isVald As Boolean = False
        Dim sql As String = "SELECT COUNT(*) FROM signature where CodeClient ='" & pCodeclient & "' and  CodeValideur is null"
        Using conn As New SqlConnection(pConnString)
            Dim cmd As New SqlCommand(sql, conn)
            Try
                conn.Open()
                If Convert.ToInt32(cmd.ExecuteScalar()) = 0 Then
                    isVald = False
                Else
                    isVald = True
                End If
            Catch ex As Exception
                Console.WriteLine(ex.Message)
            End Try
        End Using
        Return isVald
    End Function
    Sub go_home(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("loginnew.aspx")
    End Sub
</script>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>Econ _ Gestion des commandes par le configurateur de produits</title>
    <link runat="server" id="style_chooser" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="MainForm" runat="server">
    <div id="e_top">
        	<div class="e_top_g">
            <a href="/">
                <img src="img/logo_empty.png" border="0" /></a></div>
        <div class="e_top_d">
           
        </div>
    </div>
    <div id="e_top_under">
        &nbsp;</div>
    <div id="e_menu">
        <div class="e_menu_g">
            <asp:Label ID="lbl_e_menu_g" runat="server" /></div>
        <div class="e_menu_d">
		<asp:LinkButton ID="btn_home" runat="server" Text="Home | " OnClick="go_home"
                    Style="text-align: center; text-decoration: none; color: White" />		
                <asp:LinkButton ID="btn_logout" runat="server" Text="D&eacute;connexion" OnClick="btn_logout_Click"
                    Style="text-align: center; text-decoration: none; color: White" />
        </div>
    </div>
  <div id="e_body"; style="height: 787px; width: 1000px">
      
    <asp:Literal ID="iframeEcon" runat="server"></asp:Literal>
</div>
    <div id="e_bottom">
        <div class="e_bottom_g">
            &nbsp;</div>
        <div class="e_bottom_d">
            <img src="img/logo_bottom.png" border="0" alt="" /></div>
    </div>
    </form>
</body>
</html>
