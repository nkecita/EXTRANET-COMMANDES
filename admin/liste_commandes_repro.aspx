<%@ Page MasterPageFile="~/admin/AdminMasterPage.master" %>

<asp:Content ContentPlaceHolderID="e_body" runat="server">
    
    
  
    <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ AppSettings:ConnectionString %>"
        ProviderName="System.Data.SqlClient" SelectCommand="select * from commandes_repro where transfert = 'oui' order by num_commande desc">
    </asp:SqlDataSource>
    
    <div class="e_menu_title" style="width:90%">
        Liste des commandes trait&eacute;es
    </div>
    
    <br />
    <br />
    
    <asp:GridView ID="Gridview3" runat="server" CellPadding="3" ForeColor="Black" EnableViewState="False"
         AutoGenerateColumns="False" DataSourceID="SqlDataSource3"
        Style="margin-right: 42px; font-size: small;" Width="752px" AllowPaging="True"
        PageSize="20" AllowSorting="True">
        <Columns>
            <asp:TemplateField HeaderText="Commande">
                <ItemTemplate>
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("num_commande", "http://econ.fichet-pointfort.fr/admin/commande_repro.asp?nn={0}") %>'
                        Target="_blank" Text='<%# Eval("num_commande") %>'></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="dtcomm" HeaderText="Date" SortExpression="dtcomm"></asp:BoundField>
            <asp:BoundField DataField="societe" HeaderText="Société" SortExpression="societe">
            </asp:BoundField>
            <asp:BoundField DataField="responsable" HeaderText="Responsable"></asp:BoundField>
        </Columns>
        <HeaderStyle Font-Bold="True" ForeColor="White" BackColor="#999999" Font-Italic="False"
            Font-Overline="False" Font-Strikeout="False" Font-Underline="False"></HeaderStyle>
        <PagerStyle BackColor="#999999" ForeColor="White" HorizontalAlign="Center" />
    </asp:GridView>
</asp:Content>
