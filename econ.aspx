
<%@ Page Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<script runat="server">
    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        If (Session("client") Is Nothing Or Session("client") = "") Then
            Response.Redirect("login.aspx")
        End If
        
		dim CurrentDomain as string
		CurrentDomain = request.ServerVariables("SERVER_NAME")
		
        If Request.QueryString("Model") = "Devis" Then
            Dim MyTool As New Tool_fichet
            MyTool.url_econ("",CurrentDomain)
        End If
         If Not Session("charte") Is Nothing Then
            Select Case Session("charte").ToString().ToUpper()
                Case "FICH"
                    if Session("langue") = "it-IT" then
						style_chooser.Attributes("href") = "style/e_style_pff-it.css"
						lbl_e_menu_g.Text = "Italia"
					else
						style_chooser.Attributes("href") = "style/e_style_pff.css"
						if isValidator(Session("client"),connectionString)=true then
							if Session("langue") = "fr-FR" Then
								lbl_e_menu_g.Text = "Connect&eacute; en tant que Point Fort Fichet"
							else if Session("langue") = "nl-BE" Then
								lbl_e_menu_g.Text = "Ingelogd als Point Fort Fichet"							
							else if Session("langue") = "es-ES" Then
								lbl_e_menu_g.Text = "Conectado como Point Fort Fichet"														
							end if			
						else
							if Session("langue") = "fr-FR" Then
								lbl_e_menu_g.Text = "Connect&eacute; en tant que Point Fort Fichet"
							else if Session("langue") = "nl-BE" Then
								lbl_e_menu_g.Text = "Ingelogd als Point Fort Fichet"							
							else if Session("langue") = "es-ES" Then
								lbl_e_menu_g.Text = "Conectado como Point Fort Fichet"														
							end if								
						end if								
					end if	
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

        
    End Sub
    
	Sub btn_logout_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("login.aspx")
    End Sub
	Public Function isValidator(pCodeclient As String, pConnString As String) As Boolean
		Dim isVald As Boolean = False
		Dim sql As String = "SELECT COUNT(*) FROM signature where CodeClient ='" & pCodeclient & "' and  CodeValideur is null"
		Using conn As New SqlConnection(pConnString)
			Dim cmd As New SqlCommand(sql, conn)
			Try
				conn.Open()
				If  Convert.ToInt32(cmd.ExecuteScalar()) = 0 Then
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
    sub go_home(ByVal sender As Object, ByVal e As System.EventArgs)
	  Response.Redirect("login.aspx")
	end sub  	
</script>
<center>

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
    <div id="e_body" align="center" >

	<center>
        <div style="height: 787px; width: 1000px">
            <br />
			
			
            <iframe name="I1" src="<%
                         
                            
						if request.querystring("Model")="Devis"
                            dim sPath as string
							sPath = ""
							If Not Session("charte") Is Nothing Then
								Select Case Session("charte").ToString().ToUpper()
									Case "FICH"
										sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/econ4/"
									Case "TEST"
										sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/econ4test/"
									Case "ABLO"
										sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconabloy") & "/econ4-abloy/"	
									Case "STRE"
										sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconstremler") & "/econ4-stremler/"					
									Case "VACH"
										sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconvachette") & "/econ4-vachette/"
									Case "YALE"
										sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconyale") & "/econ4-yale/"
									Case "SHER"
										sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconsherlock") & "/econ4-sherlock/"
									Case "REHAB"
                                        sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/econ4-rehab/"
                                    Case "FSBA"    
                                        sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/econ4-rehab/"
									Case Else
										
											sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/econ4/"
								End Select
							
							ELSE
							
											sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/econ4/"
							end if

							  dim url as string
                              url = sPath & "eConEngineHtml.aspx?"
							 
                               url = url & "Environment=" & request.querystring("Environment")
                               url = url & "&Model=" & request.querystring("Model")
                               url = url & "&modelversion=" & request.querystring("modelversion")
                               url = url & "&Configuration=" & request.querystring("Configuration")
                               url = url & "&Version=" & request.querystring("Version")
                               url = url & "&language=" & request.querystring("language")
                               url = url & "&Customer=" & request.querystring("Customer")
                               url = url & "&Product=" & request.querystring("Product")
                                  url = url & "&test=" & request.querystring("Product")
                                response.write(url)
                            Else
                            
                            response.write(Session("chaine_econ"))
                            end if
                            %>" frameborder=no scrolling=auto style="height: 96%; width: 100%">
                Votre navigateur ne prend pas en charge les cadres insi?1ri?1s ou est actuellement configuri?1
                pour ne pas les afficher. </iframe>
        </div>
		</center>
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
</center>