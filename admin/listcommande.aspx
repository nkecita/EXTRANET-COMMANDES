
<%@ Page MasterPageFile="~/admin/AdminMasterPage.master" %>
<%@ import Namespace="System.Data" %>
<%@ import Namespace="System.Data.SqlClient" %>



<script runat="server" >
    
    Public sPATH As String = ""
    Public tabName As String() = New String(1) {}
    
    Sub Page_Load(ByVal Sender As Object, ByVal E As EventArgs)
        'Response.Write(Session("droits"))
       ' response.write(Session("filtre"))
        SqlDataSource1.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        SqlDataSource2.ConnectionString = System.Configuration.ConfigurationManager.AppSettings("connectionString")
        If Session("filtre") <> "" Then
            SqlDataSource1.SelectCommand = "SELECT [num_commande], [dtcomm],[societe], [num_client], [ref_client], [delai], [prix_valideur],[prix_pointfort], [modele],[cc_march_label],[cp_cc_nocde],[delai] FROM [commandes_portes] where transfert='non' and status=1 " & Session("filtre") & " order by num_commande "
            SqlDataSource2.SelectCommand = "SELECT [num_commande], [dtcomm],[societe], [num_client], [ref_client], [delai],  [prix_valideur],[prix_pointfort], [modele],[cc_march_label],[cp_cc_nocde],[delai]  FROM [commandes_portes] where transfert='imp' " & Session("filtre") & " order by num_commande "
        Else
            SqlDataSource1.SelectCommand = "SELECT [num_commande], [dtcomm],[societe], [num_client], [ref_client], [delai], [prix_valideur],[prix_pointfort], [modele],[cc_march_label],[cp_cc_nocde],[delai] FROM [commandes_portes] where transfert='non' and status=1 order by num_commande "
            SqlDataSource2.SelectCommand = "SELECT [num_commande], [dtcomm],[societe], [num_client], [ref_client], [delai],  [prix_valideur],[prix_pointfort], [modele],[cc_march_label],[cp_cc_nocde],[delai]  FROM [commandes_portes] where transfert='imp' order by num_commande "
        End If
        
        If Session("client") <> "ADMIN" Then
            Response.Redirect("../login.aspx")
        End If
        
  
        

    End Sub
    
    Protected Sub GridView1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound


        Dim ToolRecup As New tool_fichet
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim Lblcde As Label
            Lblcde = e.Row.FindControl("cde")
            
            tabName = getlongName(Lblcde.Text.Trim.PadLeft(7, "0"))
          
            If ToolRecup.get_order_info(Lblcde.Text, "environnement").ToLower = "default" Then
                'e.Row.Cells(9).Text = "<a href='" & "http://econ.fichet-pointfort.fr/commandes/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_AT.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"
                e.Row.Cells(9).Text = "<a href='" & sPATH & "/commandes/" & tabName(0) & "/" & tabName(1) & "/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_AT.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"
            Else
                'e.Row.Cells(9).Text = "<a href='" & "http://econ.fichet-pointfort.fr/commandes_test/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_AT.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"
                e.Row.Cells(9).Text = "<a href='" & sPATH & "/commandes_test/" & tabName(0) & "/" & tabName(1) & "/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_AT.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"
            End If
            
          
       
            Dim lblClient As Label
            lblClient = e.Row.FindControl("NumClient")
            Dim recupvalideur As String
            recupvalideur = ""
            
            recupvalideur = ToolRecup.get_valideur_info(lblClient.Text, "codeclient")
            
            If recupvalideur <> "" Then
                e.Row.Cells(2).Text = recupvalideur
                e.Row.Cells(4).Text = ToolRecup.get_order_info(Lblcde.Text.Trim, "ref_valideur")
                e.Row.Cells(7).Text = FormatNumber(CDec(ToolRecup.get_order_info(Lblcde.Text.Trim, "prix_valideur")), 2).tostring
            End If
            
            recupvalideur = ToolRecup.get_valideur_info(lblClient.Text, "raisonsociale")
            If recupvalideur <> "" Then
                e.Row.Cells(3).Text = recupvalideur
            End If
       
        End If
    End Sub
    
    Protected Sub GridView2_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView2.RowDataBound

        Dim ToolRecup As New tool_fichet

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim Lblcde As Label
            Lblcde = e.Row.FindControl("cde")
            
            tabName = getlongName(Lblcde.Text.Trim.PadLeft(7, "0"))
            
            If ToolRecup.get_order_info(Lblcde.Text, "environnement").ToLower = "default" Then
                'e.Row.Cells(9).Text = "<a href='" & "http://econ.fichet-pointfort.fr/commandes/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_AT.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"
                e.Row.Cells(9).Text = "<a href='" & sPATH & "/commandes/" & tabName(0) & "/" & tabName(1) & "/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_TA.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"
            Else
                'e.Row.Cells(9).Text = "<a href='" & "http://econ.fichet-pointfort.fr/commandes_test/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_AT.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"
                e.Row.Cells(9).Text = "<a href='" & sPATH & "/commandes_test/" & tabName(0) & "/" & tabName(1) & "/CEW" & Lblcde.Text.Trim.PadLeft(7, "0") & "_TA.HTML" & "' target='_BLANK'><img src='images/cle.png'  border='0'></a>"
            End If
            
       
            Dim lblClient As Label
            lblClient = e.Row.FindControl("NumClient")
            Dim recupvalideur As String
            recupvalideur = ""
            
            recupvalideur = ToolRecup.get_valideur_info(lblClient.Text, "codeclient")
            If recupvalideur <> "" Then
                e.Row.Cells(2).Text = recupvalideur
                e.Row.Cells(4).Text = ToolRecup.get_order_info(Lblcde.Text.Trim, "ref_valideur")
                e.Row.Cells(7).Text = FormatNumber(CDec(ToolRecup.get_order_info(Lblcde.Text.Trim, "prix_valideur")), 2).tostring
            End If
            
            recupvalideur = ToolRecup.get_valideur_info(lblClient.Text, "raisonsociale")
            If recupvalideur <> "" Then
                e.Row.Cells(3).Text = recupvalideur
            End If
       
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

         <% If Session("droits") = "ADMIN" Then%>        
    <meta http-equiv="refresh" content="30;URL="listcommande.aspx" />                
    
    <div class="e_menu_title" style="width: 90%">
        Menu d&#39;administration des commandes de blocs portes
    </div>
    <br />
    <br />
    
    <div style="text-align: left">
        Liste des nouvelles commandes</div>
    <br /><br />
    
               <asp:GridView ID="GridView1" runat="server" CellPadding="4" 
                    AutoGenerateColumns="False" ForeColor="#333333" 
                     DataSourceID="SqlDataSource1"    >
                       <FooterStyle BackColor="#5D7B9D" ForeColor="White" Font-Bold="True" />
                       <RowStyle ForeColor="#333333" BackColor="#F7F6F3" />
                        <Columns>
                    
                    <asp:HyperLinkField DataTextField="num_commande" 
                               DataNavigateUrlFormatString="appel_commande.aspx?num_commande={0}&type=FR.aspx" 
                               DataNavigateUrlFields="num_commande" Target="_blank" 
                                HeaderText="N°Cde"       />
                    
                                   
                           
                       
                <asp:BoundField DataField="dtcomm" headertext="Date" ></asp:BoundField>
                <asp:TemplateField Visible="true" HeaderText="Client">
                                <ItemTemplate>
                                    <asp:Label ID="NumClient" runat="server" Text='<%# Bind("num_client") %>' headertext="Client" ></asp:Label>
                                </ItemTemplate>
                                
                                <ItemStyle HorizontalAlign="Right" />
                 </asp:TemplateField>
                <asp:BoundField DataField="societe"  headertext="Société"></asp:BoundField>
                <asp:BoundField DataField="Ref_Client"  headertext="Ref Commande"></asp:BoundField>
                <asp:BoundField DataField="delai"  headertext="Délai Souhaité"></asp:BoundField>
                <asp:BoundField DataField="modele"  headertext="Porte"></asp:BoundField>
		

		<asp:BoundField  DataField="prix_pointfort"  headertext="prix" dataformatstring="{0:C2}" >
                    <ItemStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" 
                        Font-Strikeout="False" Font-Underline="False" HorizontalAlign="Right"/>
		</asp:BoundField>

                
                
                   <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="cde" runat="server" Text='<%# Bind("num_commande") %>' ></asp:Label>
                                </ItemTemplate>
                                
                                <ItemStyle HorizontalAlign="Right" />
                 </asp:TemplateField>
                
                
                            <asp:TemplateField></asp:TemplateField>
                
                
                
                
                </Columns>
                
                       <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                      
                       <HeaderStyle BackColor="#00529C" Font-Bold="True" ForeColor="White" />
                       <EditRowStyle BackColor="#999999" />
                       <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
   
                   </asp:GridView> 
   
   <div style="text-align: left">
        Liste des commandes à confirmer
    </div>
  <br /><br />
       <asp:GridView ID="GridView2" runat="server" CellPadding="4" 
                    AutoGenerateColumns="False" ForeColor="#333333" 
                     DataSourceID="SqlDataSource2"    >
                       <FooterStyle BackColor="#5D7B9D" ForeColor="White" Font-Bold="True" />
                       <RowStyle ForeColor="#333333" BackColor="#F7F6F3" />
                        <Columns>
                    
   <asp:HyperLinkField DataTextField="num_commande" 
                               DataNavigateUrlFormatString="appel_commande.aspx?num_commande={0}&type=ORDER.html" 
                               DataNavigateUrlFields="num_commande" Target="_blank" 
                                HeaderText="N°Cde"       />

              
                           
                       
                <asp:BoundField DataField="dtcomm" headertext="Date" ></asp:BoundField>
               <asp:TemplateField Visible="true" HeaderText="Client">
                                <ItemTemplate>
                                    <asp:Label ID="NumClient" runat="server" Text='<%# Bind("num_client") %>' headertext="Client" ></asp:Label>
                                </ItemTemplate>
                                
                                <ItemStyle HorizontalAlign="Right" />
                 </asp:TemplateField>
                <asp:BoundField DataField="societe"  headertext="Société"></asp:BoundField>
                <asp:BoundField DataField="Ref_Client"  headertext="Ref Commande"></asp:BoundField>
                <asp:BoundField DataField="delai"  headertext="Délai Souhaité"></asp:BoundField>
                <asp:BoundField DataField="modele"  headertext="Porte"></asp:BoundField>
		

		<asp:BoundField  DataField="prix_pointfort"  headertext="prix" dataformatstring="{0:C2}" >
                    <ItemStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" 
                        Font-Strikeout="False" Font-Underline="False" HorizontalAlign="Right"/>
		</asp:BoundField>

                
                
                   <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="cde" runat="server" Text='<%# Bind("num_commande") %>' ></asp:Label>
                                </ItemTemplate>
                                
                                <ItemStyle HorizontalAlign="Right" />
                 </asp:TemplateField>
                
                
                            <asp:TemplateField></asp:TemplateField>
                
                
                
                
                </Columns>
                
                       <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                      
                       <HeaderStyle BackColor="#00529C" Font-Bold="True" ForeColor="White" />
                       <EditRowStyle BackColor="#999999" />
                       <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
   
                   </asp:GridView> 
                <% End If%>
                   
   
    <div style="text-align: left">
            <a href="listcommandehisto.aspx" target="_self">Liste des Anciennes commandes</a>
    </div>

    <br />
    <br />
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString=""
        ProviderName="System.Data.SqlClient" 
        SelectCommand="">
    </asp:SqlDataSource>
    
     <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
        ConnectionString=""
        ProviderName="System.Data.SqlClient" 
        SelectCommand="">
    </asp:SqlDataSource>
  
                     
                  
    </div>

 </asp:Content>