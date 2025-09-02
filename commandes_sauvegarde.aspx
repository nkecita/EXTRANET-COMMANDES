<%@ Page MasterPageFile="~/MainMasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">
 

    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
        
        If Session("client") = "" Then
            Response.Redirect("login.aspx")
        End If
        Dim MaTrad As New Tool_fichet
        Button1.Text = MaTrad.traduction(Session("langue"), "COMMANDES_SAUVEGARDE", "BUTTON1")

    End Sub
    
    Private Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound
        If e.Row.RowType = DataControlRowType.Header Then
            Dim MaTrad As New Tool_fichet
            e.Row.Cells(0).Text = MaTrad.traduction(Session("langue"), "COMMANDES_SAUVEGARDE", "COL1")
			Dim dField As DataControlFieldCell
			Dim hlf As HyperLinkField 
			dField = e.Row.Cells(0)
			hlf = dField.ContainingField
			
			
			Dim mytool As New Tool_fichet       
			dim CurrentDomain as string
			CurrentDomain = request.ServerVariables("SERVER_NAME")

	
	
			dim cEnv as string
			cEnv=""
		
		     
		cEnv= mytool.get_info_visiteur(CurrentDomain,"ENVIRONNEMENT")
			hlf.DataNavigateUrlFormatString = "econ.aspx?environment=" & cenv & "&Model={6}&modelversion={3}&configuration={0}&version=1&language={1}&customer={4}&product={5}"

            e.Row.Cells(1).Text = MaTrad.traduction(Session("langue"), "COMMANDES_SAUVEGARDE", "COL2")
            e.Row.Cells(2).Text = MaTrad.traduction(Session("langue"), "COMMANDES_SAUVEGARDE", "COL3")
            e.Row.Cells(3).Text = MaTrad.traduction(Session("langue"), "COMMANDES_SAUVEGARDE", "COL4")
            e.Row.Cells(4).Text = MaTrad.traduction(Session("langue"), "COMMANDES_SAUVEGARDE", "COL5")
        End If
    End Sub

   
    
    Sub ApplyFilter_Click(ByVal Sender As Object, ByVal E As EventArgs)

        ' TODO: update the ConnectionString value for your application
        Dim ConnectionString As String = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        Dim CommandText As String

        ' get the filter value from the DropDownList
        Dim filterValue As String = Session("client")

        ' TODO: update the CommandText value for your application
		Dim mytool As New Tool_fichet       
	   dim CurrentDomain as string
		CurrentDomain = request.ServerVariables("SERVER_NAME")

	
	
		dim cBase as string
		cBase=""
		
		     
		cBase= mytool.get_info_visiteur(CurrentDomain,"BASE")
            
		
        CommandText = "select "
        CommandText = CommandText + " rtrim(cp.configuration) as configuration,"
        CommandText = CommandText + " cp.datecreation,"
        CommandText = CommandText + " cp.datemodification,"
        CommandText = CommandText + " cp.modele, "
        CommandText = CommandText + " cp.produit_url, "
        CommandText = CommandText + " cp.referenceclient, "
        CommandText = CommandText + " clients_new.langue, "
        CommandText = CommandText + " clients_new.codeclient, "
        CommandText = CommandText + " rtrim(fm.model) as model, "
        CommandText = CommandText + " rtrim(fm.version) as version "
        CommandText = CommandText + " from configurations_portes cp"
        CommandText = CommandText + " left join " & cBase & ".dbo.FichetModele fm on fm.id = 'MAIN'  "
        CommandText = CommandText + " Left Join  " & cBase & ".dbo.econelements ee on (  ee.modelname=fm.model)"
        CommandText = CommandText + " left join clients_new on clients_new.codeclient = cp.codeclient "
        CommandText = CommandText + " where cp.codeclient = '" & filterValue & "'"

' ee.modelversion = fm.version and
  
        CommandText = CommandText + "  and (ee.type = 3 and ee.name = cp.configuration)"
        
        If datedeb.Text <> "" And datefin.Text <> "" Then
            CommandText = CommandText + " and CONVERT(datetime, datecreation, 103) >='" & datedeb.Text & "'"
            CommandText = CommandText + " and CONVERT(datetime, datecreation, 103) <='" & datefin.Text & "'"
        End If
        If datedeb.Text <> "" And datefin.Text = "" Then
            CommandText = CommandText + " and CONVERT(datetime, datecreation, 103) >='" & datedeb.Text & "'"
        End If
        If datedeb.Text = "" And datefin.Text <> "" Then
            CommandText = CommandText + " and CONVERT(datetime, datecreation, 103) <='" & datefin.Text & "'"
        End If
        CommandText = CommandText + " order by CONVERT(datetime, datecreation, 103) desc"
        
        
        
        
        ' Response.Write(CommandText)
        
        Dim myConnection As New SqlConnection(ConnectionString)
        Dim myCommand As New SqlCommand(CommandText, myConnection)

        myConnection.Open()

        GridView1.DataSource = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        GridView1.DataBind()
        
        
        

    End Sub


    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub
</script>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    <table cellpadding="0" cellspacing="0" width="400px" class="e_color_back">
        <tr>
            <td class="e_menu_title" colspan="3">
                <%
                    Dim MaTrad As New Tool_fichet
                    Response.Write(MaTrad.traduction(Session("langue"), "COMMANDES_SAUVEGARDE", "TITRE1"))
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
                <%  Response.Write(MaTrad.traduction(Session("langue"), "COMMANDES_SAUVEGARDE", "TITRE2"))%>
            </td>
        </tr>
        <tr>
            <td style="height: 10px;" colspan="3">
            </td>
        </tr>
        <tr>
            <td align="left">
                <%  Response.Write(MaTrad.traduction(Session("langue"), "COMMANDES_SAUVEGARDE", "TEXT1"))%>
            </td>
            <td>
                &nbsp;
            </td>
            <td align="left">
                <asp:TextBox ID="datedeb" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td align="left">
                <%  Response.Write(MaTrad.traduction(Session("langue"), "COMMANDES_SAUVEGARDE", "TEXT2"))%>
            </td>
            <td>
                &nbsp;
            </td>
            <td align="left">
                <asp:TextBox ID="datefin" runat="server"> </asp:TextBox>
                <asp:Button ID="Button1" OnClick="ApplyFilter_Click" runat="server" Text='' Style="text-align: center">
                </asp:Button>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                &nbsp; &nbsp;
            </td>
        </tr>
    </table>
    <asp:GridView ID="GridView1" runat="server" CellPadding="4" AutoGenerateColumns="False"
        ForeColor="#333333" DataKeyNames="configuration"
        OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
        <FooterStyle BackColor="#5D7B9D" ForeColor="White" Font-Bold="True" />
        <RowStyle ForeColor="#333333" BackColor="#F7F6F3" HorizontalAlign="Right" />
        <Columns>
            <asp:HyperLinkField DataTextField="configuration" DataNavigateUrlFormatString= "http://econ.fichet-pointfort.fr/econ.aspx?environment=default&Model={6}&modelversion={3}&configuration={0}&version=1&language={1}&customer={4}&product={5}"
                DataNavigateUrlFields="configuration,langue,modele,version,codeclient,produit_url,model"
                Target="_self" />
            <asp:BoundField DataField="datecreation"></asp:BoundField>
            <asp:BoundField DataField="datemodification"></asp:BoundField>
            <asp:BoundField DataField="modele"></asp:BoundField>
            <asp:BoundField DataField="referenceclient"></asp:BoundField>
        </Columns>
        <PagerStyle BackColor="#999999" ForeColor="White" HorizontalAlign="Center" />
        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
        <HeaderStyle BackColor="#999999" Font-Bold="True" ForeColor="White" />
        <EditRowStyle BackColor="#999999" />
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
    </asp:GridView>
    </form> </div>
    <br />
</asp:Content>
