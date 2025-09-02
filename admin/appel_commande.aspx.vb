
Partial Class admin_appel_commande
    Inherits System.Web.UI.Page

    Public sPATH As String = ""

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load



        Dim url As String
        Dim tabName As String() = New String(1) {}

        Dim ToolRecup As New Tool_fichet
			dim CurrentDomain as string
		CurrentDomain = request.ServerVariables("SERVER_NAME")
		dim cCde as string  = ToolRecup.get_info_visiteur(CurrentDomain,"commande")
		
				
            Select ToolRecup.get_order_info(Request.QueryString("num_commande"), "environnement").toupper()
                Case "DEFAULT"
					url = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/" & cCde & "/"
				Case "TEST"
					url = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/" & cCde & "/"
				Case "ABLOY"
					url = System.Configuration.ConfigurationManager.AppSettings("urleconabloy")  & "/" & cCde & "/"
				Case "STREMLER"
					url = System.Configuration.ConfigurationManager.AppSettings("urleconstremler")  & "/" & cCde & "/"				
				Case "VACHETTE"
					url = System.Configuration.ConfigurationManager.AppSettings("urleconvachette")  & "/" & cCde & "/"
				Case "YALE"
					url = System.Configuration.ConfigurationManager.AppSettings("urleconyale")& "/" & ccde & "/"
				Case "SHERLOCK"
					url = System.Configuration.ConfigurationManager.AppSettings("urleconsherlock")& "/" & ccde & "/"
                CASE "REHAB"
                    url = System.Configuration.ConfigurationManager.AppSettings("urleconrehab")& "/" & ccde & "/"
                CASE "FSBA"
                    url = System.Configuration.ConfigurationManager.AppSettings("urleconrehab")& "/" & ccde & "/"
				Case Else
                    
						url = System.Configuration.ConfigurationManager.AppSettings("urlecon")
            End Select
		
		
	
		
        
            
       

        tabName = getlongName(Request.QueryString("num_commande").PadLeft(7, "0"))
        url = url & tabName(0) & "/" & tabName(1) & "/CEW" & Request.QueryString("num_commande").PadLeft(7, "0")
        url = url & "_" & Request.QueryString("type")
   
	 Response.Redirect(url)



    End Sub

    Private Function getlongName(ByVal p As String) As String()
        Dim tabName As String() = New String(1) {}
        tabName(0) = p.Substring(0, 3)
        tabName(1) = p.Substring(3, 2)


        Return tabName
    End Function


End Class
