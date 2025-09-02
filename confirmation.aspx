<%@ Page MasterPageFile="~/MainMasterPage.master" Debug="true" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">

    Public sPATH As String = ""
    Public tabName As String() = New String(1) {}
	
    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
'		response.write("TEST CIAGE")       
'	   response.write(Request.QueryString("CleEcon"))
'		response.write(Request.QueryString("no"))
'		response.write(Request.QueryString("document"))
		
'		response.write(session("cleEcon"))
		
		
		If Not Session("charte") Is Nothing Then
            Select Case Session("charte").ToString().ToUpper()
                Case "FICH"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes/"
				Case "TEST"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/commandes_test/"
				Case "ABLO"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconabloy") & "/commandes_abloy/"	
				Case "STRE"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconstremler") & "/commandes_stremler/"					
				Case "VACH"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconvachette") & "/commandes_vachette/"
				Case "YALE"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconyale") & "/commandes_yale/"
				Case "SHER"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconsherlock") & "/commandes_sherlock/"
				Case "REHAB"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/commandes_rehab/"
                Case "FSBA"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconrehab") & "/commandes_rehab/"
                Case Else
                    
						sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon")
            End Select
		
		ELSE
		
						sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon")
		end if
		
		
        'sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon")
  
        If Session("client") <> "" Then
            If Request.QueryString("CleEcon") <> "" Then
                If Request.QueryString("CleEcon") = Session("CleEcon") Then
                    Dim MaTrad As New Tool_fichet
                   
				   
				 
				   
				   
                    If Request.QueryString("document") = "commande" Then
                        tabName = getlongName(Request.QueryString("no").ToString().Substring(3, 7))
                        Response.Redirect(sPATH  & tabName(0) & "/" & tabName(1) & "/" & Request.QueryString("no").ToString().PadLeft(7, "0") & "_TC.html")
                        'Label1.Text = MaTrad.traduction(Session("langue"), "CONFIRMATION", "TEXT1") & " " & Request.QueryString("no").ToString()
					
                    End If
    
                    If Request.QueryString("document") = "config" Then
                        tabName = getlongName(Request.QueryString("no").ToString().PadLeft(7, "0"))
                        ' Response.Redirect("http://econ.fichet-pointfort.fr/commandes/CEW" & Request.QueryString("no").ToString().Substring(6, 4).PadLeft(7, "0") & "_LG.aspx")
                       Label1.Text = MaTrad.traduction(Session("langue"), "CONFIRMATION", "TEXT2") & " " & Request.QueryString("no").ToString()
					
                    End If

                Else
                    'Response.Redirect("login.aspx")
					
				
                End If
            Else
                
                  
				
            End If

        Else
            'Response.Redirect("login.aspx")
				
        End If


    End Sub
    Private Function getlongName(ByVal p As String) As String()
        Dim tabName As String() = New String(1) {}
        tabName(0) = p.Substring(0, 3)
        tabName(1) = p.Substring(3, 2)


        Return tabName
    End Function
</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    <table style="width: 100%;">
        <tr>
            <td>
                &nbsp; 
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td align='left'>
                <asp:Label ID="Label1" runat="server" Style="color: #003399; text-align: left;"></asp:Label>
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
</asp:Content>
