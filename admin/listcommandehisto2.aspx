<%@ Page MasterPageFile="~/admin/AdminMasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
   
    Public sPATH As String = ""
    Public tabName As String() = New String(1) {}
	    Public libcde as string =""
	'aeh
    Sub ApplyFilter_Click(ByVal Sender As Object, ByVal E As EventArgs)
        If Not IsNothing(numCmd.Text) Then
			RechercherParNumCmd(numCmd.Text)
		else
			RechercherParNumCmd(String.Empty)		
		End If
    End Sub	
	Sub RechercherParNumCmd(sFiltre as String)

	IF Session("charte").ToString().ToUpper() = "REHAB" then
		libcde="commandes_portes_rehab"
	Else
		libcde="commandes_portes"
	End If	
	
	
      SqlDataSource3.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")
		dim CurrentDomain as string
		CurrentDomain = request.ServerVariables("SERVER_NAME")
		
		Dim mytool As New Tool_fichet
		mytool.get_info_visiteur(CurrentDomain,"commande")
			
			
		Dim cBu As String
		dim cCde as string
		ccde = mytool.get_info_visiteur(CurrentDomain,"COMMANDE")
		cBu  = mytool.get_info_visiteur(CurrentDomain,"BU")

		If Not Session("charte") Is Nothing Then
			Select cBu.ToString().ToUpper()
				Case "FICH"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/" & ccde & "/"
				Case "TEST"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon") & "/" & ccde & "/"
				Case "ABLO"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconabloy") & "/" & ccde & "/"
				Case "STRE"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconstremler") & "/" & ccde & "/"			
				Case "VACH"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconvachette")& "/" & ccde & "/"
				Case "YALE"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconyale")& "/" & ccde & "/"
				Case "SHER"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconsherlock")& "/" & ccde & "/"
				Case "REHAB"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconrehab")& "/" & ccde & "/"
                Case "FSBA"
					sPATH = System.Configuration.ConfigurationManager.AppSettings("urleconrehab")& "/" & ccde & "/"
				Case Else
					
						sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon")
			End Select
		ELSE
			sPATH = System.Configuration.ConfigurationManager.AppSettings("urlecon")
		end if

		Dim cEnviron As String
		cEnviron  = mytool.get_info_visiteur(CurrentDomain,"Environnement")

		If Session("filtre") <> "" Then 
			SqlDataSource3.SelectCommand = "SELECT [num_commande], [dtcomm],hrcomm,[societe], [num_client], [ref_client], [delai],  [prix_valideur],[prix_pointfort], [modele],status,souche FROM " & libcde & " where 1=1" & " AND Environnement ='" & cEnviron & "'"  & Session("filtre") & "  "& IIf (String.IsNullOrEmpty(sFiltre), String.Empty, " AND num_commande like '" & sFiltre &"'") &" order by num_commande desc "
		Else
			SqlDataSource3.SelectCommand = "SELECT [num_commande], [dtcomm],hrcomm,[societe], [num_client], [ref_client], [delai],  [prix_valideur],[prix_pointfort], [modele],status,souche FROM " & libcde & " where Environnement ='" & cEnviron & "' " & IIf (String.IsNullOrEmpty(sFiltre), String.Empty, " AND num_commande like '" & sFiltre &"'") &"  order by num_commande desc "
		End If
       
        If Session("client") <> "ADMIN" Then
            Response.Redirect("../login.aspx")
	
        End If
	   
	End sub	
	'fin aeh
    
    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
		'aeh
		Dim MaTrad As New Tool_fichet
		Button1.text = MaTrad.traduction(IIf (Session("langue") Is Nothing, String.Empty, Session("langue")), "LISTCOMMANDEHISTO", "BUTTON1")
		'if not IsPostBack then
			RechercherParNumCmd(String.Empty)
		'end if
		'fin aeh
    End Sub
	
    Protected Sub GridView3_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles Gridview3.RowDataBound
        If e.Row.RowType = DataControlRowType.Header Then
            
            e.Row.Cells(10).Text = "Statut"
        End If

        Dim ToolRecup As New Tool_fichet

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim Lblcde As Label
            Lblcde = e.Row.FindControl("cde")
            tabName = getlongName(Lblcde.Text.Trim.PadLeft(7, "0"))
			
	 Dim souche As String = DataBinder.Eval(e.Row.DataItem, "souche").ToString()

        ' Extraire la souche (3 premiers caractères)
			
            e.Row.Cells(9).Text = "<a href='" & sPATH  & tabName(0) & "/" & tabName(1) & "/"& souche & Lblcde.Text.Trim.PadLeft(7, "0") & "_AT.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"
         
            
          
        
            Dim lblClient As Label
            lblClient = e.Row.FindControl("NumClient")
            Dim recupvalideur As String
            recupvalideur = ""
            
            recupvalideur = ToolRecup.get_valideur_info(lblClient.Text, "codeclient")
            tabName = getlongName(Lblcde.Text.Trim.PadLeft(7, "0"))
            
            If recupvalideur <> "" Then
                e.Row.Cells(2).Text = recupvalideur
                e.Row.Cells(6).Text = ToolRecup.get_order_info(Lblcde.Text.Trim, "ref_valideur")
            
                    e.Row.Cells(7).Text = "<a href='" & sPATH  & tabName(0) & "/" & tabName(1) & "/" & souche & Lblcde.Text.Trim.PadLeft(7, "0") & "_TA.HTML" & "' target='_BLANK'>" & e.Row.Cells(7).Text & "</a>"
               
               
            Else
               
                    e.Row.Cells(7).Text = "<a href='" & sPATH  & tabName(0) & "/" & tabName(1) & "/"& souche & Lblcde.Text.Trim.PadLeft(7, "0") & "_TA.HTML" & "' target='_BLANK'>" & e.Row.Cells(7).Text & "</a>"
               
                
            End If
            
            recupvalideur = ToolRecup.get_valideur_info(lblClient.Text, "raisonsociale")
            If recupvalideur <> "" Then
                e.Row.Cells(3).Text = recupvalideur
            End If
            
            
           
            Dim MaTrad As New Tool_fichet
            Dim Lblstatut As Label
            Lblstatut = e.Row.FindControl("statut")
         
            Select Case Lblstatut.Text.Trim
                Case "-1"
                    e.Row.Cells(10).Text = "<img src='../images/statut_annulee.png'  border='0' title='" & MaTrad.traduction("fr-FR", "ARCHIVE_ECON", "STATUTM1") & "'>"
                Case "0"
                    e.Row.Cells(10).Text = "<img src='../images/statut_attente_distributeur.png'  border='0' title='" & MaTrad.traduction("fr-FR", "ARCHIVE_ECON", "STATUT0") & "'>"
                Case "1"
                    e.Row.Cells(10).Text = "<img src='../images/statut_attente.png'  border='0' title='" & MaTrad.traduction("fr-FR", "ARCHIVE_ECON", "STATUT1") & "'>"
                Case "2"
                    e.Row.Cells(10).Text = "<img src='../images/statut_prise-en-compte.png'  border='0' title='" & MaTrad.traduction("fr-FR", "ARCHIVE_ECON", "STATUT2") & "'>"
                Case "3"
                    e.Row.Cells(10).Text = "<img src='../images/statut_confirmee.png'  border='0' title='" & MaTrad.traduction("fr-FR", "ARCHIVE_ECON", "STATUT3") & "'>"
                Case "4"
                    e.Row.Cells(10).Text = "<img src='../images/statut_fabriquee.png'  border='0' title='" & MaTrad.traduction("fr-FR", "ARCHIVE_ECON", "STATUT4") & "'>"
                Case "5"
                    e.Row.Cells(10).Text = "<img src='../images/statut_expediee.png'  border='0' title='" & MaTrad.traduction("fr-FR", "ARCHIVE_ECON", "STATUT5") & "'>"
                Case "2R"
                    e.Row.Cells(10).Text = "<img src='../images/statut_refusee.png'  border='0' title='" & MaTrad.traduction("fr-FR", "ARCHIVE_ECON", "STATUT2R") & "'>"
                Case "6"
                    e.Row.Cells(10).Text = "<img src='../images/statut_livree.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT6") & "'>"
                Case Else
                    e.Row.Cells(10).Text = ""
            End Select
         
            If affiche_commande(Lblcde.Text) = False Then
                e.Row.Cells(10).Text = ""
            End If



        End If
    End Sub
    Private Function affiche_commande(ByVal wCde As String) As Boolean
     

        Dim connectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")

        Dim dbConnection As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString)

		
		   Dim cEnviron As String
			dim CurrentDomain as string
		Dim ToolRecup As New Tool_fichet
		CurrentDomain = request.ServerVariables("SERVER_NAME")
		cEnviron  = ToolRecup.get_info_visiteur(CurrentDomain,"Environnement")
		
		   
		IF Session("charte").ToString().ToUpper() = "REHAB" then
			libcde="commandes_portes_rehab"
		Else
			libcde="commandes_portes"
		End If	
	
		Dim cSql As String

		
		
        cSql = " SELECT * FROM " & libcde & _
                                " WHERE     (num_commande=" & wCde & ")" & _
								" AND Environnement ='" & cEnviron & "'"



        Dim dbCommand As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
        dbCommand.CommandText = cSql
        dbCommand.Connection = dbConnection

        Dim dataAdapter As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
        dataAdapter.SelectCommand = dbCommand
        Dim dsCommande As System.Data.DataSet = New System.Data.DataSet
        dataAdapter.Fill(dsCommande)



        Dim i As Integer

        For i = 0 To dsCommande.Tables(0).Rows.Count - 1
            ' Console.WriteLine(dsCommande.Tables(0).Rows(i).Item(3).ToString)


            Dim connectionString2 As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")

            Dim dbConnection2 As System.Data.IDbConnection = New System.Data.SqlClient.SqlConnection(connectionString2)

            cSql = "SELECT content FROM econelements WHERE econelements.name='" & _
                                 dsCommande.Tables(0).Rows(i).Item("configuration").ToString & _
                                  "' AND modelversion>='9'"



            Dim dbCommand2 As System.Data.IDbCommand = New System.Data.SqlClient.SqlCommand
            dbCommand2.CommandText = cSql
            dbCommand2.Connection = dbConnection

            Dim dataAdapter2 As System.Data.IDbDataAdapter = New System.Data.SqlClient.SqlDataAdapter
            dataAdapter2.SelectCommand = dbCommand
            Dim dsEcon As System.Data.DataSet = New System.Data.DataSet
            dataAdapter.Fill(dsEcon)





            If dsEcon.Tables(0).Rows.Count = 1 Then
                Return True
            End If
            Return False



        Next
    End Function
    
    Private Function getlongName(ByVal p As String) As String()
        Dim tabName As String() = New String(1) {}
        tabName(0) = p.Substring(0, 3)
        tabName(1) = p.Substring(3, 2)


        Return tabName
    End Function
            
   
</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    <div class="e_menu_title" style="width: 90%">
        Menu d'administration des commandes 
    </div>
    <br />
    <br />	
	<!-- aeh -->
    <table cellpadding="0" cellspacing="0" width="400px" class="e_color_back" border="0">
        <tr>
            <td class="e_menu_title" colspan="3">
                <%  Dim MaTrad As New Tool_fichet
                    Response.Write(MaTrad.traduction(Session("langue"), "LISTCOMMANDEHISTO", "TITRE1"))%>
            </td>
        </tr>
        <tr>
            <td style="height: 10px" colspan="3">
            </td>
        </tr>
        <tr>
            <td style="height: 5px" colspan="3">
            </td>
        </tr>
        <tr>
            <td align="left">
                <% Response.Write(MaTrad.traduction(Session("langue"), "LISTCOMMANDEHISTO", "TEXT1"))%>
            </td>
            <td>
            </td>
            <td align="left">
                <asp:TextBox ID="numCmd" runat="server"> </asp:TextBox>&nbsp;
                <asp:Button ID="Button1" OnClick="ApplyFilter_Click" runat="server" 
                    Style="text-align: center"></asp:Button>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                &nbsp; &nbsp;
            </td>
        </tr>
    </table>	
    <br />	
	<!-- fin aeh -->
    <asp:GridView ID="Gridview3" runat="server" CellPadding="3" ForeColor="Black" EnableViewState="False"
         AutoGenerateColumns="False" DataSourceID="SqlDataSource3"
        Style="margin-right: 42px" Width="752px" AllowPaging="True" PageSize="50" AllowSorting="True" font-size="12px">
        <Columns>
 <asp:TemplateField HeaderText="Commande">
  
    <ItemTemplate>
        <asp:HyperLink 
            ID="lnkCommande" 
            runat="server" 
            Text='<%# Eval("souche")& Eval("num_commande")  %>' 
            NavigateUrl='<%# "..\affiche_commande.aspx?num_commande=" & Eval("num_commande")& "&type=FR.aspx" %>' 
            Target="_blank" />
    </ItemTemplate>
</asp:TemplateField>
				
            <asp:BoundField DataField="dtcomm" HeaderText="Date" SortExpression="dtcomm"></asp:BoundField>
            <asp:BoundField DataField="hrcomm" HeaderText="Heure" SortExpression="hrcomm"></asp:BoundField>
            <asp:TemplateField Visible="true" HeaderText="Client">
                <ItemTemplate>
                    <asp:Label ID="NumClient" runat="server" Text='<%# Bind("num_client") %>' headertext="Client"></asp:Label>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>
            <asp:BoundField DataField="societe" HeaderText="Société" SortExpression="societe">
            </asp:BoundField>
            <asp:BoundField DataField="modele" HeaderText="Porte"></asp:BoundField>
            <asp:BoundField DataField="ref_client" HeaderText="Ref Commande"></asp:BoundField>
            <asp:BoundField DataField="prix_pointfort" HeaderText="Prix" DataFormatString="{0:C2}">
                <HeaderStyle Width="100px" />
                <ItemStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
                    Font-Underline="False" HorizontalAlign="Right" />
            </asp:BoundField>
            <asp:TemplateField Visible="false">
                <ItemTemplate>
                    <asp:Label ID="cde" runat="server" Text='<%# Bind("num_commande") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>
            <asp:TemplateField></asp:TemplateField>
            <asp:TemplateField></asp:TemplateField>
            <asp:TemplateField Visible="False">
                <ItemTemplate>
                    <asp:Label ID="statut" runat="server" Text='<%# Bind("status") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>
        </Columns>
        <HeaderStyle Font-Bold="True" ForeColor="White" BackColor="#999999" Font-Italic="False"
            Font-Overline="False" Font-Strikeout="False" Font-Underline="False"></HeaderStyle>
        <PagerStyle BackColor="#999999" ForeColor="White" HorizontalAlign="Center" />
    </asp:GridView>
    <br />
    <br />
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="" ProviderName="System.Data.SqlClient">
    </asp:SqlDataSource>
</asp:Content>
