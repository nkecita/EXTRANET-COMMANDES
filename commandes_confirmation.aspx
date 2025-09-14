<%@ Page MasterPageFile="~/MainMasterPageToken.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
	Public libcde as string =""
    Sub affiche_commande()
        
		IF Session("charte").ToString().ToUpper() = "REHAB"or Session("charte").ToString().ToUpper() = "FSBA"then
			libcde="commandes_portes_rehab"
		Else
			libcde="commandes_portes"
		End If
		
		' TODO: update the ConnectionString value for your application
        Dim ConnectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        Dim CommandText As String

        ' TODO: update the CommandText value for your application
         
        CommandText = "Select TOP 30 [souche]+cast([num_commande] as varchar) as num_commande,"
        CommandText = CommandText + " num_usine,nom_usine,dtcomm,ref_client,delai,date_usine,modele,montant_usine,langue,nom_usine,date_tournee,heure_tournee,status,num_commande as numerocde "
        CommandText = CommandText + " FROM " & libcde
        CommandText = CommandText + " left join clients_new on clients_new.codeclient = " & libcde & ".num_client"
        CommandText = CommandText + "  where num_client = '" & Session("client") & "'"

               
        If datedeb.Text <> "" And datefin.Text <> "" Then
            CommandText = CommandText + " and CONVERT(datetime, dtcomm, 103) >='" & datedeb.Text & "'"
            CommandText = CommandText + " and CONVERT(datetime, dtcomm, 103) <='" & datefin.Text & "'"
        End If
        If datedeb.Text <> "" And datefin.Text = "" Then
            CommandText = CommandText + " and CONVERT(datetime, dtcomm, 103) >='" & datedeb.Text & "'"
        End If
        If datedeb.Text = "" And datefin.Text <> "" Then
            CommandText = CommandText + " and CONVERT(datetime, dtcomm, 103) <='" & datefin.Text & "'"
        End If
        CommandText = CommandText + " and (transfert = 'oui' AND vue_commande is null) "
        CommandText = CommandText + " order by CONVERT(datetime, dtcomm, 103) desc,num_commande desc"
        
        'Response.Write(CommandText)
        
        


        Dim myConnection As New SqlConnection(ConnectionString)
        Dim myCommand As New SqlCommand(CommandText, myConnection)

        myConnection.Open()

        GridView1.DataSource = myCommand.ExecuteReader(CommandBehavior.Default)
        GridView1.DataBind()

    End Sub
    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
       
        affiche_commande()
      
        Dim MaTrad As New Tool_fichet
        Button1.Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "BUTTON1")
        
        Dim ToolRecup As New Tool_fichet
        Dim recupvalideur As String
        recupvalideur = ""
        recupvalideur = ToolRecup.get_valideur_info(Session("client"), "codeclient")
            
        If recupvalideur <> "" Then
            GridView1.Columns(1).Visible = False
            GridView1.Columns(5).Visible = False
            GridView1.Columns(7).Visible = False
        End If
        
    
    End Sub
  
    Private Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        Dim MaTrad As New Tool_fichet
        If e.Row.RowType = DataControlRowType.Header Then
    
           
            e.Row.Cells(0).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL1")
            e.Row.Cells(1).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL2")
            e.Row.Cells(2).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL3")
            e.Row.Cells(3).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL4")
            e.Row.Cells(4).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL5")
            e.Row.Cells(5).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL6")
            e.Row.Cells(6).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL7")
            e.Row.Cells(7).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL8")
            e.Row.Cells(8).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL9")
             
            e.Row.Cells(9).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL10")
            e.Row.Cells(10).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL11")
            e.Row.Cells(11).Text = MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "COL12")
            
            
            
            
       
        End If
      
        If e.Row.RowType = DataControlRowType.DataRow Then
         
            Dim Lblstatut As Label
            Lblstatut = e.Row.FindControl("statut")
         
            Select Case Lblstatut.Text.Trim
                Case "-1"
                    e.Row.Cells(11).Text = "<img src='images/statut_annulee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "STATUTM1") & "'>"
                Case "0"
                    e.Row.Cells(11).Text = "<img src='images/statut_attente_distributeur.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "STATUT0") & "'>"
                Case "1"
                    e.Row.Cells(11).Text = "<img src='images/statut_attente.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "STATUT1") & "'>"
                Case "2"
                    e.Row.Cells(11).Text = "<img src='images/statut_prise-en-compte.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "STATUT2") & "'>"
                Case "3"
                    e.Row.Cells(11).Text = "<img src='images/statut_confirmee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "STATUT3") & "'>"
                Case "4"
                    e.Row.Cells(11).Text = "<img src='images/statut_fabriquee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "STATUT4") & "'>"
                Case "5"
                    e.Row.Cells(11).Text = "<img src='images/statut_expediee.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "STATUT5") & "'>"
                Case "6"
                    e.Row.Cells(11).Text = "<img src='../images/statut_livree.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "ARCHIVE_ECON", "STATUT6") & "'>"
                Case Else
                    e.Row.Cells(11).Text = "<img src='images/statut_attente.png'  border='0' title='" & MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "STATUT1") & "'>"
            End Select
         
          
                 
           
        End If
    End Sub
   
    Protected Sub ApplyFilter_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        affiche_commande()
    End Sub
    
</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    <table cellpadding="0" cellspacing="0" width="400px" class="e_color_back" border="0">
        <tr>
            <td class="e_menu_title" colspan="3">
                <%  Dim MaTrad As New Tool_fichet
                    Response.Write(MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "TITRE1"))
                %>
            </td>
        </tr>
        <tr>
            <td style="height: 10px;" colspan="3">
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
            <td align="left">
                <% Response.Write(MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "TITRE2"))%>
            </td>
        </tr>
        <tr>
            <td style="height: 10px;" colspan="3">
            </td>
        </tr>
        <tr>
            <td align="left">
                <% Response.Write(MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "TEXT1"))%>
            </td>
            <td>
                &nbsp;
            </td>
            <td align="left">
                <asp:TextBox ID="datedeb" runat="server" Style="text-align: left"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td align="left">
                <% Response.Write(MaTrad.traduction(Session("langue"), "COMMANDES_CONFIRMATION", "TEXT2"))%>
            </td>
            <td>
                &nbsp;
            </td>
            <td align="left">
                <asp:TextBox ID="datefin" runat="server" Style="text-align: left;"> </asp:TextBox>&nbsp;
                <asp:Button ID="Button1" OnClick="ApplyFilter_Click" runat="server" Text="Afficher"
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
    <asp:GridView ID="GridView1" runat="server" CellPadding="4" AutoGenerateColumns="False"
        ForeColor="#333333" DataKeyNames="num_commande">
        <FooterStyle BackColor="#5D7B9D" ForeColor="White" Font-Bold="True" />
        <RowStyle ForeColor="#333333" BackColor="#F7F6F3" />
        <Columns>
           <asp:TemplateField HeaderText="Commande">
    <ItemTemplate>
        <asp:HyperLink 
            ID="lnkCommande" 
            runat="server" 
            Text='<%# Eval("num_commande") %>' 
            NavigateUrl='<%# "affiche_commande.aspx?num_commande=" & Eval("num_commande").ToString().Substring(3) & "&type=LG.aspx" %>' 
            Target="_blank" />
    </ItemTemplate>
</asp:TemplateField>

            <asp:BoundField DataField="num_usine"></asp:BoundField>
            <asp:BoundField DataField="dtcomm"></asp:BoundField>
            <asp:BoundField DataField="ref_client"></asp:BoundField>
            <asp:BoundField DataField="delai"></asp:BoundField>
            <asp:BoundField DataField="date_usine"></asp:BoundField>
            <asp:BoundField DataField="modele"></asp:BoundField>
            <asp:BoundField DataField="montant_usine" DataFormatString="{0:C2}">
                <ItemStyle HorizontalAlign="Right" />
            </asp:BoundField>
            <asp:BoundField DataField="nom_usine" />
            <asp:BoundField DataField="date_tournee" />
            <asp:BoundField DataField="heure_tournee" />
            <asp:ImageField>
            </asp:ImageField>
            <asp:TemplateField Visible="False">
                <ItemTemplate>
                    <asp:Label ID="statut" runat="server" Text='<%# Bind("status") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>
        </Columns>
        <PagerStyle BackColor="#999999" ForeColor="White" HorizontalAlign="Center" />
        <HeaderStyle BackColor="#999999" Font-Bold="True" ForeColor="White" />
        <EditRowStyle BackColor="#999999" />
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
    </asp:GridView>
</asp:Content>
